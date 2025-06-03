// lib/screens/auftrag_erstellen_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:atyourservice/utils/geocoding_service.dart';

class AuftragErstellenScreen extends StatefulWidget {
  const AuftragErstellenScreen({Key? key}) : super(key: key);

  @override
  _AuftragErstellenScreenState createState() => _AuftragErstellenScreenState();
}

class _AuftragErstellenScreenState extends State<AuftragErstellenScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  // Controller für Formular-Felder
  final _titelController = TextEditingController();
  final _beschreibungController = TextEditingController();
  String _selectedKategorie = 'Elektriker'; // Standard-Kategorie
  final _adresseController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _auftragAbschicken() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Bitte zuerst einloggen');
      }

      final adresse = _adresseController.text.trim();
      double? lat;
      double? lon;

      if (adresse.isNotEmpty) {
        // Adresse per Geocoding in Koordinaten umwandeln
        // "Koeln" statt "Köln" ist in der Regel in Ordnung
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null) {
          throw Exception('Adresse nicht gefunden. Bitte prüfen.');
        }
        lat = coords['lat'];
        lon = coords['lng'];
      }

      // Upsert in users (falls noch nicht vorhanden)
      try {
        await _supabase.from('users').upsert({
          'id': user.id,
          'email': user.email,
          'rolle': 'kunde',
          'erstellt_am': DateTime.now().toUtc().toIso8601String(),
        });
      } catch (_) {
        // Ignoriere Fehler, falls schon vorhanden
      }

      final String id = const Uuid().v4();
      final timestamp = DateTime.now().toUtc().toIso8601String();

      // Führe den Insert aus, ohne response.error zu prüfen
      await _supabase.from('auftraege').insert({
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
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Auftrag wurde erfolgreich gespeichert!')),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neuen Auftrag erstellen')),
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
                        controller: _titelController,
                        decoration: const InputDecoration(labelText: 'Titel'),
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
                        decoration: const InputDecoration(labelText: 'Beschreibung'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedKategorie,
                        decoration: const InputDecoration(labelText: 'Kategorie'),
                        items: const [
                          DropdownMenuItem(value: 'Elektriker', child: Text('Elektriker')),
                          DropdownMenuItem(value: 'Klempner', child: Text('Klempner')),
                          DropdownMenuItem(value: 'Maler', child: Text('Maler')),
                          // Weitere Kategorien nach Bedarf
                        ],
                        onChanged: (wert) {
                          if (wert != null) {
                            setState(() {
                              _selectedKategorie = wert;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _adresseController,
                        decoration: const InputDecoration(
                          labelText: 'Adresse (z. B. Alter Markt 76, 50667 Koeln)',
                        ),
                        validator: (value) {
                          // Adresse ist optional
                          return null;
                        },
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
                        onPressed: _auftragAbschicken,
                        child: const Text('Auftrag abschicken'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
