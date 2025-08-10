import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:atyourservice/utils/geocoding_service.dart';
import '../data/kategorien.dart';
import '../l10n/app_localizations.dart';
import '../utils/category_utils.dart';
import 'premium_screen.dart';

class ProfilDienstleisterScreen extends StatefulWidget {
  const ProfilDienstleisterScreen({Key? key}) : super(key: key);

  @override
  _ProfilDienstleisterScreenState createState() =>
      _ProfilDienstleisterScreenState();
}

class _ProfilDienstleisterScreenState extends State<ProfilDienstleisterScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _telefonController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedKategorie = kategorieKeys.first;
  final _adresseController = TextEditingController();

  // Rechnungsdaten-Controller
  final _invoiceNameController = TextEditingController();
  final _invoiceAddressController = TextEditingController();
  final _invoiceTaxNumberController = TextEditingController();
  final _invoiceIbanController = TextEditingController();
  final _invoiceLogoUrlController = TextEditingController();

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

  bool _deletingAccount = false;

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
      if (user == null)
        throw Exception(AppLocalizations.of(context)!.pleaseLogin);
      final data = await _supabase
          .from('dienstleister_details')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (data != null) {
        _nameController.text = data['name'] as String? ?? '';
        final gespeicherteKategorie =
            data['kategorie'] as String? ?? kategorieKeys.first;
        _selectedKategorie = kategorieKeys.contains(gespeicherteKategorie)
            ? gespeicherteKategorie
            : kategorieKeys.first;
        _adresseController.text = data['adresse'] as String? ?? '';
        _telefonController.text = data['telefon'] as String? ?? '';
        _emailController.text = (data['email'] as String?)?.isNotEmpty == true
            ? data['email'] as String
            : _emailController.text;
        _profilbildUrl = data['profilbild_url'] as String?;
        _lastProfileChange = data['last_profile_change'] != null
            ? DateTime.parse(data['last_profile_change'])
            : null;

        // Rechnungsdaten
        _invoiceNameController.text = data['invoice_name'] as String? ?? '';
        _invoiceAddressController.text =
            data['invoice_address'] as String? ?? '';
        _invoiceTaxNumberController.text =
            data['invoice_tax_number'] as String? ?? '';
        _invoiceIbanController.text = data['invoice_iban'] as String? ?? '';
        _invoiceLogoUrlController.text =
            data['invoice_logo_url'] as String? ?? '';
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
      final values = res
          .map((b) => (b['bewertung'] as num?)?.toDouble() ?? 0.0)
          .toList();
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
      if (user == null)
        throw Exception(AppLocalizations.of(context)!.pleaseLogin);

      final isFree = (_aboTyp ?? 'free') == 'free';

      if (isFree && _lastProfileChange != null) {
        final now = DateTime.now();
        final diff = now.difference(_lastProfileChange!).inDays;
        if (diff < 20) {
          final naechstesDatum = _lastProfileChange!.add(
            const Duration(days: 20),
          );
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.changeNotAllowedTitle),
              content: Text(
                AppLocalizations.of(context)!.changeNotAllowedContent(
                  naechstesDatum.toLocal().toString().substring(0, 10),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
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
      final telefon = _telefonController.text.trim();
      final email = _emailController.text.trim();
      final kategorie = _selectedKategorie;
      final adresse = _adresseController.text.trim();

      double? lat;
      double? lon;
      if (adresse.isNotEmpty) {
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null)
          throw Exception(AppLocalizations.of(context)!.addressNotFound);
        lat = coords['lat'];
        lon = coords['lng'];
      }

      String? profilbildUrl = _profilbildUrl;
      if (_neuesProfilbild != null) {
        final fileName =
            '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _supabase.storage
            .from('profile-pics')
            .upload(
              fileName,
              _neuesProfilbild!,
              fileOptions: const FileOptions(upsert: true),
            );
        final String publicUrl = _supabase.storage
            .from('profile-pics')
            .getPublicUrl(fileName);
        profilbildUrl = publicUrl;
      }

      // Rechnungsdaten
      final invoiceName = _invoiceNameController.text.trim();
      final invoiceAddress = _invoiceAddressController.text.trim();
      final invoiceTaxNumber = _invoiceTaxNumberController.text.trim();
      final invoiceIban = _invoiceIbanController.text.trim();
      final invoiceLogoUrl = _invoiceLogoUrlController.text.trim();

      await _supabase.from('dienstleister_details').upsert({
        'user_id': user.id,
        'name': name,
        'kategorie': kategorie,
        'adresse': adresse.isEmpty ? null : adresse,
        'latitude': lat,
        'longitude': lon,
        'telefon': telefon,
        'email': email,
        'profilbild_url': profilbildUrl,
        'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
        if (isFree)
          'last_profile_change': DateTime.now().toUtc().toIso8601String(),
        'invoice_name': invoiceName,
        'invoice_address': invoiceAddress,
        'invoice_tax_number': invoiceTaxNumber,
        'invoice_iban': invoiceIban,
        'invoice_logo_url': invoiceLogoUrl,
      }, onConflict: 'user_id').select();

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
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _neuesProfilbild = File(picked.path);
      });
    }
  }

  Future<void> _kontoLoeschenDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.deleteAccountButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _kontoLoeschen();
    }
  }

  // >>> HIER IST DIE ANGEPASSTE METHODE <<<
  Future<void> _kontoLoeschen() async {
    setState(() {
      _deletingAccount = true;
      _errorMessage = null;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      final session = _supabase.auth.currentSession;
      if (session == null) throw Exception(l10n.pleaseLogin);

      // Aufruf deiner Edge Function "delete_user"
      final res = await _supabase.functions.invoke('delete_user');

      // 2xx erwarten (z. B. 204 No Content)
      if (res.status < 200 || res.status >= 300) {
        throw Exception('Delete failed: ${res.status} ${res.data}');
      }

      // Session lokal beenden
      await _supabase.auth.signOut();

      if (!mounted) return;
      // Zurück zum Login
      Navigator.of(context).popUntil((route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.accountDeleted)),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _deletingAccount = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _adresseController.dispose();
    _telefonController.dispose();
    _emailController.dispose();
    _invoiceNameController.dispose();
    _invoiceAddressController.dispose();
    _invoiceTaxNumberController.dispose();
    _invoiceIbanController.dispose();
    _invoiceLogoUrlController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) =>
      InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
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
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _bildWaehlen,
          icon: const Icon(Icons.edit, size: 20),
          label: Text(AppLocalizations.of(context)!.changeProfileImage),
          style: TextButton.styleFrom(foregroundColor: primaryColor),
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
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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

  /// Rechnungsdaten: Immer sichtbar, aber bei Free/Silver ausgegraut
  Widget _rechnungsdatenWidget(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isGold = (_aboTyp ?? 'free') == 'gold';

    InputDecoration invoiceDecoration(String label) => InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isGold ? Colors.white : Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabled: isGold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(
          l10n.invoiceSectionTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _invoiceNameController,
          decoration: invoiceDecoration(l10n.invoiceNameLabel),
          enabled: isGold,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceAddressController,
          decoration: invoiceDecoration(l10n.invoiceAddressLabel),
          enabled: isGold,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceTaxNumberController,
          decoration: invoiceDecoration(l10n.invoiceTaxNumberLabel),
          enabled: isGold,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceIbanController,
          decoration: invoiceDecoration(l10n.invoiceIbanLabel),
          enabled: isGold,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceLogoUrlController,
          decoration: invoiceDecoration(l10n.invoiceLogoUrlLabel),
          enabled: isGold,
        ),
        const SizedBox(height: 10),
        if (!isGold)
          Text(
            l10n.invoiceGoldInfo,
            style: const TextStyle(fontSize: 13, color: Colors.red),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget? limitHinweis;
    final isFree = (_aboTyp ?? 'free') == 'free';
    if (isFree && _lastProfileChange != null) {
      final naechstesDatum = _lastProfileChange!.add(const Duration(days: 20));
      final nochGesperrt = DateTime.now().isBefore(naechstesDatum);
      if (nochGesperrt) {
        limitHinweis = Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            l10n.changeLimitHint(
              naechstesDatum.toLocal().toString().substring(0, 10),
            ),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        );
      }
    }

    final sortedKategorieEntries =
        (kategorieKeys
            .map((key) => MapEntry(key, getKategorieLabel(key, l10n)))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value)));

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(l10n.profileAppBar),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          // Hintergrund wie Dashboard
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3876BF), Color(0xFFE7ECEF)],
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -45,
            right: -45,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _premiumButtonOben(context),
                          const SizedBox(height: 2),
                          _profilbildWidget(),
                          const SizedBox(height: 7),
                          // Bewertungen
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: (_durchschnitt != null)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 28,
                                      ),
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
                                        l10n.ratingsCount(
                                          _anzahlBewertungen.toString(),
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    l10n.noRatingsYet,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                          if (limitHinweis != null) limitHinweis,
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
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
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: _inputDecoration(
                                      l10n.nameLabel,
                                      icon: Icons.person,
                                    ),
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                        ? l10n.nameValidator
                                        : null,
                                  ),
                                  const SizedBox(height: 18),
                                  DropdownButtonFormField<String>(
                                    value: _selectedKategorie,
                                    isExpanded: true,
                                    decoration: _inputDecoration(
                                      l10n.categoryLabel,
                                      icon: Icons.category,
                                    ),
                                    selectedItemBuilder: (context) =>
                                        sortedKategorieEntries.map((entry) {
                                          return Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              entry.value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                    items: sortedKategorieEntries.map((entry) {
                                      return DropdownMenuItem(
                                        value: entry.key,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            entry.value,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (wert) {
                                      if (wert != null) {
                                        setState(() {
                                          _selectedKategorie = wert;
                                        });
                                      }
                                    },
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                        ? l10n.categoryValidator
                                        : null,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _adresseController,
                                    decoration: _inputDecoration(
                                      l10n.addressLabel,
                                      icon: Icons.location_on,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _telefonController,
                                    decoration: _inputDecoration(
                                      l10n.phoneLabel,
                                      icon: Icons.phone,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                        ? l10n.phoneValidator
                                        : null,
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: _inputDecoration(
                                      l10n.emailLabel,
                                      icon: Icons.email,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.emailEmptyValidator;
                                      }
                                      final emailRegExp = RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+',
                                      );
                                      if (!emailRegExp.hasMatch(value)) {
                                        return l10n.emailInvalidValidator;
                                      }
                                      return null;
                                    },
                                  ),
                                  _rechnungsdatenWidget(context),
                                  const SizedBox(height: 24),
                                  if (_errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        "${l10n.errorPrefix(_errorMessage!)}",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.save),
                                      label: Text(l10n.profileSaveButton),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : _profilSpeichern,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  _deletingAccount
                                      ? const CircularProgressIndicator()
                                      : SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.delete_forever,
                                            ),
                                            label: Text(
                                              l10n.deleteAccountButton,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red[600],
                                              foregroundColor: Colors.white,
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 13,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: _deletingAccount
                                                ? null
                                                : _kontoLoeschenDialog,
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
        ],
      ),
    );
  }
}
