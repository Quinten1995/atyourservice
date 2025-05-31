import 'package:flutter/material.dart';
import 'login_kunde_screen.dart';
import 'login_dienstleister_screen.dart';

import '../models/dienstleister.dart';
import '../utils/dienstleister_filter.dart';

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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                List<Dienstleister> alleDienstleister = [
                  Dienstleister(
                    id: '1',
                    name: 'Malermeister Müller',
                    kategorie: 'Maler',
                    latitude: 48.137154,
                    longitude: 11.576124,
                    zuletztOnline: DateTime.now().subtract(Duration(minutes: 2)),
                  ),
                  Dienstleister(
                    id: '2',
                    name: 'Elektriker Schmidt',
                    kategorie: 'Elektriker',
                    latitude: 48.775846,
                    longitude: 9.182932,
                    zuletztOnline: DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
                  ),
                  Dienstleister(
                    id: '3',
                    name: 'Malerbetrieb Schulz',
                    kategorie: 'Maler',
                    latitude: 48.208174,
                    longitude: 16.373819,
                    zuletztOnline: DateTime.now().subtract(Duration(minutes: 45)),
                  ),
                ];

                double auftragLat = 48.1351;
                double auftragLon = 11.5820;
                String kategorie = 'Maler';

                List<Dienstleister> passendeDienstleister = findePassendeDienstleister(
                  alleDienstleister: alleDienstleister,
                  kategorie: kategorie,
                  auftragLat: auftragLat,
                  auftragLon: auftragLon,
                  maxEntfernungKm: 50,
                );

                String names = passendeDienstleister.isNotEmpty
                    ? passendeDienstleister.map((d) => d.name).join(', ')
                    : 'Keine passenden Dienstleister gefunden';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gefundene Dienstleister: $names')),
                );
              },
              child: const Text('Dienstleister testen'),
            ),
          ],
        ),
      ),
    );
  }
}




