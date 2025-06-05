import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import 'auftrag_detail_screen.dart';
import '../data/kategorie_icons.dart'; // <-- Import für die Icon-Map

// Hilfsfunktion für Status-Badge-Farbe
Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'offen':
      return Colors.blue;
    case 'in bearbeitung':
      return Colors.orange;
    case 'abgeschlossen':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

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

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

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
          .or('status.eq.offen,status.eq.in bearbeitung,status.eq.abgeschlossen')
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
    _ladeAuftraege();
  }

  // NEU: Auftrag ausblenden (Soft-Delete für abgeschlossene Aufträge)
  Future<void> _auftragEntfernen(Auftrag auftrag) async {
    try {
      await supabase
          .from('auftraege')
          .update({'kunde_auftragsstatus': 'entfernt'})
          .eq('id', auftrag.id);

      setState(() {
        _auftraege.removeWhere((a) => a['id'] == auftrag.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Auftrag ausgeblendet.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Ausblenden: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: const Text('Meine Aufträge', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _ladeAuftraege,
            color: primaryColor,
            tooltip: 'Aktualisieren',
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
                    ? const Center(
                        child: Text(
                          'Keine Aufträge gefunden.',
                          style: TextStyle(fontSize: 17, color: Colors.black54),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _auftraege.length,
                        separatorBuilder: (context, idx) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final auftragMap = _auftraege[index];
                          final auftrag = Auftrag.fromJson(auftragMap);

                          return Material(
                            color: Colors.white,
                            elevation: 2,
                            borderRadius: BorderRadius.circular(15),
                            child: ListTile(
                              isThreeLine: true, // WICHTIG für mehr Platz bei Wrap
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              leading: Icon(
                                kategorieIcons[auftrag.kategorie] ?? Icons.work_outline,
                                color: primaryColor,
                                size: 30,
                              ),
                              title: Text(
                                auftrag.titel,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 6,
                                  children: [
                                    // Kategorie-Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        auftrag.kategorie,
                                        style: const TextStyle(
                                          color: Color(0xFF3876BF), // primaryColor
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Status-Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: statusColor(auftrag.status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        auftrag.status,
                                        style: TextStyle(
                                          color: statusColor(auftrag.status),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (auftrag.status.toLowerCase() == 'abgeschlossen')
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                      tooltip: 'Auftrag ausblenden',
                                      onPressed: () => _auftragEntfernen(auftrag),
                                    ),
                                  const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
                                ],
                              ),
                              onTap: () => _openDetailScreen(auftrag),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
