import '../models/dienstleister.dart';

List<Dienstleister> dienstleisterDaten = [
  Dienstleister(
    id: 'd1',
    name: 'Maler Max',
    kategorie: 'Maler',
    latitude: 52.5200,
    longitude: 13.4050, // Berlin
    zuletztOnline: DateTime.now().subtract(Duration(minutes: 3)),
  ),
  Dienstleister(
    id: 'd2',
    name: 'Elektriker Erika',
    kategorie: 'Elektriker',
    latitude: 52.5000,
    longitude: 13.4100, // Nähe Berlin
    zuletztOnline: DateTime.now().subtract(Duration(minutes: 25)),
  ),
  Dienstleister(
    id: 'd3',
    name: 'Klempner Klaus',
    kategorie: 'Klempner',
    latitude: 48.1351,
    longitude: 11.5820, // München
    zuletztOnline: DateTime.now().subtract(Duration(minutes: 58)),
  ),
  Dienstleister(
    id: 'd4',
    name: 'Malerin Mona',
    kategorie: 'Maler',
    latitude: 52.5190,
    longitude: 13.4000, // Nähe Berlin
    zuletztOnline: DateTime.now().subtract(Duration(minutes: 8)),
  ),
];

