import 'package:flutter/material.dart';
import 'kunden_dashboard_screen.dart';  // Wichtig: importiere das Dashboard!

class LoginKundeScreen extends StatefulWidget {
  @override
  _LoginKundeScreenState createState() => _LoginKundeScreenState();
}

class _LoginKundeScreenState extends State<LoginKundeScreen> {
  final _emailController = TextEditingController();
  final _passwortController = TextEditingController();

  void _login() {
    final email = _emailController.text.trim();
    final passwort = _passwortController.text;

    if (email.isEmpty || passwort.isEmpty) {
      _showError('Bitte E-Mail und Passwort eingeben.');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showError('Bitte eine gültige E-Mail-Adresse eingeben.');
      return;
    }

    // TODO: Backend-Login hier einbauen

    print('Login als Kunde: $email / $passwort');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login erfolgreich (Demo)')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => KundenDashboardScreen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login für Kunden')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwortController,
              decoration: InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registrierung folgt später')),
                );
              },
              child: Text('Noch kein Konto? Jetzt registrieren'),
            ),
          ],
        ),
      ),
    );
  }
}



