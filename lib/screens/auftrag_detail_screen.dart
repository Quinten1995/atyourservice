// lib/screens/auftrag_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/auftrag.dart';

class AuftragDetailScreen extends StatefulWidget {
  final Auftrag initialAuftrag;
  const AuftragDetailScreen({Key? key, required this.initialAuftrag}) : super(key: key);

  @override
  _AuftragDetailScreenState createState() => _AuftragDetailScreenState();
}

class _AuftragDetailScreenState extends State<AuftragDetailScreen> {
  Auftrag? _auftragDetails;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Zuerst: direkt das übergebene initialAuftrag setzen
    _auftragDetails = widget.initialAuftrag;
    // _ladeAuftrag() rufen wir später auf, um echte DB-Daten zu holen.
  }

  // Kommentar erstmal: Supabase-Logik auskommentieren
  /*
  Future<void> _ladeAuftrag() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await Supabase.instance.client
          .from('auftraege')
          .select()
          .eq('id', widget.initialAuftrag.id)
          .single() as Map<String, dynamic>;

      setState(() {
        _auftragDetails = Auftrag.fromJson(data);
        _isLoading = false;
      });
    } on PostgrestException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auftragsdetails')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _auftragDetails == null
            ? const Center(child: Text('Keine Daten verfügbar'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _auftragDetails!.titel,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('Beschreibung: ${_auftragDetails!.beschreibung}'),
                  const SizedBox(height: 8),
                  Text('Kategorie: ${_auftragDetails!.kategorie}'),
                  if (_auftragDetails!.adresse != null) ...[
                    const SizedBox(height: 8),
                    Text('Adresse: ${_auftragDetails!.adresse!}'),
                  ],
                  if (_auftragDetails!.latitude != null && _auftragDetails!.longitude != null) ...[
                    const SizedBox(height: 8),
                    Text('Standort: ${_auftragDetails!.latitude}, ${_auftragDetails!.longitude}'),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Status:'),
                      const SizedBox(width: 12),
                      Text(_auftragDetails!.status),
                    ],
                  ),
                  // Lösch-Button aktuell noch nicht aktiv
                ],
              ),
      ),
    );
  }
}
