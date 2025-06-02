// login_dienstleister_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dienstleister_dashboard_screen.dart';
import 'registrierung_screen.dart';

class LoginDienstleisterScreen extends StatefulWidget {
  const LoginDienstleisterScreen({Key? key}) : super(key: key);

  @override
  _LoginDienstleisterScreenState createState() => _LoginDienstleisterScreenState();
}

class _LoginDienstleisterScreenState extends State<LoginDienstleisterScreen> {
  final _emailController = TextEditingController(text: 'walterlangengries@gmail.com');
  final _passwortController = TextEditingController(text: 'password123');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final AuthResponse authRes = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwortController.text,
      );
      final user = authRes.user;
      if (user == null) {
        throw AuthException('Login fehlgeschlagen. Bitte überprüfe deine Daten oder bestätige deine E-Mail.');
      }

      // 1. Prüfen, ob es bereits einen Eintrag in 'users' gibt
      final fetched = await supabase
          .from('users')
          .select('rolle')
          .eq('id', user.id)
          .maybeSingle(); // Rückgabe: Map<String, dynamic>? oder null

      if (fetched == null) {
        // Kein Eintrag in 'users' → erster Login: Insert mit Rolle 'dienstleister'
        try {
          await supabase.from('users').insert({
            'id': user.id,
            'email': user.email,
            'rolle': 'dienstleister',
            'erstellt_am': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          print('[DEBUG] Insert in users schlug fehl: $e');
        }
      } else if (fetched['rolle'] != 'dienstleister') {
        // Eintrag existiert, aber Rolle passt nicht
        await supabase.auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dieser Account ist kein Dienstleister. Bitte nutze den Kunden-Login.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login erfolgreich!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DienstleisterDashboardScreen()),
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
      appBar: AppBar(title: const Text('Login für Dienstleister')),
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
