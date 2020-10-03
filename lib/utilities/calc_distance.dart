import 'dart:math';

// algorithm from:
// https://www.geeksforgeeks.org/program-distance-two-points-earth/
double distance({double lat1, double lat2, double lon1, double lon2}) {
  lon1 = degreesToRads(lon1);
  lon2 = degreesToRads(lon2);
  lat1 = degreesToRads(lat1);
  lat2 = degreesToRads(lat2);

  // Haversine formula
  final dlon = lon2 - lon1;
  final dlat = lat2 - lat1;
  final a = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2) as double;

  final c = 2 * asin(sqrt(a));

  // Radius of earth in kilometers. Use 3956 for miles
  final r = 6371;

  // returns result in km
  final resultInKm = (c * r);
  final resultInKmRounded = double.parse((resultInKm).toStringAsFixed(1));
  return resultInKmRounded;
}

double degreesToRads(double deg) {
  return (deg * pi) / 180.0;
}
