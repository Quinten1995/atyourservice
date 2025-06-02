// lib/screens/start_screen.dart

import 'package:flutter/material.dart';
import 'login_kunde_screen.dart';
import 'login_dienstleister_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('atyourservice')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginKundeScreen()),
                  );
                },
                child: const Text('Ich suche Hilfe (Kunde)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginDienstleisterScreen()),
                  );
                },
                child: const Text('Ich biete Hilfe an (Dienstleister)'),
              ),

              // Der folgende Block wurde entfernt:
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     // Hier war bisher der "Dienstleister testen"-Code
              //   },
              //   child: const Text('Dienstleister testen'),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
