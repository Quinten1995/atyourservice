import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/kategorien.dart';
import '../l10n/app_localizations.dart'; // Lokalisation importieren

// 🔎 Analytics
import '../utils/analytics_service.dart';

class RegistrierungScreen extends StatefulWidget {
  const RegistrierungScreen({Key? key}) : super(key: key);

  @override
  State<RegistrierungScreen> createState() => _RegistrierungScreenState();
}

class _RegistrierungScreenState extends State<RegistrierungScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _rolle = 'kunde';
  String? _selectedKategorie;
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  Future<void> _registrieren() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final identities = response.user?.identities;
      if (identities != null && identities.isNotEmpty) {
        // 🔎 Analytics nach erfolgreichem Signup
        final l10n = AppLocalizations.of(context)!;
        final role = (_rolle == 'dienstleister') ? 'provider' : 'customer';
        final uid = response.user?.id;

        try {
          await AnalyticsService.I.setUserId(uid);
          await AnalyticsService.I.setUserProps(
            role: role,
            locale: l10n.localeName,
          );
          await AnalyticsService.I.signupCompleted(role: role, city: 'unknown');
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.registerSuccess),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.registerExists)),
        );
      }
    } on AuthException catch (authError) {
      final err = authError.message.toLowerCase();
      String userMessage;
      if (err.contains('already registered') ||
          err.contains('duplicate') ||
          err.contains('user exists')) {
        userMessage = AppLocalizations.of(context)!.registerExists;
      } else if (err.contains('invalid email')) {
        userMessage = AppLocalizations.of(context)!.registerInvalidEmail;
      } else if (err.contains('password')) {
        userMessage = AppLocalizations.of(context)!.registerPasswordShort;
      } else {
        userMessage = AppLocalizations.of(
          context,
        )!.registerFailed(authError.message);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(userMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.registerUnknownError(e.toString()),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Helper: übersetztes Label einer Kategorie
  String getKategorieLabel(String kategorieKey, AppLocalizations l10n) {
    switch (kategorieKey) {
      case 'category_babysitter':
        return l10n.category_babysitter;
      case 'category_catering':
        return l10n.category_catering;
      case 'category_dachdecker':
        return l10n.category_dachdecker;
      case 'category_elektriker':
        return l10n.category_elektriker;
      case 'category_ernaehrungsberatung':
        return l10n.category_ernaehrungsberatung;
      case 'category_eventplanung':
        return l10n.category_eventplanung;
      case 'category_fahrdienste':
        return l10n.category_fahrdienste;
      case 'category_fahrlehrer':
        return l10n.category_fahrlehrer;
      case 'category_fensterputzer':
        return l10n.category_fensterputzer;
      case 'category_fliesenleger':
        return l10n.category_fliesenleger;
      case 'category_fotografie':
        return l10n.category_fotografie;
      case 'category_friseur':
        return l10n.category_friseur;
      case 'category_gartenpflege':
        return l10n.category_gartenpflege; // L10n: „Gartenpflege / GaLa-Bau“
      case 'category_grafikdesign':
        return l10n.category_grafikdesign;
      case 'category_handy_reparatur':
        return l10n.category_handy_reparatur;
      case 'category_haushaltsreinigung':
        return l10n.category_haushaltsreinigung;
      case 'category_hausmeisterservice':
        return l10n.category_hausmeisterservice;
      case 'category_heizungsbauer':
        return l10n.category_heizungsbauer;
      case 'category_hundesitter':
        return l10n.category_hundesitter;
      case 'category_it_support':
        return l10n.category_it_support;
      case 'category_klempner':
        return l10n.category_klempner;
      case 'category_kosmetik':
        return l10n.category_kosmetik;
      case 'category_kuenstler':
        return l10n.category_kuenstler;
      case 'category_kurierdienst':
        return l10n.category_kurierdienst;
      case 'category_maler':
        return l10n.category_maler;
      case 'category_massagen':
        return l10n.category_massagen;
      case 'category_maurer':
        return l10n.category_maurer;
      case 'category_moebelaufbau':
        return l10n.category_moebelaufbau;
      case 'category_musikunterricht':
        return l10n.category_musikunterricht;
      case 'category_nachhilfe':
        return l10n.category_nachhilfe;
      case 'category_nagelstudio':
        return l10n.category_nagelstudio;
      case 'category_pc_reparatur':
        return l10n.category_pc_reparatur;
      case 'category_partyservice':
        return l10n.category_partyservice;
      case 'category_personal_trainer':
        return l10n.category_personal_trainer;
      case 'category_rasenmaeher_service':
        return l10n.category_rasenmaeher_service;
      case 'category_rechtsberatung':
        return l10n.category_rechtsberatung;
      case 'category_reparaturdienste':
        return l10n.category_reparaturdienste;
      case 'category_seniorenbetreuung':
        return l10n.category_seniorenbetreuung;
      case 'category_social_media':
        return l10n.category_social_media;
      case 'category_sonstige':
        return l10n.category_sonstige;
      case 'category_sprachunterricht':
        return l10n.category_sprachunterricht;
      case 'category_steuerberatung':
        return l10n.category_steuerberatung;
      case 'category_tischler':
        return l10n.category_tischler;
      case 'category_transport':
        return l10n.category_transport;
      case 'category_umzugstransporte':
        return l10n.category_umzugstransporte;
      case 'category_umzugshelfer':
        return l10n.category_umzugshelfer;
      case 'category_uebersetzungen':
        return l10n.category_uebersetzungen;
      case 'category_waescheservice':
        return l10n.category_waescheservice;
      case 'category_webdesign':
        return l10n.category_webdesign;
      case 'category_einkaufsservice':
        return l10n.category_einkaufsservice;
      case 'category_haustierbetreuung':
        return l10n.category_haustierbetreuung;
      default:
        return kategorieKey;
    }
  }

  /// ACTIVE zuerst (alphabetisch nach Label), dann BETA (alphabetisch)
  List<String> sortedSelectableKeys(AppLocalizations l10n) {
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

  /// UI: hübsches Dropdown-Item mit optionalem „Beta“-Chip
  Widget _categoryDropdownItem(String key, AppLocalizations l10n) {
    final baseLabel = getKategorieLabel(key, l10n);
    final isBeta = categoryStatus[key] == CategoryStatus.beta;

    // Falls du später einen i18n-Key möchtest: l10n.badgeBeta
    const betaText = 'Beta';

    // Chip-Optik dezent & lesbar im Dropdown
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 🔹 Nur ACTIVE + BETA für die Auswahl – erst ACTIVE (A-Z), dann BETA (A-Z)
    final keys = sortedSelectableKeys(l10n);

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(
          l10n.registerAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    l10n.registerTitle,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Rollenwahl (Kunde / Dienstleister)
                  DropdownButtonFormField<String>(
                    value: _rolle,
                    decoration: InputDecoration(
                      labelText: l10n.roleLabel,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(22),
                    items: [
                      DropdownMenuItem(
                        value: 'kunde',
                        child: Text(l10n.roleKunde),
                      ),
                      DropdownMenuItem(
                        value: 'dienstleister',
                        child: Text(l10n.roleDienstleister),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rolle = value;
                          if (_rolle != 'dienstleister')
                            _selectedKategorie = null;
                        });
                      }
                    },
                  ),

                  // Kategorie-Auswahl nur bei Dienstleister!
                  if (_rolle == 'dienstleister') ...[
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value:
                          _selectedKategorie ??
                          (keys.isNotEmpty ? keys.first : null),
                      decoration: InputDecoration(
                        labelText: l10n.categoryLabel,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(22),
                      items: keys.map((kategorie) {
                        return DropdownMenuItem(
                          value: kategorie,
                          child: _categoryDropdownItem(kategorie, l10n),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedKategorie = value);
                      },
                      validator: (value) {
                        if (_rolle != 'dienstleister') return null;
                        if (keys.isEmpty) {
                          return l10n.kategorieValidator;
                        }
                        if (value == null || value.isEmpty) {
                          return l10n.kategorieValidator;
                        }
                        if (!keys.contains(value)) {
                          return l10n.kategorieValidator;
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 20),

                  // E-Mail-Feld
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.emailLabel,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.emailEmpty;
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return l10n.emailInvalid;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Passwort-Feld
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.passwordLabel,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.passwordEmpty;
                      }
                      if (value.length < 6) return l10n.passwordTooShort;
                      return null;
                    },
                  ),

                  const SizedBox(height: 34),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _registrieren,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.20),
                            ),
                            child: Text(
                              l10n.registerButton,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
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
