// lib/screens/datenschutz_screen.dart

import 'package:flutter/material.dart';

class DatenschutzScreen extends StatelessWidget {
  const DatenschutzScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datenschutz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Datenschutzerklärung', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text(
                '1. Verantwortliche Stelle\n'
                'Verantwortlich für die Datenverarbeitung ist:\n'
                'Quinten Hessmann\n'
                'Meylstraat 33\n'
                '2540 Hove (Belgium)\n'
                'E-Mail: quintenhessmann1995@yahoo.com\n'
                'Telefon: +32 470 52 57 26\n\n'
                '2. Erhebung und Speicherung personenbezogener Daten\n'
                'Wir verarbeiten die Daten, die Sie im Rahmen der Nutzung dieser App eingeben (z.B. Name, E-Mail, Adresse). Die Daten werden ausschließlich zur Vermittlung zwischen Kunden und Dienstleistern verwendet.\n\n'
                '3. Weitergabe von Daten\n'
                'Eine Übermittlung Ihrer Daten an Dritte erfolgt nur, sofern dies zur Vertragsabwicklung erforderlich ist oder Sie eingewilligt haben.\n\n'
                '4. Rechte der Nutzer\n'
                'Sie haben das Recht auf Auskunft, Berichtigung, Löschung und Einschränkung der Verarbeitung Ihrer Daten sowie auf Beschwerde bei einer Aufsichtsbehörde.\n\n'
                '5. Kontakt\n'
                'Bei Fragen zum Datenschutz kontaktieren Sie uns unter quintenhessmann1995@yahoo.com\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
