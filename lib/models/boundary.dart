import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

class Boundary {
  final int size;
  final Position position;

  Boundary({
    @required this.size,
    @required this.position,
  });

  Boundary.fromMap(Map<dynamic, dynamic> map)
      : size = map['size'] as int,
        position = map['position'] as Position;
}
