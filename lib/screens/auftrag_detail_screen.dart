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

  // NEU: Kontaktinfos
  String? _kundenTelefonnummer;
  String? _dienstleisterTelefonnummer;

  final SupabaseClient _supabase = Supabase.instance.client;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

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
      _kundenTelefonnummer = null;
      _dienstleisterTelefonnummer = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Nicht eingeloggt');
      }

      // Rolle laden
      final roleResponse = await _supabase
          .from('users')
          .select('rolle')
          .eq('id', user.id)
          .maybeSingle();
      if (roleResponse == null || roleResponse['rolle'] == null) {
        throw Exception('Rolle konnte nicht ermittelt werden');
      }
      final isDL = roleResponse['rolle'] == 'dienstleister';
      setState(() {
        _isDienstleister = isDL;
      });

      // Auftrag laden (aktuelle Daten)
      final auftragMap = await _supabase
          .from('auftraege')
          .select()
          .eq('id', widget.initialAuftrag.id)
          .maybeSingle();

      if (auftragMap == null) throw Exception('Auftrag nicht gefunden');

      final Auftrag aktuellerAuftrag = Auftrag.fromJson(auftragMap);
      setState(() {
        _auftragDetails = aktuellerAuftrag;
      });

      // Telefonnummern laden, wenn der Auftrag in Bearbeitung ist und DL zugeordnet
      if (aktuellerAuftrag.status == 'in bearbeitung' && aktuellerAuftrag.dienstleisterId != null) {
        if (isDL) {
          // Dienstleister sieht Kundentelefon
          setState(() {
            _kundenTelefonnummer = aktuellerAuftrag.telefon;
          });
        } else {
          // Kunde sieht Dienstleister-Telefon aus dienstleister_details
          final details = await _supabase
              .from('dienstleister_details')
              .select('telefon')
              .eq('user_id', aktuellerAuftrag.dienstleisterId!)
              .maybeSingle();
          setState(() {
            _dienstleisterTelefonnummer = details?['telefon'];
          });
        }
      }

      setState(() {
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

      // Nach Annahme Kontaktdaten neu laden
      await _ladeRolleUndAktuellenAuftrag();
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

  Future<void> _kundeAuftragEntfernen() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Auftrag entfernen?'),
        content: const Text('Möchten Sie den Auftrag dauerhaft aus Ihrer Übersicht entfernen?'),
        actions: [
          TextButton(child: const Text('Abbrechen'), onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(child: const Text('Entfernen'), onPressed: () => Navigator.of(ctx).pop(true)),
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
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Auftragsdetails', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _auftragDetails == null
                ? const Center(child: Text('Keine Daten verfügbar'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_auftragDetails!.titel,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.10),
                                blurRadius: 7,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Beschreibung:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800])),
                              Text(_auftragDetails!.beschreibung, style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 14),
                              Text('Kategorie: ${_auftragDetails!.kategorie}'),
                              if (_auftragDetails!.adresse != null) ...[
                                const SizedBox(height: 6),
                                Text('Adresse: ${_auftragDetails!.adresse!}'),
                              ],
                              if (_auftragDetails!.latitude != null && _auftragDetails!.longitude != null) ...[
                                const SizedBox(height: 6),
                                Text('Standort: ${_auftragDetails!.latitude}, ${_auftragDetails!.longitude}'),
                              ],
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  const Text('Status:', style: TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 10),
                                  Chip(
                                    label: Text(
                                      _auftragDetails!.status.toUpperCase(),
                                      style: TextStyle(
                                        color: _auftragDetails!.status == 'abgeschlossen'
                                            ? Colors.white
                                            : primaryColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    backgroundColor: _auftragDetails!.status == 'abgeschlossen'
                                        ? Colors.green
                                        : accentColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // NEU: Kontaktbereich, wenn zugeordnet und in Bearbeitung
                        if (_auftragDetails!.status == 'in bearbeitung' && _auftragDetails!.dienstleisterId != null) ...[
                          const SizedBox(height: 18),
                          Text(
                            'Kontakt:',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800], fontSize: 17),
                          ),
                          if (_isDienstleister && _kundenTelefonnummer != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 18),
                                const SizedBox(width: 7),
                                Text('Kunde: $_kundenTelefonnummer', style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ],
                          if (!_isDienstleister && _dienstleisterTelefonnummer != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 18),
                                const SizedBox(width: 7),
                                Text('Dienstleister: $_dienstleisterTelefonnummer', style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ],
                        ],
                        const SizedBox(height: 32),
                        if (_isDienstleister && _auftragDetails!.status == 'offen')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _auftragAnnehmen,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Auftrag annehmen'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 3,
                              ),
                            ),
                          ),
                        if (_isDienstleister && _auftragDetails!.status == 'in bearbeitung')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _auftragAbschliessen,
                              icon: const Icon(Icons.check),
                              label: const Text('Auftrag beenden'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 3,
                              ),
                            ),
                          ),
                        // Kunden-Button (NEU)
                        if (!_isDienstleister && _auftragDetails!.status == 'in bearbeitung')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _kundeAuftragEntfernen,
                              icon: const Icon(Icons.delete),
                              label: const Text('Auftrag entfernen'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 20),
                          Text('Fehler: $_errorMessage', style: const TextStyle(color: Colors.red)),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }
}
