// lib/screens/dienstleister_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import '../utils/entfernung_utils.dart';
import 'auftrag_detail_screen.dart';
import 'profil_dienstleister_screen.dart';

class DienstleisterDashboardScreen extends StatefulWidget {
  const DienstleisterDashboardScreen({Key? key}) : super(key: key);

  @override
  _DienstleisterDashboardScreenState createState() =>
      _DienstleisterDashboardScreenState();
}

class _DienstleisterDashboardScreenState
    extends State<DienstleisterDashboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  // Profil‐Daten
  String? _meineKategorie;
  double? _meineLatitude;
  double? _meineLongitude;

  // Liste der Aufträge aus der DB (raw Maps)
  List<Map<String, dynamic>> _alleOffenenAuftraegeRaw = [];
  List<Map<String, dynamic>> _alleLaufendenAuftraegeRaw = [];

  // Starke Typen‐Listen für die UI
  List<Auftrag> _offenePassendeAuftraege = [];
  List<Auftrag> _laufendeAuftraege = [];

  @override
  void initState() {
    super.initState();
    _ladeProfilUndAuftraege();
  }

  Future<void> _ladeProfilUndAuftraege() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _alleOffenenAuftraegeRaw = [];
      _alleLaufendenAuftraegeRaw = [];
      _offenePassendeAuftraege = [];
      _laufendeAuftraege = [];
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Nicht eingeloggt');
      }

      // 1) Profil abrufen (kategorie, latitude, longitude)
      final List<dynamic> profilList = await supabase
          .from('dienstleister_details')
          .select('kategorie, latitude, longitude')
          .eq('user_id', user.id);

      if (profilList.isEmpty) {
        throw Exception('Bitte zunächst dein Profil anlegen.');
      }

      final profilData = profilList.first as Map<String, dynamic>;
      final String? kategorie = profilData['kategorie'] as String?;
      final double? latitude =
          (profilData['latitude'] as num?)?.toDouble();
      final double? longitude =
          (profilData['longitude'] as num?)?.toDouble();

      if (kategorie == null) {
        throw Exception('Kategorie im Profil fehlt.');
      }

      _meineKategorie = kategorie;
      _meineLatitude = latitude;
      _meineLongitude = longitude;

      // 2) Alle offenen Aufträge derselben Kategorie laden
      final List<dynamic> rawOffen = await supabase
          .from('auftraege')
          .select()
          .eq('kategorie', kategorie)
          .eq('status', 'offen');

      _alleOffenenAuftraegeRaw =
          rawOffen.cast<Map<String, dynamic>>();

      // 3) Alle laufenden (in bearbeitung) Aufträge laden, die diesem DL gehören
      final List<dynamic> rawLaufend = await supabase
          .from('auftraege')
          .select()
          .eq('status', 'in bearbeitung')
          .eq('dienstleister_id', user.id);

      _alleLaufendenAuftraegeRaw =
          rawLaufend.cast<Map<String, dynamic>>();

      // 4) Filtern: nur offene Aufträge, die <= 50 km entfernt sind
      if (_meineLatitude != null && _meineLongitude != null) {
        _offenePassendeAuftraege = _alleOffenenAuftraegeRaw
            .map((map) => Auftrag.fromJson(map))
            .where((auftrag) {
          if (auftrag.latitude == null || auftrag.longitude == null) {
            return false;
          }
          final dist = berechneEntfernung(
            _meineLatitude!,
            _meineLongitude!,
            auftrag.latitude!,
            auftrag.longitude!,
          );
          return dist <= 50.0;
        }).toList();
      } else {
        // Ohne Koordinaten: alle offenen Aufträge anzeigen
        _offenePassendeAuftraege = _alleOffenenAuftraegeRaw
            .map((map) => Auftrag.fromJson(map))
            .toList();
      }

      // 5) Alle laufenden Aufträge in starke Typen‐Liste überführen
      _laufendeAuftraege = _alleLaufendenAuftraegeRaw
          .map((map) => Auftrag.fromJson(map))
          .toList();

      setState(() {
        _isLoading = false;
      });
    } on PostgrestException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Dienstleister'),
        actions: [
          // Refresh‐Button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Neu laden',
            onPressed: _ladeProfilUndAuftraege,
          ),
          // Profil bearbeiten
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil bearbeiten',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilDienstleisterScreen(),
                ),
              );
              // Nach Rückkehr immer neu laden
              _ladeProfilUndAuftraege();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Fehler: $_errorMessage'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1) Bereich: Meine laufenden Aufträge
                      if (_laufendeAuftraege.isNotEmpty) ...[
                        const Text(
                          'Meine laufenden Aufträge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          // Innerhalb von Column ein Expanded, damit ListView scrollt
                          child: ListView.builder(
                            itemCount: _laufendeAuftraege.length,
                            itemBuilder: (context, index) {
                              final Auftrag auftrag = _laufendeAuftraege[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(auftrag.titel),
                                  subtitle: Text(
                                      'Status: ${auftrag.status} • Kunde: ${auftrag.kundeId}'),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AuftragDetailScreen(
                                          initialAuftrag: auftrag,
                                        ),
                                      ),
                                    ).then((_) {
                                      // Beim Zurückkommen automatisch neu laden
                                      _ladeProfilUndAuftraege();
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 32),
                      ],

                      // 2) Bereich: Offene, passende Aufträge
                      const Text(
                        'Offene, passende Aufträge',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _offenePassendeAuftraege.isEmpty
                          ? const Center(
                              child: Text('Keine passenden Aufträge gefunden.'),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _offenePassendeAuftraege.length,
                                itemBuilder: (context, index) {
                                  final Auftrag auftrag = _offenePassendeAuftraege[index];

                                  // Entfernungs‐Text berechnen, falls Koordinaten da sind
                                  String distText = '';
                                  if (_meineLatitude != null &&
                                      _meineLongitude != null &&
                                      auftrag.latitude != null &&
                                      auftrag.longitude != null) {
                                    final double dist = berechneEntfernung(
                                      _meineLatitude!,
                                      _meineLongitude!,
                                      auftrag.latitude!,
                                      auftrag.longitude!,
                                    );
                                    distText = '${dist.toStringAsFixed(1)} km entfernt';
                                  }

                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    child: ListTile(
                                      title: Text(auftrag.titel),
                                      subtitle: Text(distText),
                                      trailing:
                                          const Icon(Icons.arrow_forward_ios, size: 16),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AuftragDetailScreen(
                                              initialAuftrag: auftrag,
                                            ),
                                          ),
                                        ).then((_) {
                                          // Nach Rückkehr neu laden, damit ggf. 
                                          // angenommene Aufträge sofort umsortiert werden
                                          _ladeProfilUndAuftraege();
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
      ),
    );
  }
}
