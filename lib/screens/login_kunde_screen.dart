import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'kunden_dashboard_screen.dart';
import 'registrierung_screen.dart';

class LoginKundeScreen extends StatefulWidget {
  const LoginKundeScreen({Key? key}) : super(key: key);

  @override
  _LoginKundeScreenState createState() => _LoginKundeScreenState();
}

class _LoginKundeScreenState extends State<LoginKundeScreen> {
  final _emailController = TextEditingController(text: 'quintenhessmann1995@yahoo.com');
  final _passwortController = TextEditingController(text: 'password123');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  // Farben passend zum Startscreen
  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwortController.text,
      );
      final user = response.user;
      if (user == null) {
        throw AuthException('Login fehlgeschlagen. Bitte überprüfe Deine Daten oder bestätige Deine E-Mail.');
      }

      try {
        await supabase.from('users').upsert({
          'id': user.id,
          'email': user.email,
          'rolle': 'kunde',
          'erstellt_am': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        print('[DEBUG] Upsert in users schlug fehl: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login erfolgreich!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KundenDashboardScreen()),
      );
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login fehlgeschlagen: ${error.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unbekannter Fehler: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Bitte E-Mail eingeben';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Bitte eine gültige E-Mail eingeben';
    return null;
  }

  String? _validatePasswort(String? value) {
    if (value == null || value.isEmpty) return 'Bitte Passwort eingeben';
    if (value.length < 6) return 'Passwort muss mindestens 6 Zeichen lang sein';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Login für Kunden', style: TextStyle(fontWeight: FontWeight.bold)),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Optional: Überschrift
                  Text(
                    'Anmelden',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
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
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 20),

                  // Passwort
                  TextFormField(
                    controller: _passwortController,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
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
                    obscureText: true,
                    validator: _validatePasswort,
                  ),

                  const SizedBox(height: 34),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.20),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                  const SizedBox(height: 14),

                  // Registrierung
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrierungScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    child: const Text('Noch kein Konto? Jetzt registrieren'),
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
