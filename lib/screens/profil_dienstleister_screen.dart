import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:atyourservice/utils/geocoding_service.dart';
import '../data/kategorien.dart';

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
  String _selectedKategorie = kategorieListe.first;
  final _adresseController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  double? _durchschnitt;
  int _anzahlBewertungen = 0;

  String? _profilbildPfad;    // Nur relativer Pfad (ab Bucket)!
  File? _neuesProfilbild;     // Lokale Datei (falls neu ausgewählt)

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  void initState() {
    super.initState();
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
        final gespeicherteKategorie = data['kategorie'] as String? ?? kategorieListe.first;
        _selectedKategorie = kategorieListe.contains(gespeicherteKategorie)
            ? gespeicherteKategorie
            : kategorieListe.first;
        _adresseController.text = data['adresse'] as String? ?? '';
        _telefonController.text = data['telefon'] as String? ?? '';
        _emailController.text = (data['email'] as String?)?.isNotEmpty == true
            ? data['email'] as String
            : _emailController.text;
        _profilbildPfad = data['profilbild_url'] as String?;
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

      // === PROFILBILD-UPLOAD (Root im Bucket, kein Unterordner mehr!) ===
      String? profilbildPfad = _profilbildPfad;
      if (_neuesProfilbild != null) {
        final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        // Upload direkt in den Bucket-Root (kein extra Ordner!)
        await _supabase.storage
            .from('profile-pics')
            .upload(fileName, _neuesProfilbild!, fileOptions: const FileOptions(upsert: true));
        profilbildPfad = 'profile-pics/$fileName'; // **Nur Pfad, keine URL!**
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
            'profilbild_url': profilbildPfad,
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
          }, onConflict: 'user_id')
          .select();

      setState(() {
        _profilbildPfad = profilbildPfad;
        _neuesProfilbild = null;
      });

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

  Future<void> _bildWaehlen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _neuesProfilbild = File(picked.path);
      });
    }
  }

  void _showDeleteProfileDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Profil löschen'),
        content: const Text(
          'Möchtest du dein Profil wirklich löschen?\n\n'
          'Sende uns dazu bitte eine E-Mail an:\n'
          'quintenhessmann1995@yahoo.com\n\n'
          'Wir löschen dein Konto und alle personenbezogenen Daten umgehend gemäß DSGVO.',
        ),
        actions: [
          TextButton(
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('E-Mail senden'),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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

  Widget _profilbildWidget() {
    final double avatarSize = 96;
    Widget avatar;

    if (_neuesProfilbild != null) {
      avatar = CircleAvatar(
        radius: avatarSize / 2,
        backgroundImage: FileImage(_neuesProfilbild!),
      );
    } else if (_profilbildPfad != null && _profilbildPfad!.isNotEmpty) {
      final publicUrl = 'https://npqanssmfxdvwauuaemd.supabase.co/storage/v1/object/public/${_profilbildPfad!}';
      avatar = CircleAvatar(
        radius: avatarSize / 2,
        backgroundImage: NetworkImage(publicUrl),
      );
    } else {
      avatar = CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: 48, color: Colors.grey[700]),
      );
    }

    return Column(
      children: [
        avatar,
        const SizedBox(height: 7),
        TextButton.icon(
          onPressed: _bildWaehlen,
          icon: const Icon(Icons.edit, size: 20),
          label: const Text('Profilbild ändern'),
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
      ],
    );
  }

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
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _profilbildWidget(),
                      const SizedBox(height: 14),
                      Container(
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
                      // PROFIL LÖSCHEN BUTTON
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('Profil löschen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 1,
                          ),
                          onPressed: _showDeleteProfileDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
