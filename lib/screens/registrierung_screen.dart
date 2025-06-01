import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrierungScreen extends StatefulWidget {
  const RegistrierungScreen({Key? key}) : super(key: key);

  @override
  State<RegistrierungScreen> createState() => _RegistrierungScreenState();
}

class _RegistrierungScreenState extends State<RegistrierungScreen> {
  final _formKey = GlobalKey<FormState>();

  // ✅ VORAUSGEFÜLLTE LOGIN-DATEN:
  final _emailController = TextEditingController(text: 'quintenhessmann1995@yahoo.com');
  final _passwordController = TextEditingController(text: 'test1234');

  String _rolle = 'kunde';
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _registrieren() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // 📩 Wenn Email-Verifizierung aktiv ist, ist response.user != null, aber keine Session
      final userId = response.user?.id;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrierung erfolgreich! Bitte bestätige deine E-Mail.')),
        );
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
        return;
      }

      // ✅ Nutzerprofil in Tabelle "users" speichern
      await supabase.from('users').insert({
        'id': userId,
        'email': email,
        'rolle': _rolle,
        'erstellt_am': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrierung erfolgreich! Bitte bestätige deine E-Mail.')),
      );

      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $error')),
      );
      setState(() => _isLoading = false);
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
              DropdownButtonFormField<String>(
                value: _rolle,
                decoration: const InputDecoration(labelText: 'Rolle auswählen'),
                items: const [
                  DropdownMenuItem(value: 'kunde', child: Text('Kunde')),
                  DropdownMenuItem(value: 'dienstleister', child: Text('Dienstleister')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _rolle = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bitte E-Mail eingeben';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Bitte gültige E-Mail eingeben';
                  return null;
                },
              ),
              const SizedBox(height: 16),
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











