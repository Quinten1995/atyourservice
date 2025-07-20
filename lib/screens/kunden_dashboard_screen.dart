import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import 'auftrag_detail_screen.dart';
import 'auftrag_erstellen_screen.dart';
import 'profil_kunde_screen.dart';
import '../l10n/app_localizations.dart';
import '../data/kategorie_icons.dart'; // ICON-MAP importieren!

extension StatusTranslation on AppLocalizations {
  String translateStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'offen':
      case 'open':
        return statusOffen;
      case 'in bearbeitung':
      case 'in_progress':
        return statusInBearbeitung;
      case 'abgeschlossen':
      case 'completed':
        return statusAbgeschlossen;
      default:
        return status ?? '';
    }
  }
}

class KundenDashboardScreen extends StatefulWidget {
  const KundenDashboardScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  State<KundenDashboardScreen> createState() => _KundenDashboardScreenState();
}

class _KundenDashboardScreenState extends State<KundenDashboardScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _laufendeAuftraegeRaw = [];
  List<Auftrag> _offeneAuftraege = [];
  List<Auftrag> _abgeschlosseneAuftraege = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ladeAuftraege();
    });
  }

  Future<void> _ladeAuftraege() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception(l10n.notLoggedIn);

      final auftraegeRaw = await supabase
          .from('auftraege')
          .select('*, dienstleister:users!auftraege_dienstleister_id_fkey(email)')
          .eq('kunde_id', user.id)
          .or('kunde_auftragsstatus.is.null,kunde_auftragsstatus.neq.entfernt')
          .order('erstellt_am', ascending: false);

      final auftraegeMaps = (auftraegeRaw as List).cast<Map<String, dynamic>>();

      _laufendeAuftraegeRaw = auftraegeMaps
          .where((map) => map['status'] == 'in bearbeitung')
          .toList();
      _offeneAuftraege = auftraegeMaps
          .where((map) => map['status'] == 'offen')
          .map((map) => Auftrag.fromJson(map))
          .toList();
      _abgeschlosseneAuftraege = auftraegeMaps
          .where((map) => map['status'] == 'abgeschlossen')
          .map((map) => Auftrag.fromJson(map))
          .toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _dashboardHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 2, top: 8),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: Colors.white,
            size: 28,
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.black.withOpacity(0.36),
                offset: Offset(0, 2),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Text(
            l10n.kundenDashboardHeader,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.1,
              shadows: [
                Shadow(
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.36),
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: KundenDashboardScreen.accentColor,
      appBar: AppBar(
        title: Text(
          l10n.kundenDashboardAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: KundenDashboardScreen.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshTooltip,
            onPressed: _ladeAuftraege,
            color: KundenDashboardScreen.primaryColor,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: l10n.editProfileTooltip,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilKundeScreen()),
              );
              _ladeAuftraege();
            },
            color: KundenDashboardScreen.primaryColor,
          ),
        ],
      ),
      body: Stack(
        children: [
          // --- Hintergrund: Gradient + Kreise ---
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3876BF),
                  Color(0xFFE7ECEF),
                ],
              ),
            ),
          ),
          // Oben Links
          Positioned(
            top: -70,
            left: -70,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: KundenDashboardScreen.primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Unten Rechts
          Positioned(
            bottom: -60,
            right: -55,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: KundenDashboardScreen.accentColor.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(l10n.errorPrefix(_errorMessage!)))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          _dashboardHeader(),

                          if (_laufendeAuftraegeRaw.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              l10n.laufendeAuftraege,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 7),
                            SizedBox(
                              height: 156,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _laufendeAuftraegeRaw.length,
                                separatorBuilder: (context, i) => const SizedBox(width: 13),
                                itemBuilder: (context, index) {
                                  final map = _laufendeAuftraegeRaw[index];
                                  final auftrag = Auftrag.fromJson(map);
                                  final dienstleister = map['dienstleister'];
                                  final dienstleisterEmail = dienstleister != null ? dienstleister['email'] as String? : null;
                                  return Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white.withOpacity(0.96),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(18),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
                                          ),
                                        ).then((_) => _ladeAuftraege());
                                      },
                                      child: Container(
                                        width: 240,
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 22,
                                                  backgroundColor: KundenDashboardScreen.accentColor,
                                                  child: Icon(
                                                    getKategorieIcon(auftrag.kategorie),
                                                    color: KundenDashboardScreen.primaryColor,
                                                    size: 28,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    auftrag.titel,
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              children: [
                                                Icon(Icons.assignment, size: 17, color: KundenDashboardScreen.primaryColor),
                                                const SizedBox(width: 5),
                                                Text(
                                                  l10n.statusPrefix(l10n.translateStatus(auftrag.status)),
                                                  style: const TextStyle(fontSize: 13),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            if (dienstleisterEmail != null)
                                              Text(
                                                l10n.dienstleisterPrefix(dienstleisterEmail),
                                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 30, thickness: 1.2),
                          ],
                          Text(
                            l10n.offeneAuftraege,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                          const SizedBox(height: 7),
                          Expanded(
                            child: _offeneAuftraege.isEmpty
                                ? Center(
                                    child: Text(
                                      l10n.noOffeneAuftraege,
                                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _offeneAuftraege.length,
                                    separatorBuilder: (context, i) => const SizedBox(height: 14),
                                    itemBuilder: (context, index) {
                                      final auftrag = _offeneAuftraege[index];
                                      return Material(
                                        color: Colors.white.withOpacity(0.96),
                                        borderRadius: BorderRadius.circular(18),
                                        elevation: 2,
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                                          leading: CircleAvatar(
                                            radius: 22,
                                            backgroundColor: KundenDashboardScreen.accentColor,
                                            child: Icon(
                                              getKategorieIcon(auftrag.kategorie),
                                              color: KundenDashboardScreen.primaryColor,
                                              size: 28,
                                            ),
                                          ),
                                          title: Text(
                                            auftrag.titel,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: auftrag.status != null
                                              ? Padding(
                                                  padding: const EdgeInsets.only(top: 3.0),
                                                  child: Text(
                                                    l10n.statusPrefix(l10n.translateStatus(auftrag.status)),
                                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                                  ),
                                                )
                                              : null,
                                          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
                                              ),
                                            ).then((_) => _ladeAuftraege());
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          if (_abgeschlosseneAuftraege.isNotEmpty) ...[
                            const Divider(height: 28, thickness: 1.2),
                            Text(
                              l10n.abgeschlosseneAuftraege,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 7),
                            SizedBox(
                              height: 112,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _abgeschlosseneAuftraege.length,
                                separatorBuilder: (context, i) => const SizedBox(width: 14),
                                itemBuilder: (context, index) {
                                  final auftrag = _abgeschlosseneAuftraege[index];
                                  return Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white.withOpacity(0.96),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(18),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
                                          ),
                                        ).then((_) => _ladeAuftraege());
                                      },
                                      child: Container(
                                        width: 190,
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 17,
                                                  backgroundColor: KundenDashboardScreen.accentColor,
                                                  child: Icon(
                                                    getKategorieIcon(auftrag.kategorie),
                                                    color: KundenDashboardScreen.primaryColor,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    auftrag.titel,
                                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              l10n.abgeschlossenStatus,
                                              style: TextStyle(fontSize: 13, color: Colors.teal[700]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AuftragErstellenScreen()),
          ).then((_) => _ladeAuftraege());
        },
        backgroundColor: KundenDashboardScreen.primaryColor,
        elevation: 7,
        tooltip: l10n.neuerAuftrag,
        child: const Icon(Icons.add, size: 30),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
