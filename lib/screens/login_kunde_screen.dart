// login_kunde_screen.dart
import 'dart:ui'; // App/Device-Sprache
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'kunden_dashboard_screen.dart';
import 'registrierung_screen.dart';
import 'passwort_vergessen_screen.dart';
import '../l10n/app_localizations.dart';

// ===== Push-Lang (nur für Server-Push, UI bleibt unberührt) ==================
String _normalizeLangCode(Locale locale) {
  final lc = locale.languageCode.toLowerCase();
  if (lc.startsWith('de')) return 'de';
  if (lc.startsWith('en')) return 'en';
  if (lc.startsWith('nl')) return 'nl';
  if (lc.startsWith('fr')) return 'fr';
  if (lc.startsWith('tr')) return 'tr';
  if (lc.startsWith('es')) return 'es';
  if (lc.startsWith('it')) return 'it';
  return 'en';
}

Future<void> _updateUserLangForPushOnly(SupabaseClient supabase) async {
  final user = supabase.auth.currentUser;
  if (user == null) return;

  final lang = _normalizeLangCode(PlatformDispatcher.instance.locale);

  final current = await supabase
      .from('users')
      .select('lang')
      .eq('id', user.id)
      .maybeSingle();

  if ((current?['lang'] as String?) == lang) return;

  await supabase.from('users').update({'lang': lang}).eq('id', user.id);
}
// ============================================================================

class LoginKundeScreen extends StatefulWidget {
  const LoginKundeScreen({Key? key}) : super(key: key);

  @override
  _LoginKundeScreenState createState() => _LoginKundeScreenState();
}

class _LoginKundeScreenState extends State<LoginKundeScreen> {
  final _emailController = TextEditingController();
  final _passwortController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  // Nur die letzte E-Mail merken (ohne Checkbox & ohne Passwortspeicher)
  static const _prefsKeyEmail = 'last_email_kunde';

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  void initState() {
    super.initState();
    _loadLastEmail(); // lädt nur die letzte E-Mail, kein Auto-Login
  }

  Future<void> _loadLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKeyEmail);
    if (saved != null && mounted) {
      setState(() => _emailController.text = saved);
    }
  }

  Future<void> _saveLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyEmail, _emailController.text.trim());
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1) Einloggen
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwortController.text,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('Invalid login credentials');
      }

      // 2) Rolle aus users lesen (falls vorhanden)
      final existing = await supabase
          .from('users')
          .select('rolle')
          .eq('id', user.id)
          .maybeSingle();

      // 3) DL-Account blocken
      if (existing != null && existing['rolle'] == 'dienstleister') {
        await supabase.auth.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.wrongRoleCustomer),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // 4) Falls kein Eintrag -> als Kunde anlegen
      if (existing == null) {
        try {
          await supabase.from('users').insert({
            'id': user.id,
            'email': user.email,
            'rolle': 'kunde',
            'erstellt_am': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          // ignore: avoid_print
          print('[DEBUG] Insert in users (kunde) schlug fehl: $e');
        }
      }

      // 4b) Push-Sprache (nur Server-seitig)
      await _updateUserLangForPushOnly(supabase);

      // Nur die E-Mail persistieren
      await _saveLastEmail();

      // 5) Erfolg
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.loginSuccess)));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KundenDashboardScreen()),
      );
    } on AuthException catch (error) {
      bool showNotRegistered = false;

      try {
        final email = _emailController.text.trim();
        final exists = await supabase
            .from('users')
            .select('id')
            .eq('email', email)
            .maybeSingle();
        showNotRegistered = (exists == null);
      } catch (_) {
        final msg = (error.message ?? '').toLowerCase();
        if (msg.contains('user not found') ||
            msg.contains('no user') ||
            msg.contains('not registered')) {
          showNotRegistered = true;
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            showNotRegistered
                ? l10n.accountNotRegistered
                : l10n.wrongCredentials,
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginUnknownError(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l10n.emailValidatorEmpty;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return l10n.emailValidatorInvalid;
    return null;
  }

  String? _validatePasswort(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return l10n.passwordValidatorEmpty;
    if (value.length < 6) return l10n.passwordValidatorShort;
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textColor = Colors.black.withOpacity(0.87);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.loginKundeAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3876BF), Color(0xFFE7ECEF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.13),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -40,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.21),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 12,
                  ),
                  child: Card(
                    color: Colors.white.withOpacity(0.96),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 28,
                      ),
                      child: Form(
                        key: _formKey,
                        child: AutofillGroup(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle_rounded,
                                size: 56,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 18),
                              Text(
                                l10n.loginKundeHeadline,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.white54,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
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
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email,
                                ],
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwortController,
                                decoration: InputDecoration(
                                  labelText: l10n.passwordLabel,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(),
                                autofillHints: const [AutofillHints.password],
                                validator: _validatePasswort,
                              ),

                              // Keine Merken-Checkboxen – nur E-Mail wird automatisch behalten
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PasswortVergessenScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: Text(l10n.forgotPasswordButton),
                                ),
                              ),
                              const SizedBox(height: 18),

                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          elevation: 4,
                                          shadowColor: primaryColor.withOpacity(
                                            0.20,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.loginButton,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                              const SizedBox(height: 14),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrierungScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                child: Text(l10n.noAccountYet),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
