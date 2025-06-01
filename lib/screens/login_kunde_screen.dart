import 'package:flutter/material.dart';
import 'kunden_dashboard_screen.dart';
import 'registrierung_screen.dart'; // Import für Registrierung

class LoginKundeScreen extends StatefulWidget {
  @override
  _LoginKundeScreenState createState() => _LoginKundeScreenState();
}

class _LoginKundeScreenState extends State<LoginKundeScreen> {
  final _emailController = TextEditingController();
  final _passwortController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final passwort = _passwortController.text;

      // TODO: Backend-Login hier einbauen (Supabase o.ä.)

      print('Login als Kunde: $email / $passwort');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login erfolgreich (Demo)')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KundenDashboardScreen()),
      );
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
      appBar: AppBar(title: Text('Login für Kunden')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwortController,
                decoration: InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                validator: _validatePasswort,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrierungScreen()),
                  );
                },
                child: Text('Noch kein Konto? Jetzt registrieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




