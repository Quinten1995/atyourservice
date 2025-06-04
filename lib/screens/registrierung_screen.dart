import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrierungScreen extends StatefulWidget {
  const RegistrierungScreen({Key? key}) : super(key: key);

  @override
  State<RegistrierungScreen> createState() => _RegistrierungScreenState();
}

class _RegistrierungScreenState extends State<RegistrierungScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'quintenhessmann1995@yahoo.com');
  final _passwordController = TextEditingController(text: 'password123');
  String _rolle = 'kunde';
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
      await supabase.auth.signInWithPassword(
        email: email,
        password: '••••••••',
      );
      await supabase.auth.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diese E-Mail ist bereits registriert. Bitte einloggen.')),
      );
    } on AuthException catch (authError) {
      final err = authError.message.toLowerCase();
      if (err.contains('invalid login credentials')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diese E-Mail ist bereits registriert. Passwort vergessen?')),
        );
      } else if (err.contains('user not found')) {
        await _signUpFlow(email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Überprüfen: ${authError.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unbekannter Fehler: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpFlow(String email, String password) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrierung erfolgreich! Bitte überprüfe deine E-Mail und bestätige sie.'),
        ),
      );
      Navigator.of(context).pop();
    } on AuthException catch (authError) {
      final err = authError.message.toLowerCase();
      String userMessage;
      if (err.contains('already registered') ||
          err.contains('duplicate') ||
          err.contains('user exists')) {
        userMessage = 'Diese E-Mail ist bereits registriert.';
      } else if (err.contains('invalid email')) {
        userMessage = 'Bitte gib eine gültige E-Mail-Adresse ein.';
      } else if (err.contains('password')) {
        userMessage = 'Passwort muss mindestens 6 Zeichen haben.';
      } else {
        userMessage = 'Registrierung fehlgeschlagen: ${authError.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unbekannter Fehler: $e')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Registrierung', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    'Registrieren',
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
                      labelText: 'Rolle auswählen',
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
                    items: const [
                      DropdownMenuItem(value: 'kunde', child: Text('Kunde')),
                      DropdownMenuItem(value: 'dienstleister', child: Text('Dienstleister')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _rolle = value);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // E-Mail-Feld
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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Bitte E-Mail eingeben';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Bitte gültige E-Mail eingeben';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Passwort-Feld
                  TextFormField(
                    controller: _passwordController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Bitte Passwort eingeben';
                      if (value.length < 6) return 'Passwort muss mindestens 6 Zeichen haben';
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
                            child: const Text(
                              'Registrieren',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
