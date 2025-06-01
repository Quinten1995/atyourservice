class Auftrag {
  final String id;
  final String kundeId;
  final String titel;
  final String beschreibung;
  final String kategorie;
  final String? adresse;
  final double? latitude;
  final double? longitude;
  final String status;
  final DateTime erstelltAm;
  final DateTime aktualisiertAm;

  Auftrag({
    required this.id,
    required this.kundeId,
    required this.titel,
    required this.beschreibung,
    required this.kategorie,
    this.adresse,
    this.latitude,
    this.longitude,
    required this.status,
    required this.erstelltAm,
    required this.aktualisiertAm,
  });

  factory Auftrag.fromJson(Map<String, dynamic> json) {
    return Auftrag(
      id: json['id'],
      kundeId: json['kunde_id'],
      titel: json['titel'],
      beschreibung: json['beschreibung'] ?? '',
      kategorie: json['kategorie'],
      adresse: json['adresse'],
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
      longitude: (json['longitude'] != null) ? json['longitude'].toDouble() : null,
      status: json['status'],
      erstelltAm: DateTime.parse(json['erstellt_am']),
      aktualisiertAm: DateTime.parse(json['aktualisiert_am']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kunde_id': kundeId,
      'titel': titel,
      'beschreibung': beschreibung,
      'kategorie': kategorie,
      'adresse': adresse,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'erstellt_am': erstelltAm.toIso8601String(),
      'aktualisiert_am': aktualisiertAm.toIso8601String(),
    };
  }
}
