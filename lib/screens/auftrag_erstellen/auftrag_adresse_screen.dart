import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/auftrag_form_data.dart';
import '../../../l10n/app_localizations.dart';
import 'auftrag_termin_screen.dart';

class AuftragAdresseScreen extends StatefulWidget {
  final AuftragFormData formData;
  static const Color primaryColor = Color(0xFF3876BF);
  static const Color accentColor = Color(0xFFE7ECEF);

  const AuftragAdresseScreen({Key? key, required this.formData}) : super(key: key);

  @override
  State<AuftragAdresseScreen> createState() => _AuftragAdresseScreenState();
}

class _AuftragAdresseScreenState extends State<AuftragAdresseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _adresseController = TextEditingController(text: widget.formData.adresse ?? '');
  late final _telefonController = TextEditingController(text: widget.formData.telefon ?? '');

  String? _heimatAdresse;

  @override
  void initState() {
    super.initState();
    _ladeHeimatadresse();
  }

  // Holt die Heimatadresse für den eingeloggten User aus Supabase
  Future<void> _ladeHeimatadresse() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final res = await supabase
        .from('users')
        .select('adresse')
        .eq('id', user.id)
        .maybeSingle();
    setState(() {
      _heimatAdresse = res?['adresse'] ?? '';
    });
  }

  @override
  void dispose() {
    _adresseController.dispose();
    _telefonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auftragAdresseAppBar, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AuftragAdresseScreen.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AuftragAdresseScreen.primaryColor, AuftragAdresseScreen.accentColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Card(
                color: Colors.white.withOpacity(0.96),
                elevation: 8,
                shadowColor: AuftragAdresseScreen.primaryColor.withOpacity(0.12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 48, color: AuftragAdresseScreen.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          l10n.auftragAdresseHeadline,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.auftragAdresseInfo,
                          style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 26),
                        // Heimatadresse einfügen-Button + Infotext (L10N)
                        if (_heimatAdresse != null && _heimatAdresse!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.home, color: AuftragAdresseScreen.primaryColor, size: 30),
                                    label: Text(
                                      l10n.heimatadresseEinfuegen,
                                      style: const TextStyle(
                                        color: AuftragAdresseScreen.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.5,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _adresseController.text = _heimatAdresse!;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.heimatadresseButtonInfo,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.grey[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        TextFormField(
                          controller: _adresseController,
                          decoration: InputDecoration(
                            labelText: l10n.adresseLabel,
                            hintText: l10n.adresseHint,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: AuftragAdresseScreen.primaryColor, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.adresseValidator;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _telefonController,
                          decoration: InputDecoration(
                            labelText: l10n.telefonnummerLabel,
                            hintText: l10n.telefonnummerHint,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: AuftragAdresseScreen.primaryColor, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.telefonnummerValidator;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        // --- BUTTONS: Immer gleich groß, maximal breit ---
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: Text(l10n.zurueckButton),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AuftragAdresseScreen.primaryColor,
                                    side: BorderSide(color: AuftragAdresseScreen.primaryColor, width: 1.5),
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
                                    backgroundColor: AuftragAdresseScreen.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                    shadowColor: AuftragAdresseScreen.primaryColor.withOpacity(0.20),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      widget.formData.adresse = _adresseController.text.trim();
                                      widget.formData.telefon = _telefonController.text.trim();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AuftragTerminScreen(formData: widget.formData),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
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
