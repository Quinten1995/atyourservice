import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MeineAuftraegeScreen extends StatefulWidget {
  const MeineAuftraegeScreen({Key? key}) : super(key: key);

  @override
  State<MeineAuftraegeScreen> createState() => _MeineAuftraegeScreenState();
}

class _MeineAuftraegeScreenState extends State<MeineAuftraegeScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _auftraege = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _ladeAuftraege();
  }

  Future<void> _ladeAuftraege() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Kein eingeloggter Nutzer gefunden.');
      }

      // In v2 liefert .select() direkt eine List zurück, nicht mehr PostgrestResponse.
      final data = await supabase
          .from('auftraege')
          .select()
          .eq('kunde_id', user.id)
          .order('erstellt_am', ascending: false);

      // data ist List<dynamic>, wir wandeln sie in List<Map<String, dynamic>> um
      setState(() {
        _auftraege = (data as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Fehler: $_errorMessage'))
              : _auftraege.isEmpty
                  ? const Center(child: Text('Keine Aufträge gefunden.'))
                  : ListView.builder(
                      itemCount: _auftraege.length,
                      itemBuilder: (context, index) {
                        final auftrag = _auftraege[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text('${auftrag['titel']}'),
                            subtitle: Text('Kategorie: ${auftrag['kategorie']}'),
                            trailing: Text('${auftrag['status']}'),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Auftragsdetails: ${auftrag['titel']}'),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
