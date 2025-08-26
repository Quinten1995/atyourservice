import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:printing/printing.dart';
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
  String? _rechnungNummer;

  final List<String> _waehrungen = ["€", "\$", "CHF", "£", "₺"];

  double _round2(double v) => (v * 100).round() / 100.0;

  static const Map<String, String> _currencyIsoBySymbol = {
    "€": "EUR",
    "\$": "USD",
    "CHF": "CHF",
    "£": "GBP",
    "₺": "TRY",
  };

  @override
  void dispose() {
    _preisController.dispose();
    super.dispose();
  }

  Future<String> _holeOderErzeugeRechnungsnummer() async {
    final supabase = Supabase.instance.client;
    final res = await supabase.rpc('next_invoice_number', params: {'_dl': widget.dienstleisterId});
    final nummer = (res as String?)?.trim();
    if (nummer == null || nummer.isEmpty) {
      throw Exception('Konnte keine Rechnungsnummer erzeugen.');
    }
    return nummer!;
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final sb = Supabase.instance.client;

      // -------- Daten holen --------
      final dlDetails = await sb
          .from('dienstleister_details')
          .select('''
            name,
            invoice_name,
            adresse,
            invoice_address,
            invoice_tax_number,
            invoice_iban,
            invoice_bic,
            invoice_logo_url,
            profilbild_url,
            is_small_business,
            default_vat_rate,
            company_name,
            ust_id
          ''')
          .eq('user_id', widget.dienstleisterId)
          .maybeSingle();

      final kundenDetails = await sb
          .from('users')
          .select('full_name, adresse, email')
          .eq('id', widget.kundeId)
          .maybeSingle();

      final auftragDetails = await sb
          .from('auftraege')
          .select('id')
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

      // -------- Rechnungsnummer --------
      final rechnungsNummer = await _holeOderErzeugeRechnungsnummer();

      // -------- Betrag (Brutto) --------
      final grossInput = double.tryParse(_preisController.text.replaceAll(',', '.')) ?? 0.0;
      if (grossInput <= 0) {
        setState(() {
          _error = l10n.amountRequired;
          _isLoading = false;
        });
        return;
      }

      // -------- VAT / Zahlungsziel --------
      final isSmallBiz = (dlDetails['is_small_business'] as bool?) == true;
      final vatRate = isSmallBiz ? 0.0 : ((dlDetails['default_vat_rate'] as num?)?.toDouble() ?? 19.0);

      const int dueDaysDefault = 14;
      // l10n-Default (keine DB-Spalte mehr abgefragt)
      final String paymentTerms = l10n.paymentTermsDefault(dueDaysDefault.toString());

      // Beträge
      double net = grossInput;
      double vat = 0.0;
      double gross = grossInput;
      if (!isSmallBiz && vatRate > 0) {
        net = _round2(grossInput / (1 + vatRate / 100));
        vat = _round2(grossInput - net);
      }

      final currencyCode = _currencyIsoBySymbol[_waehrung] ?? 'EUR';

      // Datum
      final issuedAt = DateTime.now();
      final serviceDate = widget.datum ?? issuedAt;
      final dueDate = issuedAt.add(const Duration(days: dueDaysDefault));

      // -------- Denormalisierte Namen/Adressen --------
      final supplierName = (() {
        final invName = (dlDetails['invoice_name'] as String?)?.trim();
        if (invName != null && invName.isNotEmpty) return invName;
        return (dlDetails['name'] as String?)?.trim() ?? '';
      })();

      final supplierAddress = (dlDetails['invoice_address'] as String?)?.trim().isNotEmpty == true
          ? (dlDetails['invoice_address'] as String).trim()
          : ((dlDetails['adresse'] as String?)?.trim() ?? '');

      final dlLogoUrl = (dlDetails['invoice_logo_url'] as String?)?.trim().isNotEmpty == true
          ? (dlDetails['invoice_logo_url'] as String).trim()
          : (dlDetails['profilbild_url'] as String? ?? '');

      // Kunde: full_name -> email
      String kundeName = (kundenDetails['full_name'] as String?)?.trim() ?? '';
      if (kundeName.isEmpty) {
        kundeName = (kundenDetails['email'] as String?)?.trim() ?? '';
      }
      final kundeAddress = (kundenDetails['adresse'] as String?)?.trim().isNotEmpty == true
          ? (kundenDetails['adresse'] as String).trim()
          : (widget.adresse ?? '');

      final taxNote = isSmallBiz
          ? 'Kein Ausweis von Umsatzsteuer, da Kleinunternehmer gem. § 19 UStG.'
          : null;

      // -------- 1) Rechnung in DB --------
      final inserted = await sb
          .from('rechnungen')
          .insert({
            'auftrag_id': widget.auftragId,
            'dienstleister_id': widget.dienstleisterId,
            'kunde_id': widget.kundeId,
            'nummer': rechnungsNummer,
            'issued_at': issuedAt.toIso8601String(),
            'service_from': serviceDate.toIso8601String().substring(0, 10),
            'service_to': serviceDate.toIso8601String().substring(0, 10),

            'currency_code': currencyCode,
            'net_amount': net,
            'vat_rate': vatRate,
            'vat_amount': vat,
            'gross_amount': gross,
            'is_small_business': isSmallBiz,
            'tax_note': taxNote,

            'supplier_name': supplierName,
            'supplier_address': supplierAddress,
            'customer_name': kundeName,
            'customer_address': kundeAddress,

            'payment_terms': paymentTerms,
            'due_date': dueDate.toIso8601String().substring(0, 10),

            // Abwärtskompatibel
            'betrag': gross,
            'waehrung': _waehrung,
            'beschreibung': widget.beschreibung,
          })
          .select('id')
          .single();

      final rechnungId = inserted['id'] as String;

      // -------- 2) PDF erzeugen + speichern --------
      final saveResult = await generateAndSaveInvoice(
        rechnungLabel: l10n.invoiceLabel,
        invoiceNumber: rechnungsNummer,
        invoiceNoShortLabel: l10n.invoiceNoShort,
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

        // Summen/Zahlung Labels
        netAmountLabel: l10n.netAmountLabel,
        vatLabelFormatted: l10n.vatLabelWithPercent(vatRate.toStringAsFixed(0)),
        totalLabel: l10n.totalLabel,
        dueOnLabel: l10n.dueOnLabel,
        vatIdLabel: l10n.vatIdLabel,
        bicLabel: l10n.bicLabel,

        // DL
        dlName: supplierName,
        dlAddress: dlDetails['adresse'] as String? ?? "",
        dlInvoiceAddress: supplierAddress,
        dlTaxNumber: dlDetails['invoice_tax_number'] as String? ?? "",
        dlIban: dlDetails['invoice_iban'] as String? ?? "",
        dlLogoUrl: dlLogoUrl,
        dlBic: dlDetails['invoice_bic'] as String?,
        dlCompanyName: dlDetails['company_name'] as String?,
        dlUstId: dlDetails['ust_id'] as String?,

        // Kunde
        kundeName: kundeName,
        kundeAddress: kundeAddress,

        // Basis
        auftragsBeschreibung: widget.beschreibung,
        preis: gross,
        waehrung: _waehrung,
        datum: issuedAt,

        // MwSt & Zahlung
        currencyCode: currencyCode,
        isSmallBusiness: isSmallBiz,
        vatRate: vatRate,
        netAmount: net,
        vatAmount: vat,
        grossAmount: gross,
        taxNote: taxNote,
        paymentTerms: paymentTerms,
        dueDate: dueDate,

        // Storage
        rechnungId: rechnungId,
      );

      final pdfUrl = (saveResult['url'] as String?) ?? '';
      final pdfSha = (saveResult['sha256'] as String?) ?? '';
      final pdfBytesLocal = saveResult['bytes'] as Uint8List;

      // -------- 3) URL/SHA updaten --------
      await sb.from('rechnungen').update({
        if (pdfUrl.isNotEmpty) 'pdf_url': pdfUrl,
        if (pdfSha.isNotEmpty) 'pdf_sha256': pdfSha,
      }).eq('id', rechnungId);

      // Auftrag spiegeln (optional)
      await sb.from('auftraege').update({'rechnung_nr': rechnungsNummer}).eq('id', widget.auftragId);

      // -------- 4) PDF anzeigen --------
      try {
        if (pdfUrl.isNotEmpty) {
          final filePath = 'invoices/$rechnungId.pdf';
          final bytesFromStorage = await sb.storage.from('rechnungen_pdfs').download(filePath);
          await Printing.layoutPdf(onLayout: (_) async => bytesFromStorage);
        } else {
          await Printing.layoutPdf(onLayout: (_) async => pdfBytesLocal);
        }
      } catch (_) {
        await Printing.layoutPdf(onLayout: (_) async => pdfBytesLocal);
      }

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
                    // Hinweisblock
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

                    // Betrag
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                      child: TextField(
                        controller: _preisController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: '${l10n.amountLabel} (Brutto)',
                          border: const OutlineInputBorder(),
                          hintText: 'z.B. 119,00',
                        ),
                      ),
                    ),

                    // Währung
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

                    // Button
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
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
