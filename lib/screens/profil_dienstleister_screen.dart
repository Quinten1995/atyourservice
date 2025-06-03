// lib/screens/profil_dienstleister_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atyourservice/utils/geocoding_service.dart';

class ProfilDienstleisterScreen extends StatefulWidget {
  const ProfilDienstleisterScreen({Key? key}) : super(key: key);

  @override
  _ProfilDienstleisterScreenState createState() =>
      _ProfilDienstleisterScreenState();
}

class _ProfilDienstleisterScreenState
    extends State<ProfilDienstleisterScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  // Controller für Formular-Felder
  final _nameController = TextEditingController();
  final _beschreibungController = TextEditingController();
  String _selectedKategorie = 'Elektriker';
  final _adresseController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // JWT in der Konsole ausgeben:
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      print('––– MEIN JWT-TOKEN: ${session.accessToken}');
    } else {
      print('––– KEINE SESSION GEFUNDEN');
    }

    _ladeProfil();
  }

  Future<void> _ladeProfil() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Bitte zuerst einloggen');

      // Prüfen, ob es schon ein Profil gibt
      final data = await _supabase
          .from('dienstleister_details')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (data != null) {
        _nameController.text = data['name'] as String? ?? '';
        _beschreibungController.text = data['beschreibung'] as String? ?? '';
        _selectedKategorie = data['kategorie'] as String? ?? 'Elektriker';
        _adresseController.text = data['adresse'] as String? ?? '';
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

  Future<void> _profilSpeichern() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Bitte zuerst einloggen');

      final name = _nameController.text.trim();
      final beschreibung = _beschreibungController.text.trim();
      final kategorie = _selectedKategorie;
      final adresse = _adresseController.text.trim();

      double? lat;
      double? lon;

      if (adresse.isNotEmpty) {
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null) throw Exception('Adresse nicht gefunden. Bitte prüfen.');
        lat = coords['lat'];
        lon = coords['lng'];
      }

      // Lösung A: Nur UPDATE, weil Datensatz bereits existiert
      // Wir fügen hier .select() ans Ende, damit tatsächlich eine Query ausgeführt wird
      await _supabase
          .from('dienstleister_details')
          .update({
            'name': name,
            'beschreibung': beschreibung,
            'kategorie': kategorie,
            'adresse': adresse.isEmpty ? null : adresse,
            'latitude': lat,
            'longitude': lon,
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('user_id', user.id)
          .select(); // ohne .select() würde keine Anfrage gesendet

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil wurde erfolgreich aktualisiert!')),
      );
    } catch (e) {
      // Wenn Supabase einen Fehler wirft, fangen wir ihn hier ab
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dienstleister-Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Name eingeben';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _beschreibungController,
                        decoration:
                            const InputDecoration(labelText: 'Beschreibung'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedKategorie,
                        decoration:
                            const InputDecoration(labelText: 'Kategorie'),
                        items: const [
                          DropdownMenuItem(
                              value: 'Elektriker', child: Text('Elektriker')),
                          DropdownMenuItem(
                              value: 'Klempner', child: Text('Klempner')),
                          DropdownMenuItem(
                              value: 'Maler', child: Text('Maler')),
                        ],
                        onChanged: (wert) {
                          if (wert != null) {
                            setState(() {
                              _selectedKategorie = wert;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Kategorie auswählen';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _adresseController,
                        decoration: const InputDecoration(
                          labelText: 'Adresse (z. B. Straße, PLZ, Stadt)',
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_errorMessage != null) ...[
                        Text(
                          'Fehler: $_errorMessage',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                      ],
                      ElevatedButton(
                        onPressed: _profilSpeichern,
                        child: const Text('Profil speichern'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
