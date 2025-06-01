import 'package:flutter/material.dart';
import 'dienstleister_dashboard_screen.dart';
import 'registrierung_screen.dart'; // Import für Registrierung

class LoginDienstleisterScreen extends StatefulWidget {
  @override
  _LoginDienstleisterScreenState createState() => _LoginDienstleisterScreenState();
}

class _LoginDienstleisterScreenState extends State<LoginDienstleisterScreen> {
  final _emailController = TextEditingController();
  final _passwortController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final passwort = _passwortController.text;

      // TODO: Hier Login-Logik mit Supabase etc. einbauen

      print('Login als Dienstleister: $email / $passwort');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login erfolgreich (Demo)')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DienstleisterDashboardScreen()),
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
      appBar: AppBar(title: Text('Login für Dienstleister')),
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



