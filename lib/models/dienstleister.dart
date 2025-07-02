class Dienstleister {
  final String id;
  final String name;
  final String kategorie;
  final double latitude;
  final double longitude;
  final DateTime zuletztOnline;

  // Rechnungsdaten
  final String? invoiceName;
  final String? invoiceAddress;
  final String? invoiceTaxNumber;
  final String? invoiceIban;
  final String? invoiceLogoUrl;

  Dienstleister({
    required this.id,
    required this.name,
    required this.kategorie,
    required this.latitude,
    required this.longitude,
    required this.zuletztOnline,
    this.invoiceName,
    this.invoiceAddress,
    this.invoiceTaxNumber,
    this.invoiceIban,
    this.invoiceLogoUrl,
  });

  // Factory-Konstruktor: Map (DB) -> Dienstleister-Objekt
  factory Dienstleister.fromMap(Map<String, dynamic> map) {
    return Dienstleister(
      id: map['id'] as String,
      name: map['name'] as String,
      kategorie: map['kategorie'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      zuletztOnline: DateTime.parse(map['zuletzt_online'] as String),
      invoiceName: map['invoice_name'] as String?,
      invoiceAddress: map['invoice_address'] as String?,
      invoiceTaxNumber: map['invoice_tax_number'] as String?,
      invoiceIban: map['invoice_iban'] as String?,
      invoiceLogoUrl: map['invoice_logo_url'] as String?,
    );
  }

  // Objekt -> Map (zum Speichern/Updaten)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'kategorie': kategorie,
      'latitude': latitude,
      'longitude': longitude,
      'zuletzt_online': zuletztOnline.toIso8601String(),
      'invoice_name': invoiceName,
      'invoice_address': invoiceAddress,
      'invoice_tax_number': invoiceTaxNumber,
      'invoice_iban': invoiceIban,
      'invoice_logo_url': invoiceLogoUrl,
    };
  }
}
