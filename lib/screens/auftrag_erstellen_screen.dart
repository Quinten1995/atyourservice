// lib/screens/auftrag_erstellen_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

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
  final _latitudeController = TextEditingController();  // neu: Latitude-Feld
  final _longitudeController = TextEditingController(); // neu: Longitude-Feld

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

      // Koordinaten parsen (optionales Feld)
      double? lat;
      double? lon;
      if (_latitudeController.text.trim().isNotEmpty &&
          _longitudeController.text.trim().isNotEmpty) {
        lat = double.tryParse(_latitudeController.text.trim());
        lon = double.tryParse(_longitudeController.text.trim());
        if (lat == null || lon == null) {
          throw Exception('Bitte gültige Zahlen für Latitude und Longitude eingeben');
        }
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

      // Insert in auftraege mit status = 'offen' (kleingeschrieben)
      await _supabase.from('auftraege').insert({
        'id': id,
        'kunde_id': user.id,
        'titel': _titelController.text.trim(),
        'beschreibung': _beschreibungController.text.trim(),
        'kategorie': _selectedKategorie,
        'adresse': _adresseController.text.trim().isEmpty
            ? null
            : _adresseController.text.trim(),
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
  void dispose() {
    _titelController.dispose();
    _beschreibungController.dispose();
    _adresseController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  String? _validateLatitude(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final v = double.tryParse(value);
    if (v == null || v < -90 || v > 90) return 'Ungültige Latitude';
    return null;
  }

  String? _validateLongitude(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final v = double.tryParse(value);
    if (v == null || v < -180 || v > 180) return 'Ungültige Longitude';
    return null;
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
                        decoration: const InputDecoration(labelText: 'Adresse (optional)'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _latitudeController,
                        decoration: const InputDecoration(labelText: 'Latitude (z. B. 50.9375)'),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: _validateLatitude,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _longitudeController,
                        decoration: const InputDecoration(labelText: 'Longitude (z. B. 6.9603)'),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: _validateLongitude,
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
