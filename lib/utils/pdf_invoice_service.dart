import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateAndPrintInvoice({
  required String rechnungLabel,
  required String invoiceNumber,
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
  required String dlName,
  required String dlAddress,
  String? dlInvoiceAddress,
  String? dlTaxNumber,
  String? dlIban,
  String? dlLogoUrl,
  required String kundeName,
  required String kundeAddress,
  required String auftragsBeschreibung,
  required double preis,
  required String waehrung, // <--- NEU!
  required DateTime datum,
}) async {
  final pdf = pw.Document();

  // Logo laden, falls vorhanden
  pw.ImageProvider? logoProvider;
  if (dlLogoUrl != null && dlLogoUrl.isNotEmpty) {
    try {
      final image = await networkImage(dlLogoUrl);
      logoProvider = image;
    } catch (_) {
      logoProvider = null;
    }
  }

  final datumFormatted = "${datum.day.toString().padLeft(2, '0')}.${datum.month.toString().padLeft(2, '0')}.${datum.year}";

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Kopfbereich mit Titel und Rechnungsnummer
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(rechnungLabel, style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  if (logoProvider != null)
                    pw.Image(logoProvider, height: 50),
                  pw.SizedBox(height: 6),
                  pw.Text('Nr: $invoiceNumber', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(vonLabel, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(dlName),
          pw.Text(dlAddress),
          if (dlInvoiceAddress != null && dlInvoiceAddress.isNotEmpty)
            pw.Text('$invoiceAddressLabel $dlInvoiceAddress'),
          if (dlTaxNumber != null && dlTaxNumber.isNotEmpty)
            pw.Text('$taxNumberLabel $dlTaxNumber'),
          if (dlIban != null && dlIban.isNotEmpty)
            pw.Text('$ibanLabel $dlIban'),
          pw.SizedBox(height: 16),
          pw.Text(fuerLabel, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(kundeName),
          pw.Text(kundeAddress),
          pw.SizedBox(height: 16),
          pw.Text(descriptionLabel, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(auftragsBeschreibung),
          pw.SizedBox(height: 16),
          pw.Text(
            '$betragLabel ${preis.toStringAsFixed(2)} $waehrung', // <-- Währung dynamisch!
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          pw.Text('$datumLabel $datumFormatted'),
          pw.Spacer(),
          pw.Text(
            generatedByText,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
          pw.UrlLink(
            destination: websiteUrlText,
            child: pw.Text(websiteUrlText, style: pw.TextStyle(decoration: pw.TextDecoration.underline, color: PdfColors.blue)),
          ),
        ],
      ),
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
