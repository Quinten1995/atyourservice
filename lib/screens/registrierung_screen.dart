import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrierungScreen extends StatefulWidget {
  const RegistrierungScreen({Key? key}) : super(key: key);

  @override
  State<RegistrierungScreen> createState() => _RegistrierungScreenState();
}

class _RegistrierungScreenState extends State<RegistrierungScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'walterlangengries@gmail.com');
  final _passwordController = TextEditingController(text: 'password123');
  String _rolle = 'kunde';
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _registrieren() async {
    print('[DEBUG] _registrieren() aufgerufen');
    if (!_formKey.currentState!.validate()) {
      print('[DEBUG] Form nicht valide, Abbruch');
      return;
    }

    setState(() => _isLoading = true);
    print('[DEBUG] _isLoading = true');

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      print('[DEBUG] Versuche signUp() für $email');
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      print('[DEBUG] signUp() zurück: user=${response.user}, session=${response.session}');

      // Wenn signUp erfolgreich (auch wenn E-Mail-Verifizierung noch aussteht),
      // zeigen wir eine Erfolgsmeldung und navigieren zurück.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registrierung erfolgreich! Bitte überprüfe deine E-Mail und bestätige sie.',
          ),
        ),
      );
      print('[DEBUG] Snackbar gezeigt, Navigator.pop()');
      Navigator.of(context).pop();
    } on AuthException catch (authError) {
      // AuthException fängt z.B. "E-Mail existiert bereits", "Passwort zu schwach" o.Ä.
      print('[DEBUG] AuthException: ${authError.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrierung fehlgeschlagen: ${authError.message}'),
        ),
      );
    } catch (e) {
      // Alle anderen Fehler (Netzwerk, unerwartete Zustände, etc.)
      print('[DEBUG] Allgemeine Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unbekannter Fehler: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
      print('[DEBUG] _isLoading = false');
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
      appBar: AppBar(title: const Text('Registrierung')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Rollenwahl (kunden/​dienstleister) – optional
              DropdownButtonFormField<String>(
                value: _rolle,
                decoration: const InputDecoration(labelText: 'Rolle auswählen'),
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
              const SizedBox(height: 16),

              // E-Mail-Feld
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte E-Mail eingeben';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Bitte gültige E-Mail eingeben';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Passwort-Feld
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte Passwort eingeben';
                  if (value.length < 6) return 'Passwort muss mindestens 6 Zeichen haben';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Registrieren-Button
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registrieren,
                      child: const Text('Registrieren'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
