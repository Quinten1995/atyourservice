import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/pdf_invoice_service.dart';
import '../l10n/app_localizations.dart';

class PdfRechnungScreen extends StatefulWidget {
  final String auftragId;
  final String dienstleisterId;
  final String kundeId;
  final String beschreibung;
  final String? adresse;
  final DateTime? datum;

  const PdfRechnungScreen({
    Key? key,
    required this.auftragId,
    required this.dienstleisterId,
    required this.kundeId,
    required this.beschreibung,
    required this.adresse,
    required this.datum,
  }) : super(key: key);

  @override
  State<PdfRechnungScreen> createState() => _PdfRechnungScreenState();
}

class _PdfRechnungScreenState extends State<PdfRechnungScreen> {
  bool _isLoading = false;
  String? _error;
  final _preisController = TextEditingController();
  String _waehrung = "€";
  String? _rechnungNummer; // <-- Neu

  final List<String> _waehrungen = ["€", "\$", "CHF", "£", "₺"];

  @override
  void dispose() {
    _preisController.dispose();
    super.dispose();
  }

  // Holt oder generiert eine neue Rechnungsnummer nach dem Muster "DL-2024-00023"
  Future<String> _holeOderErzeugeRechnungsnummer() async {
    final supabase = Supabase.instance.client;

    // 1. Gibt es schon eine Rechnungsnummer für diesen Auftrag?
    final auftrag = await supabase
        .from('auftraege')
        .select('rechnung_nr')
        .eq('id', widget.auftragId)
        .maybeSingle();

    if (auftrag != null && auftrag['rechnung_nr'] != null && auftrag['rechnung_nr'] != "") {
      return auftrag['rechnung_nr'] as String;
    }

    // 2. Hole die höchste bisherige Rechnungsnummer für diesen Dienstleister im aktuellen Jahr
    final jetzt = DateTime.now();
    final jahr = jetzt.year;
    final letzteRechnung = await supabase
        .from('rechnungen')
        .select('nummer')
        .eq('dienstleister_id', widget.dienstleisterId)
        .ilike('nummer', '%-$jahr-%') // Nur dieses Jahr
        .order('erstellt_am', ascending: false)
        .limit(1)
        .maybeSingle();

    int neueNummer = 1;
    if (letzteRechnung != null && letzteRechnung['nummer'] != null) {
      final matches = RegExp(r'(\d+)$').firstMatch(letzteRechnung['nummer']);
      if (matches != null) {
        neueNummer = int.parse(matches.group(1)!) + 1;
      }
    }

    // Rechnungsnummer zusammensetzen (z.B. DL-2024-00001, DL = Dienstleister-Id Prefix)
    final rechnungsNummer = "${widget.dienstleisterId.substring(0, 2).toUpperCase()}-$jahr-${neueNummer.toString().padLeft(5, '0')}";

    // 3. Speichere neue Rechnungsnummer in Tabelle "rechnungen" und auch im Auftrag
    await supabase.from('rechnungen').insert({
      'auftrag_id': widget.auftragId,
      'dienstleister_id': widget.dienstleisterId,
      'nummer': rechnungsNummer,
      'erstellt_am': jetzt.toIso8601String(),
    });
    await supabase.from('auftraege').update({'rechnung_nr': rechnungsNummer}).eq('id', widget.auftragId);

    return rechnungsNummer;
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final supabase = Supabase.instance.client;
      final dlDetails = await supabase
          .from('dienstleister_details')
          .select()
          .eq('user_id', widget.dienstleisterId)
          .maybeSingle();

      final kundenDetails = await supabase
          .from('users')
          .select()
          .eq('id', widget.kundeId)
          .maybeSingle();

      final auftragDetails = await supabase
          .from('auftraege')
          .select()
          .eq('id', widget.auftragId)
          .maybeSingle();

      if (dlDetails == null || kundenDetails == null || auftragDetails == null) {
        setState(() {
          _error = "Daten fehlen für die Rechnung.";
          _isLoading = false;
        });
        return;
      }

      final l10n = AppLocalizations.of(context)!;
      // 1. Rechnungsnummer holen oder generieren
      final rechnungsNummer = await _holeOderErzeugeRechnungsnummer();

      final preis = double.tryParse(_preisController.text.replaceAll(',', '.')) ?? 0.0;

      if (preis <= 0) {
        setState(() {
          _error = l10n.amountRequired;
          _isLoading = false;
        });
        return;
      }

      await generateAndPrintInvoice(
        rechnungLabel: l10n.invoiceLabel,
        invoiceNumber: rechnungsNummer,
        vonLabel: l10n.fromLabel,
        invoiceAddressLabel: l10n.invoiceAddressLabel,
        taxNumberLabel: l10n.taxNumberLabel,
        ibanLabel: l10n.ibanLabel,
        fuerLabel: l10n.toLabel,
        descriptionLabel: l10n.descriptionLabel,
        betragLabel: l10n.amountLabel,
        datumLabel: l10n.dateLabel,
        generatedByText: l10n.generatedByText,
        websiteUrlText: 'https://atyourservice.app',
        dlName: dlDetails['name'] as String? ?? "",
        dlAddress: dlDetails['adresse'] as String? ?? "",
        dlInvoiceAddress: dlDetails['invoice_address'] as String? ?? "",
        dlTaxNumber: dlDetails['invoice_tax_number'] as String? ?? "",
        dlIban: dlDetails['invoice_iban'] as String? ?? "",
        dlLogoUrl: dlDetails['profilbild_url'] as String? ?? "",
        kundeName: kundenDetails['email'] as String? ?? "",
        kundeAddress: widget.adresse ?? "",
        auftragsBeschreibung: widget.beschreibung,
        preis: preis,
        waehrung: _waehrung,
        datum: widget.datum ?? DateTime.now(),
      );
      setState(() {
        _isLoading = false;
        _rechnungNummer = rechnungsNummer;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rechnungGenerierenAppBar),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hinweis für Rechnungsdaten im Profil
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber, width: 1.2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber[900], size: 23),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.invoiceProfileHint,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                      child: TextField(
                        controller: _preisController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: l10n.amountLabel,
                          border: const OutlineInputBorder(),
                          hintText: 'z.B. 49,99',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: DropdownButtonFormField<String>(
                        value: _waehrung,
                        decoration: InputDecoration(
                          labelText: l10n.currencyLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: _waehrungen
                            .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _waehrung = value);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: Text(l10n.rechnungAlsPdfAnzeigenLabel),
                      onPressed: _generatePdf,
                    ),
                    if (_rechnungNummer != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        "${l10n.invoiceNumberLabel}: $_rechnungNummer",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ]
                  ],
                ),
              ),
      ),
    );
  }
}
