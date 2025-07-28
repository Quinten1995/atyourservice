import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auftrag.dart';
import 'bewertung_dialog.dart';
import '../l10n/app_localizations.dart';
import '../utils/pdf_invoice_service.dart';
import 'pdf_rechnung_screen.dart';
import '../utils/category_utils.dart';

// Hilfsfunktion für Kategorie-Icons
IconData getKategorieIcon(String? kategorie) {
  if (kategorie == null) return Icons.assignment_ind;
  switch (kategorie.toLowerCase()) {
    case 'category_elektriker':
    case 'elektriker':
      return Icons.electrical_services;
    case 'category_maler':
    case 'maler':
      return Icons.format_paint;
    case 'category_babysitter':
    case 'babysitter / kinderbetreuung':
      return Icons.child_care;
    case 'category_klempner':
    case 'klempner':
      return Icons.plumbing;
    case 'category_gartenpflege':
    case 'gartenpflege':
      return Icons.grass;
    case 'category_haushaltsreinigung':
    case 'haushaltsreinigung':
      return Icons.cleaning_services;
    case 'category_transport':
    case 'transport':
      return Icons.local_shipping;
    default:
      return Icons.assignment_ind;
  }
}

class AuftragDetailScreen extends StatefulWidget {
  final Auftrag initialAuftrag;
  const AuftragDetailScreen({Key? key, required this.initialAuftrag}) : super(key: key);

  @override
  _AuftragDetailScreenState createState() => _AuftragDetailScreenState();
}

class _AuftragDetailScreenState extends State<AuftragDetailScreen> {
  Auftrag? _auftragDetails;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDienstleister = false;

  String? _kundenTelefonnummer;
  String? _dienstleisterTelefonnummer;

  double? _dlDurchschnitt;
  int? _dlAnzahlBewertungen;

  String? _dienstleisterProfilbildUrl;
  String? _aboTyp;
  String? _dienstleisterAboTyp;
  String? _kundenName;
  String? _dienstleisterName;

  final SupabaseClient _supabase = Supabase.instance.client;

  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  String _getLocalizedStatus(String status, AppLocalizations l10n) {
    switch (status) {
      case 'offen':
        return l10n.statusOffen;
      case 'in bearbeitung':
        return l10n.statusInBearbeitung;
      case 'abgeschlossen':
        return l10n.statusAbgeschlossen;
      default:
        return status;
    }
  }

  @override
  void initState() {
    super.initState();
    _auftragDetails = widget.initialAuftrag;
    _ladeRolleUndAktuellenAuftrag().then((_) {
      _zeigeBewertungsDialogWennNoetig();
    });
  }

