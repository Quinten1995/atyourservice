import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/auftrag_form_data.dart';
import '../../utils/geocoding_service.dart';
import '../../l10n/app_localizations.dart';
import '../kunden_dashboard_screen.dart';

// 🔎 Analytics
import '../../utils/analytics_service.dart';

class AuftragReviewScreen extends StatefulWidget {
  final AuftragFormData formData;
  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  const AuftragReviewScreen({Key? key, required this.formData})
    : super(key: key);

  @override
  State<AuftragReviewScreen> createState() => _AuftragReviewScreenState();
}

class _AuftragReviewScreenState extends State<AuftragReviewScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  // Sehr simple Heuristik: nimmt nach letztem Komma das „Wort“, sonst unknown
  String _cityFromAddress(String? addr) {
    if (addr == null) return 'unknown';
    final s = addr.trim();
    if (s.isEmpty) return 'unknown';
    final parts = s.split(',');
    final tail = parts.isNotEmpty ? parts.last.trim() : s;
    // z.B. "54290 Trier" → nimm das letzte Wort
    final words = tail.split(RegExp(r'\s+'));
    return words.isNotEmpty ? words.last : 'unknown';
  }

  Future<void> _auftragAbschicken() async {
    final supabase = Supabase.instance.client;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception(l10n.bitteEinloggen);

      // Geocoding nur, wenn Adresse vorhanden
      double? lat, lon;
      final hasAdresse = (widget.formData.adresse ?? '').trim().isNotEmpty;
      if (hasAdresse) {
        final coords = await GeocodingService().getCoordinates(
          widget.formData.adresse!.trim(),
        );
        if (coords == null) throw Exception(l10n.adresseNichtGefunden);
        lat = coords['lat'];
        lon = coords['lng'];
      }

      final String id = const Uuid().v4();
      final timestamp = DateTime.now().toUtc().toIso8601String();

      // Map mit bedingten Einträgen für optionale Felder
      final auftragMap = <String, dynamic>{
        'id': id,
        'kunde_id': user.id,
        'titel': widget.formData.titel ?? '',
        'beschreibung': widget.formData.beschreibung ?? '',
        'kategorie': widget.formData.kategorie ?? '',
        if (hasAdresse) 'adresse': widget.formData.adresse!.trim(),
        if (lat != null) 'latitude': lat,
        if (lon != null) 'longitude': lon,
        'status': 'offen',
        'erstellt_am': timestamp,
        'aktualisiert_am': timestamp,
        if ((widget.formData.telefon ?? '').trim().isNotEmpty)
          'telefon': widget.formData.telefon!.trim(),

        // Preis & Preis-Typ
        'preis': widget.formData.preis,
        'preis_typ': widget.formData.preisTyp,
        'so_schnell_wie_moeglich': widget.formData.soSchnellWieMoeglich,

        // Termin-Logik
        if (!widget.formData.soSchnellWieMoeglich &&
            widget.formData.terminDatum != null)
          'termin_datum': widget.formData.terminDatum!
              .toIso8601String()
              .substring(0, 10),
        if (!widget.formData.soSchnellWieMoeglich &&
            widget.formData.zeitVon != null)
          'zeit_von':
              '${widget.formData.zeitVon!.hour.toString().padLeft(2, '0')}:${widget.formData.zeitVon!.minute.toString().padLeft(2, '0')}',
        if (!widget.formData.soSchnellWieMoeglich &&
            widget.formData.zeitBis != null)
          'zeit_bis':
              '${widget.formData.zeitBis!.hour.toString().padLeft(2, '0')}:${widget.formData.zeitBis!.minute.toString().padLeft(2, '0')}',

        // Wiederkehrend
        'wiederkehrend': widget.formData.wiederkehrend,
        if (widget.formData.wiederkehrend) ...{
          if (widget.formData.intervall != null)
            'intervall': widget.formData.intervall,
          if (widget.formData.wochentag != null)
            'wochentag': widget.formData.wochentag,
          if (widget.formData.anzahlWiederholungen != null)
            'anzahl_wiederholungen': widget.formData.anzahlWiederholungen,
          if (widget.formData.wiederholenBis != null)
            'wiederholen_bis': widget.formData.wiederholenBis!
                .toIso8601String()
                .substring(0, 10),
        },
      };

      await supabase.from('auftraege').insert(auftragMap);

      // 🔎 Analytics: direkt nach erfolgreichem Insert
      try {
        final cat = widget.formData.kategorie ?? 'unknown';
        final city = _cityFromAddress(widget.formData.adresse);
        await AnalyticsService.I.jobCreated(category: cat, city: city);
      } catch (_) {}

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.auftragGespeichert)));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const KundenDashboardScreen()),
        (route) => false,
      );
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        )!.unbekannterFehler(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildReviewItem(
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.7),
          ),
          const SizedBox(height: 2),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            decoration: BoxDecoration(
              color: highlight ? Colors.yellow[50] : Colors.grey[100],
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(value, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  String getValue(dynamic value) =>
      (value == null || value == '') ? '-' : value.toString();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.auftragReviewAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AuftragReviewScreen.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AuftragReviewScreen.primaryColor,
              AuftragReviewScreen.accentColor,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Card(
                color: Colors.white.withOpacity(0.97),
                elevation: 8,
                shadowColor: AuftragReviewScreen.primaryColor.withOpacity(0.13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fact_check_rounded,
                        size: 48,
                        color: AuftragReviewScreen.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.auftragReviewHeadline,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.auftragReviewInfo,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 22),

                      _buildReviewItem(
                        l10n.kategorieLabel,
                        getValue(widget.formData.kategorie),
                      ),
                      _buildReviewItem(
                        l10n.titelLabel,
                        getValue(widget.formData.titel),
                      ),
                      _buildReviewItem(
                        l10n.beschreibungLabel,
                        getValue(widget.formData.beschreibung),
                      ),
                      _buildReviewItem(
                        l10n.adresseLabel,
                        getValue(widget.formData.adresse),
                      ),
                      _buildReviewItem(
                        l10n.telefonnummerLabel,
                        getValue(widget.formData.telefon),
                      ),
                      _buildReviewItem(
                        l10n.preisLabel,
                        widget.formData.preis == null
                            ? (widget.formData.preisTyp == 'verhandelbar'
                                  ? l10n.verhandelbarLabel
                                  : '-')
                            : '${widget.formData.preis!.toStringAsFixed(2)} €',
                      ),
                      _buildReviewItem(
                        l10n.ausfuehrungszeitpunkt,
                        widget.formData.soSchnellWieMoeglich
                            ? l10n.soSchnellWieMoeglich
                            : l10n.geplant,
                      ),
                      if (!widget.formData.soSchnellWieMoeglich &&
                          widget.formData.terminDatum != null)
                        _buildReviewItem(
                          l10n.terminLabel,
                          '${widget.formData.terminDatum!.day.toString().padLeft(2, '0')}.${widget.formData.terminDatum!.month.toString().padLeft(2, '0')}.${widget.formData.terminDatum!.year}',
                        ),
                      if (!widget.formData.soSchnellWieMoeglich &&
                          widget.formData.zeitVon != null)
                        _buildReviewItem(
                          l10n.zeitVon,
                          '${widget.formData.zeitVon!.hour.toString().padLeft(2, '0')}:${widget.formData.zeitVon!.minute.toString().padLeft(2, '0')}',
                        ),
                      if (!widget.formData.soSchnellWieMoeglich &&
                          widget.formData.zeitBis != null)
                        _buildReviewItem(
                          l10n.zeitBis,
                          '${widget.formData.zeitBis!.hour.toString().padLeft(2, '0')}:${widget.formData.zeitBis!.minute.toString().padLeft(2, '0')}',
                        ),
                      _buildReviewItem(
                        l10n.wiederkehrendCheckbox,
                        widget.formData.wiederkehrend ? l10n.ja : l10n.nein,
                      ),
                      if (widget.formData.wiederkehrend &&
                          widget.formData.intervall != null)
                        _buildReviewItem(
                          l10n.intervallLabel,
                          getValue(widget.formData.intervall),
                        ),
                      if (widget.formData.wiederkehrend &&
                          widget.formData.wochentag != null)
                        _buildReviewItem(
                          l10n.wochentagLabel,
                          getValue(widget.formData.wochentag),
                        ),
                      if (widget.formData.wiederkehrend &&
                          widget.formData.anzahlWiederholungen != null)
                        _buildReviewItem(
                          l10n.anzahlWiederholungenLabel,
                          getValue(widget.formData.anzahlWiederholungen),
                        ),
                      if (widget.formData.wiederkehrend &&
                          widget.formData.wiederholenBis != null)
                        _buildReviewItem(
                          l10n.wiederholenBisLabelPlain,
                          '${widget.formData.wiederholenBis!.day.toString().padLeft(2, '0')}.${widget.formData.wiederholenBis!.month.toString().padLeft(2, '0')}.${widget.formData.wiederholenBis!.year}',
                        ),

                      const SizedBox(height: 20),

                      if (_errorMessage != null) ...[
                        Text(
                          l10n.errorPrefix(_errorMessage!),
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                      ],

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: Text(l10n.zurueckButton),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    AuftragReviewScreen.primaryColor,
                                side: BorderSide(
                                  color: AuftragReviewScreen.primaryColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check_circle_rounded),
                                label: Text(l10n.absendenButton),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AuftragReviewScreen.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 4,
                                  shadowColor: AuftragReviewScreen.primaryColor
                                      .withOpacity(0.20),
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : _auftragAbschicken,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
