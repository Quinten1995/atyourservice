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

      final roleResponse = await _supabase
          .from('users')
          .select('rolle')
          .eq('id', user.id)
          .maybeSingle();
      if (roleResponse == null || roleResponse['rolle'] == null) {
        throw Exception('Rolle konnte nicht ermittelt werden');
      }
      setState(() {
        _isDienstleister = roleResponse['rolle'] == 'dienstleister';
      });

      final auftragMap = await _supabase
          .from('auftraege')
          .select()
          .eq('id', widget.initialAuftrag.id)
          .maybeSingle();

      if (auftragMap == null) throw Exception('Auftrag nicht gefunden');

      setState(() {
        _auftragDetails = Auftrag.fromJson(auftragMap as Map<String, dynamic>);
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
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
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

      setState(() {
        _auftragDetails = Auftrag.fromJson(updated);
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
    setState(() => _isLoading = true);

    try {
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
        _auftragDetails = Auftrag.fromJson(updated);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // 🟢 NEU: Auftrag lokal für Kunden entfernen
  Future<void> _kundeAuftragEntfernen() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Auftrag entfernen?'),
        content: Text('Möchten Sie den Auftrag dauerhaft aus Ihrer Übersicht entfernen?'),
        actions: [
          TextButton(child: Text('Abbrechen'), onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(child: Text('Entfernen'), onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _supabase.from('auftraege').update({
        'kunde_auftragsstatus': 'entfernt',
        'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', _auftragDetails!.id);

      Navigator.of(context).pop(); // Zurück zur Übersicht
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
      appBar: AppBar(title: Text('Auftragsdetails')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _auftragDetails == null
                ? Center(child: Text('Keine Daten verfügbar'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_auftragDetails!.titel, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        Text('Beschreibung: ${_auftragDetails!.beschreibung}'),
                        SizedBox(height: 8),
                        Text('Kategorie: ${_auftragDetails!.kategorie}'),
                        SizedBox(height: 8),
                        if (_auftragDetails!.adresse != null) ...[
                          Text('Adresse: ${_auftragDetails!.adresse!}'),
                          SizedBox(height: 8),
                        ],
                        if (_auftragDetails!.latitude != null && _auftragDetails!.longitude != null) ...[
                          Text('Standort: ${_auftragDetails!.latitude}, ${_auftragDetails!.longitude}'),
                          SizedBox(height: 8),
                        ],
                        SizedBox(height: 16),
                        Row(
                          children: [Text('Status:'), SizedBox(width: 12), Text(_auftragDetails!.status)],
                        ),
                        SizedBox(height: 24),
                        if (_isDienstleister && _auftragDetails!.status == 'offen')
                          ElevatedButton(
                            onPressed: _auftragAnnehmen,
                            child: Text('Auftrag annehmen'),
                          ),
                        if (_isDienstleister && _auftragDetails!.status == 'in bearbeitung')
                          ElevatedButton(
                            onPressed: _auftragAbschliessen,
                            child: Text('Auftrag beenden'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        // 🟢 Kunden-Button (NEU)
                        if (!_isDienstleister && _auftragDetails!.status == 'in bearbeitung')
                          ElevatedButton(
                            onPressed: _kundeAuftragEntfernen,
                            child: Text('Auftrag entfernen'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                          ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: 16),
                          Text('Fehler: $_errorMessage', style: TextStyle(color: Colors.red)),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }
}
