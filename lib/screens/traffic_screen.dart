import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';
import '../utils/geocoding_service.dart';
import '../utils/entfernung_utils.dart';

class TrafficScreen extends StatefulWidget {
  const TrafficScreen({Key? key}) : super(key: key);

  @override
  State<TrafficScreen> createState() => _TrafficScreenState();
}

class _TrafficScreenState extends State<TrafficScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>>? _trafficData;
  bool _isLoading = true;
  String? _error;

  final double maxEntfernungKm = 20.0;

  @override
  void initState() {
    super.initState();
    _fetchTrafficData();
  }

  Future<void> _fetchTrafficData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. Aktuellen Kunden (User) mit Adresse holen
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _error = "Nicht eingeloggt.";
        });
        return;
      }

      final userResult = await supabase
          .from('users')
          .select('adresse')
          .eq('id', userId)
          .maybeSingle();

      final kundenAdresse = userResult?['adresse'] as String?;
      print('Kundenadresse: $kundenAdresse');

      if (kundenAdresse == null || kundenAdresse.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = AppLocalizations.of(context)!.trafficScreenKeineAdresse;
        });
        return;
      }

      // 2. Adresse zu Koordinaten wandeln
      final userCoords = await GeocodingService().getCoordinates(kundenAdresse);
      print('Geocoded userCoords: $userCoords');

      if (userCoords == null) {
        setState(() {
          _isLoading = false;
          _error = AppLocalizations.of(context)!.trafficScreenAdresseFehler;
        });
        return;
      }
      final double userLat = userCoords['lat']!;
      final double userLon = userCoords['lng']!;

      // 3. Dienstleister mit Standort & Kategorie laden
      final List<dynamic> data = await supabase
          .from('dienstleister_details')
          .select('kategorie, latitude, longitude');

      for (var item in data) {
        print('DL: Kategorie=${item['kategorie']}, lat=${item['latitude']}, lon=${item['longitude']}');
      }

      // 4. Nur Dienstleister im Radius behalten
      final regionDienstleister = data.where((item) {
        final lat = item['latitude'];
        final lon = item['longitude'];
        if (lat == null || lon == null) return false;
        final entfernung = berechneEntfernung(
          userLat,
          userLon,
          (lat as num).toDouble(),
          (lon as num).toDouble(),
        );
        print('→ DL ${item['kategorie']}: Entfernung = $entfernung km');
        return entfernung <= maxEntfernungKm;
      }).toList();

      print('Dienstleister im Umkreis ($maxEntfernungKm km): ${regionDienstleister.length}');

      // 5. Kategorien zählen
      Map<String, int> kategorieCounts = {};
      for (var item in regionDienstleister) {
        String kategorie = item['kategorie'] ?? 'Unbekannt';
        kategorieCounts[kategorie] = (kategorieCounts[kategorie] ?? 0) + 1;
      }
      final sortedList = kategorieCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      setState(() {
        _trafficData = sortedList
            .map((e) => {'kategorie': e.key, 'anzahl': e.value})
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = AppLocalizations.of(context)!.errorPrefix(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(l10n.kundenDashboardAppBar),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellowAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 18, right: 18, bottom: 7),
            child: Material(
              color: Colors.yellow[50],
              elevation: 0,
              borderRadius: BorderRadius.circular(13),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber[800], size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.trafficScreenInfoText,
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontSize: 15.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : (_trafficData == null || _trafficData!.isEmpty)
                        ? Center(
                            child: Text(
                              l10n.keineDienstleisterInRegion,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _trafficData!.length,
                            itemBuilder: (context, index) {
                              final entry = _trafficData![index];
                              final kategorie = entry['kategorie'];
                              final anzahl = entry['anzahl'];

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                child: Row(
                                  children: [
                                    const Icon(Icons.category, color: Colors.black54),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        l10n.getKategorieName(kategorie),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: LinearProgressIndicator(
                                        value: (_trafficData![0]['anzahl'] == 0)
                                            ? 0
                                            : (anzahl / (_trafficData![0]['anzahl'])),
                                        minHeight: 10,
                                        color: Colors.yellow[700],
                                        backgroundColor: Colors.yellow[100],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '$anzahl',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// ------ Extension für die Kategorie-Übersetzung (direkt hier am Dateiende!) ------
extension KategorieL10nExtension on AppLocalizations {
  String getKategorieName(String kategorie) {
    switch (kategorie) {
      case 'category_babysitter': return category_babysitter;
      case 'category_catering': return category_catering;
      case 'category_dachdecker': return category_dachdecker;
      case 'category_elektriker': return category_elektriker;
      case 'category_ernaehrungsberatung': return category_ernaehrungsberatung;
      case 'category_eventplanung': return category_eventplanung;
      case 'category_fahrdienste': return category_fahrdienste;
      case 'category_fahrlehrer': return category_fahrlehrer;
      case 'category_fensterputzer': return category_fensterputzer;
      case 'category_fliesenleger': return category_fliesenleger;
      case 'category_fotografie': return category_fotografie;
      case 'category_friseur': return category_friseur;
      case 'category_gartenpflege': return category_gartenpflege;
      case 'category_grafikdesign': return category_grafikdesign;
      case 'category_handy_reparatur': return category_handy_reparatur;
      case 'category_haushaltsreinigung': return category_haushaltsreinigung;
      case 'category_hausmeisterservice': return category_hausmeisterservice;
      case 'category_heizungsbauer': return category_heizungsbauer;
      case 'category_hundesitter': return category_hundesitter;
      case 'category_it_support': return category_it_support;
      case 'category_klempner': return category_klempner;
      case 'category_kosmetik': return category_kosmetik;
      case 'category_kuenstler': return category_kuenstler;
      case 'category_kurierdienst': return category_kurierdienst;
      case 'category_maler': return category_maler;
      case 'category_massagen': return category_massagen;
      case 'category_maurer': return category_maurer;
      case 'category_moebelaufbau': return category_moebelaufbau;
      case 'category_musikunterricht': return category_musikunterricht;
      case 'category_nachhilfe': return category_nachhilfe;
      case 'category_nagelstudio': return category_nagelstudio;
      case 'category_pc_reparatur': return category_pc_reparatur;
      case 'category_partyservice': return category_partyservice;
      case 'category_personal_trainer': return category_personal_trainer;
      case 'category_rasenmaeher_service': return category_rasenmaeher_service;
      case 'category_rechtsberatung': return category_rechtsberatung;
      case 'category_reparaturdienste': return category_reparaturdienste;
      case 'category_seniorenbetreuung': return category_seniorenbetreuung;
      case 'category_social_media': return category_social_media;
      case 'category_sonstige': return category_sonstige;
      case 'category_sprachunterricht': return category_sprachunterricht;
      case 'category_steuerberatung': return category_steuerberatung;
      case 'category_tischler': return category_tischler;
      case 'category_transport': return category_transport;
      case 'category_umzugstransporte': return category_umzugstransporte;
      case 'category_umzugshelfer': return category_umzugshelfer;
      case 'category_uebersetzungen': return category_uebersetzungen;
      case 'category_waescheservice': return category_waescheservice;
      case 'category_webdesign': return category_webdesign;
      case 'category_einkaufsservice': return category_einkaufsservice;
      case 'category_haustierbetreuung': return category_haustierbetreuung;
      default:
        return kategorie;
    }
  }
}
