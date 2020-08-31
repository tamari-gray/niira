import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

class Boundary {
  final int size;
  final Position
      position; // TODO: position will be an object of latlng coords, update when choose geolocation library

  Boundary({
    @required this.size,
    @required this.position,
  });
}
