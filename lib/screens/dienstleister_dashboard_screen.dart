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
  final supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  // Profil-Daten
  String? _meineKategorie;
  double? _meineLatitude;
  double? _meineLongitude;

  // Alle Aufträge aus der DB als Map-Liste
  List<Map<String, dynamic>> _alleAuftraege = [];
  // Gefilterte Aufträge als starke Typ-Liste
  List<Auftrag> _passendeAuftraege = [];

  @override
  void initState() {
    super.initState();
    _ladeProfilUndAuftraege();
  }

  Future<void> _ladeProfilUndAuftraege() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _alleAuftraege = [];
      _passendeAuftraege = [];
    });

    try {
      final user = supabase.auth.currentUser;

      // ────────── Debug: Prüfen, welcher User eingeloggt ist ──────────
      print('--- DEBUG: aktueller Dienstleister user.id = ${user?.id}');

      if (user == null) {
        throw Exception('Nicht eingeloggt');
      }

      // ────────── 1) Profil abrufen ──────────
      final List<dynamic> profilList = await supabase
          .from('dienstleister_details')
          .select('kategorie, latitude, longitude')
          .eq('user_id', user.id);

      // Debug-Ausgabe: Was liefert die Datenbank für das Profil?
      print('--- DEBUG: profilList aus dienstleister_details:');
      print(profilList);

      if (profilList.isEmpty) {
        throw Exception('Bitte zunächst dein Profil anlegen.');
      }

      final profilData = profilList.first as Map<String, dynamic>;
      final String? kategorie = profilData['kategorie'] as String?;
      final double? latitude = (profilData['latitude'] as num?)?.toDouble();
      final double? longitude = (profilData['longitude'] as num?)?.toDouble();

      // Debug-Ausgabe: Welche Werte enthält das Profil?
      print(
          '--- DEBUG: Gewähltes Profil: kategorie="$kategorie", latitude=$latitude, longitude=$longitude');

      if (kategorie == null) {
        throw Exception('Kategorie im Profil fehlt.');
      }

      _meineKategorie = kategorie;
      _meineLatitude = latitude;
      _meineLongitude = longitude;

      // ────────── 2) Alle offenen Aufträge derselben Kategorie laden ──────────
      final List<dynamic> rawAuftragsData = await supabase
          .from('auftraege')
          .select()
          .eq('kategorie', kategorie)
          .eq('status', 'offen');

      // Debug-Ausgabe: Was liefert die DB für Aufträge?
      print(
          '--- DEBUG: rawAuftragsData für kategorie="$kategorie", status="offen":');
      print(rawAuftragsData);

      _alleAuftraege = rawAuftragsData.cast<Map<String, dynamic>>();

      // ────────── 3) Nach Entfernung filtern (≤ 50 km) ──────────
      if (latitude != null && longitude != null) {
        _passendeAuftraege = _alleAuftraege
            .map((map) => Auftrag.fromJson(map))
            .where((auftrag) {
          // Debug-Ausgabe: Jeder Auftrag mit seinen Koordinaten
          print(
              '--- Auftrag prüfen: titel="${auftrag.titel}", latitude=${auftrag.latitude}, longitude=${auftrag.longitude}');

          if (auftrag.latitude == null || auftrag.longitude == null) {
            print('   → verworfen, weil latitude oder longitude null');
            return false;
          }
          final double dist = berechneEntfernung(
            latitude,
            longitude,
            auftrag.latitude!,
            auftrag.longitude!,
          );
          // Debug-Ausgabe: Berechnete Distanz
          print('   → berechnete Distanz: ${dist.toStringAsFixed(2)} km');
          return dist <= 50.0;
        }).toList();
      } else {
        // Wenn keine eigenen Koordinaten vorhanden, dann alle Aufträge anzeigen
        _passendeAuftraege =
            _alleAuftraege.map((map) => Auftrag.fromJson(map)).toList();
      }

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
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil bearbeiten',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfilDienstleisterScreen()),
              );
              _ladeProfilUndAuftraege(); // Nach Rückkehr neu laden
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Fehler: ${_errorMessage!}'))
                : _passendeAuftraege.isEmpty
                    ? const Center(child: Text('Keine passenden Aufträge gefunden.'))
                    : ListView.builder(
                        itemCount: _passendeAuftraege.length,
                        itemBuilder: (context, index) {
                          final Auftrag auftrag = _passendeAuftraege[index];
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
                          return ListTile(
                            title: Text(auftrag.titel),
                            subtitle: Text(distText),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AuftragDetailScreen(initialAuftrag: auftrag),
                                ),
                              );
                            },
                          );
                        },
                      ),
      ),
    );
  }
}
