import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuftragErstellenScreen extends StatefulWidget {
  const AuftragErstellenScreen({Key? key}) : super(key: key);

  @override
  State<AuftragErstellenScreen> createState() =>
      _AuftragErstellenScreenState();
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

  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  Future<void> _auftragAbschicken() async {
    print('[DEBUG] _auftragAbschicken() wurde aufgerufen');

    final titel = _titelController.text.trim();
    final beschreibung = _beschreibungController.text.trim();
    final kategorie = _ausgewaehlteKategorie;

    print('[DEBUG] Eingaben → titel="$titel", beschreibung="$beschreibung", kategorie="$kategorie"');

    if (titel.isEmpty || beschreibung.isEmpty || kategorie == null) {
      print('[DEBUG] Abbruch: Felder unvollständig');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte alle Felder ausfüllen')),
      );
      return;
    }

    setState(() => _isLoading = true);
    print('[DEBUG] set _isLoading = true');

    try {
      // 1. Prüfen, ob ein User eingeloggt ist
      final currentUser = supabase.auth.currentUser;
      print('[DEBUG] currentUser = $currentUser');

      if (currentUser == null) {
        print('[DEBUG] Abbruch: Kein eingeloggter Benutzer');
        throw Exception('Kein eingeloggter Benutzer gefunden.');
      }

      // 2. Sicherstellen, dass der User in der Tabelle "users" existiert (Upsert)
      try {
        await supabase.from('users').upsert({
          'id': currentUser.id,
          'email': currentUser.email,
          'rolle': 'kunde',
          'erstellt_am': DateTime.now().toIso8601String(),
        });
        print('[DEBUG] Upsert in "users" erfolgreich');
      } catch (e) {
        print('[DEBUG] Upsert in "users" fehlgeschlagen: $e');
        // Wir fahren trotzdem fort, weil der Fremdschlüssel‐Eintrag
        // vermutlich schon existiert oder wir ihn nicht dringend brauchen.
      }

      // 3. Neue UUID generieren
      final neueId = const Uuid().v4();
      print('[DEBUG] neueId = $neueId');

      // 4. Zeitstempel
      final jetzt = DateTime.now().toIso8601String();
      print('[DEBUG] jetzt = $jetzt');

      // 5. Auftrag einfügen – jetzt, da der FK-Eintrag garantiert existiert (oder zumindest der Versuch lief)
      final result = await supabase
          .from('auftraege')
          .insert({
            'id': neueId,
            'kunde_id': currentUser.id,
            'titel': titel,
            'beschreibung': beschreibung,
            'kategorie': kategorie,
            'status': 'offen',            // Kleinbuchstaben, um Check-Constraint zu erfüllen
            'erstellt_am': jetzt,
            'aktualisiert_am': jetzt,
          })
          .select();
      print('[DEBUG] Insert-Result: $result');

      // 6. Bei Erfolg Snackbar & Navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Auftrag wurde erfolgreich gespeichert!')),
      );
      Navigator.pop(context);
    } on PostgrestException catch (error) {
      // Fängt Postgres-spezifische Fehler (z. B. Constraint-Verletzungen) ab
      print('[DEBUG] PostgrestException: ${error.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speichern fehlgeschlagen: ${error.message}')),
      );
    } catch (e) {
      // Alle anderen Fehler
      print('[DEBUG] Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unbekannter Fehler: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
      print('[DEBUG] set _isLoading = false');
    }
  }

  @override
  void dispose() {
    _titelController.dispose();
    _beschreibungController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neuen Auftrag erstellen')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titelController,
                decoration:
                    const InputDecoration(labelText: 'Titel des Auftrags'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _beschreibungController,
                decoration: const InputDecoration(labelText: 'Beschreibung'),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
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
                decoration: const InputDecoration(labelText: 'Kategorie wählen'),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _auftragAbschicken,
                      child: const Text('Auftrag erstellen'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
