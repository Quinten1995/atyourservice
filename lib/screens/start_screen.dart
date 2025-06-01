import 'package:flutter/material.dart';
import 'login_kunde_screen.dart';
import 'login_dienstleister_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Willkommen bei AtYourService')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginKundeScreen()),
                );
              },
              child: const Text('Ich suche Hilfe (Kunde)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginDienstleisterScreen()),
                );
              },
              child: const Text('Ich biete Hilfe an (Dienstleister)'),
            ),

            // Optional: Testbutton für Dienstleister-Filter/Logik
            // Wenn du den aktuell nicht brauchst, kannst du ihn auch entfernen
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Hier könnte später deine Testlogik für Dienstleister rein
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test-Button gedrückt')),
                );
              },
              child: const Text('Dienstleister testen (optional)'),
            ),
          ],
        ),
      ),
    );
  }
}





