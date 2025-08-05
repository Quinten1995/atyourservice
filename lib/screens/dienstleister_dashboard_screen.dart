import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import '../utils/entfernung_utils.dart';
import 'auftrag_detail_screen.dart';
import 'profil_dienstleister_screen.dart';
import '../l10n/app_localizations.dart';
import '../l10n/status_value_extension.dart';
import 'pdf_rechnung_screen.dart';
import 'achievement_screen.dart';

class DienstleisterDashboardScreen extends StatefulWidget {
  const DienstleisterDashboardScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  State<DienstleisterDashboardScreen> createState() => _DienstleisterDashboardScreenState();
}

class _DienstleisterDashboardScreenState extends State<DienstleisterDashboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  String? _meineKategorie;
  double? _meineLatitude;
  double? _meineLongitude;
  String? _aboTyp;

  List<Map<String, dynamic>> _alleOffenenAuftraegeRaw = [];
  List<Map<String, dynamic>> _alleLaufendenAuftraegeRaw = [];
  List<Map<String, dynamic>> _alleAbgeschlosseneAuftraegeRaw = [];
  List<Auftrag> _offenePassendeAuftraege = [];

  int _selectedFilter = 0; // 0: Alle, 1: Offen, 2: Laufend, 3: Abgeschlossen
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ladeProfilUndAuftraege();
    });
  }

  Future<void> _ladeProfilUndAuftraege() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _alleOffenenAuftraegeRaw = [];
      _alleLaufendenAuftraegeRaw = [];
      _alleAbgeschlosseneAuftraegeRaw = [];
      _offenePassendeAuftraege = [];
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception(l10n.notLoggedIn);

      final List<dynamic> profilList = await supabase
          .from('dienstleister_details')
          .select('kategorie, latitude, longitude')
          .eq('user_id', user.id);

      if (profilList.isEmpty) throw Exception(l10n.pleaseCreateProfile);

      final profilData = profilList.first as Map<String, dynamic>;
      final String? kategorie = profilData['kategorie'] as String?;
      final double? latitude = (profilData['latitude'] as num?)?.toDouble();
      final double? longitude = (profilData['longitude'] as num?)?.toDouble();

      if (kategorie == null) throw Exception(l10n.profilMissingCategory);

      _meineKategorie = kategorie;
      _meineLatitude = latitude;
      _meineLongitude = longitude;

      final userData = await supabase
          .from('users')
          .select('abo_typ')
          .eq('id', user.id)
          .maybeSingle();
      _aboTyp = userData?['abo_typ'] as String? ?? 'free';

      final List<dynamic> rawOffen = await supabase
          .from('auftraege')
          .select()
          .eq('kategorie', kategorie)
          .eq('status', 'offen');
      _alleOffenenAuftraegeRaw = rawOffen.cast<Map<String, dynamic>>();

      final List<dynamic> rawLaufend = await supabase
          .from('auftraege')
          .select('*, kunde:users!auftraege_kunde_id_fkey(email)')
          .eq('status', 'in bearbeitung')
          .eq('dienstleister_id', user.id);
      _alleLaufendenAuftraegeRaw = rawLaufend.cast<Map<String, dynamic>>();

      final List<dynamic> rawAbgeschlossen = await supabase
          .from('auftraege')
          .select('*, kunde:users!auftraege_kunde_id_fkey(email)')
          .eq('status', 'abgeschlossen')
          .eq('dienstleister_id', user.id);
      _alleAbgeschlosseneAuftraegeRaw = rawAbgeschlossen.cast<Map<String, dynamic>>();

      double radiusKm = 5.0;
      if (_aboTyp == 'silver')
        radiusKm = 15.0;
      else if (_aboTyp == 'gold')
        radiusKm = 40.0;

      if (_meineLatitude != null && _meineLongitude != null) {
        _offenePassendeAuftraege = _alleOffenenAuftraegeRaw
            .map((map) => Auftrag.fromJson(map))
            .where((auftrag) {
              if (auftrag.latitude == null || auftrag.longitude == null)
                return false;
              final dist = berechneEntfernung(
                _meineLatitude!,
                _meineLongitude!,
                auftrag.latitude!,
                auftrag.longitude!,
              );
              return dist <= radiusKm;
            })
            .toList();
        // ---- SORTIERUNG NACH DISTANZ ----
        _offenePassendeAuftraege.sort((a, b) {
          final distA = (a.latitude != null && a.longitude != null)
              ? berechneEntfernung(_meineLatitude!, _meineLongitude!, a.latitude!, a.longitude!)
              : double.infinity;
          final distB = (b.latitude != null && b.longitude != null)
              ? berechneEntfernung(_meineLatitude!, _meineLongitude!, b.latitude!, b.longitude!)
              : double.infinity;
          return distA.compareTo(distB);
        });
      } else {
        _offenePassendeAuftraege = _alleOffenenAuftraegeRaw
            .map((map) => Auftrag.fromJson(map))
            .toList();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ===== FILTERCHIPS =====
  Widget _buildFilterChips(AppLocalizations l10n) {
    final labels = [
      l10n.filterAlle,
      l10n.filterOffen,
      l10n.filterLaufend,
      l10n.filterAbgeschlossen,
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = _selectedFilter == i;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ChoiceChip(
              label: Text(labels[i]),
              selected: isSelected,
              selectedColor: DienstleisterDashboardScreen.primaryColor,
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

  // ===== ICON BUTTONS AUF DEN KARTEN =====
  Widget _buildCardActions({
    required bool showPdf,
    required VoidCallback? onPdf,
    required bool showDelete,
    required VoidCallback? onDelete,
    bool isGold = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPdf)
          Tooltip(
            message: l10n.rechnungGenerierenButtonLabel,
            child: IconButton(
              icon: Icon(Icons.picture_as_pdf,
                  color: isGold ? Colors.indigo : Colors.grey[400], size: 24),
              onPressed: onPdf,
              splashRadius: 22,
            ),
          ),
        if (showDelete)
          Tooltip(
            message: l10n.deleteJobTooltip,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 24),
              onPressed: onDelete,
              splashRadius: 22,
            ),
          ),
      ],
    );
  }

  // ===== AUFTRAGSKARTE (Für alle Typen) =====
  Widget _buildAuftragsKarte({
    required Auftrag auftrag,
    String? kundenEmail,
    String? distText,
    bool showPdf = false,
    VoidCallback? onPdf,
    bool showDelete = false,
    VoidCallback? onDelete,
    VoidCallback? onTap,
    bool isGold = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
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
                      Icon(Icons.assignment, size: 16, color: DienstleisterDashboardScreen.primaryColor),
                      const SizedBox(width: 7),
                      Text(
                        l10n.statusValue(auftrag.status), // <-- HIER WIRD DER STATUS PER L10N-EXTENSION ANGEZEIGT!
                        style: const TextStyle(fontSize: 13),
                      ),
                      if (!auftrag.soSchnellWieMoeglich) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.access_time_rounded, color: Colors.teal[700], size: 16),
                      ],
                    ],
                  ),
                  if (kundenEmail != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.kundePrefix(kundenEmail),
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                  if (distText != null) ...[
                    const SizedBox(height: 4),
                    Text(distText, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                  ],
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: _buildCardActions(
            showPdf: showPdf,
            onPdf: onPdf,
            showDelete: showDelete,
            onDelete: onDelete,
            isGold: isGold,
          ),
        ),
      ],
    );
  }

  // ===== AUFTRAGSLISTEN JE FILTER =====
  List<Widget> _buildOffeneKarten(AppLocalizations l10n) {
    return _offenePassendeAuftraege.map((auftrag) {
      String distText = '';
      if (_meineLatitude != null &&
          _meineLongitude != null &&
          auftrag.latitude != null &&
          auftrag.longitude != null) {
        final double dist = berechneEntfernung(
          _meineLatitude!,
          _meineLongitude!,
          auftrag.latitude!,
          auftrag.longitude!,
        );
        distText = l10n.entfernungSuffix(dist.toStringAsFixed(1));
      }
      return _buildAuftragsKarte(
        auftrag: auftrag,
        distText: distText.isNotEmpty ? distText : null,
        showPdf: false,
        showDelete: false,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
            ),
          ).then((_) => _ladeProfilUndAuftraege());
        },
      );
    }).toList();
  }

  List<Widget> _buildLaufendeKarten(AppLocalizations l10n) {
    final bool isGold = _aboTyp == 'gold';
    return _alleLaufendenAuftraegeRaw.map((map) {
      final auftrag = Auftrag.fromJson(map);
      final kunde = map['kunde'];
      final kundenEmail = kunde?['email'] ?? 'Kunde';
      return _buildAuftragsKarte(
        auftrag: auftrag,
        kundenEmail: kundenEmail,
        showPdf: true,
        isGold: isGold,
        onPdf: isGold
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfRechnungScreen(
                      auftragId: auftrag.id,
                      dienstleisterId: auftrag.dienstleisterId!,
                      kundeId: auftrag.kundeId,
                      beschreibung: auftrag.beschreibung,
                      adresse: auftrag.adresse,
                      datum: auftrag.aktualisiertAm,
                    ),
                  ),
                );
              }
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.onlyForGoldTooltip),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
        showDelete: false,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
            ),
          ).then((_) => _ladeProfilUndAuftraege());
        },
      );
    }).toList();
  }

  List<Widget> _buildAbgeschlosseneKarten(AppLocalizations l10n) {
    final bool isGold = _aboTyp == 'gold';
    return _alleAbgeschlosseneAuftraegeRaw.map((map) {
      final auftrag = Auftrag.fromJson(map);
      final kunde = map['kunde'];
      final kundenEmail = kunde?['email'] ?? 'Kunde';
      return _buildAuftragsKarte(
        auftrag: auftrag,
        kundenEmail: kundenEmail,
        showPdf: true,
        isGold: isGold,
        onPdf: isGold
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfRechnungScreen(
                      auftragId: auftrag.id,
                      dienstleisterId: auftrag.dienstleisterId!,
                      kundeId: auftrag.kundeId,
                      beschreibung: auftrag.beschreibung,
                      adresse: auftrag.adresse,
                      datum: auftrag.aktualisiertAm,
                    ),
                  ),
                );
              }
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.onlyForGoldTooltip),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
        showDelete: true,
        onDelete: () {
          setState(() {
            _alleAbgeschlosseneAuftraegeRaw.removeWhere(
                (element) => element['id'] == auftrag.id);
          });
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuftragDetailScreen(initialAuftrag: auftrag),
            ),
          ).then((_) => _ladeProfilUndAuftraege());
        },
      );
    }).toList();
  }

  // ===== FILTERED LISTE =====
  Widget _buildFilteredList(AppLocalizations l10n) {
    List<Widget> cards = [];
    if (_selectedFilter == 0) {
      if (_alleLaufendenAuftraegeRaw.isNotEmpty) {
        cards.addAll(_buildLaufendeKarten(l10n));
      }
      if (_alleAbgeschlosseneAuftraegeRaw.isNotEmpty) {
        cards.addAll(_buildAbgeschlosseneKarten(l10n));
      }
      if (_offenePassendeAuftraege.isNotEmpty) {
        cards.addAll(_buildOffeneKarten(l10n));
      }
    } else if (_selectedFilter == 1) {
      if (_offenePassendeAuftraege.isNotEmpty) {
        cards.addAll(_buildOffeneKarten(l10n));
      }
    } else if (_selectedFilter == 2) {
      if (_alleLaufendenAuftraegeRaw.isNotEmpty) {
        cards.addAll(_buildLaufendeKarten(l10n));
      }
    } else if (_selectedFilter == 3) {
      if (_alleAbgeschlosseneAuftraegeRaw.isNotEmpty) {
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

  // ===== BOTTOM NAVIGATION BAR =====
  Widget _buildBottomNav(AppLocalizations l10n) {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      selectedItemColor: DienstleisterDashboardScreen.primaryColor,
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
              builder: (_) => AchievementScreen(
                aboTyp: _aboTyp ?? 'free',
                isTopBewertet: false,
                completedJobsCount: 0,
              ),
            ),
          );
        } else if (i == 2) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfilDienstleisterScreen(),
            ),
          );
          _ladeProfilUndAuftraege();
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
      backgroundColor: DienstleisterDashboardScreen.accentColor,
      appBar: AppBar(
        title: Text(
          l10n.dienstleisterDashboardAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: DienstleisterDashboardScreen.primaryColor,
      ),
      body: Stack(
        children: [
          // Hintergrund-Deko
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3876BF), Color(0xFFE7ECEF)],
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
                color: DienstleisterDashboardScreen.primaryColor.withOpacity(0.12),
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
                color: DienstleisterDashboardScreen.accentColor.withOpacity(0.20),
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
    );
  }
}
