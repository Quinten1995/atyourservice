import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/auftrag.dart';
import '../utils/entfernung_utils.dart';

import 'auftrag_detail_screen.dart';
import 'profil_dienstleister_screen.dart';
import 'pdf_rechnung_screen.dart';
import 'achievement_screen.dart';
import 'premium_screen.dart'; // für Upgrade-CTA

import '../l10n/app_localizations.dart';
import '../l10n/status_value_extension.dart';

// 🔎 Analytics
import '../utils/analytics_service.dart';

class DienstleisterDashboardScreen extends StatefulWidget {
  const DienstleisterDashboardScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  static const Map<String, Color> statusColors = {
    'offen': Color(0xFF43A047),
    'in bearbeitung': Color(0xFF1E88E5),
    'abgeschlossen': Color(0xFF757575),
  };
  static const Map<String, IconData> statusIcons = {
    'offen': Icons.inbox,
    'in bearbeitung': Icons.hourglass_bottom,
    'abgeschlossen': Icons.check_circle,
  };

  @override
  State<DienstleisterDashboardScreen> createState() =>
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

  /// Sichtbar im aktuellen Plan
  List<Auftrag> _offenePassendeAuftraege = [];

  /// Außerhalb aktueller Radius, aber innerhalb des nächsten Plans (Upsell)
  List<Auftrag> _offeneUpsellAuftraege = [];

  int _selectedFilter = 0; // 0: Alle, 1: Offen, 2: Laufend, 3: Abgeschlossen
  int _bottomNavIndex = 0;

  int _completedJobsCount = 0;
  double _durchschnittsbewertung = 0.0;
  int _anzahlBewertungen = 0;

  // --- Neu-Toggle (zeitbasiert) ---
  bool _onlyNew = false;
  static const int _kNewWindowHours = 24; // 24h-Fenster für "Neu"

