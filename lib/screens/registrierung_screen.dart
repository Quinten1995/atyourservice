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

  Future<void> _registrieren() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // 1. Überprüfen, ob die E-Mail bereits registriert ist:
      //    Wir versuchen, uns mit einem Dummy-Passwort einzuloggen.
      //    Wenn AuthException geworfen wird:
      //      - "Invalid login credentials" ⇒ E-Mail existiert, aber falsches Passwort.
      //      - "User not found" ⇒ E-Mail existiert nicht (kann neu registriert werden).
      //      - andere Fehlermeldung ⇒ entsprechend behandeln.
      await supabase.auth.signInWithPassword(
        email: email,
        password: '••••••••', // Dummy-Passwort für den Existenz-Check
      );
      // Wenn kein AuthException geworfen wurde, konnte man sich tatsächlich einloggen ⇒ Konto existiert mit diesem Passwort.
      // Wir loggen den Nutzer sofort wieder aus und zeigen eine Fehlermeldung an.
      await supabase.auth.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diese E-Mail ist bereits registriert. Bitte einloggen.')),
      );
    } on AuthException catch (authError) {
      final err = authError.message.toLowerCase();
      if (err.contains('invalid login credentials')) {
        // E-Mail existiert, aber falsches Passwort
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diese E-Mail ist bereits registriert. Passwort vergessen?')),
        );
      } else if (err.contains('user not found')) {
        // E-Mail existiert nicht ⇒ sicher zum Signup weitermachen
        await _signUpFlow(email, password);
      } else {
        // andere AuthException (z.B. Netzwerkfehler)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Überprüfen: ${authError.message}')),
        );
      }
    } catch (e) {
      // Alle anderen Fehler (z. B. Netzwerk-Timeout)
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
      // Registrierung erfolgreich (egal ob Bestätigungsmail verschickt wurde oder nicht)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registrierung erfolgreich! Bitte überprüfe deine E-Mail und bestätige sie.',
          ),
        ),
      );
      Navigator.of(context).pop();
    } on AuthException catch (authError) {
      // Sollte normalerweise hier nicht "E-Mail existiert bereits" sein, da wir das vorher abgefangen haben.
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
      appBar: AppBar(title: const Text('Registrierung')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Rollenwahl (Kunde / Dienstleister)
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
