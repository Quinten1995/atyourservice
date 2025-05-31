import 'package:flutter/material.dart';

class AuftragErstellenScreen extends StatefulWidget {
  @override
  _AuftragErstellenScreenState createState() => _AuftragErstellenScreenState();
}

class _AuftragErstellenScreenState extends State<AuftragErstellenScreen> {
  final _titelController = TextEditingController();
  final _beschreibungController = TextEditingController();
  String? _ausgewaehlteKategorie;

  final List<String> _kategorien = [
    'Elektriker',
    'Klempner',
    'Maler',
    'Tischler',
    'Gartenbau',
    'IT-Service',
  ];

  void _auftragAbschicken() {
    final titel = _titelController.text;
    final beschreibung = _beschreibungController.text;
    final kategorie = _ausgewaehlteKategorie;

    if (titel.isEmpty || beschreibung.isEmpty || kategorie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte alle Felder ausfüllen')),
      );
      return;
    }

    // TODO: Auftrag an Backend senden
    print('Auftrag erstellt: $titel / $beschreibung / $kategorie');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Auftrag wurde erstellt!')),
    );

    Navigator.pop(context); // zurück zum Dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neuen Auftrag erstellen')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titelController,
                decoration: InputDecoration(labelText: 'Titel des Auftrags'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _beschreibungController,
                decoration: InputDecoration(labelText: 'Beschreibung'),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _ausgewaehlteKategorie,
                items: _kategorien.map((kategorie) {
                  return DropdownMenuItem(
                    value: kategorie,
                    child: Text(kategorie),
                  );
                }).toList(),
                onChanged: (wert) {
                  setState(() {
                    _ausgewaehlteKategorie = wert;
                  });
                },
                decoration: InputDecoration(labelText: 'Kategorie wählen'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _auftragAbschicken,
                child: Text('Auftrag erstellen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
