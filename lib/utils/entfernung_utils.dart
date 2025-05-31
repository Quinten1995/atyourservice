import 'dart:math';

double berechneEntfernung(double lat1, double lon1, double lat2, double lon2) {
  const double erdRadius = 6371; // in Kilometern

  double dLat = _gradZuBogenmass(lat2 - lat1);
  double dLon = _gradZuBogenmass(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_gradZuBogenmass(lat1)) *
          cos(_gradZuBogenmass(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double entfernung = erdRadius * c;

  return entfernung;
}

double _gradZuBogenmass(double grad) {
  return grad * pi / 180;
}
