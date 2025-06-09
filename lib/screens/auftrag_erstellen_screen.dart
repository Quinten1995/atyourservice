import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/geocoding_service.dart';
import '../data/kategorien.dart';
import '../l10n/app_localizations.dart';

class AuftragErstellenScreen extends StatefulWidget {
  const AuftragErstellenScreen({Key? key}) : super(key: key);

  @override
  _AuftragErstellenScreenState createState() => _AuftragErstellenScreenState();
}

class _AuftragErstellenScreenState extends State<AuftragErstellenScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _titelController = TextEditingController();
  final _beschreibungController = TextEditingController();
  final _adresseController = TextEditingController();
  final _telefonController = TextEditingController();

  String _selectedKategorie = kategorieKeys.first;
  bool _isLoading = false;
  String? _errorMessage;

  String? _heimatAdresse;

  bool soSchnellWieMoeglich = true;
  DateTime? terminDatum;
  TimeOfDay? zeitVon;
  TimeOfDay? zeitBis;

  bool _wiederkehrend = false;
  String? _intervall;
  String? _wochentag;
  int? _anzahlWiederholungen;
  DateTime? _wiederholenBis;

  static const intervallOptionen = [
    "wöchentlich", "alle 2 Wochen", "monatlich",
  ];
  static const wochentage = [
    "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"
  ];

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  void initState() {
    super.initState();
    _ladeHeimatadresse();
  }

  Future<void> _ladeHeimatadresse() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    final res = await _supabase
        .from('users')
        .select('adresse')
        .eq('id', user.id)
        .maybeSingle();
    setState(() {
      _heimatAdresse = res?['adresse'] ?? '';
    });
  }

  String _timeOfDayToString(TimeOfDay tod) =>
      '${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}';

  Future<void> _auftragAbschicken() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception(l10n.bitteEinloggen);

      final adresse = _adresseController.text.trim();
      final telefon = _telefonController.text.trim();
      double? lat, lon;
      if (adresse.isNotEmpty) {
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null) throw Exception(l10n.adresseNichtGefunden);
        lat = coords['lat'];
        lon = coords['lng'];
      }
      final String id = const Uuid().v4();
      final timestamp = DateTime.now().toUtc().toIso8601String();

      final auftragMap = {
        'id': id,
        'kunde_id': user.id,
        'titel': _titelController.text.trim(),
        'beschreibung': _beschreibungController.text.trim(),
        'kategorie': _selectedKategorie,
        'adresse': adresse.isEmpty ? null : adresse,
        'latitude': lat,
        'longitude': lon,
        'status': 'offen',
        'erstellt_am': timestamp,
        'aktualisiert_am': timestamp,
        'telefon': telefon,
        'so_schnell_wie_moeglich': soSchnellWieMoeglich,
        'termin_datum': (!soSchnellWieMoeglich && terminDatum != null)
            ? terminDatum!.toIso8601String().substring(0, 10)
            : null,
        'zeit_von': (!soSchnellWieMoeglich && zeitVon != null)
            ? _timeOfDayToString(zeitVon!)
            : null,
        'zeit_bis': (!soSchnellWieMoeglich && zeitBis != null)
            ? _timeOfDayToString(zeitBis!)
            : null,
        'wiederkehrend': _wiederkehrend,
        'intervall': _wiederkehrend ? _intervall : null,
        'wochentag': _wiederkehrend ? _wochentag : null,
        'anzahl_wiederholungen': _wiederkehrend ? _anzahlWiederholungen : null,
        'wiederholen_bis': _wiederkehrend && _wiederholenBis != null
            ? _wiederholenBis!.toIso8601String().substring(0, 10)
            : null,
      };

      await _supabase.from('auftraege').insert(auftragMap);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.auftragGespeichert)),
      );
      Navigator.pop(context);
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.unbekannterFehler(e.toString());
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titelController.dispose();
    _beschreibungController.dispose();
    _adresseController.dispose();
    _telefonController.dispose();
    super.dispose();
  }

  // Helper: Key zu Übersetzung
  String getKategorieLabel(String key, AppLocalizations l10n) {
  switch (key) {
    case 'category_babysitter':
      return l10n.category_babysitter;
    case 'category_catering':
      return l10n.category_catering;
    case 'category_dachdecker':
      return l10n.category_dachdecker;
    case 'category_elektriker':
      return l10n.category_elektriker;
    case 'category_ernaehrungsberatung':
      return l10n.category_ernaehrungsberatung;
    case 'category_eventplanung':
      return l10n.category_eventplanung;
    case 'category_fahrdienste':
      return l10n.category_fahrdienste;
    case 'category_fahrlehrer':
      return l10n.category_fahrlehrer;
    case 'category_fensterputzer':
      return l10n.category_fensterputzer;
    case 'category_fliesenleger':
      return l10n.category_fliesenleger;
    case 'category_fotografie':
      return l10n.category_fotografie;
    case 'category_friseur':
      return l10n.category_friseur;
    case 'category_gartenpflege':
      return l10n.category_gartenpflege;
    case 'category_grafikdesign':
      return l10n.category_grafikdesign;
    case 'category_handy_reparatur':
      return l10n.category_handy_reparatur;
    case 'category_haushaltsreinigung':
      return l10n.category_haushaltsreinigung;
    case 'category_hausmeisterservice':
      return l10n.category_hausmeisterservice;
    case 'category_heizungsbauer':
      return l10n.category_heizungsbauer;
    case 'category_hundesitter':
      return l10n.category_hundesitter;
    case 'category_it_support':
      return l10n.category_it_support;
    case 'category_klempner':
      return l10n.category_klempner;
    case 'category_kosmetik':
      return l10n.category_kosmetik;
    case 'category_kuenstler':
      return l10n.category_kuenstler;
    case 'category_kurierdienst':
      return l10n.category_kurierdienst;
    case 'category_maler':
      return l10n.category_maler;
    case 'category_massagen':
      return l10n.category_massagen;
    case 'category_maurer':
      return l10n.category_maurer;
    case 'category_moebelaufbau':
      return l10n.category_moebelaufbau;
    case 'category_musikunterricht':
      return l10n.category_musikunterricht;
    case 'category_nachhilfe':
      return l10n.category_nachhilfe;
    case 'category_nagelstudio':
      return l10n.category_nagelstudio;
    case 'category_pc_reparatur':
      return l10n.category_pc_reparatur;
    case 'category_partyservice':
      return l10n.category_partyservice;
    case 'category_personal_trainer':
      return l10n.category_personal_trainer;
    case 'category_rasenmaeher_service':
      return l10n.category_rasenmaeher_service;
    case 'category_rechtsberatung':
      return l10n.category_rechtsberatung;
    case 'category_reparaturdienste':
      return l10n.category_reparaturdienste;
    case 'category_seniorenbetreuung':
      return l10n.category_seniorenbetreuung;
    case 'category_social_media':
      return l10n.category_social_media;
    case 'category_sonstige':
      return l10n.category_sonstige;
    case 'category_sprachunterricht':
      return l10n.category_sprachunterricht;
    case 'category_steuerberatung':
      return l10n.category_steuerberatung;
    case 'category_tischler':
      return l10n.category_tischler;
    case 'category_transport':
      return l10n.category_transport;
    case 'category_umzugstransporte':
      return l10n.category_umzugstransporte;
    case 'category_umzugshelfer':
      return l10n.category_umzugshelfer;
    case 'category_uebersetzungen':
      return l10n.category_uebersetzungen;
    case 'category_waescheservice':
      return l10n.category_waescheservice;
    case 'category_webdesign':
      return l10n.category_webdesign;
    case 'category_einkaufsservice':
      return l10n.category_einkaufsservice;
    case 'category_haustierbetreuung':
      return l10n.category_haustierbetreuung;
    default:
      return key;
  }
}


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(l10n.auftragErstellenTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 18),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          l10n.auftragEinstellenUeberschrift,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _titelController,
                          decoration: InputDecoration(
                            labelText: l10n.titelLabel,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.titelValidator;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _beschreibungController,
                          decoration: InputDecoration(
                            labelText: l10n.beschreibungLabel,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedKategorie,
                          decoration: InputDecoration(
                            labelText: l10n.kategorieLabel,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                          items: kategorieKeys.map((key) {
                            return DropdownMenuItem(
                              value: key,
                              child: Text(getKategorieLabel(key, l10n)),
                            );
                          }).toList(),
                          onChanged: (wert) {
                            if (wert != null) {
                              setState(() {
                                _selectedKategorie = wert;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_heimatAdresse != null && _heimatAdresse!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.home, color: Color(0xFF3876BF)),
                                label: Text(
                                  l10n.heimatadresseEinfuegen,
                                  style: const TextStyle(
                                    color: Color(0xFF3876BF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _adresseController.text = _heimatAdresse!;
                                  });
                                },
                              ),
                            ),
                          ),
                        TextFormField(
                          controller: _adresseController,
                          decoration: InputDecoration(
                            labelText: l10n.adresseLabel,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefonController,
                          decoration: InputDecoration(
                            labelText: l10n.telefonnummerLabel,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.telefonnummerValidator;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.ausfuehrungszeitpunkt, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: soSchnellWieMoeglich,
                                  onChanged: (val) {
                                    setState(() {
                                      soSchnellWieMoeglich = true;
                                      terminDatum = null;
                                      zeitVon = null;
                                      zeitBis = null;
                                    });
                                  },
                                ),
                                Text(l10n.soSchnellWieMoeglich),
                                Radio<bool>(
                                  value: false,
                                  groupValue: soSchnellWieMoeglich,
                                  onChanged: (val) {
                                    setState(() {
                                      soSchnellWieMoeglich = false;
                                    });
                                  },
                                ),
                                Text(l10n.geplant),
                              ],
                            ),
                            if (!soSchnellWieMoeglich) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.calendar_today, size: 18),
                                      label: Text(terminDatum == null
                                          ? l10n.datumWaehlen
                                          : '${terminDatum!.day.toString().padLeft(2, '0')}.${terminDatum!.month.toString().padLeft(2, '0')}.${terminDatum!.year}'),
                                      onPressed: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: terminDatum ?? DateTime.now().add(const Duration(days: 1)),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(const Duration(days: 365)),
                                        );
                                        if (picked != null) setState(() => terminDatum = picked);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.access_time, size: 18),
                                      label: Text(zeitVon == null
                                          ? l10n.zeitVon
                                          : '${zeitVon!.hour.toString().padLeft(2, '0')}:${zeitVon!.minute.toString().padLeft(2, '0')}'),
                                      onPressed: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: const TimeOfDay(hour: 10, minute: 0),
                                        );
                                        if (picked != null) setState(() => zeitVon = picked);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.access_time, size: 18),
                                      label: Text(zeitBis == null
                                          ? l10n.zeitBis
                                          : '${zeitBis!.hour.toString().padLeft(2, '0')}:${zeitBis!.minute.toString().padLeft(2, '0')}'),
                                      onPressed: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: const TimeOfDay(hour: 12, minute: 0),
                                        );
                                        if (picked != null) setState(() => zeitBis = picked);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
                        CheckboxListTile(
                          value: _wiederkehrend,
                          onChanged: (val) {
                            setState(() {
                              _wiederkehrend = val ?? false;
                            });
                          },
                          title: Text(l10n.wiederkehrendCheckbox),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        if (_wiederkehrend) ...[
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _intervall,
                            decoration: InputDecoration(labelText: l10n.intervallLabel),
                            items: intervallOptionen
                                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                                .toList(),
                            onChanged: (val) => setState(() => _intervall = val),
                            validator: (val) => val == null ? l10n.intervallValidator : null,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _wochentag,
                            decoration: InputDecoration(labelText: l10n.wochentagLabel),
                            items: wochentage
                                .map((tag) => DropdownMenuItem(value: tag, child: Text(tag)))
                                .toList(),
                            onChanged: (val) => setState(() => _wochentag = val),
                            validator: (val) => val == null ? l10n.wochentagValidator : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(labelText: l10n.anzahlWiederholungenLabel),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              _anzahlWiederholungen = int.tryParse(val);
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(_wiederholenBis == null
                                    ? l10n.wiederholenBisNichtGesetzt
                                    : l10n.wiederholenBisLabel(_wiederholenBis!.toLocal().toString().split(' ')[0])),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _wiederholenBis ?? DateTime.now().add(const Duration(days: 30)),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (picked != null) setState(() => _wiederholenBis = picked);
                                },
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 28),
                        if (_errorMessage != null) ...[
                          Text(
                            l10n.errorPrefix(_errorMessage!),
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _auftragAbschicken,
                            icon: const Icon(Icons.send_rounded),
                            label: Text(
                              l10n.auftragAbschicken,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
