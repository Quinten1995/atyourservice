import 'package:flutter/material.dart';
import 'meine_auftraege_screen.dart';

class DienstleisterDashboardScreen extends StatelessWidget {
  // Beispielhafte Kategorien - kannst du später erweitern
  final List<String> kategorien = [
    'Babysitter',
    'Reinigung',
    'Handwerk',
    'Nachhilfe',
    'IT & Technik',
    'Umzug & Transport',
    'Gartenarbeit',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dienstleister-Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Kategorien als Scrollbare Chips
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: kategorien.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: ActionChip(
                      label: Text(kategorien[index]),
                      onPressed: () {
                        // TODO: Filter auf Kategorie anwenden
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kategorie: ${kategorien[index]}')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Platzhalter für Auftragsliste (später dynamisch)
            Expanded(
              child: Center(
                child: Text(
                  'Hier werden passende Aufträge angezeigt',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),

            // Button für "Meine Aufträge"
            ElevatedButton.icon(
              icon: Icon(Icons.assignment),
              label: Text('Meine Aufträge'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeineAuftraegeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

