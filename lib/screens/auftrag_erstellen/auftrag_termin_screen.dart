import 'package:flutter/material.dart';
import '../../models/auftrag_form_data.dart';
import '../../l10n/app_localizations.dart';
import 'auftrag_wiederkehrend_screen.dart';

class AuftragTerminScreen extends StatefulWidget {
  final AuftragFormData formData;
  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  const AuftragTerminScreen({Key? key, required this.formData})
    : super(key: key);

  @override
  State<AuftragTerminScreen> createState() => _AuftragTerminScreenState();
}

class _AuftragTerminScreenState extends State<AuftragTerminScreen> {
  bool soSchnellWieMoeglich = true;
  DateTime? terminDatum;
  TimeOfDay? zeitVon;
  TimeOfDay? zeitBis;

  @override
  void initState() {
    super.initState();
    soSchnellWieMoeglich = widget.formData.soSchnellWieMoeglich;
    terminDatum = widget.formData.terminDatum;
    zeitVon = widget.formData.zeitVon;
    zeitBis = widget.formData.zeitBis;
  }

  String _formatTimeOfDay(TimeOfDay? tod) {
    if (tod == null) return "--:--";
    return '${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}';
  }

  Future<DateTime?> _pickDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: terminDatum ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AuftragTerminScreen.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, {TimeOfDay? initial}) {
    return showTimePicker(
      context: context,
      initialTime: initial ?? const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AuftragTerminScreen.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AbsorbPointer(
          child: TextFormField(
            enabled: enabled,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              hintText: label,
              suffixIcon: Icon(
                icon,
                color: enabled ? AuftragTerminScreen.primaryColor : Colors.grey,
              ),
              filled: true,
              fillColor: enabled ? Colors.white : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 14,
              ),
            ),
            controller: TextEditingController(text: value),
            style: TextStyle(
              color: enabled ? Colors.black87 : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 15.2,
            ),
          ),
        ),
      ),
    );
  }

  void _onNextPressed(AppLocalizations l10n) {
    if (!soSchnellWieMoeglich) {
      if (terminDatum == null || zeitVon == null || zeitBis == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.terminValidierungFehler ??
                  "Bitte wähle ein Datum und beide Uhrzeiten aus.",
            ),
            backgroundColor: Colors.red[600],
          ),
        );
        return;
      }
    }
    widget.formData.soSchnellWieMoeglich = soSchnellWieMoeglich;
    widget.formData.terminDatum = terminDatum;
    widget.formData.zeitVon = zeitVon;
    widget.formData.zeitBis = zeitBis;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AuftragWiederkehrendScreen(formData: widget.formData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.auftragTerminAppBar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AuftragTerminScreen.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AuftragTerminScreen.primaryColor,
              AuftragTerminScreen.accentColor,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Card(
                color: Colors.white.withOpacity(0.98),
                elevation: 8,
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
                      const SizedBox(height: 2),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 48,
                        color: AuftragTerminScreen.primaryColor,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.auftragTerminHeadline,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.auftragTerminInfo,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const SizedBox(height: 10),
                      Text(
                        l10n.ausfuehrungszeitpunkt,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 9),

                      // ChoiceChips jetzt mit Wrap statt Row, verhindert Overflow
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(l10n.soSchnellWieMoeglich),
                            selected: soSchnellWieMoeglich,
                            onSelected: (selected) {
                              setState(() {
                                soSchnellWieMoeglich = true;
                                terminDatum = null;
                                zeitVon = null;
                                zeitBis = null;
                              });
                            },
                            selectedColor: AuftragTerminScreen.primaryColor
                                .withOpacity(0.14),
                            backgroundColor: Colors.grey[100],
                            labelStyle: TextStyle(
                              color: soSchnellWieMoeglich
                                  ? AuftragTerminScreen.primaryColor
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: soSchnellWieMoeglich
                                    ? AuftragTerminScreen.primaryColor
                                          .withOpacity(0.28)
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          ChoiceChip(
                            label: Text(l10n.geplant),
                            selected: !soSchnellWieMoeglich,
                            onSelected: (selected) {
                              setState(() {
                                soSchnellWieMoeglich = false;
                              });
                            },
                            selectedColor: AuftragTerminScreen.primaryColor
                                .withOpacity(0.14),
                            backgroundColor: Colors.grey[100],
                            labelStyle: TextStyle(
                              color: !soSchnellWieMoeglich
                                  ? AuftragTerminScreen.primaryColor
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: !soSchnellWieMoeglich
                                    ? AuftragTerminScreen.primaryColor
                                          .withOpacity(0.28)
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ],
                      ),

                      if (!soSchnellWieMoeglich) ...[
                        const SizedBox(height: 20),
                        _buildDateTimeField(
                          label: l10n.datumWaehlen,
                          value: terminDatum == null
                              ? ""
                              : '${terminDatum!.day.toString().padLeft(2, '0')}.${terminDatum!.month.toString().padLeft(2, '0')}.${terminDatum!.year}',
                          icon: Icons.calendar_today,
                          onTap: () async {
                            final picked = await _pickDate(context);
                            if (picked != null)
                              setState(() => terminDatum = picked);
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateTimeField(
                                label: l10n.zeitVon,
                                value: zeitVon == null
                                    ? ""
                                    : _formatTimeOfDay(zeitVon),
                                icon: Icons.access_time,
                                onTap: () async {
                                  final picked = await _pickTime(
                                    context,
                                    initial: zeitVon,
                                  );
                                  if (picked != null)
                                    setState(() => zeitVon = picked);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateTimeField(
                                label: l10n.zeitBis,
                                value: zeitBis == null
                                    ? ""
                                    : _formatTimeOfDay(zeitBis),
                                icon: Icons.access_time,
                                onTap: () async {
                                  final picked = await _pickTime(
                                    context,
                                    initial: zeitBis,
                                  );
                                  if (picked != null)
                                    setState(() => zeitBis = picked);
                                },
                              ),
                            ),
                          ],
                        ),
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
                                  foregroundColor:
                                      AuftragTerminScreen.primaryColor,
                                  side: BorderSide(
                                    color: AuftragTerminScreen.primaryColor,
                                    width: 1.5,
                                  ),
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
                                  backgroundColor:
                                      AuftragTerminScreen.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 4,
                                  shadowColor: AuftragTerminScreen.primaryColor
                                      .withOpacity(0.20),
                                ),
                                onPressed: () => _onNextPressed(l10n),
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
