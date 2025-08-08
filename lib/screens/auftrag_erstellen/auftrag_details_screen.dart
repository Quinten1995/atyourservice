import 'package:flutter/material.dart';
import '../../models/auftrag_form_data.dart';
import '../../l10n/app_localizations.dart';
import 'auftrag_adresse_screen.dart';

class AuftragDetailsScreen extends StatefulWidget {
  final AuftragFormData formData;
  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  const AuftragDetailsScreen({Key? key, required this.formData}) : super(key: key);

  @override
  State<AuftragDetailsScreen> createState() => _AuftragDetailsScreenState();
}

class _AuftragDetailsScreenState extends State<AuftragDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titelController = TextEditingController(text: widget.formData.titel ?? '');
  late final _beschreibungController = TextEditingController(text: widget.formData.beschreibung ?? '');
  late final _preisController = TextEditingController(
    text: widget.formData.preis != null ? widget.formData.preis.toString() : ''
  );

  String _selectedPreisTyp = "gesamt"; // Default: Gesamtpreis

  @override
  void initState() {
    super.initState();
    if (widget.formData.preisTyp != null) {
      _selectedPreisTyp = widget.formData.preisTyp!;
    }
  }

  @override
  void dispose() {
    _titelController.dispose();
    _beschreibungController.dispose();
    _preisController.dispose();
    super.dispose();
  }

  Widget _buildPreisTypCard({
    required String preisTyp,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    final isSelected = _selectedPreisTyp == preisTyp;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPreisTyp = preisTyp;
          _preisController.text = '';
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AuftragDetailsScreen.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          // Dezent: Kein Schatten, keine intensive Farbe!
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AuftragDetailsScreen.primaryColor : Colors.grey[500], size: 28),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                      color: isSelected ? AuftragDetailsScreen.primaryColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: preisTyp,
              groupValue: _selectedPreisTyp,
              onChanged: (val) {
                setState(() {
                  _selectedPreisTyp = val!;
                  _preisController.text = '';
                });
              },
              activeColor: AuftragDetailsScreen.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auftragDetailsAppBar, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AuftragDetailsScreen.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AuftragDetailsScreen.accentColor,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Card(
                color: Colors.white,
                elevation: 7,
                shadowColor: AuftragDetailsScreen.primaryColor.withOpacity(0.09),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.edit_note_rounded, size: 48, color: AuftragDetailsScreen.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          l10n.auftragDetailsHeadline,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.auftragDetailsInfo,
                          style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 26),
                        TextFormField(
                          controller: _titelController,
                          decoration: InputDecoration(
                            labelText: l10n.titelLabel,
                            hintText: l10n.titelHint,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: AuftragDetailsScreen.primaryColor, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return l10n.titelValidator;
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _beschreibungController,
                          decoration: InputDecoration(
                            labelText: l10n.beschreibungLabel,
                            hintText: l10n.beschreibungHint,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: AuftragDetailsScreen.primaryColor, width: 2),
                            ),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          l10n.preisTypLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        _buildPreisTypCard(
                          preisTyp: "gesamt",
                          title: l10n.preisTypGesamt,
                          description: l10n.preisTypGesamtDesc,
                          icon: Icons.attach_money_rounded,
                          color: AuftragDetailsScreen.primaryColor,
                          context: context,
                        ),
                        _buildPreisTypCard(
                          preisTyp: "stunden",
                          title: l10n.preisTypStunden,
                          description: l10n.preisTypStundenDesc,
                          icon: Icons.timer_rounded,
                          color: AuftragDetailsScreen.primaryColor,
                          context: context,
                        ),
                        _buildPreisTypCard(
                          preisTyp: "verhandelbar",
                          title: l10n.preisTypVerhandelbar,
                          description: l10n.preisTypVerhandelbarDesc,
                          icon: Icons.handshake_rounded,
                          color: AuftragDetailsScreen.primaryColor,
                          context: context,
                        ),
                        if (_selectedPreisTyp != "verhandelbar") ...[
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _preisController,
                            decoration: InputDecoration(
                              labelText: _selectedPreisTyp == "gesamt"
                                  ? l10n.preisLabelGesamt
                                  : l10n.preisLabelStunden,
                              hintText: _selectedPreisTyp == "gesamt"
                                  ? l10n.preisHintGesamt
                                  : l10n.preisHintStunden,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: AuftragDetailsScreen.primaryColor, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (_selectedPreisTyp == "verhandelbar") return null;
                              if (value == null || value.isEmpty) return l10n.preisValidator;
                              if (double.tryParse(value.replaceAll(',', '.')) == null) {
                                return l10n.preisValidator;
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              l10n.preisHinweisVerhandelbar,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 26),
                        // ---- Buttons: Gleich groß, klar abgegrenzt ----
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: Text(l10n.zurueckButton),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AuftragDetailsScreen.primaryColor,
                                    side: BorderSide(color: AuftragDetailsScreen.primaryColor, width: 1.7),
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
                                    backgroundColor: AuftragDetailsScreen.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                    shadowColor: AuftragDetailsScreen.primaryColor.withOpacity(0.20),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      widget.formData.titel = _titelController.text.trim();
                                      widget.formData.beschreibung = _beschreibungController.text.trim();
                                      widget.formData.preisTyp = _selectedPreisTyp;

                                      final preisText = _preisController.text.trim();
                                      if (_selectedPreisTyp == "gesamt" || _selectedPreisTyp == "stunden") {
                                        widget.formData.preis = double.tryParse(preisText.replaceAll(',', '.'));
                                      } else {
                                        widget.formData.preis = null;
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AuftragAdresseScreen(formData: widget.formData),
                                        ),
                                      );
                                    }
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
