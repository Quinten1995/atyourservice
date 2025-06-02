// lib/screens/auftrag_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  bool _isDienstleister = false;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _auftragDetails = widget.initialAuftrag;
    _ladeRolleUndAktuellenAuftrag();
  }

  Future<void> _ladeRolleUndAktuellenAuftrag() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Nicht eingeloggt');
      }

      // 1) Rolle des aktuellen Nutzers abfragen
      final roleResponse = await _supabase
          .from('users')
          .select('rolle')
          .eq('id', user.id)
          .maybeSingle();
      if (roleResponse == null || roleResponse['rolle'] == null) {
        throw Exception('Rolle konnte nicht ermittelt werden');
      }
      setState(() {
        _isDienstleister = (roleResponse['rolle'] as String) == 'dienstleister';
      });

      // 2) Neuesten Auftrag aus der Datenbank laden
      final auftragMap = await _supabase
          .from('auftraege')
          .select()
          .eq('id', widget.initialAuftrag.id)
          .maybeSingle();

      if (auftragMap == null) {
        throw Exception('Auftrag nicht gefunden');
      }

      setState(() {
        _auftragDetails = Auftrag.fromJson(auftragMap as Map<String, dynamic>);
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

  Future<void> _auftragAnnehmen() async {
    if (_auftragDetails == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Nicht eingeloggt');
      }

      // Update + sofort SELECT, damit wir eine gültige Antwort erhalten
      final updated = await _supabase
          .from('auftraege')
          .update({
            'status': 'in bearbeitung',
            'dienstleister_id': user.id,
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', _auftragDetails!.id)
          .select()
          .single();

      // Wenn hier ein Fehler passiert, schlägt PostgrestException an
      setState(() {
        _auftragDetails = Auftrag.fromJson(updated as Map<String, dynamic>);
      });

      // Keine extra Abfrage nötig, wir haben schon die aktualisierten Daten
      setState(() {
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

  Future<void> _auftragAbschliessen() async {
    if (_auftragDetails == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Update + sofort SELECT
      final updated = await _supabase
          .from('auftraege')
          .update({
            'status': 'abgeschlossen',
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', _auftragDetails!.id)
          .select()
          .single();

      setState(() {
        _auftragDetails = Auftrag.fromJson(updated as Map<String, dynamic>);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auftragsdetails')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _auftragDetails == null
                ? const Center(child: Text('Keine Daten verfügbar'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titel anzeigen
                        Text(
                          _auftragDetails!.titel,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        // Beschreibung
                        Text('Beschreibung: ${_auftragDetails!.beschreibung}'),
                        const SizedBox(height: 8),
                        // Kategorie
                        Text('Kategorie: ${_auftragDetails!.kategorie}'),
                        const SizedBox(height: 8),
                        // Adresse (falls vorhanden)
                        if (_auftragDetails!.adresse != null) ...[
                          Text('Adresse: ${_auftragDetails!.adresse!}'),
                          const SizedBox(height: 8),
                        ],
                        // Standort (falls vorhanden)
                        if (_auftragDetails!.latitude != null && _auftragDetails!.longitude != null) ...[
                          Text('Standort: ${_auftragDetails!.latitude}, ${_auftragDetails!.longitude}'),
                          const SizedBox(height: 8),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Status:'),
                            const SizedBox(width: 12),
                            Text(_auftragDetails!.status),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (!_isLoading && _auftragDetails != null) ...[
                          // Button "Auftrag annehmen"
                          if (_isDienstleister && _auftragDetails!.status == 'offen')
                            ElevatedButton(
                              onPressed: _auftragAnnehmen,
                              child: const Text('Auftrag annehmen'),
                            ),
                          // Button "Auftrag abschliessen"
                          if (_isDienstleister &&
                              _auftragDetails!.status == 'in bearbeitung' &&
                              _auftragDetails!.dienstleisterId == _supabase.auth.currentUser!.id)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: ElevatedButton(
                                onPressed: _auftragAbschliessen,
                                child: const Text('Auftrag abschliessen'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                        ],
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Fehler: $_errorMessage',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }
}
