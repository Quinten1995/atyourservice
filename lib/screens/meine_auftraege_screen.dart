import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import 'auftrag_detail_screen.dart';
import '../data/kategorie_icons.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = l10n.notLoggedIn;
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
          .or('kunde_auftragsstatus.is.null,kunde_auftragsstatus.neq.entfernt')
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

  // Soft-Delete für abgeschlossene Aufträge
  Future<void> _auftragEntfernen(Auftrag auftrag) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await supabase
          .from('auftraege')
          .update({'kunde_auftragsstatus': 'entfernt'})
          .eq('id', auftrag.id);

      setState(() {
        _auftraege.removeWhere((a) => a['id'] == auftrag.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.auftragHidden)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.auftragHideError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(
          l10n.meineAuftraegeAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _ladeAuftraege,
            color: primaryColor,
            tooltip: l10n.refreshTooltip,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(l10n.errorPrefix(_errorMessage!)))
                : _auftraege.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noAuftraegeFound,
                          style: const TextStyle(fontSize: 17, color: Colors.black54),
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
                              isThreeLine: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              leading: Icon(
                                kategorieIcons[auftrag.kategorie] ?? Icons.work_outline,
                                color: primaryColor,
                                size: 30,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      auftrag.titel,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (!auftrag.soSchnellWieMoeglich)
                                    Tooltip(
                                      message: l10n.geplanterAuftrag,
                                      child: Icon(Icons.access_time_rounded, color: Colors.teal[700], size: 21),
                                    ),
                                ],
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
                                          color: Color(0xFF3876BF),
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
                                      tooltip: l10n.auftragAusblenden,
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
