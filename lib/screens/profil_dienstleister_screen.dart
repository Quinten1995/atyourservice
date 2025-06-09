import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:atyourservice/utils/geocoding_service.dart';
import '../data/kategorien.dart';
import '../l10n/app_localizations.dart';
import 'premium_screen.dart';

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
  final _emailController = TextEditingController();
  String _selectedKategorie = kategorieListe.first;
  final _adresseController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  double? _durchschnitt;
  int _anzahlBewertungen = 0;

  String? _profilbildUrl;
  File? _neuesProfilbild;

  DateTime? _lastProfileChange;
  String? _aboTyp;

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
      if (user == null) throw Exception(AppLocalizations.of(context)!.pleaseLogin);
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
        _profilbildUrl = data['profilbild_url'] as String?;
        _lastProfileChange = data['last_profile_change'] != null
            ? DateTime.parse(data['last_profile_change'])
            : null;
      }

      final userData = await _supabase
          .from('users')
          .select('abo_typ')
          .eq('id', user.id)
          .maybeSingle();
      _aboTyp = userData?['abo_typ'] as String? ?? 'free';
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
      if (user == null) throw Exception(AppLocalizations.of(context)!.pleaseLogin);

      final isFree = (_aboTyp ?? 'free') == 'free';

      if (isFree && _lastProfileChange != null) {
        final now = DateTime.now();
        final diff = now.difference(_lastProfileChange!).inDays;
        if (diff < 20) {
          final naechstesDatum = _lastProfileChange!.add(const Duration(days: 20));
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.changeNotAllowedTitle),
              content: Text(AppLocalizations.of(context)!.changeNotAllowedContent(
                  naechstesDatum.toLocal().toString().substring(0, 10))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.ok)),
              ],
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final name = _nameController.text.trim();
      final beschreibung = _beschreibungController.text.trim();
      final telefon = _telefonController.text.trim();
      final email = _emailController.text.trim();
      final kategorie = _selectedKategorie;
      final adresse = _adresseController.text.trim();

      double? lat;
      double? lon;
      if (adresse.isNotEmpty) {
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null) throw Exception(AppLocalizations.of(context)!.addressNotFound);
        lat = coords['lat'];
        lon = coords['lng'];
      }

      String? profilbildUrl = _profilbildUrl;
      if (_neuesProfilbild != null) {
        final storageResponse = await _supabase.storage
            .from('profile-pics')
            .upload(
              '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg',
              _neuesProfilbild!,
              fileOptions: const FileOptions(upsert: true),
            );
        final String publicUrl = _supabase.storage
            .from('profile-pics')
            .getPublicUrl(storageResponse);
        profilbildUrl = publicUrl;
      }

      await _supabase
          .from('dienstleister_details')
          .upsert({
            'user_id': user.id,
            'name': name,
            'beschreibung': beschreibung,
            'kategorie': kategorie,
            'adresse': adresse.isEmpty ? null : adresse,
            'latitude': lat,
            'longitude': lon,
            'telefon': telefon,
            'email': email,
            'profilbild_url': profilbildUrl,
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
            if (isFree) 'last_profile_change': DateTime.now().toUtc().toIso8601String(),
          }, onConflict: 'user_id')
          .select();

      setState(() {
        _profilbildUrl = profilbildUrl;
        _neuesProfilbild = null;
        if (isFree) {
          _lastProfileChange = DateTime.now();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileSaved)),
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
          borderSide: const BorderSide(color: primaryColor, width: 2),
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
    } else if (_profilbildUrl != null && _profilbildUrl!.isNotEmpty) {
      avatar = CircleAvatar(
        radius: avatarSize / 2,
        backgroundImage: NetworkImage(_profilbildUrl!),
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
          label: Text(AppLocalizations.of(context)!.changeProfileImage),
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _premiumButtonOben(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(Icons.star, color: Colors.yellow[700]),
          label: Text(AppLocalizations.of(context)!.upgradeToPremium),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[600],
            foregroundColor: Colors.black87,
            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PremiumScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? limitHinweis;
    final isFree = (_aboTyp ?? 'free') == 'free';
    if (isFree && _lastProfileChange != null) {
      final naechstesDatum = _lastProfileChange!.add(const Duration(days: 20));
      final nochGesperrt = DateTime.now().isBefore(naechstesDatum);
      if (nochGesperrt) {
        limitHinweis = Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            AppLocalizations.of(context)!.changeLimitHint(
              naechstesDatum.toLocal().toString().substring(0, 10),
            ),
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profileAppBar),
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
                      _premiumButtonOben(context),
                      const SizedBox(height: 10),
                      _profilbildWidget(),
                      const SizedBox(height: 14),
                      if (limitHinweis != null) limitHinweis,
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
                                      AppLocalizations.of(context)!.ratingsCount(
                                        _anzahlBewertungen.toString(),
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  AppLocalizations.of(context)!.noRatingsYet,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              const SizedBox(height: 26),
                              TextFormField(
                                controller: _nameController,
                                decoration: _inputDecoration(AppLocalizations.of(context)!.nameLabel),
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? AppLocalizations.of(context)!.nameValidator
                                        : null,
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _beschreibungController,
                                decoration: _inputDecoration(AppLocalizations.of(context)!.descriptionLabel),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 18),
                              DropdownButtonFormField<String>(
                                value: _selectedKategorie,
                                decoration: _inputDecoration(AppLocalizations.of(context)!.categoryLabel),
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
                                    ? AppLocalizations.of(context)!.categoryValidator
                                    : null,
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _adresseController,
                                decoration: _inputDecoration(AppLocalizations.of(context)!.addressLabel),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _telefonController,
                                decoration: _inputDecoration(AppLocalizations.of(context)!.phoneLabel),
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? AppLocalizations.of(context)!.phoneValidator
                                        : null,
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _emailController,
                                decoration: _inputDecoration(AppLocalizations.of(context)!.emailLabel),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.emailEmptyValidator;
                                  }
                                  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailRegExp.hasMatch(value)) {
                                    return AppLocalizations.of(context)!.emailInvalidValidator;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "${AppLocalizations.of(context)!.errorPrefix(_errorMessage!)}",
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.save),
                                  label: Text(AppLocalizations.of(context)!.profileSaveButton),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: _isLoading ? null : _profilSpeichern,
                                ),
                              ),
                            ],
                          ),
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