  Future<void> _ladeRolleUndAktuellenAuftrag() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _kundenTelefonnummer = null;
      _dienstleisterTelefonnummer = null;
      _dlDurchschnitt = null;
      _dlAnzahlBewertungen = null;
      _dienstleisterProfilbildUrl = null;
      _kundenName = null;
      _dienstleisterName = null;
      _dienstleisterAboTyp = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception(AppLocalizations.of(context)!.notLoggedIn);
      }

      final userResponse = await _supabase
          .from('users')
          .select('rolle, abo_typ')
          .eq('id', user.id)
          .maybeSingle();
      if (userResponse == null || userResponse['rolle'] == null) {
        throw Exception(AppLocalizations.of(context)!.rolleNichtErmittelt);
      }
      final isDL = userResponse['rolle'] == 'dienstleister';
      setState(() {
        _isDienstleister = isDL;
        _aboTyp = userResponse['abo_typ'] as String? ?? 'free';
      });

      final auftragMap = await _supabase
          .from('auftraege')
          .select()
          .eq('id', widget.initialAuftrag.id)
          .maybeSingle();

      if (auftragMap == null) throw Exception(AppLocalizations.of(context)!.auftragNichtGefunden);

      final Auftrag aktuellerAuftrag = Auftrag.fromJson(auftragMap);
      setState(() {
        _auftragDetails = aktuellerAuftrag;
      });

      final kunde = await _supabase
          .from('users')
          .select('email')
          .eq('id', aktuellerAuftrag.kundeId)
          .maybeSingle();
      setState(() {
        _kundenName = kunde?['email'];
      });

      if (aktuellerAuftrag.status == 'in bearbeitung' && aktuellerAuftrag.dienstleisterId != null) {
        if (isDL) {
          setState(() {
            _kundenTelefonnummer = aktuellerAuftrag.telefon;
          });
        } else {
          final details = await _supabase
              .from('dienstleister_details')
              .select('telefon')
              .eq('user_id', aktuellerAuftrag.dienstleisterId!)
              .maybeSingle();
          setState(() {
            _dienstleisterTelefonnummer = details?['telefon'];
          });
        }
      }

      if (aktuellerAuftrag.dienstleisterId != null) {
        await _ladeDienstleisterBewertung(aktuellerAuftrag.dienstleisterId!);

        final details = await _supabase
            .from('dienstleister_details')
            .select('profilbild_url, user_id')
            .eq('user_id', aktuellerAuftrag.dienstleisterId!)
            .maybeSingle();
        setState(() {
          _dienstleisterProfilbildUrl = details?['profilbild_url'];
        });

        final dl = await _supabase
            .from('users')
            .select('email, abo_typ')
            .eq('id', aktuellerAuftrag.dienstleisterId!)
            .maybeSingle();
        setState(() {
          _dienstleisterName = dl?['email'];
          _dienstleisterAboTyp = dl?['abo_typ'] ?? 'free';
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _ladeDienstleisterBewertung(String dienstleisterId) async {
    final res = await _supabase
        .from('bewertungen')
        .select('bewertung')
        .eq('dienstleister_id', dienstleisterId);

    if (res is List && res.isNotEmpty) {
      final values = res.map((b) => (b['bewertung'] as int?) ?? 0).toList();
      setState(() {
        _dlDurchschnitt = values.reduce((a, b) => a + b) / values.length;
        _dlAnzahlBewertungen = values.length;
      });
    } else {
      setState(() {
        _dlDurchschnitt = null;
        _dlAnzahlBewertungen = 0;
      });
    }
  }

  Future<void> _zeigeBewertungsDialogWennNoetig() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || _auftragDetails == null || _isDienstleister || _auftragDetails!.status != 'abgeschlossen') {
      return;
    }

    final existing = await _supabase
        .from('bewertungen')
        .select('id')
        .eq('auftrag_id', _auftragDetails!.id)
        .eq('kunde_id', userId)
        .maybeSingle();

    if (existing == null) {
      final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => BewertungDialog(
          auftragId: _auftragDetails!.id,
          dienstleisterId: _auftragDetails!.dienstleisterId!,
        ),
      );
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.bewertungDanke)),
        );
        setState(() {});
      }
    }
  }

  Future<void> _auftragAnnehmen() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      int wochenLimit = 1; // Default: free
      if ((_aboTyp ?? 'free') == 'silver') wochenLimit = 3;
      if ((_aboTyp ?? 'free') == 'gold') wochenLimit = 99999;

      if ((_aboTyp ?? 'free') != 'gold') {
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekStartUtc = DateTime.utc(weekStart.year, weekStart.month, weekStart.day);

        final auftraegeDieseWoche = await _supabase
            .from('auftraege')
            .select()
            .eq('dienstleister_id', user.id)
            .gte('angenommen_am', weekStartUtc.toIso8601String())
            .inFilter('status', ['in bearbeitung', 'abgeschlossen']);

        if (auftraegeDieseWoche is List && auftraegeDieseWoche.length >= wochenLimit) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.limitErreicht),
              content: Text(
                (_aboTyp == 'free')
                    ? AppLocalizations.of(context)!.limitFree
                    : AppLocalizations.of(context)!.limitSilver,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            ),
          );
          setState(() => _isLoading = false);
          return;
        }
      }

      final updated = await _supabase
          .from('auftraege')
          .update({
            'status': 'in bearbeitung',
            'dienstleister_id': user.id,
            'angenommen_am': DateTime.now().toUtc().toIso8601String(),
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', _auftragDetails!.id)
          .select()
          .single();

      setState(() {
        _auftragDetails = Auftrag.fromJson(updated);
        _isLoading = false;
      });

      await _ladeRolleUndAktuellenAuftrag();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _auftragAbschliessen() async {
    setState(() => _isLoading = true);

    try {
      final updated = await _supabase
          .from('auftraege')
          .update({
            'status': 'abgeschlossen',
            'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', _auftragDetails!.id)
          .select()
          .single();

      setState(() {
        _auftragDetails = Auftrag.fromJson(updated);
        _isLoading = false;
      });

      _zeigeBewertungsDialogWennNoetig();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _kundeAuftragEntfernen() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.auftragEntfernenTitel),
        content: Text(l10n.auftragEntfernenText),
        actions: [
          TextButton(
              child: Text(l10n.abbrechen),
              onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(
              child: Text(l10n.entfernen),
              onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _supabase.from('auftraege').update({
        'kunde_auftragsstatus': 'entfernt',
        'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', _auftragDetails!.id);

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _auftragErneutPosten() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.auftragErneutPostenTitle),
        content: Text(l10n.auftragErneutPostenText),
        actions: [
          TextButton(
            child: Text(l10n.abbrechen),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text(l10n.ok),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _supabase.from('auftraege').update({
        'status': 'offen',
        'dienstleister_id': null,
        'angenommen_am': null,
        'aktualisiert_am': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', _auftragDetails!.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.auftragErneutGepostet)),
      );

      await _ladeRolleUndAktuellenAuftrag();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _zeitplanungAnzeige() {
    final l10n = AppLocalizations.of(context)!;
    final ad = _auftragDetails!;
    if (ad.wiederkehrend == true) {
      return Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.repeat, color: Colors.deepPurple, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                [
                  if ((ad.wochentag ?? '').isNotEmpty) l10n.jedenWochentag(ad.wochentag ?? ''),
                  if (ad.intervall != null) ad.intervall!,
                  if (ad.zeitVon != null && ad.zeitBis != null)
                    "${ad.zeitVon!.format(context)}–${ad.zeitBis!.format(context)} Uhr",
                  if (ad.wiederholenBis != null)
                    l10n.bisDatum(
                        "${ad.wiederholenBis!.day.toString().padLeft(2, '0')}.${ad.wiederholenBis!.month.toString().padLeft(2, '0')}.${ad.wiederholenBis!.year}"),
                  if (ad.anzahlWiederholungen != null)
                    "${ad.anzahlWiederholungen} ${l10n.malSuffix}"
                ].where((s) => s.isNotEmpty).join(", "),
                style: const TextStyle(fontSize: 15, color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    } else if (ad.soSchnellWieMoeglich == false && ad.terminDatum != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.schedule, color: Colors.blueGrey, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${ad.terminDatum!.day.toString().padLeft(2, '0')}.${ad.terminDatum!.month.toString().padLeft(2, '0')}.${ad.terminDatum!.year}"
                "${ad.zeitVon != null && ad.zeitBis != null ? ", ${ad.zeitVon!.format(context)}–${ad.zeitBis!.format(context)} Uhr" : ""}",
                style: const TextStyle(fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.flash_on, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.soSchnellWieMoeglich,
              style: const TextStyle(fontSize: 15, color: Colors.orange, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }
  }

  Widget _premiumBadge() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: 4.0, left: 0.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium, color: Colors.amber[800], size: 20),
          const SizedBox(width: 3),
          Text(
            l10n.premiumBadgeLabel,
            style: TextStyle(
              color: Colors.amber[900],
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _auftragInfoCard() {
    final l10n = AppLocalizations.of(context)!;
    final ad = _auftragDetails!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.10),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(getKategorieIcon(ad.kategorie), color: primaryColor, size: 22),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  ad.titel,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: primaryColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _zeitplanungAnzeige(),
          const SizedBox(height: 11),
          Text(
            l10n.beschreibung,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, top: 1, bottom: 7),
            child: Text(ad.beschreibung, style: const TextStyle(fontSize: 16)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(getKategorieIcon(ad.kategorie), color: primaryColor, size: 19),
              SizedBox(width: 7),
              Text(l10n.kategorie, style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(width: 7),
              Text(getKategorieLabel(ad.kategorie, l10n)),
            ],
          ),
          const SizedBox(height: 8),
          if (ad.adresse != null && ad.adresse!.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.redAccent, size: 19),
                SizedBox(width: 7),
                Text(l10n.adresse, style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(width: 7),
                Expanded(child: Text(ad.adresse!, overflow: TextOverflow.ellipsis)),
              ],
            ),
          if (ad.latitude != null && ad.longitude != null)
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 3),
              child: Text(
                '(${ad.latitude?.toStringAsFixed(5)}, ${ad.longitude?.toStringAsFixed(5)})',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
          const SizedBox(height: 11),
          Row(
            children: [
              Text(l10n.status, style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              Chip(
                label: Text(
                  _getLocalizedStatus(ad.status, l10n),
                  style: TextStyle(
                    color: ad.status == 'abgeschlossen'
                        ? Colors.white
                        : primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                backgroundColor: ad.status == 'abgeschlossen'
                    ? Colors.green
                    : accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _angenommenVonInfo() {
    if (_auftragDetails == null ||
        _auftragDetails!.dienstleisterId == null ||
        !(_auftragDetails!.status == 'in bearbeitung' || _auftragDetails!.status == 'abgeschlossen')) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 2, right: 2, bottom: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[800], size: 20),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              l10n.acceptedByLabel(_dienstleisterName ?? l10n.roleDienstleister),
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[800],
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dienstleisterVisitenkarte() {
    if (_auftragDetails == null ||
        _auftragDetails!.dienstleisterId == null ||
        !(_auftragDetails!.status == 'in bearbeitung' || _auftragDetails!.status == 'abgeschlossen')) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: (_dienstleisterProfilbildUrl != null && _dienstleisterProfilbildUrl!.isNotEmpty)
                  ? NetworkImage(_dienstleisterProfilbildUrl!)
                  : null,
              child: (_dienstleisterProfilbildUrl == null || _dienstleisterProfilbildUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 34, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name und Premium Badge als Column (Badge unter Name, kein Überlappen!)
                  Text(
                    _dienstleisterName ?? l10n.roleDienstleister,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_dienstleisterAboTyp == 'gold') _premiumBadge(),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 22),
                      Text(
                        _dlDurchschnitt != null
                            ? '${_dlDurchschnitt!.toStringAsFixed(2)} / 5'
                            : '—',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (_dlAnzahlBewertungen != null && _dlAnzahlBewertungen! > 0)
                        Text(
                          l10n.ratingsCount(_dlAnzahlBewertungen!),
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kontaktBereich() {
    final l10n = AppLocalizations.of(context)!;
    final ad = _auftragDetails!;
    if (ad.status == 'in bearbeitung' && ad.dienstleisterId != null) {
      String? label;
      String? nummer;
      if (_isDienstleister && _kundenTelefonnummer != null) {
        label = l10n.kundePrefix(_kundenName ?? l10n.roleKunde);
        nummer = _kundenTelefonnummer;
      } else if (!_isDienstleister && _dienstleisterTelefonnummer != null) {
        label = l10n.dienstleisterPrefix(_dienstleisterName ?? l10n.roleDienstleister);
        nummer = _dienstleisterTelefonnummer;
      }
      if (label != null && nummer != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.kontaktZuLabel(label),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(Icons.contact_phone, color: Colors.blueGrey, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SelectableText(
                          nummer,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.black54),
                        tooltip: l10n.nummerKopieren,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: nummer!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.nummerKopiert)),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.call, color: Colors.green),
                        tooltip: l10n.anrufen,
                        onPressed: () {
                          final uri = Uri(scheme: 'tel', path: nummer!);
                          launchUrl(uri);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _actionButtons() {
    final l10n = AppLocalizations.of(context)!;
    final ad = _auftragDetails!;
    return Column(
      children: [
        const SizedBox(height: 32),
        if (_isDienstleister && ad.status == 'offen')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _auftragAnnehmen,
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.auftragAnnehmen),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
          ),
        if (_isDienstleister && ad.status == 'in bearbeitung')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _auftragAbschliessen,
              icon: const Icon(Icons.check),
              label: Text(l10n.auftragBeenden),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
          ),
        if (!_isDienstleister && (ad.status == 'offen' || ad.status == 'in bearbeitung' || ad.status == 'abgeschlossen'))
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _kundeAuftragEntfernen,
              icon: const Icon(Icons.delete),
              label: Text(
                ad.status == 'abgeschlossen'
                    ? l10n.auftragEntfernenUebersicht
                    : l10n.auftragEntfernen,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        if (!_isDienstleister && ad.status == 'in bearbeitung')
          const SizedBox(height: 18),
        if (!_isDienstleister && ad.status == 'in bearbeitung')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _auftragErneutPosten,
              icon: const Icon(Icons.replay),
              label: Text(l10n.auftragErneutPosten),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 20),
          Text(
            l10n.errorPrefix(_errorMessage ?? ""),
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        title: Text(l10n.auftragDetailTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _auftragDetails == null
                ? Center(child: Text(l10n.keineDatenVerfuegbar))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _auftragInfoCard(),
                        _angenommenVonInfo(),
                        _dienstleisterVisitenkarte(),
                        _kontaktBereich(),
                        _actionButtons(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
