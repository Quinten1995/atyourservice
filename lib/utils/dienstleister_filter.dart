import '../models/dienstleister.dart';
import 'entfernung_utils.dart';

List<Dienstleister> findePassendeDienstleister({
  required List<Dienstleister> alleDienstleister,
  required String kategorie,
  required double auftragLat,
  required double auftragLon,
  double maxEntfernungKm = 20.0, // Standard-Radius z. B. 20 km
}) {
  return alleDienstleister.where((dienstleister) {
    bool gleicheKategorie = dienstleister.kategorie == kategorie;
    double entfernung = berechneEntfernung(
      auftragLat,
      auftragLon,
      dienstleister.latitude,   // hier angepasst
      dienstleister.longitude,  // hier angepasst
    );
    return gleicheKategorie && entfernung <= maxEntfernungKm;
  }).toList();
}
