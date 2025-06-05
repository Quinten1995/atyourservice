import 'package:flutter/material.dart'; // für TimeOfDay

class Auftrag {
  final String id;
  final String kundeId;
  final String? dienstleisterId;
  final String titel;
  final String beschreibung;
  final String kategorie;
  final String? adresse;
  final double? latitude;
  final double? longitude;
  final String status;
  final DateTime erstelltAm;
  final DateTime aktualisiertAm;
  final String? telefon;

  // Planung und Zeitfenster
  final bool soSchnellWieMoeglich;
  final DateTime? terminDatum;
  final TimeOfDay? zeitVon;
  final TimeOfDay? zeitBis;

  // Intervall / Wiederkehrend (NEU)
  final bool wiederkehrend;
  final String? intervall;
  final String? wochentag;
  final int? anzahlWiederholungen;
  final DateTime? wiederholenBis;

  Auftrag({
    required this.id,
    required this.kundeId,
    this.dienstleisterId,
    required this.titel,
    required this.beschreibung,
    required this.kategorie,
    this.adresse,
    this.latitude,
    this.longitude,
    required this.status,
    required this.erstelltAm,
    required this.aktualisiertAm,
    this.telefon,
    this.soSchnellWieMoeglich = true,
    this.terminDatum,
    this.zeitVon,
    this.zeitBis,
    // NEU
    this.wiederkehrend = false,
    this.intervall,
    this.wochentag,
    this.anzahlWiederholungen,
    this.wiederholenBis,
  });

  factory Auftrag.fromJson(Map<String, dynamic> json) => Auftrag(
        id: json['id'] as String,
        kundeId: json['kunde_id'] as String,
        dienstleisterId: json['dienstleister_id'] as String?,
        titel: json['titel'] as String,
        beschreibung: json['beschreibung'] as String,
        kategorie: json['kategorie'] as String,
        adresse: json['adresse'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        status: json['status'] as String,
        erstelltAm: DateTime.parse(json['erstellt_am'] as String),
        aktualisiertAm: DateTime.parse(json['aktualisiert_am'] as String),
        telefon: json['telefon'] as String?,
        soSchnellWieMoeglich: json['so_schnell_wie_moeglich'] as bool? ?? true,
        terminDatum: json['termin_datum'] != null
            ? DateTime.tryParse(json['termin_datum'])
            : null,
        zeitVon: json['zeit_von'] != null
            ? _parseTimeOfDay(json['zeit_von'])
            : null,
        zeitBis: json['zeit_bis'] != null
            ? _parseTimeOfDay(json['zeit_bis'])
            : null,
        // NEU
        wiederkehrend: json['wiederkehrend'] == true,
        intervall: json['intervall'] as String?,
        wochentag: json['wochentag'] as String?,
        anzahlWiederholungen: json['anzahl_wiederholungen'] as int?,
        wiederholenBis: json['wiederholen_bis'] != null
            ? DateTime.tryParse(json['wiederholen_bis'])
            : null,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
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
      'so_schnell_wie_moeglich': soSchnellWieMoeglich,
      if (terminDatum != null) 'termin_datum': terminDatum!.toIso8601String(),
      if (zeitVon != null) 'zeit_von': _timeOfDayToString(zeitVon!),
      if (zeitBis != null) 'zeit_bis': _timeOfDayToString(zeitBis!),
      // NEU
      'wiederkehrend': wiederkehrend,
      if (intervall != null) 'intervall': intervall,
      if (wochentag != null) 'wochentag': wochentag,
      if (anzahlWiederholungen != null) 'anzahl_wiederholungen': anzahlWiederholungen,
      if (wiederholenBis != null) 'wiederholen_bis': wiederholenBis!.toIso8601String().substring(0, 10),
    };
    if (dienstleisterId != null) {
      map['dienstleister_id'] = dienstleisterId;
    }
    if (telefon != null) {
      map['telefon'] = telefon;
    }
    return map;
  }

  Auftrag copyWith({
    String? titel,
    String? beschreibung,
    String? kategorie,
    String? adresse,
    double? latitude,
    double? longitude,
    String? status,
    String? dienstleisterId,
    DateTime? aktualisiertAm,
    String? telefon,
    bool? soSchnellWieMoeglich,
    DateTime? terminDatum,
    TimeOfDay? zeitVon,
    TimeOfDay? zeitBis,
    // NEU
    bool? wiederkehrend,
    String? intervall,
    String? wochentag,
    int? anzahlWiederholungen,
    DateTime? wiederholenBis,
  }) {
    return Auftrag(
      id: id,
      kundeId: kundeId,
      dienstleisterId: dienstleisterId ?? this.dienstleisterId,
      titel: titel ?? this.titel,
      beschreibung: beschreibung ?? this.beschreibung,
      kategorie: kategorie ?? this.kategorie,
      adresse: adresse ?? this.adresse,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      erstelltAm: erstelltAm,
      aktualisiertAm: aktualisiertAm ?? this.aktualisiertAm,
      telefon: telefon ?? this.telefon,
      soSchnellWieMoeglich: soSchnellWieMoeglich ?? this.soSchnellWieMoeglich,
      terminDatum: terminDatum ?? this.terminDatum,
      zeitVon: zeitVon ?? this.zeitVon,
      zeitBis: zeitBis ?? this.zeitBis,
      // NEU
      wiederkehrend: wiederkehrend ?? this.wiederkehrend,
      intervall: intervall ?? this.intervall,
      wochentag: wochentag ?? this.wochentag,
      anzahlWiederholungen: anzahlWiederholungen ?? this.anzahlWiederholungen,
      wiederholenBis: wiederholenBis ?? this.wiederholenBis,
    );
  }

  // Hilfsfunktionen für TimeOfDay-Handling (String <-> TimeOfDay)
  static TimeOfDay _parseTimeOfDay(String value) {
    final parts = value.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
