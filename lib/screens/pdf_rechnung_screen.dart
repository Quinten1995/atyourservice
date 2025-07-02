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

  // Jetzt mit Türkische Lira!
  final List<String> _waehrungen = ["€", "\$", "CHF", "£", "₺"];

  @override
  void dispose() {
    _preisController.dispose();
    super.dispose();
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
      final rechnungsNummer = auftragDetails['rechnung_nr'] ?? 'C01';
      final preis = double.tryParse(_preisController.text.replaceAll(',', '.')) ?? 0.0;

      if (preis <= 0) {
        setState(() {
          _error = l10n.amountRequired; // Füge den Key in die arb-Dateien ein
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
        waehrung: _waehrung, // <- Neue Übergabe an die PDF-Funktion!
        datum: widget.datum ?? DateTime.now(),
      );
      setState(() {
        _isLoading = false;
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
                          labelText: l10n.currencyLabel, // Füge "currencyLabel" in die arb-Dateien ein
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
