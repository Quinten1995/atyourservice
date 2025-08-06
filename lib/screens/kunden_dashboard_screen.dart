import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import 'auftrag_detail_screen.dart';
import 'auftrag_erstellen_screen.dart';
import 'profil_kunde_screen.dart';
import 'traffic_screen.dart';
import 'kunden_achievement_screen.dart'; // <-- ACHIEVEMENT SCREEN!
import '../l10n/app_localizations.dart';
import '../l10n/status_value_extension.dart'; // für statusValue!
import '../data/kategorie_icons.dart';

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

  int _selectedFilter = 0; // 0: Alle, 1: Offen, 2: Laufend, 3: Abgeschlossen
  int _bottomNavIndex = 0; // 0 = Aufträge, 1 = Achievements, 2 = Profil

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

  // Filterchips für die Filterleiste oben
  Widget _buildFilterChips(AppLocalizations l10n) {
    final labels = [
      l10n.filterAlle,
      l10n.filterOffen,
      l10n.filterLaufend,
      l10n.filterAbgeschlossen,
    ];
    final chipIcons = [
      Icons.filter_alt, // Alle
      Icons.inbox, // Offen
      Icons.hourglass_bottom, // Laufend
      Icons.check_circle, // Abgeschlossen
    ];
    final chipColors = [
      Colors.grey, // Alle
      Color(0xFF43A047), // Offen
      Color(0xFF1E88E5), // Laufend
      Color(0xFF757575), // Abgeschlossen
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = _selectedFilter == i;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(chipIcons[i], size: 17, color: isSelected ? Colors.white : chipColors[i]),
                  const SizedBox(width: 6),
                  Text(labels[i]),
                ],
              ),
              selected: isSelected,
              selectedColor: chipColors[i],
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => setState(() => _selectedFilter = i),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Gefilterte Karten je Status
  Widget _buildFilteredList(AppLocalizations l10n) {
    List<Widget> cards = [];

    // Hinweis bei "Abgeschlossen"-Filter anzeigen
    if (_selectedFilter == 3) {
      cards.add(Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                l10n.abgeschlosseneAuftraegeHinweis,
                style: TextStyle(
                  color: Colors.amber[900],
                  fontSize: 13.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    if (_selectedFilter == 0) {
      // Alle: Laufende → Abgeschlossene → Offene
      if (_laufendeAuftraegeRaw.isNotEmpty) {
        cards.addAll(_buildLaufendeKarten(l10n));
      }
      if (_abgeschlosseneAuftraege.isNotEmpty) {
        cards.addAll(_buildAbgeschlosseneKarten(l10n));
      }
      if (_offeneAuftraege.isNotEmpty) {
        cards.addAll(_buildOffeneKarten(l10n));
      }
    } else if (_selectedFilter == 1) {
      if (_offeneAuftraege.isNotEmpty) {
        cards.addAll(_buildOffeneKarten(l10n));
      }
    } else if (_selectedFilter == 2) {
      if (_laufendeAuftraegeRaw.isNotEmpty) {
        cards.addAll(_buildLaufendeKarten(l10n));
      }
    } else if (_selectedFilter == 3) {
      if (_abgeschlosseneAuftraege.isNotEmpty) {
        cards.addAll(_buildAbgeschlosseneKarten(l10n));
      }
    }

    return Expanded(
      child: cards.isEmpty
          ? Center(
              child: Text(
                l10n.noPassendeAuftraege,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
            )
          : ListView.separated(
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 13),
              itemBuilder: (_, i) => cards[i],
            ),
    );
  }

  // Laufende Karten
  List<Widget> _buildLaufendeKarten(AppLocalizations l10n) {
    return _laufendeAuftraegeRaw.map((map) {
      final auftrag = Auftrag.fromJson(map);
      final dienstleister = map['dienstleister'];
      final dienstleisterEmail = dienstleister != null ? dienstleister['email'] as String? : null;
      return _buildAuftragsKarte(
        auftrag: auftrag,
        dienstleisterEmail: dienstleisterEmail,
        status: auftrag.status,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
            ),
          ).then((_) => _ladeAuftraege());
        },
      );
    }).toList();
  }

  // Offene Karten
  List<Widget> _buildOffeneKarten(AppLocalizations l10n) {
    return _offeneAuftraege.map((auftrag) {
      return _buildAuftragsKarte(
        auftrag: auftrag,
        status: auftrag.status,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
            ),
          ).then((_) => _ladeAuftraege());
        },
      );
    }).toList();
  }

  // Abgeschlossene Karten
  List<Widget> _buildAbgeschlosseneKarten(AppLocalizations l10n) {
    return _abgeschlosseneAuftraege.map((auftrag) {
      return _buildAuftragsKarte(
        auftrag: auftrag,
        status: auftrag.status,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
            ),
          ).then((_) => _ladeAuftraege());
        },
      );
    }).toList();
  }

  // Auftragskarte-Widget (wie beim DL, Status-Badge modern)
  Widget _buildAuftragsKarte({
    required Auftrag auftrag,
    String? dienstleisterEmail,
    String? status,
    VoidCallback? onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    // Status-Design
    final lowerStatus = (status ?? auftrag.status).toLowerCase();
    Color badgeColor;
    IconData badgeIcon;
    switch (lowerStatus) {
      case 'offen':
        badgeColor = Color(0xFF43A047);
        badgeIcon = Icons.inbox;
        break;
      case 'in bearbeitung':
        badgeColor = Color(0xFF1E88E5);
        badgeIcon = Icons.hourglass_bottom;
        break;
      case 'abgeschlossen':
        badgeColor = Color(0xFF757575);
        badgeIcon = Icons.check_circle;
        break;
      default:
        badgeColor = Colors.grey;
        badgeIcon = Icons.info;
    }
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(18),
      color: Colors.white.withOpacity(0.98),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                auftrag.titel,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(badgeIcon, color: badgeColor, size: 17),
                        const SizedBox(width: 6),
                        Text(
                          l10n.statusValue(auftrag.status),
                          style: TextStyle(
                            color: badgeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (dienstleisterEmail != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    l10n.dienstleisterPrefix(dienstleisterEmail),
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom Navigation Bar – jetzt mit Navigation zum Achievement-Screen!
  Widget _buildBottomNav(AppLocalizations l10n) {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      selectedItemColor: KundenDashboardScreen.primaryColor,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      onTap: (i) async {
        if (i == _bottomNavIndex) return;
        setState(() => _bottomNavIndex = i);
        if (i == 1) {
          // ACHIEVEMENT SCREEN!
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const KundenAchievementScreen(),
            ),
          );
          setState(() => _bottomNavIndex = 0);
        } else if (i == 2) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfilKundeScreen(),
            ),
          );
          setState(() => _bottomNavIndex = 0);
          _ladeAuftraege();
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: l10n.auftraege),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: l10n.achievementTitle),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: l10n.profil),
      ],
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
            icon: Icon(Icons.show_chart, color: Colors.amber[700], size: 28),
            tooltip: "Markt & Aktivität",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TrafficScreen(),
                ),
              );
            },
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(l10n.errorPrefix(_errorMessage!)))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterChips(l10n),
                          _buildFilteredList(l10n),
                        ],
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(l10n),
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
