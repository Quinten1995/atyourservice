// lib/utils/geocoding_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  /// Ruft OpenStreetMap Nominatim an, um aus einer Adresse
  /// Breiten- und Längengrad zu bekommen.
  Future<Map<String, double>?> getCoordinates(String address) async {
    // URL für Nominatim: format=json, limit=1 → nur das erste Ergebnis
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?format=json&limit=1&q=${Uri.encodeComponent(address)}',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          // User-Agent laut Nominatim-Vorgabe (eigene App/Mail einsetzen)
          'User-Agent': 'atyourservice-FlutterApp/1.0 (meine@mailadresse.de)',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final first = data[0] as Map<String, dynamic>;
          final lat = double.tryParse(first['lat'] as String);
          final lon = double.tryParse(first['lon'] as String);
          if (lat != null && lon != null) {
            return {'lat': lat, 'lng': lon};
          }
        }
      }
    } catch (_) {
      // Bei Fehlern geben wir null zurück
    }
    return null;
  }
}
