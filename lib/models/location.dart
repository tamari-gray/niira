import 'package:meta/meta.dart';

class Location {
  final double latitude;
  final double longitude;

  Location({@required this.latitude, @required this.longitude});

  Location.fromMap(Map<String, dynamic> map)
      : latitude = (map ?? const <String, double>{})['latitude'] as double,
        longitude = (map ?? const <String, double>{})['longitude'] as double;
}