  bool _isNewByTime(DateTime? createdUtc) {
    if (createdUtc == null) return false;
    final diff = DateTime.now().toUtc().difference(createdUtc.toUtc());
    return diff.inHours <= _kNewWindowHours;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ladeProfilUndAuftraege();
    });
  }

  // --------- Abo-/Radius-Helper ---------
  double _planRadius(String? abo) {
    switch ((abo ?? 'free').toLowerCase()) {
      case 'gold':
        return 30.0; // aktuell in deinem Projekt so genutzt
      case 'silver':
        return 15.0;
      default:
        return 5.0;
    }
  }

  String? _nextPlan(String? abo) {
    switch ((abo ?? 'free').toLowerCase()) {
      case 'free':
        return 'silver';
      case 'silver':
        return 'gold';
      default:
        return null; // gold hat keinen nächsthöheren Plan
    }
  }

  String _planPretty(BuildContext context, String plan) {
    final l10n = AppLocalizations.of(context)!;
    switch (plan) {
      case 'silver':
        return l10n.planSilver;
      case 'gold':
        return l10n.planGold;
      default:
        return l10n.planFree;
    }
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
      _offeneUpsellAuftraege = [];

      _completedJobsCount = 0;
      _durchschnittsbewertung = 0.0;
      _anzahlBewertungen = 0;
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
      _aboTyp = (userData?['abo_typ'] as String?) ?? 'free';

      if (_meineKategorie != null) {
        final List<dynamic> rawOffen = await supabase
            .from('auftraege')
            .select()
            .eq('kategorie', _meineKategorie!)
            .eq('status', 'offen');
        _alleOffenenAuftraegeRaw = rawOffen.cast<Map<String, dynamic>>();
      }

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

      _completedJobsCount = _alleAbgeschlosseneAuftraegeRaw.length;

      // Bewertungen → Durchschnitt + Anzahl
      final bewertungenData = await supabase
          .from('bewertungen')
          .select('bewertung')
          .eq('dienstleister_id', user.id);

      if (bewertungenData != null &&
          bewertungenData is List &&
          bewertungenData.isNotEmpty) {
        double sum = 0.0;
        int count = 0;
        for (var b in bewertungenData) {
          final val = (b['bewertung'] as num?)?.toDouble();
          if (val != null) {
            sum += val;
            count++;
          }
        }
        if (count > 0) _durchschnittsbewertung = sum / count;
        _anzahlBewertungen = count;
      }

      // ---------- Radius-Filter + Upsell-Berechnung ----------
      final double baseRadiusKm = _planRadius(_aboTyp);
      final String? nextPlan = _nextPlan(_aboTyp);
      final double? nextRadiusKm = nextPlan != null
          ? _planRadius(nextPlan)
          : null;

      if (_meineLatitude != null && _meineLongitude != null) {
        final alleOffen = _alleOffenenAuftraegeRaw
            .map((map) => Auftrag.fromJson(map))
            .where((a) => a.latitude != null && a.longitude != null);

        final visible = <Auftrag>[];
        final upsell = <Auftrag>[];

        for (final a in alleOffen) {
          final dist = berechneEntfernung(
            _meineLatitude!,
            _meineLongitude!,
            a.latitude!,
            a.longitude!,
          );
          if (dist <= baseRadiusKm) {
            visible.add(a);
          } else if (nextRadiusKm != null && dist <= nextRadiusKm) {
            upsell.add(a);
          }
        }

        // Sortiere beide nach Distanz
        int cmpByDist(Auftrag x, Auftrag y) {
          final dx = berechneEntfernung(
            _meineLatitude!,
            _meineLongitude!,
            x.latitude!,
            x.longitude!,
          );
          final dy = berechneEntfernung(
            _meineLatitude!,
            _meineLongitude!,
            y.latitude!,
            y.longitude!,
          );
          return dx.compareTo(dy);
        }

        visible.sort(cmpByDist);
        upsell.sort(cmpByDist);

        _offenePassendeAuftraege = visible;
        // Nicht spammen: max. 3 Upsell-Karten lokal
        _offeneUpsellAuftraege = nextPlan == null
            ? <Auftrag>[]
            : upsell.take(3).toList();
      } else {
        // kein Standort → alles normal sichtbar, kein Upsell
        _offenePassendeAuftraege = _alleOffenenAuftraegeRaw
            .map((m) => Auftrag.fromJson(m))
            .toList();
        _offeneUpsellAuftraege = [];
      }

      // 🔎 Analytics: User-Kontext nach erfolgreichem Laden setzen
      try {
        await AnalyticsService.I.setUserId(user.id);
        await AnalyticsService.I.setUserProps(
          role: 'provider',
          plan: _aboTyp ?? 'free',
          locale: l10n.localeName,
          // city könntest du später setzen, sobald du einen City-String hast
        );
      } catch (_) {}

      setState(() => _isLoading = false);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      setState(() {
        _errorMessage = msg;
        _isLoading = false;
      });
    }
  }

  // ----- Preis Helpers (l10n-ready, analog Kunden-Dashboard) -----
  String? _formatPrice(Auftrag a, AppLocalizations l10n) {
    final typ = (a.preisTyp ?? '').toLowerCase();
    final v = a.preis;

    if (typ == 'verhandelbar') return l10n.verhandelbarLabel;
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

  Widget buildStatusBadge(String status, AppLocalizations l10n) {
    final lowerStatus = status.toLowerCase();
    final color =
        DienstleisterDashboardScreen.statusColors[lowerStatus] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            DienstleisterDashboardScreen.statusIcons[lowerStatus] ?? Icons.info,
            color: color,
            size: 17,
          ),
          const SizedBox(width: 6),
          Text(
            l10n.statusValue(status),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ----- Aktionen (PDF/Delete) -----
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
              icon: Icon(
                Icons.picture_as_pdf,
                color: isGold ? Colors.indigo : Colors.grey[400],
                size: 24,
              ),
              onPressed: onPdf,
              splashRadius: 22,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
          ),
        if (showDelete)
          Tooltip(
            message: l10n.deleteJobTooltip,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 24),
              onPressed: onDelete,
              splashRadius: 22,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
          ),
      ],
    );
  }

  // ----- Normale (sichtbare) Auftrags-Karte -----
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
    final priceText = _formatPrice(auftrag, l10n);
    final bool isNew = _isNewByTime(auftrag.erstelltAm);

    return Material(
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
              // Titel + Preis + (optional) Actions rechts
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      auftrag.titel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (priceText != null) ...[
                    const SizedBox(width: 8),
                    _buildPricePill(priceText),
                  ],
                  if (showPdf || showDelete) ...[
                    const SizedBox(width: 6),
                    Transform.translate(
                      offset: const Offset(0, -2),
                      child: _buildCardActions(
                        showPdf: showPdf,
                        onPdf: onPdf,
                        showDelete: showDelete,
                        onDelete: onDelete,
                        isGold: isGold,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  buildStatusBadge(auftrag.status, l10n),
                  if (isNew) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.filterNeu, // "Neu"
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                  if (!auftrag.soSchnellWieMoeglich) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.teal[700],
                      size: 16,
                    ),
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
                Text(
                  distText,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ----- Upsell (LOCKED) Karte — ohne Kategoriezeile -----
  Widget _buildLockedCard({
    required Auftrag auftrag,
    required String requiredPlan, // 'silver' | 'gold'
    String? distText,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final pretty = _planPretty(context, requiredPlan);
    return Material(
      elevation: 2.5,
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kopfzeile
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: const Icon(Icons.lock, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.upsellCardTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (distText != null) ...[
              const SizedBox(height: 4),
              Text(
                distText,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.65),
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 10),
            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.workspace_premium),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DienstleisterDashboardScreen.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PremiumScreen()),
                  );
                },
                label: Text(l10n.upsellUpgradeButton(pretty)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- Kartenlisten -----
  List<Widget> _buildOffeneKarten(AppLocalizations l10n) {
    // 1) Optionale Neu-Filterung (nur sichtbare, offene!)
    final List<Auftrag> sichtbareOffene = _onlyNew
        ? _offenePassendeAuftraege
              .where((a) => _isNewByTime(a.erstelltAm))
              .toList()
        : _offenePassendeAuftraege;

    // 2) Normale offenen Karten rendern
    final openCards = sichtbareOffene.map((auftrag) {
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

    // 3) Upsell-Karten (max 3), an sinnvollen Positionen einstreuen
    if (_offeneUpsellAuftraege.isNotEmpty) {
      final lockedCards = <Widget>[];
      final nextPlan = _nextPlan(_aboTyp)!;

      for (final a in _offeneUpsellAuftraege) {
        String? distText;
        if (_meineLatitude != null &&
            _meineLongitude != null &&
            a.latitude != null &&
            a.longitude != null) {
          final d = berechneEntfernung(
            _meineLatitude!,
            _meineLongitude!,
            a.latitude!,
            a.longitude!,
          );
          distText = l10n.entfernungSuffix(d.toStringAsFixed(1));
        }
        lockedCards.add(
          _buildLockedCard(
            auftrag: a,
            requiredPlan: nextPlan,
            distText: distText,
          ),
        );
      }

      // Einfüge-Positionen (nicht aggressiv)
      final positions = <int>[2, 7, 12];
      int li = 0;
      for (final p in positions) {
        if (li >= lockedCards.length) break;
        final idx = (p < 0)
            ? 0
            : (p > openCards.length ? openCards.length : p); // clamp
        openCards.insert(idx, lockedCards[li++]);
      }
    }

    return openCards;
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
              (element) => element['id'] == auftrag.id,
            );
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

  Widget _buildFilteredList(AppLocalizations l10n) {
    List<Widget> cards = [];
    if (_selectedFilter == 0) {
      if (_alleLaufendenAuftraegeRaw.isNotEmpty) {
        cards.addAll(_buildLaufendeKarten(l10n));
      }
      if (_alleAbgeschlosseneAuftraegeRaw.isNotEmpty) {
        cards.addAll(_buildAbgeschlosseneKarten(l10n));
      }
      // Offene + Upsell
      final offeneMitUpsell = _buildOffeneKarten(l10n);
      if (offeneMitUpsell.isNotEmpty) cards.addAll(offeneMitUpsell);
    } else if (_selectedFilter == 1) {
      final offeneMitUpsell = _buildOffeneKarten(l10n);
      if (offeneMitUpsell.isNotEmpty) cards.addAll(offeneMitUpsell);
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
          // Top bewertet: Ø >= 4.5 UND mindestens 5 Bewertungen
          final isTopBewertet =
              _durchschnittsbewertung >= 4.5 && _anzahlBewertungen >= 5;

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AchievementScreen(
                aboTyp: _aboTyp ?? 'free',
                isTopBewertet: isTopBewertet,
                completedJobsCount: _completedJobsCount,
              ),
            ),
          );
          setState(() => _bottomNavIndex = 0);
        } else if (i == 2) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfilDienstleisterScreen(),
            ),
          );
          setState(() => _bottomNavIndex = 0);
          _ladeProfilUndAuftraege();
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.assignment),
          label: l10n.auftraege,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.emoji_events),
          label: l10n.achievementTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n.profil,
        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterChips(l10n),
                      _buildNewToggle(l10n),
                      _buildFilteredList(l10n),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(l10n),
    );
  }

  // ----- Filterchips (Status) -----
  Widget _buildFilterChips(AppLocalizations l10n) {
    final labels = [
      l10n.filterAlle,
      l10n.filterOffen,
      l10n.filterLaufend,
      l10n.filterAbgeschlossen,
    ];
    final chipIcons = [
      Icons.filter_alt,
      DienstleisterDashboardScreen.statusIcons['offen']!,
      DienstleisterDashboardScreen.statusIcons['in bearbeitung']!,
      DienstleisterDashboardScreen.statusIcons['abgeschlossen']!,
    ];
    final chipColors = [
      Colors.grey,
      DienstleisterDashboardScreen.statusColors['offen']!,
      DienstleisterDashboardScreen.statusColors['in bearbeitung']!,
      DienstleisterDashboardScreen.statusColors['abgeschlossen']!,
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(labels.length, (i) {
            final isSelected = _selectedFilter == i;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      chipIcons[i],
                      size: 17,
                      color: isSelected ? Colors.white : chipColors[i],
                    ),
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
      ),
    );
  }

  // ----- Neu-Toggle-Zeile: runder Button -----
  Widget _buildNewToggle(AppLocalizations l10n) {
    final bool on = _onlyNew;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Tooltip(
            message: l10n.filterNeu,
            child: RawMaterialButton(
              onPressed: () => setState(() => _onlyNew = !on),
              elevation: on ? 4 : 1,
              highlightElevation: 6,
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              shape: const CircleBorder(),
              fillColor: on ? Colors.orange[700] : Colors.white,
              splashColor: Colors.orange.withOpacity(0.15),
              child: Icon(
                Icons.fiber_new,
                size: 22,
                color: on ? Colors.white : Colors.orange[700],
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (on)
            Expanded(
              child: Text(
                l10n.onlyNewWindowInfo(_kNewWindowHours),
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black.withOpacity(0.65),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
