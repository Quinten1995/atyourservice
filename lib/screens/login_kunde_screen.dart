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
      // ❌ hier wird kein const vor dem Screen mehr verwendet
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
      appBar: AppBar(title: const Text('Login für Kunden')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwortController,
                decoration: const InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                validator: _validatePasswort,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrierungScreen()),
                  );
                },
                child: const Text('Noch kein Konto? Jetzt registrieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
