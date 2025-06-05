import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atyourservice/utils/geocoding_service.dart';
import '../data/kategorien.dart'; // <--- Zentrale Kategorienliste importieren

class ProfilDienstleisterScreen extends StatefulWidget {
  const ProfilDienstleisterScreen({Key? key}) : super(key: key);

  @override
  _ProfilDienstleisterScreenState createState() => _ProfilDienstleisterScreenState();
}

class _ProfilDienstleisterScreenState extends State<ProfilDienstleisterScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _beschreibungController = TextEditingController();
  final _telefonController = TextEditingController();
  final _emailController = TextEditingController(text: 'lala@popo.com');
  String _selectedKategorie = kategorieListe.first; // <--- Defaultwert auf zentrale Liste setzen
  final _adresseController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  double? _durchschnitt;
  int _anzahlBewertungen = 0;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  void initState() {
    super.initState();

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      print('––– MEIN JWT-TOKEN: ${session.accessToken}');
    } else {
      print('––– KEINE SESSION GEFUNDEN');
    }

    _ladeProfil();
    _ladeBewertungen();
  }

  Future<void> _ladeProfil() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Bitte zuerst einloggen');
      final data = await _supabase
          .from('dienstleister_details')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (data != null) {
        _nameController.text = data['name'] as String? ?? '';
        _beschreibungController.text = data['beschreibung'] as String? ?? '';
        // --- Prüfe, ob gespeicherte Kategorie gültig ist, sonst fallback auf erste:
        final gespeicherteKategorie = data['kategorie'] as String? ?? kategorieListe.first;
        _selectedKategorie = kategorieListe.contains(gespeicherteKategorie)
            ? gespeicherteKategorie
            : kategorieListe.first;
        _adresseController.text = data['adresse'] as String? ?? '';
        _telefonController.text = data['telefon'] as String? ?? '';
        _emailController.text = (data['email'] as String?)?.isNotEmpty == true
            ? data['email'] as String
            : _emailController.text;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Laden des Profils: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _ladeBewertungen() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    final res = await _supabase
        .from('bewertungen')
        .select('bewertung')
        .eq('dienstleister_id', user.id);

    if (res is List && res.isNotEmpty) {
      final values = res.map((b) => (b['bewertung'] as int?) ?? 0).toList();
      setState(() {
        _durchschnitt = values.reduce((a, b) => a + b) / values.length;
        _anzahlBewertungen = values.length;
      });
    } else {
      setState(() {
        _durchschnitt = null;
        _anzahlBewertungen = 0;
      });
    }
  }

  Future<void> _profilSpeichern() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Bitte zuerst einloggen');

      final name         = _nameController.text.trim();
      final beschreibung = _beschreibungController.text.trim();
      final telefon      = _telefonController.text.trim();
      final email        = _emailController.text.trim();
      final kategorie    = _selectedKategorie;
      final adresse      = _adresseController.text.trim();

      double? lat;
      double? lon;
      if (adresse.isNotEmpty) {
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null) throw Exception('Adresse nicht gefunden. Bitte prüfen.');
        lat = coords['lat'];
        lon = coords['lng'];
      }

      await _supabase
          .from('dienstleister_details')
          .upsert({
            'user_id':        user.id,
            'name':           name,
            'beschreibung':   beschreibung,
            'kategorie':      kategorie,
            'adresse':        adresse.isEmpty ? null : adresse,
            'latitude':       lat,
            'longitude':      lon,
            'telefon':        telefon,
            'email':          email,
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
          }, onConflict: 'user_id')
          .select();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil wurde erfolgreich gespeichert!')),
      );
      _ladeBewertungen();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _beschreibungController.dispose();
    _adresseController.dispose();
    _telefonController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Dienstleister-Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_durchschnitt != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 28),
                                const SizedBox(width: 6),
                                Text(
                                  '${_durchschnitt!.toStringAsFixed(2)} / 5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  '($_anzahlBewertungen Bewertungen)',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )
                          else
                            const Text(
                              'Noch keine Bewertungen',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          const SizedBox(height: 26),
                          TextFormField(
                            controller: _nameController,
                            decoration: _inputDecoration('Name'),
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Bitte Name eingeben' : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _beschreibungController,
                            decoration: _inputDecoration('Beschreibung'),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 18),
                          DropdownButtonFormField<String>(
                            value: _selectedKategorie,
                            decoration: _inputDecoration('Kategorie'),
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
                            validator: (value) => (value == null || value.isEmpty)
                                ? 'Bitte Kategorie auswählen'
                                : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _adresseController,
                            decoration: _inputDecoration('Adresse (z. B. Straße, PLZ, Stadt)'),
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _telefonController,
                            decoration: _inputDecoration('Telefon'),
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Bitte Telefonnummer angeben' : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration('E-Mail'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Bitte E-Mail angeben';
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Bitte gültige E-Mail-Adresse eingeben';
                              }
                              return null;
                            },
                          ),
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
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: primaryColor,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                elevation: 2,
                              ),
                              onPressed: _profilSpeichern,
                              child: const Text('Profil speichern'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
