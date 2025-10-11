import 'dart:io';
import 'dart:async'; // für Autosave-Debounce
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // optional, falls anderswo genutzt
import 'dart:convert'; // optional, falls anderswo genutzt
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

  // Basis-Profil
  final _nameController = TextEditingController();
  final _telefonController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedKategorie;
  final _adresseController = TextEditingController();

  // Rechnungs-/Firmen-/Steuerdaten
  final _invoiceNameController = TextEditingController(); // Absender-Name
  final _invoiceAddressController = TextEditingController(); // Rechnungsadresse
  final _invoiceTaxNumberController = TextEditingController(); // Steuernummer
  final _invoiceIbanController = TextEditingController();
  final _invoiceBicController = TextEditingController();
  final _invoiceLogoUrlController = TextEditingController();

  final _companyNameController = TextEditingController(); // Firmenname (opt)
  final _ustIdController = TextEditingController(); // USt-ID (opt)
  final _vatRateController = TextEditingController(text: '19'); // Standard-USt

  bool _isSmallBusiness = false; // §19 UStG

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

  // ===== Autosave =====
  Timer? _autosaveDebounce;
  bool _autosaveInFlight = false;

  // ===== Diff-Tracking für geschützte Felder =====
  Map<String, dynamic> _initialProtected = {};

  // Rechnungsblock UI
  bool _invoiceExpanded = false;

  @override
  void initState() {
    super.initState();
    _ladeProfil();
    _ladeBewertungen();

    // Autosave-Listener (nur Textfelder)
    for (final c in [
      _nameController,
      _telefonController,
      _emailController,
      _adresseController,
      _invoiceNameController,
      _invoiceAddressController,
      _invoiceTaxNumberController,
      _invoiceIbanController,
      _invoiceBicController,
      _invoiceLogoUrlController,
      _companyNameController,
      _ustIdController,
      _vatRateController,
    ]) {
      c.addListener(_scheduleAutosave);
    }
  }

  @override
  void dispose() {
    _autosaveDebounce?.cancel();
    // Controller disposen
    _nameController.dispose();
    _adresseController.dispose();
    _telefonController.dispose();
    _emailController.dispose();

    _invoiceNameController.dispose();
    _invoiceAddressController.dispose();
    _invoiceTaxNumberController.dispose();
    _invoiceIbanController.dispose();
    _invoiceBicController.dispose();
    _invoiceLogoUrlController.dispose();

    _companyNameController.dispose();
    _ustIdController.dispose();
    _vatRateController.dispose();
    super.dispose();
  }

  // --- Autosave: debounce + leise speichern ---
  void _scheduleAutosave() {
    // Für Free-User KEIN Autosave an geschützten Feldern (sonst verbrauchen sie ungewollt das Kontingent)
    final isFree = (_aboTyp ?? 'free') == 'free';
    if (isFree) {
      // Avatar darf separat gespeichert werden, der Rest per Autosave nicht.
      return;
    }

    _autosaveDebounce?.cancel();
    _autosaveDebounce = Timer(const Duration(milliseconds: 1000), () async {
      if (_autosaveInFlight) return;
      _autosaveInFlight = true;
      try {
        await _profilSpeichern(silent: true); // leises Speichern, ohne Lock
      } finally {
        _autosaveInFlight = false;
      }
    });
  }

  // „Soft“-Validierung für Autosave (kein Error-UI)
  bool _isSoftValid() {
    final nameOk = _nameController.text.trim().isNotEmpty;
    final phoneOk = _telefonController.text.trim().isNotEmpty;
    final email = _emailController.text.trim();
    final emailOk =
        email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final katOk = (_selectedKategorie ?? '').isNotEmpty;
    return nameOk && phoneOk && emailOk && katOk;
  }

  // Aktuellen Zustand geschützter Felder für Diff
  Map<String, dynamic> _currentProtected() => {
    'name': _nameController.text.trim(),
    'kategorie': _selectedKategorie,
    'adresse': _adresseController.text.trim(),
    'telefon': _telefonController.text.trim(),
    'email': _emailController.text.trim(),
  };

  bool _protectedChangedSinceLoad() {
    for (final k in _initialProtected.keys) {
      if (_initialProtected[k] != _currentProtected()[k]) return true;
    }
    return false;
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
          .select('''
            name, kategorie, adresse, telefon, email, profilbild_url,
            last_profile_change, aktualisiert_am,
            invoice_name, invoice_address, invoice_tax_number, invoice_iban, invoice_bic, invoice_logo_url,
            is_small_business, default_vat_rate, company_name, ust_id
          ''')
          .eq('user_id', user.id)
          .maybeSingle();

      // WELCHE Keys sind heute überhaupt auswählbar?
      final allowedKeys = selectableCategoryKeys(); // ACTIVE + BETA

      if (data != null) {
        _nameController.text = data['name'] as String? ?? '';

        final gespeicherteKategorie = data['kategorie'] as String?;
        if (gespeicherteKategorie != null &&
            allowedKeys.contains(gespeicherteKategorie)) {
          _selectedKategorie = gespeicherteKategorie;
        } else {
          _selectedKategorie = allowedKeys.isNotEmpty
              ? allowedKeys.first
              : null;
        }

        _adresseController.text = data['adresse'] as String? ?? '';
        _telefonController.text = data['telefon'] as String? ?? '';
        _emailController.text = (data['email'] as String?)?.isNotEmpty == true
            ? data['email'] as String
            : _emailController.text;
        _profilbildUrl = data['profilbild_url'] as String?;
        _lastProfileChange = data['last_profile_change'] != null
            ? DateTime.tryParse(data['last_profile_change'])
            : null;

        // Rechnungs-/Steuer-/Firmen-Daten
        _invoiceNameController.text = data['invoice_name'] as String? ?? '';
        _invoiceAddressController.text =
            data['invoice_address'] as String? ?? '';
        _invoiceTaxNumberController.text =
            data['invoice_tax_number'] as String? ?? '';
        _invoiceIbanController.text = data['invoice_iban'] as String? ?? '';
        _invoiceBicController.text = data['invoice_bic'] as String? ?? '';
        _invoiceLogoUrlController.text =
            data['invoice_logo_url'] as String? ?? '';

        _companyNameController.text = data['company_name'] as String? ?? '';
        _ustIdController.text = data['ust_id'] as String? ?? '';
        _isSmallBusiness = (data['is_small_business'] as bool?) ?? false;

        final vatNum = (data['default_vat_rate'] as num?)?.toDouble();
        _vatRateController.text = vatNum != null ? vatNum.toString() : '19';
      } else {
        _selectedKategorie = allowedKeys.isNotEmpty ? allowedKeys.first : null;
      }

      final userData = await _supabase
          .from('users')
          .select('abo_typ')
          .eq('id', user.id)
          .maybeSingle();
      _aboTyp = userData?['abo_typ'] as String? ?? 'free';

      // initial snapshot für Diff
      _initialProtected = _currentProtected();
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

  // Avatar-only speichern (immer erlaubt, auch Free+Lock; ohne last_profile_change)
  Future<void> _saveAvatarOnly({bool silent = false}) async {
    final l10n = AppLocalizations.of(context)!;
    final user = _supabase.auth.currentUser;
    if (user == null || _neuesProfilbild == null) return;

    final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _supabase.storage
        .from('profile-pics')
        .upload(
          fileName,
          _neuesProfilbild!,
          fileOptions: const FileOptions(upsert: true),
        );
    final publicUrl = _supabase.storage
        .from('profile-pics')
        .getPublicUrl(fileName);

    await _supabase
        .from('dienstleister_details')
        .update({
          'profilbild_url': publicUrl,
          'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', user.id);

    setState(() {
      _profilbildUrl = publicUrl;
      _neuesProfilbild = null;
    });

    if (!silent && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    }
  }

  // Speichern (silent = ohne Loader/Fehler-UI)
  Future<void> _profilSpeichern({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final l10n = AppLocalizations.of(context)!;
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception(l10n.pleaseLogin);

      final isFree = (_aboTyp ?? 'free') == 'free';
      final now = DateTime.now();

      // Lock prüfen (Free-User)
      final locked =
          isFree &&
          _lastProfileChange != null &&
          now.difference(_lastProfileChange!).inDays < 20;

      if (locked) {
        // Avatar-Durchlass
        if (_neuesProfilbild != null) {
          await _saveAvatarOnly(silent: silent);
        } else if (!silent && mounted) {
          final naechstesDatum = _lastProfileChange!.add(
            const Duration(days: 20),
          );
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(l10n.changeNotAllowedTitle),
              content: Text(
                l10n.changeNotAllowedContent(
                  naechstesDatum.toLocal().toString().substring(0, 10),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.ok),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Validierung
      if (!silent) {
        if (!_formKey.currentState!.validate()) return;
      } else {
        if (!_isSoftValid()) return;
      }

      // Felder
      final name = _nameController.text.trim();
      final telefon = _telefonController.text.trim();
      final email = _emailController.text.trim();
      final kategorie = _selectedKategorie;
      final adresse = _adresseController.text.trim();

      double? lat;
      double? lon;
      if (adresse.isNotEmpty) {
        final coords = await GeocodingService().getCoordinates(adresse);
        if (coords == null) {
          if (silent) {
            return;
          } else {
            throw Exception(AppLocalizations.of(context)!.addressNotFound);
          }
        }
        lat = coords['lat'];
        lon = coords['lng'];
      }

      // Avatar ggf. hochladen
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
        profilbildUrl = _supabase.storage
            .from('profile-pics')
            .getPublicUrl(fileName);
      }

      // Rechnungs-/Steuer-/Firmen-Daten
      final invoiceName = _invoiceNameController.text.trim();
      final invoiceAddress = _invoiceAddressController.text.trim();
      final invoiceTaxNumber = _invoiceTaxNumberController.text.trim();
      final invoiceIban = _invoiceIbanController.text.trim();
      final invoiceBic = _invoiceBicController.text.trim();
      final invoiceLogoUrl = _invoiceLogoUrlController.text.trim();

      final companyName = _companyNameController.text.trim();
      final ustId = _ustIdController.text.trim();
      final parsedVat =
          double.tryParse(_vatRateController.text.replaceAll(',', '.')) ?? 19.0;
      final defaultVatRate = parsedVat < 0 ? 0.0 : parsedVat;

      // Upsert
      final payload = {
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

        // Rechnungs-/Steuer-/Firmen-Daten
        'invoice_name': invoiceName,
        'invoice_address': invoiceAddress,
        'invoice_tax_number': invoiceTaxNumber,
        'invoice_iban': invoiceIban,
        'invoice_bic': invoiceBic,
        'invoice_logo_url': invoiceLogoUrl,

        'company_name': companyName,
        'ust_id': ustId,
        'is_small_business': _isSmallBusiness,
        'default_vat_rate': _isSmallBusiness ? 0.0 : defaultVatRate,
      };

      // Nur bei MANUELLEM Speichern & echten geschützten Änderungen das Lock "verbrauchen"
      final protectedChanged = _protectedChangedSinceLoad();
      final shouldConsumeQuota = !silent && isFree && protectedChanged;
      if (shouldConsumeQuota) {
        payload['last_profile_change'] = DateTime.now()
            .toUtc()
            .toIso8601String();
      }

      await _supabase
          .from('dienstleister_details')
          .upsert(payload, onConflict: 'user_id')
          .select();

      setState(() {
        _profilbildUrl = profilbildUrl;
        _neuesProfilbild = null;
        if (shouldConsumeQuota) {
          _lastProfileChange = now;
          _initialProtected = _currentProtected(); // Snapshot aktualisieren
        } else if (!silent) {
          // Bei manuellem Speichern ohne protected-Änderung trotzdem initialen Snapshot aktualisieren
          _initialProtected = _currentProtected();
        }
      });

      if (!silent && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
      }
      if (!silent) _ladeBewertungen();
    } catch (e) {
      if (!silent) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (!silent) {
        setState(() {
          _isLoading = false;
        });
      }
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
      await _saveAvatarOnly();
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

  Future<void> _kontoLoeschen() async {
    setState(() {
      _deletingAccount = true;
      _errorMessage = null;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      final session = _supabase.auth.currentSession;
      if (session == null) throw Exception(l10n.pleaseLogin);

      final res = await _supabase.functions.invoke('delete_user');
      if (res.status < 200 || res.status >= 300) {
        throw Exception('Delete failed: ${res.status} ${res.data}');
      }

      await _supabase.auth.signOut();

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.accountDeleted)));
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

  /// ACTIVE zuerst (alphabetisch nach Label), dann BETA (alphabetisch)
  List<String> _sortedSelectableKeys(AppLocalizations l10n) {
    final all = selectableCategoryKeys(); // ACTIVE + BETA aus kategorien.dart
    final active = <String>[];
    final beta = <String>[];

    for (final k in all) {
      (categoryStatus[k] == CategoryStatus.beta ? beta : active).add(k);
    }

    int byLabel(String a, String b) =>
        getKategorieLabel(a, l10n).compareTo(getKategorieLabel(b, l10n));

    active.sort(byLabel);
    beta.sort(byLabel);
    return [...active, ...beta];
  }

  /// Dropdown-Item mit optionalem „Beta“-Chip
  Widget _categoryDropdownItem(String key, AppLocalizations l10n) {
    final baseLabel = getKategorieLabel(key, l10n);
    final isBeta = categoryStatus[key] == CategoryStatus.beta;

    const betaText = 'Beta'; // Optional: i18n
    final betaChip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Text(
        betaText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.amber.shade800,
          height: 1.0,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(baseLabel, overflow: TextOverflow.ellipsis)),
        if (isBeta) ...[const SizedBox(width: 8), betaChip],
      ],
    );
  }

  /// Rechnungs-/Steuerdaten: Immer sichtbar, aber bei Free/Silver ausgegraut,
  /// hier als hübscher Aufklappblock (ExpansionTile)
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

    final inner = Column(
      children: [
        const SizedBox(height: 12),
        TextFormField(
          controller: _companyNameController,
          decoration: invoiceDecoration(l10n.companyNameOptional),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _ustIdController,
          decoration: invoiceDecoration(l10n.vatIdOptional),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceNameController,
          decoration: invoiceDecoration(l10n.invoiceNameLabel),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceAddressController,
          decoration: invoiceDecoration(l10n.invoiceAddressLabel),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceTaxNumberController,
          decoration: invoiceDecoration(l10n.invoiceTaxNumberLabel),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceIbanController,
          decoration: invoiceDecoration(l10n.invoiceIbanLabel),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceBicController,
          decoration: invoiceDecoration(l10n.bicOptional),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _invoiceLogoUrlController,
          decoration: invoiceDecoration(l10n.invoiceLogoUrlLabel),
          enabled: isGold,
          onChanged: (_) => _scheduleAutosave(),
        ),
        const SizedBox(height: 16),
        Opacity(
          opacity: isGold ? 1.0 : 0.6,
          child: IgnorePointer(
            ignoring: !isGold,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text(l10n.smallBusinessLabel),
                  value: _isSmallBusiness,
                  onChanged: (v) {
                    setState(() => _isSmallBusiness = v);
                    _scheduleAutosave();
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _vatRateController,
                  decoration: invoiceDecoration(l10n.defaultVatRateLabel),
                  enabled: isGold && !_isSmallBusiness,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => _scheduleAutosave(),
                  validator: (val) {
                    if (_isSmallBusiness) return null;
                    if (!isGold) return null;
                    if (val == null || val.trim().isEmpty) return null;
                    final v = double.tryParse(val.replaceAll(',', '.'));
                    if (v == null || v < 0 || v > 100)
                      return l10n.invalidVatRate;
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (!isGold)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                l10n.invoiceGoldInfo,
                style: const TextStyle(fontSize: 13, color: Colors.red),
              ),
            ),
          ),
      ],
    );

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: ExpansionTile(
          initiallyExpanded: _invoiceExpanded,
          onExpansionChanged: (v) => setState(() => _invoiceExpanded = v),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: const Icon(Icons.receipt_long, color: primaryColor),
          title: Text(
            AppLocalizations.of(context)!.invoiceSectionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.invoiceSectionSubtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          children: [inner],
        ),
      ),
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

    // Nur ACTIVE + BETA – erst ACTIVE (A–Z), dann BETA (A–Z)
    final keys = _sortedSelectableKeys(l10n);

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
          // Hintergrund
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
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${_durchschnitt!.toStringAsFixed(2)} / 5',
                                        style: const TextStyle(
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
                                    style: const TextStyle(
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

                                  // Kategorien: ACTIVE zuerst, dann BETA (beide A–Z)
                                  DropdownButtonFormField<String>(
                                    value:
                                        _selectedKategorie ??
                                        (keys.isNotEmpty ? keys.first : null),
                                    isExpanded: true,
                                    decoration: _inputDecoration(
                                      l10n.categoryLabel,
                                      icon: Icons.category,
                                    ),
                                    selectedItemBuilder: (context) =>
                                        keys.map((k) {
                                          return Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              getKategorieLabel(k, l10n),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                    items: keys.map((k) {
                                      return DropdownMenuItem(
                                        value: k,
                                        child: _categoryDropdownItem(k, l10n),
                                      );
                                    }).toList(),
                                    onChanged: (wert) {
                                      if (wert != null) {
                                        setState(
                                          () => _selectedKategorie = wert,
                                        );
                                        _scheduleAutosave();
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.categoryValidator;
                                      }
                                      if (!keys.contains(value)) {
                                        return l10n.categoryValidator;
                                      }
                                      return null;
                                    },
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

                                  const SizedBox(height: 18),

                                  // Aufklappbarer Rechnungs-/Faktura-Block
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
                                          : () => _profilSpeichern(),
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
