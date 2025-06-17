class Dienstleister {
  final String id;
  final String name;
  final String kategorie;
  final double latitude;
  final double longitude;
  final DateTime zuletztOnline; // ✅ HIER hinzugefügt

  Dienstleister({
    required this.id,
    required this.name,
    required this.kategorie,
    required this.latitude,
    required this.longitude,
    required this.zuletztOnline,
  });
}

