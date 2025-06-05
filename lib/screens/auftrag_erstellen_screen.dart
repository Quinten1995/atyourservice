import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/geocoding_service.dart';
import '../data/kategorien.dart'; // <-- Zentrale Kategorienliste importieren

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

  String _selectedKategorie = kategorieListe.first;
  bool _isLoading = false;
  String? _errorMessage;

  String? _heimatAdresse;

  // Planung / Termin
  bool soSchnellWieMoeglich = true;
  DateTime? terminDatum;
  TimeOfDay? zeitVon;
  TimeOfDay? zeitBis;

  // Intervall / Wiederkehrend (NEU)
  bool _wiederkehrend = false;
  String? _intervall; // z.B. "wöchentlich", "alle 2 Wochen"
  String? _wochentag;
  int? _anzahlWiederholungen;
  DateTime? _wiederholenBis;

  static const intervallOptionen = [
    "wöchentlich",
    "alle 2 Wochen",
    "monatlich",
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
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Bitte zuerst einloggen');

      final adresse = _adresseController.text.trim();
      final telefon = _telefonController.text.trim();
      double? lat, lon;
      if (adresse.isNotEmpty) {
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null) throw Exception('Adresse nicht gefunden.');
        lat = coords['lat'];
        lon = coords['lng'];
      }
      final String id = const Uuid().v4();
      final timestamp = DateTime.now().toUtc().toIso8601String();

      // Map für Auftrag
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
        // NEU: Intervall/Wiederkehrend
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
        const SnackBar(content: Text('Auftrag wurde gespeichert!')),
      );
      Navigator.pop(context);
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unbekannter Fehler: $e';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Neuen Auftrag erstellen', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          'Jetzt Auftrag einstellen',
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
                            labelText: 'Titel',
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
                              return 'Bitte Titel eingeben';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _beschreibungController,
                          decoration: InputDecoration(
                            labelText: 'Beschreibung',
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
                            labelText: 'Kategorie',
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
                          items: kategorieListe.map((kategorie) {
                            return DropdownMenuItem(
                              value: kategorie,
                              child: Text(kategorie),
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

                        // Heimatadresse einfügen
                        if (_heimatAdresse != null && _heimatAdresse!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.home, color: Color(0xFF3876BF)),
                                label: const Text(
                                  "Heimatadresse einfügen",
                                  style: TextStyle(
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
                            labelText: 'Adresse (z. B. Alter Markt 76, 50667 Köln)',
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
                            labelText: 'Telefonnummer',
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
                              return 'Bitte Telefonnummer eingeben';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Termin/Planungsauswahl
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ausführungszeitpunkt', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                const Text('So schnell wie möglich'),
                                Radio<bool>(
                                  value: false,
                                  groupValue: soSchnellWieMoeglich,
                                  onChanged: (val) {
                                    setState(() {
                                      soSchnellWieMoeglich = false;
                                    });
                                  },
                                ),
                                const Text('Geplant'),
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
                                          ? 'Datum wählen'
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
                                          ? 'Zeit von'
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
                                          ? 'Zeit bis'
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

                        // NEU: Wiederkehrend/Intervall
                        CheckboxListTile(
                          value: _wiederkehrend,
                          onChanged: (val) {
                            setState(() {
                              _wiederkehrend = val ?? false;
                            });
                          },
                          title: const Text("Wiederkehrender Auftrag?"),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        if (_wiederkehrend) ...[
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _intervall,
                            decoration: const InputDecoration(labelText: "Intervall"),
                            items: intervallOptionen
                                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                                .toList(),
                            onChanged: (val) => setState(() => _intervall = val),
                            validator: (val) => val == null ? 'Bitte Intervall wählen' : null,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _wochentag,
                            decoration: const InputDecoration(labelText: "Wochentag"),
                            items: wochentage
                                .map((tag) => DropdownMenuItem(value: tag, child: Text(tag)))
                                .toList(),
                            onChanged: (val) => setState(() => _wochentag = val),
                            validator: (val) => val == null ? 'Bitte Wochentag wählen' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Anzahl Wiederholungen (optional)"),
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
                                    ? "Wiederholen bis: nicht gesetzt"
                                    : "Wiederholen bis: ${_wiederholenBis!.toLocal().toString().split(' ')[0]}"),
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
                            'Fehler: $_errorMessage',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _auftragAbschicken,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text(
                              'Auftrag abschicken',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
