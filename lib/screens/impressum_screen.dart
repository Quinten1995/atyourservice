// lib/screens/impressum_screen.dart

import 'package:flutter/material.dart';

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impressum')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Impressum', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text(
                'Angaben gemäß § 5 TMG\n\n'
                'Betreiber der App:\n'
                'Quinten Hessmann\n'
                'Meylstraat 33\n'
                '2540 Hove (Belgium)\n\n'
                'Kontakt:\n'
                'Telefon: +32 470 52 57 26\n'
                'E-Mail: quintenhessmann1995@yahoo.com\n\n'
                'Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV:\n'
                'Quinten Hessmann, Adresse wie oben\n\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
