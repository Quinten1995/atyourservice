// lib/utils/pdf_invoice_service.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // für networkImage
import 'package:supabase_flutter/supabase_flutter.dart';

/// Baut das PDF und lädt es in den Storage-Bucket hoch.
/// Gibt Public-URL (falls Upload klappt), optional sha256 (leer) UND immer die lokalen Bytes zurück.
Future<Map<String, dynamic>> generateAndSaveInvoice({
  // ===== Meta / Labels (aus l10n) =====
  required String rechnungLabel,
  required String invoiceNumber,
  required String invoiceNoShortLabel,     // z.B. "Nr:" / "No:" / "N° :"
  required String vonLabel,
  required String invoiceAddressLabel,
  required String taxNumberLabel,
  required String ibanLabel,
  required String fuerLabel,
  required String descriptionLabel,
  required String betragLabel,
  required String datumLabel,
  required String generatedByText,
  required String websiteUrlText,

  // Summenblock / Zahlungsblock (aus l10n)
  required String netAmountLabel,          // "Netto" / "Net"
  required String vatLabelFormatted,       // schon formatiert z.B. "USt (19%)"
  required String totalLabel,              // "Gesamt" / "Total"
  required String dueOnLabel,              // "Fällig am:" / "Due on:"
  required String vatIdLabel,              // "USt-IdNr.:" / "VAT ID:"
  required String bicLabel,                // "BIC:" (lokalisiert)

  // ===== Absender (DL) =====
  required String dlName,
  required String dlAddress,
  String? dlInvoiceAddress,
  String? dlTaxNumber,
  String? dlIban,
  String? dlLogoUrl,

  // Optional erweiterte DL-Felder (nur angezeigt, wenn übergeben)
  String? dlBic,
  String? dlCompanyName,
  String? dlUstId,

  // ===== Empfänger (Kunde) =====
  required String kundeName,
  required String kundeAddress,

  // ===== Leistung / Betrag (brutto) =====
  required String auftragsBeschreibung,
  required double preis,      // Brutto (Legacy – wird als Fallback genutzt)
  required String waehrung,   // Symbol, z.B. "€"
  required DateTime datum,

  // ===== Optionale, neue Parameter für MwSt & Zahlungsinfo =====
  String? currencyCode,       // z.B. "EUR" (nur Anzeigezweck)
  bool? isSmallBusiness,      // §19 UStG → keine MwSt
  double? vatRate,            // z.B. 19.0
  double? netAmount,          // Netto-Betrag
  double? vatAmount,          // USt-Betrag
  double? grossAmount,        // Brutto-Betrag (falls != preis)
  String? taxNote,            // Hinweistext bei Kleinunternehmer
  String? paymentTerms,       // "Zahlbar innerhalb von ... Tagen ..."
  DateTime? dueDate,          // Fälligkeitsdatum

  // ===== Storage =====
  required String rechnungId, // für den Storage-Pfad
}) async {
  final pdf = pw.Document();

  // ---------- Helpers ----------
  String _fmtMoney(double v, {String? symbol}) {
    // einfache Währungsformatierung ohne intl
    final s = v.toStringAsFixed(2);
    return symbol == null || symbol.isEmpty ? s : '$s $symbol';
  }

  String _fmtDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";

  pw.Widget _kv(String k, String v, {bool bold = false}) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
          pw.Text(v, style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
        ],
      );

  // Logo laden (optional)
  pw.ImageProvider? logoProvider;
  if (dlLogoUrl != null && dlLogoUrl.isNotEmpty) {
    try {
      logoProvider = await networkImage(dlLogoUrl);
    } catch (_) {
      logoProvider = null;
    }
  }

  final datumFormatted = _fmtDate(datum);

  // Beträge: neue Felder bevorzugen, sonst Legacy (preis = Brutto)
  final bool smallBiz = isSmallBusiness == true;
  final double gross = (grossAmount ?? preis);
  final double? vatR = smallBiz ? 0.0 : vatRate; // nur Info
  final double? net  = smallBiz ? null : netAmount;
  final double? vat  = smallBiz ? null : vatAmount;

  // ---------- PDF ----------
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Kopf
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    rechnungLabel,
                    style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    '${invoiceNoShortLabel.trim()} $invoiceNumber',
                    style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('$datumLabel $datumFormatted'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  if (logoProvider != null) pw.Image(logoProvider, height: 50),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 18),

          // Absender
          pw.Text(vonLabel, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          if (dlCompanyName != null && dlCompanyName!.trim().isNotEmpty)
            pw.Text(dlCompanyName!.trim()),
          pw.Text(dlName),
          pw.Text(dlAddress),
          if (dlInvoiceAddress != null && dlInvoiceAddress!.isNotEmpty)
            pw.Text('$invoiceAddressLabel $dlInvoiceAddress'),
          if (dlTaxNumber != null && dlTaxNumber!.isNotEmpty)
            pw.Text('$taxNumberLabel $dlTaxNumber'),
          if (dlUstId != null && dlUstId!.trim().isNotEmpty)
            pw.Text('$vatIdLabel ${dlUstId!.trim()}'),
          if (dlIban != null && dlIban!.isNotEmpty)
            pw.Text('$ibanLabel $dlIban'),
          if (dlBic != null && dlBic!.trim().isNotEmpty)
            pw.Text('$bicLabel ${dlBic!.trim()}'),

          pw.SizedBox(height: 16),

          // Empfänger
          pw.Text(fuerLabel, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(kundeName),
          pw.Text(kundeAddress),

          pw.SizedBox(height: 16),

          // Beschreibung
          pw.Text(descriptionLabel, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(auftragsBeschreibung),

          pw.SizedBox(height: 18),

          // Summenblock
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                if (!smallBiz && net != null && vat != null && vatR != null) ...[
                  _kv('$netAmountLabel:', _fmtMoney(net, symbol: waehrung)),
                  pw.SizedBox(height: 4),
                  _kv('$vatLabelFormatted:', _fmtMoney(vat, symbol: waehrung)),
                  pw.Divider(color: PdfColors.grey300),
                  _kv('$totalLabel:', _fmtMoney(gross, symbol: waehrung), bold: true),
                ] else ...[
                  _kv(betragLabel, _fmtMoney(gross, symbol: waehrung), bold: true),
                ],
                if (smallBiz && (taxNote != null && taxNote!.trim().isNotEmpty)) ...[
                  pw.SizedBox(height: 6),
                  pw.Text(
                    taxNote!.trim(),
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                ],
              ],
            ),
          ),

          pw.SizedBox(height: 12),

          // Zahlungsinformationen
          if (dueDate != null || (paymentTerms != null && paymentTerms!.trim().isNotEmpty))
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
                color: PdfColors.grey100,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (dueDate != null)
                    _kv(dueOnLabel, _fmtDate(dueDate!)),
                  if (paymentTerms != null && paymentTerms!.trim().isNotEmpty) ...[
                    if (dueDate != null) pw.SizedBox(height: 4),
                    pw.Text(paymentTerms!.trim()),
                  ],
                ],
              ),
            ),

          pw.Spacer(),

          // Footer
          pw.Text(
            generatedByText,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
          pw.UrlLink(
            destination: websiteUrlText,
            child: pw.Text(
              websiteUrlText,
              style: pw.TextStyle(
                decoration: pw.TextDecoration.underline,
                color: PdfColors.blue,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // PDF in Bytes
  final Uint8List bytes = await pdf.save();

  // === Upload in Supabase Storage (ohne App zu blockieren, wenn RLS greift) ===
  final client = Supabase.instance.client;
  final bucket = 'rechnungen_pdfs';
  final path = 'invoices/$rechnungId.pdf'; // kein führender Slash

  String publicUrl = '';
  try {
    // Nutzer muss eingeloggt sein, sonst Rolle anon -> 403
    final uid = client.auth.currentUser?.id;
    if (uid == null) {
      throw Exception('Nicht eingeloggt (auth.uid ist null).');
    }

    await client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'application/pdf',
          ),
        );

    publicUrl = client.storage.from(bucket).getPublicUrl(path);
  } catch (_) {
    // Upload fehlgeschlagen (z. B. RLS 403) -> wir liefern trotzdem die Bytes zurück,
    // damit das PDF direkt angezeigt/gedruckt werden kann.
    publicUrl = '';
  }

  return {
    'url': publicUrl, // leer, wenn Upload blockiert
    'sha256': '',
    'bytes': bytes,
  };
}
