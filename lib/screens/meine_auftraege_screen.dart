import 'package:flutter/material.dart';

class MeineAuftraegeScreen extends StatelessWidget {
  // Temporäre Demo-Daten – später durch echte Auftragsdaten ersetzen
  final List<Map<String, String>> auftraege = [
    {
      'titel': 'Lichtschalter reparieren',
      'kategorie': 'Elektriker',
      'status': 'Offen',
    },
    {
      'titel': 'Garten pflegen',
      'kategorie': 'Gartenbau',
      'status': 'In Bearbeitung',
    },
    {
      'titel': 'WLAN einrichten',
      'kategorie': 'IT-Service',
      'status': 'Abgeschlossen',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meine Aufträge')),
      body: ListView.builder(
        itemCount: auftraege.length,
        itemBuilder: (context, index) {
          final auftrag = auftraege[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(auftrag['titel']!),
              subtitle: Text('Kategorie: ${auftrag['kategorie']!}'),
              trailing: Text(auftrag['status']!),
              onTap: () {
                // Später zu Detailansicht navigieren
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Detailansicht kommt später')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
