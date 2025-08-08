import 'package:flutter/material.dart';
import '../../models/auftrag_form_data.dart';
import '../../l10n/app_localizations.dart';
import 'auftrag_review_screen.dart';

class AuftragWiederkehrendScreen extends StatefulWidget {
  final AuftragFormData formData;
  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  const AuftragWiederkehrendScreen({Key? key, required this.formData}) : super(key: key);

  @override
  State<AuftragWiederkehrendScreen> createState() => _AuftragWiederkehrendScreenState();
}

class _AuftragWiederkehrendScreenState extends State<AuftragWiederkehrendScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _wiederkehrend = false;
  String? _intervall;
  String? _wochentag;
  int? _anzahlWiederholungen;
  DateTime? _wiederholenBis;
  String? _errorMessage;

  final List<String> intervalKeys = [
    'interval_weekly',
    'interval_biweekly',
    'interval_monthly',
  ];
  final List<String> weekdayKeys = [
    'weekday_monday',
    'weekday_tuesday',
    'weekday_wednesday',
    'weekday_thursday',
    'weekday_friday',
    'weekday_saturday',
    'weekday_sunday',
  ];

  String getIntervalLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'interval_weekly':
        return l10n.interval_weekly;
      case 'interval_biweekly':
        return l10n.interval_biweekly;
      case 'interval_monthly':
        return l10n.interval_monthly;
      default:
        return key;
    }
  }

  String getWeekdayLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'weekday_monday':
        return l10n.weekday_monday;
      case 'weekday_tuesday':
        return l10n.weekday_tuesday;
      case 'weekday_wednesday':
        return l10n.weekday_wednesday;
      case 'weekday_thursday':
        return l10n.weekday_thursday;
      case 'weekday_friday':
        return l10n.weekday_friday;
      case 'weekday_saturday':
        return l10n.weekday_saturday;
      case 'weekday_sunday':
        return l10n.weekday_sunday;
      default:
        return key;
    }
  }

  @override
  void initState() {
    super.initState();
    _wiederkehrend = widget.formData.wiederkehrend;
    _intervall = widget.formData.intervall;
    _wochentag = widget.formData.wochentag;
    _anzahlWiederholungen = widget.formData.anzahlWiederholungen;
    _wiederholenBis = widget.formData.wiederholenBis;
  }

  bool _validateWiederkehrend(AppLocalizations l10n) {
    if (_wiederkehrend) {
      if (_intervall == null || _wochentag == null || _anzahlWiederholungen == null || _anzahlWiederholungen! < 1) {
        setState(() {
          _errorMessage = l10n.wiederkehrendValidierungFehler;
        });
        return false;
      }
    }
    setState(() {
      _errorMessage = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auftragWiederkehrendAppBar, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AuftragWiederkehrendScreen.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AuftragWiederkehrendScreen.primaryColor, AuftragWiederkehrendScreen.accentColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Card(
                color: Colors.white.withOpacity(0.96),
                elevation: 8,
                shadowColor: AuftragWiederkehrendScreen.primaryColor.withOpacity(0.12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.repeat_rounded, size: 48, color: AuftragWiederkehrendScreen.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          l10n.auftragWiederkehrendHeadline,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.auftragWiederkehrendInfo,
                          style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 22),
                        CheckboxListTile(
                          value: _wiederkehrend,
                          onChanged: (val) {
                            setState(() {
                              _wiederkehrend = val ?? false;
                            });
                          },
                          title: Text(l10n.wiederkehrendCheckbox),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        if (_wiederkehrend) ...[
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _intervall,
                            decoration: InputDecoration(
                              labelText: l10n.intervallLabel,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            items: intervalKeys
                                .map((key) => DropdownMenuItem(value: key, child: Text(getIntervalLabel(key, l10n))))
                                .toList(),
                            onChanged: (val) => setState(() => _intervall = val),
                            validator: (val) => val == null ? l10n.intervallValidator : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _wochentag,
                            decoration: InputDecoration(
                              labelText: l10n.wochentagLabel,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            items: weekdayKeys
                                .map((key) => DropdownMenuItem(value: key, child: Text(getWeekdayLabel(key, l10n))))
                                .toList(),
                            onChanged: (val) => setState(() => _wochentag = val),
                            validator: (val) => val == null ? l10n.wochentagValidator : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(labelText: l10n.anzahlWiederholungenLabel),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                _anzahlWiederholungen = int.tryParse(val);
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(_wiederholenBis == null
                                    ? l10n.wiederholenBisNichtGesetzt
                                    : l10n.wiederholenBisLabel(_wiederholenBis!.toLocal().toString().split(' ')[0])),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _wiederholenBis ?? DateTime.now().add(const Duration(days: 30)),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (picked != null) setState(() => _wiederholenBis = picked);
                                },
                              ),
                            ],
                          ),
                        ],
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                        ],
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: Text(l10n.zurueckButton),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AuftragWiederkehrendScreen.primaryColor,
                                    side: BorderSide(color: AuftragWiederkehrendScreen.primaryColor, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.navigate_next_rounded),
                                  label: Text(l10n.weiterButton),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AuftragWiederkehrendScreen.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                    shadowColor: AuftragWiederkehrendScreen.primaryColor.withOpacity(0.20),
                                  ),
                                  onPressed: () {
                                    // Validate & update FormData
                                    if (!_validateWiederkehrend(l10n)) return;
                                    widget.formData.wiederkehrend = _wiederkehrend;
                                    widget.formData.intervall = _intervall;
                                    widget.formData.wochentag = _wochentag;
                                    widget.formData.anzahlWiederholungen = _anzahlWiederholungen;
                                    widget.formData.wiederholenBis = _wiederholenBis;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AuftragReviewScreen(formData: widget.formData),
                                      ),
                                    );
                                  },
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
      ),
    );
  }
}
