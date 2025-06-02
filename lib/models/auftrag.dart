// lib/models/auftrag.dart

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

  factory Auftrag.fromJson(Map<String, dynamic> json) => Auftrag(
        id: json['id'] as String,
        kundeId: json['kunde_id'] as String,
        titel: json['titel'] as String,
        beschreibung: json['beschreibung'] as String,
        kategorie: json['kategorie'] as String,
        adresse: json['adresse'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        status: json['status'] as String,
        erstelltAm: DateTime.parse(json['erstellt_am'] as String),
        aktualisiertAm: DateTime.parse(json['aktualisiert_am'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kunde_id': kundeId,
        'titel': titel,
        'beschreibung': beschreibung,
        'kategorie': kategorie,
        if (adresse != null) 'adresse': adresse,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'status': status,
        'erstellt_am': erstelltAm.toIso8601String(),
        'aktualisiert_am': aktualisiertAm.toIso8601String(),
      };

  Auftrag copyWith({
    String? titel,
    String? beschreibung,
    String? kategorie,
    String? adresse,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? aktualisiertAm,
  }) {
    return Auftrag(
      id: id,
      kundeId: kundeId,
      titel: titel ?? this.titel,
      beschreibung: beschreibung ?? this.beschreibung,
      kategorie: kategorie ?? this.kategorie,
      adresse: adresse ?? this.adresse,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      erstelltAm: erstelltAm,
      aktualisiertAm: aktualisiertAm ?? this.aktualisiertAm,
    );
  }
}
