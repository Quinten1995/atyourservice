import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import '../utils/entfernung_utils.dart';
import 'auftrag_detail_screen.dart';
import 'profil_dienstleister_screen.dart';

class DienstleisterDashboardScreen extends StatefulWidget {
  const DienstleisterDashboardScreen({Key? key}) : super(key: key);

  @override
  _DienstleisterDashboardScreenState createState() => _DienstleisterDashboardScreenState();
}

class _DienstleisterDashboardScreenState extends State<DienstleisterDashboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  String? _meineKategorie;
  double? _meineLatitude;
  double? _meineLongitude;

  List<Map<String, dynamic>> _alleOffenenAuftraegeRaw = [];
  List<Map<String, dynamic>> _alleLaufendenAuftraegeRaw = [];
  List<Auftrag> _offenePassendeAuftraege = [];
  List<Auftrag> _laufendeAuftraege = [];

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

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
      if (user == null) throw Exception('Nicht eingeloggt');

      // 1) Profil abrufen (kategorie, latitude, longitude)
      final List<dynamic> profilList = await supabase
          .from('dienstleister_details')
          .select('kategorie, latitude, longitude')
          .eq('user_id', user.id);

      if (profilList.isEmpty) throw Exception('Bitte zunächst dein Profil anlegen.');

      final profilData = profilList.first as Map<String, dynamic>;
      final String? kategorie = profilData['kategorie'] as String?;
      final double? latitude = (profilData['latitude'] as num?)?.toDouble();
      final double? longitude = (profilData['longitude'] as num?)?.toDouble();

      if (kategorie == null) throw Exception('Kategorie im Profil fehlt.');

      _meineKategorie = kategorie;
      _meineLatitude = latitude;
      _meineLongitude = longitude;

      // 2) Alle offenen Aufträge derselben Kategorie laden
      final List<dynamic> rawOffen = await supabase
          .from('auftraege')
          .select()
          .eq('kategorie', kategorie)
          .eq('status', 'offen');
      _alleOffenenAuftraegeRaw = rawOffen.cast<Map<String, dynamic>>();

      // 3) Laufende (in bearbeitung) Aufträge dieses Dienstleisters
      final List<dynamic> rawLaufend = await supabase
          .from('auftraege')
          .select()
          .eq('status', 'in bearbeitung')
          .eq('dienstleister_id', user.id);
      _alleLaufendenAuftraegeRaw = rawLaufend.cast<Map<String, dynamic>>();

      // 4) Offene Aufträge, nur ≤50km
      if (_meineLatitude != null && _meineLongitude != null) {
        _offenePassendeAuftraege = _alleOffenenAuftraegeRaw
            .map((map) => Auftrag.fromJson(map))
            .where((auftrag) {
          if (auftrag.latitude == null || auftrag.longitude == null) return false;
          final dist = berechneEntfernung(
            _meineLatitude!, _meineLongitude!,
            auftrag.latitude!, auftrag.longitude!,
          );
          return dist <= 50.0;
        }).toList();
      } else {
        _offenePassendeAuftraege =
            _alleOffenenAuftraegeRaw.map((map) => Auftrag.fromJson(map)).toList();
      }

      _laufendeAuftraege =
          _alleLaufendenAuftraegeRaw.map((map) => Auftrag.fromJson(map)).toList();

      setState(() => _isLoading = false);
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

  Widget _dashboardHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 2),
      child: Row(
        children: [
          Icon(Icons.handyman, color: primaryColor, size: 28),
          const SizedBox(width: 10),
          Text(
            'Dein Dashboard',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: primaryColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Dashboard Dienstleister', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Neu laden',
            onPressed: _ladeProfilUndAuftraege,
            color: primaryColor,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil bearbeiten',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilDienstleisterScreen()),
              );
              _ladeProfilUndAuftraege();
            },
            color: primaryColor,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Fehler: $_errorMessage'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dashboardHeader(),
                      if (_laufendeAuftraege.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Meine laufenden Aufträge',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          height: 135,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _laufendeAuftraege.length,
                            separatorBuilder: (context, i) => const SizedBox(width: 13),
                            itemBuilder: (context, index) {
                              final Auftrag auftrag = _laufendeAuftraege[index];
                              return Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
                                      ),
                                    ).then((_) => _ladeProfilUndAuftraege());
                                  },
                                  child: Container(
                                    width: 240,
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          auftrag.titel,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(Icons.assignment, size: 17, color: primaryColor),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Status: ${auftrag.status}',
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          'Kunde: ${auftrag.kundeId}',
                                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(height: 32, thickness: 1.2),
                      ],
                      Text(
                        'Offene, passende Aufträge',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 7),
                      Expanded(
                        child: _offenePassendeAuftraege.isEmpty
                            ? Center(
                                child: Text(
                                  'Keine passenden Aufträge gefunden.',
                                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _offenePassendeAuftraege.length,
                                separatorBuilder: (context, i) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final Auftrag auftrag = _offenePassendeAuftraege[index];

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

                                  return Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    elevation: 2,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                      leading: Icon(Icons.assignment_outlined, color: primaryColor, size: 30),
                                      title: Text(
                                        auftrag.titel,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: distText.isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 3.0),
                                              child: Text(distText, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                                            )
                                          : null,
                                      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
                                          ),
                                        ).then((_) => _ladeProfilUndAuftraege());
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
