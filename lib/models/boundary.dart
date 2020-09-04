import 'package:meta/meta.dart';
import 'package:niira/models/location.dart';

class Boundary {
  final int size;
  final Location position;

  Boundary({
    @required this.size,
    @required this.position,
  });

  Boundary.fromMap(Map<dynamic, dynamic> map)
      : size = map['size'] as int,
        position = Location.fromMap(map['position'] as Map<String, dynamic>);
}
