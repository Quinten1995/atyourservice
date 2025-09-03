// lib/screens/login_dienstleister_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dienstleister_dashboard_screen.dart';
import 'registrierung_screen.dart';
import 'passwort_vergessen_screen.dart';
import '../l10n/app_localizations.dart';

// ⬇️ NEU: Push-Token Helper
import '../utils/push_tokens.dart';

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

class LoginDienstleisterScreen extends StatefulWidget {
  const LoginDienstleisterScreen({Key? key}) : super(key: key);

  @override
  _LoginDienstleisterScreenState createState() =>
      _LoginDienstleisterScreenState();
}

class _LoginDienstleisterScreenState extends State<LoginDienstleisterScreen> {
  final _emailController = TextEditingController(
    text: 'walterlangengries@gmail.com',
  );
  final _passwortController = TextEditingController(text: 'password1234');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1) Versuch: normal einloggen
      final AuthResponse authRes = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwortController.text,
      );

      final user = authRes.user;
      if (user == null) {
        throw const AuthException('Invalid login credentials');
      }

      // 2) Rolle prüfen/nachziehen
      final fetched = await supabase
          .from('users')
          .select('rolle')
          .eq('id', user.id)
          .maybeSingle();

      if (fetched == null) {
        // Ersteintrag für DL
        try {
          await supabase.from('users').insert({
            'id': user.id,
            'email': user.email,
            'rolle': 'dienstleister',
            'erstellt_am': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          // ignore: avoid_print
          print('[DEBUG] Insert in users (dienstleister) schlug fehl: $e');
        }
      } else if (fetched['rolle'] != 'dienstleister') {
        await supabase.auth.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.wrongRoleDL),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // 2b) Push-Sprache einmalig setzen (kein Einfluss auf UI/l10n)
      await _updateUserLangForPushOnly(supabase);

      // 2c) ⬇️ NEU: Aktuelles Geräte-Token in users.push_token speichern
      await upsertPushToken(supabase);

      // 3) Erfolg
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.loginSuccess)));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DienstleisterDashboardScreen(),
        ),
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textColor = Colors.black.withOpacity(0.87);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.loginDLAppBar,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business_center_rounded,
                              size: 56,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l10n.loginDLHeadline,
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
                              validator: _validatePasswort,
                            ),
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
                            const SizedBox(height: 24),
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
          ],
        ),
      ),
    );
  }
}
