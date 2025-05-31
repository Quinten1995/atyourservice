import 'package:flutter/material.dart';
import 'auftrag_erstellen_screen.dart';
import 'meine_auftraege_screen.dart';

class KundenDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kunden-Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuftragErstellenScreen()),
                );
              },
              icon: Icon(Icons.add),
              label: Text('Neuen Auftrag erstellen'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeineAuftraegeScreen()),
                );
              },
              icon: Icon(Icons.assignment),
              label: Text('Meine Aufträge'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



