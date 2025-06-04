// lib/screens/meine_auftraege_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import 'auftrag_detail_screen.dart';

class MeineAuftraegeScreen extends StatefulWidget {
  const MeineAuftraegeScreen({Key? key}) : super(key: key);

  @override
  _MeineAuftraegeScreenState createState() => _MeineAuftraegeScreenState();
}

class _MeineAuftraegeScreenState extends State<MeineAuftraegeScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _auftraege = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _ladeAuftraege();
  }

  Future<void> _ladeAuftraege() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Nicht eingeloggt';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await supabase
          .from('auftraege')
          .select()
          .eq('kunde_id', user.id)
          .or('status.eq.offen,status.eq.in bearbeitung')
          .eq('kunde_auftragsstatus', 'sichtbar')
          .order('erstellt_am', ascending: false);

      setState(() {
        _auftraege = (response as List).cast<Map<String, dynamic>>();
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

  Future<void> _openDetailScreen(Auftrag auftrag) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
      ),
    );
    _ladeAuftraege(); // Aktualisiert die Liste nach Rückkehr
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Aufträge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _ladeAuftraege,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text('Fehler: $_errorMessage'))
                : _auftraege.isEmpty
                    ? const Center(child: Text('Keine Aufträge gefunden.'))
                    : ListView.builder(
                        itemCount: _auftraege.length,
                        itemBuilder: (context, index) {
                          final auftragMap = _auftraege[index];
                          final auftrag = Auftrag.fromJson(auftragMap);
                          return ListTile(
                            title: Text(auftrag.titel),
                            subtitle: Text('Kategorie: ${auftrag.kategorie}  •  Status: ${auftrag.status}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => _openDetailScreen(auftrag),
                          );
                        },
                      ),
      ),
    );
  }
}
