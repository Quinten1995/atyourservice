import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/geocoding_service.dart';

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
  String _selectedKategorie = 'Elektriker';
  final _adresseController = TextEditingController();
  final _telefonController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

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
        'telefon': telefon,
      });
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
                          items: const [
                            DropdownMenuItem(value: 'Elektriker', child: Text('Elektriker')),
                            DropdownMenuItem(value: 'Klempner', child: Text('Klempner')),
                            DropdownMenuItem(value: 'Maler', child: Text('Maler')),
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
