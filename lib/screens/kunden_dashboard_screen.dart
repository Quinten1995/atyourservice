import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import '../models/auftrag_form_data.dart';
import 'auftrag_detail_screen.dart';
import 'auftrag_erstellen/auftrag_kategorie_screen.dart';
import 'profil_kunde_screen.dart';
import 'traffic_screen.dart';
import 'kunden_achievement_screen.dart';
import '../l10n/app_localizations.dart';
import '../l10n/status_value_extension.dart';
import '../data/kategorie_icons.dart';
import 'start_screen.dart'; // Für Logout-Navigation

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
  int _bottomNavIndex = 0;

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
          .where((map) => (map['status'] as String).toLowerCase() == 'in bearbeitung')
          .toList();
      _offeneAuftraege = auftraegeMaps
          .where((map) => (map['status'] as String).toLowerCase() == 'offen')
          .map((map) => Auftrag.fromJson(map))
          .toList();
      _abgeschlosseneAuftraege = auftraegeMaps
          .where((map) => (map['status'] as String).toLowerCase() == 'abgeschlossen')
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

  // --- Logout Handler ---
  Future<void> _logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StartScreen()),
      (route) => false,
    );
  }

  Widget _buildFilterChips(AppLocalizations l10n) {
    final labels = [
      l10n.filterAlle,
      l10n.filterOffen,
      l10n.filterLaufend,
      l10n.filterAbgeschlossen,
    ];
    final chipIcons = [
      Icons.filter_alt,
      Icons.inbox,
      Icons.hourglass_bottom,
      Icons.check_circle,
    ];
    final chipColors = [
      Colors.grey,
      const Color(0xFF43A047),
      const Color(0xFF1E88E5),
      const Color(0xFF757575),
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

  Widget _buildFilteredList(AppLocalizations l10n) {
    List<Widget> cards = [];
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

  // -------- Preis-Helpers (l10n-ready) --------
  String? _formatPrice(Auftrag a, AppLocalizations l10n) {
    final typ = (a.preisTyp ?? '').toLowerCase();
    final v = a.preis;

    if (typ == 'verhandelbar') return l10n.verhandelbarLabel;

    // Fallback (alte Datensätze ohne preis_typ): Betrag, wenn vorhanden
    if (typ.isEmpty) {
      if (v == null) return null;
      final amount = _fmtAmount(v);
      return l10n.priceTotal(amount);
    }

    if (v == null) return null;
    final amount = _fmtAmount(v);
    return (typ == 'stunden')
        ? l10n.pricePerHour(amount, l10n.hourShort)
        : l10n.priceTotal(amount);
  }

  String _fmtAmount(double v) =>
      (v == v.roundToDouble()) ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  Widget _buildPricePill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: Colors.black.withOpacity(0.75),
        ),
      ),
    );
  }

  Widget _buildAuftragsKarte({
    required Auftrag auftrag,
    String? dienstleisterEmail,
    String? status,
    VoidCallback? onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final lowerStatus = (status ?? auftrag.status).toLowerCase();
    Color badgeColor;
    IconData badgeIcon;
    switch (lowerStatus) {
      case 'offen':
        badgeColor = const Color(0xFF43A047);
        badgeIcon = Icons.inbox;
        break;
      case 'in bearbeitung':
        badgeColor = const Color(0xFF1E88E5);
        badgeIcon = Icons.hourglass_bottom;
        break;
      case 'abgeschlossen':
        badgeColor = const Color(0xFF757575);
        badgeIcon = Icons.check_circle;
        break;
      default:
        badgeColor = Colors.grey;
        badgeIcon = Icons.info;
    }

    final priceText = _formatPrice(auftrag, l10n);

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
              // Titel + Preis rechts
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      auftrag.titel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (priceText != null) ...[
                    const SizedBox(width: 8),
                    _buildPricePill(priceText),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Status-Badge
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

              // Dienstleister (falls vorhanden)
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
        BottomNavigationBarItem(icon: const Icon(Icons.assignment), label: l10n.auftraege),
        BottomNavigationBarItem(icon: const Icon(Icons.emoji_events), label: l10n.achievementTitle),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: l10n.profil),
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red, size: 28),
            tooltip: "Logout",
            onPressed: () async {
              await _logout(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
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
            MaterialPageRoute(
              builder: (_) => AuftragKategorieScreen(formData: AuftragFormData.empty()),
            ),
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
