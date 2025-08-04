import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import '../utils/entfernung_utils.dart';
import 'auftrag_detail_screen.dart';
import 'profil_dienstleister_screen.dart';
import '../l10n/app_localizations.dart';
import '../l10n/status_value_extension.dart';
import 'pdf_rechnung_screen.dart';
import 'achievement_screen.dart'; // ACHTUNG: Pfad ggf. anpassen

class DienstleisterDashboardScreen extends StatefulWidget {
  const DienstleisterDashboardScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  @override
  _DienstleisterDashboardScreenState createState() =>
      _DienstleisterDashboardScreenState();
}

class _DienstleisterDashboardScreenState
    extends State<DienstleisterDashboardScreen> {
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

  // Für Achievement-Icon-Loading
  bool _isAchievementsLoading = false;

  Future<void> _openAchievementsScreen() async {
    setState(() => _isAchievementsLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // 1. Lade abgeschlossene Jobs
      final detailsRes = await supabase
          .from('dienstleister_details')
          .select('completed_jobs_count')
          .eq('user_id', user.id)
          .maybeSingle();
      final completedJobsCount = detailsRes?['completed_jobs_count'] ?? 0;

      // 2. Lade Bewertungen
      final bewertungenRes = await supabase
          .from('bewertungen')
          .select('bewertung')
          .eq('dienstleister_id', user.id);

      double durchschnitt = 0.0;
      int anzahl = 0;
      if (bewertungenRes is List && bewertungenRes.isNotEmpty) {
        anzahl = bewertungenRes.length;
        final values = bewertungenRes.map((b) => (b['bewertung'] as int?) ?? 0).toList();
        durchschnitt = values.reduce((a, b) => a + b) / anzahl;
      }
      final isTopBewertet = (anzahl >= 2 && durchschnitt >= 4.5);

      setState(() => _isAchievementsLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AchievementScreen(
            aboTyp: _aboTyp ?? 'free',
            isTopBewertet: isTopBewertet,
            completedJobsCount: completedJobsCount,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isAchievementsLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Achievements: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _updateZuletztOnline();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ladeProfilUndAuftraege();
    });
  }

  // Update in beiden Tabellen!
  Future<void> _updateZuletztOnline() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final jetzt = DateTime.now().toIso8601String();
    try {
      // users Tabelle
      await supabase
          .from('users')
          .update({'zuletzt_online': jetzt})
          .eq('id', user.id);
      // dienstleister_details Tabelle
      await supabase
          .from('dienstleister_details')
          .update({'zuletzt_online': jetzt})
          .eq('user_id', user.id);
    } catch (_) {}
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
      _alleAbgeschlosseneAuftraegeRaw = rawAbgeschlossen
          .cast<Map<String, dynamic>>();

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

  Widget _dashboardHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 2, top: 8),
      child: Row(
        children: [
          Icon(
            Icons.handyman,
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
            l10n.dienstleisterDashboardHeader,
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

  Widget _buildAuftragsListe(
    List<Map<String, dynamic>> auftraegeRaw,
    String titel, {
    bool isCompleted = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final bool isGold = (_aboTyp == 'gold');

    if (auftraegeRaw.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          l10n.noPassendeAuftraege,
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titel,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: auftraegeRaw.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final map = auftraegeRaw[index];
              final auftrag = Auftrag.fromJson(map);
              final kunde = map['kunde'];
              final kundenEmail = kunde?['email'] ?? 'Kunde';

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
                        builder: (_) =>
                            AuftragDetailScreen(initialAuftrag: auftrag),
                      ),
                    ).then((_) => _ladeProfilUndAuftraege());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    auftrag.titel,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!auftrag.soSchnellWieMoeglich)
                                  Tooltip(
                                    message: l10n.geplanterAuftrag,
                                    child: Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.teal[700],
                                      size: 18,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.assignment,
                                  size: 15,
                                  color:
                                      DienstleisterDashboardScreen.primaryColor,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  l10n.statusPrefix(
                                    l10n.statusValue(auftrag.status),
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.kundePrefix(kundenEmail),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.picture_as_pdf, size: 17),
                              label: Text(
                                l10n.rechnungGenerierenButtonLabel,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isGold
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isGold
                                    ? Colors.indigo
                                    : Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                minimumSize: const Size.fromHeight(44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              onPressed: () {
                                if (!isGold) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.onlyForGoldTooltip),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PdfRechnungScreen(
                                        auftragId: auftrag.id,
                                        dienstleisterId:
                                            auftrag.dienstleisterId!,
                                        kundeId: auftrag.kundeId,
                                        beschreibung: auftrag.beschreibung,
                                        adresse: auftrag.adresse,
                                        datum: auftrag.aktualisiertAm,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            if (isCompleted) ...[
                              const SizedBox(height: 13),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                  tooltip: l10n.deleteJobTooltip,
                                  onPressed: () {
                                    setState(() {
                                      _alleAbgeschlosseneAuftraegeRaw
                                          .removeWhere(
                                            (element) =>
                                                element['id'] == auftrag.id,
                                          );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
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
        actions: [
          // ACHIEVEMENT-ICON (Pokál/Medaille)
          if (_isAchievementsLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(
                Icons.emoji_events, // Goldene Medaille/Pokál
                color: Colors.orange[700],
                size: 28,
              ),
              tooltip: l10n.achievementTitle,
              onPressed: _openAchievementsScreen,
            ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: l10n.editProfileTooltip,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfilDienstleisterScreen(),
                ),
              );
              _ladeProfilUndAuftraege();
            },
            color: DienstleisterDashboardScreen.primaryColor,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Hintergrund: Gradient + Deko-Kreise wie bei den anderen Screens
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
                color: DienstleisterDashboardScreen.primaryColor.withOpacity(
                  0.12,
                ),
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
                color: DienstleisterDashboardScreen.accentColor.withOpacity(
                  0.20,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(l10n.errorPrefix(_errorMessage!)))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dashboardHeader(),
                          if (_alleLaufendenAuftraegeRaw.isNotEmpty)
                            _buildAuftragsListe(
                              _alleLaufendenAuftraegeRaw,
                              l10n.meineLaufendenAuftraege,
                            ),
                          if (_alleAbgeschlosseneAuftraegeRaw.isNotEmpty)
                            _buildAuftragsListe(
                              _alleAbgeschlosseneAuftraegeRaw,
                              l10n.meineAbgeschlossenenAuftraege,
                              isCompleted: true,
                            ),
                          Text(
                            l10n.offenePassendeAuftraege,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 7),
                          Expanded(
                            child: _offenePassendeAuftraege.isEmpty
                                ? Center(
                                    child: Text(
                                      l10n.noPassendeAuftraege,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _offenePassendeAuftraege.length,
                                    separatorBuilder: (context, i) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final Auftrag auftrag =
                                          _offenePassendeAuftraege[index];
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
                                        distText = l10n.entfernungSuffix(
                                          dist.toStringAsFixed(1),
                                        );
                                      }

                                      return Material(
                                        color: Colors.white.withOpacity(0.96),
                                        borderRadius: BorderRadius.circular(18),
                                        elevation: 2,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 18,
                                          ),
                                          leading: Icon(
                                            Icons.assignment_outlined,
                                            color: DienstleisterDashboardScreen
                                                .primaryColor,
                                            size: 30,
                                          ),
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  auftrag.titel,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (!auftrag.soSchnellWieMoeglich)
                                                Tooltip(
                                                  message:
                                                      l10n.geplanterAuftrag,
                                                  child: Icon(
                                                    Icons.access_time_rounded,
                                                    color: Colors.teal[700],
                                                    size: 20,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          subtitle: distText.isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 3.0,
                                                  ),
                                                  child: Text(
                                                    distText,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                )
                                              : null,
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color: Colors.black38,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    AuftragDetailScreen(
                                                  initialAuftrag: auftrag,
                                                ),
                                              ),
                                            ).then(
                                              (_) => _ladeProfilUndAuftraege(),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
