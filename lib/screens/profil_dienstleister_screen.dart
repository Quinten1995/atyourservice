// lib/screens/profil_dienstleister_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilDienstleisterScreen extends StatefulWidget {
  const ProfilDienstleisterScreen({Key? key}) : super(key: key);

  @override
  _ProfilDienstleisterScreenState createState() => _ProfilDienstleisterScreenState();
}

class _ProfilDienstleisterScreenState extends State<ProfilDienstleisterScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  // Controller für die Eingabefelder
  final _nameController = TextEditingController();
  String _selectedKategorie = 'Elektriker'; // Standard-Wert
  final _beschreibungController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _ladeProfil();
  }

  Future<void> _ladeProfil() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Nicht eingeloggt');

      // Profil abrufen (wenn vorhanden)
      final data = await _supabase
          .from('dienstleister_details')
          .select()
          .eq('user_id', user.id)
          .maybeSingle() as Map<String, dynamic>?;

      if (data != null) {
        _nameController.text = data['name'] as String;
        _selectedKategorie = data['kategorie'] as String;
        _beschreibungController.text = data['beschreibung'] as String? ?? '';
        _latitudeController.text = data['latitude']?.toString() ?? '';
        _longitudeController.text = data['longitude']?.toString() ?? '';
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

  Future<void> _speichereProfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Nicht eingeloggt');

      final lat = double.tryParse(_latitudeController.text.trim());
      final lon = double.tryParse(_longitudeController.text.trim());

      await _supabase.from('dienstleister_details').upsert({
        'user_id': user.id,
        'name': _nameController.text.trim(),
        'kategorie': _selectedKategorie,
        'beschreibung': _beschreibungController.text.trim(),
        'latitude': lat,
        'longitude': lon,
        'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil gespeichert!')),
      );
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
  void dispose() {
    _nameController.dispose();
    _beschreibungController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil (Dienstleister)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Fehler: $_errorMessage'))
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Bitte Name eingeben';
                            return null;
                          },
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
                          controller: _beschreibungController,
                          decoration: const InputDecoration(labelText: 'Beschreibung'),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _latitudeController,
                          decoration: const InputDecoration(labelText: 'Latitude (z.B. 50.9375)'),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _longitudeController,
                          decoration: const InputDecoration(labelText: 'Longitude (z.B. 6.9603)'),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _speichereProfil,
                          child: const Text('Profil speichern'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
