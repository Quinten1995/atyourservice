import 'package:flutter/material.dart'; // für TimeOfDay

class AuftragFormData {
  String? kategorie;
  String? titel;
  String? beschreibung;
  String? adresse;
  double? latitude;
  double? longitude;
  String? telefon;

  String? preisTyp;    // <--- NEU: 'gesamt', 'stunde', 'verhandelbar'
  double? preis;       // Preis: Nur befüllt, wenn Typ 'gesamt' oder 'stunde'
  String? preisHinweis; // Zusatzinfo, z.B. "inkl. Materialkosten"

  bool soSchnellWieMoeglich = true;
  DateTime? terminDatum;
  TimeOfDay? zeitVon;
  TimeOfDay? zeitBis;
  bool wiederkehrend = false;
  String? intervall;
  String? wochentag;
  int? anzahlWiederholungen;
  DateTime? wiederholenBis;

  AuftragFormData();

  // Factory für ein "leeres" Objekt mit Default-Werten
  factory AuftragFormData.empty() => AuftragFormData()
    ..kategorie = null
    ..titel = null
    ..beschreibung = null
    ..adresse = null
    ..latitude = null
    ..longitude = null
    ..telefon = null
    ..preisTyp = null        // <--- NEU
    ..preis = null           // <--- NEU
    ..preisHinweis = null    // <--- bleibt
    ..soSchnellWieMoeglich = true
    ..terminDatum = null
    ..zeitVon = null
    ..zeitBis = null
    ..wiederkehrend = false
    ..intervall = null
    ..wochentag = null
    ..anzahlWiederholungen = null
    ..wiederholenBis = null;
}
