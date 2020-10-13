import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/models/location.dart';

extension LocationExt on Location {
  LatLng toLatLng() => LatLng(latitude, longitude);

  CameraPosition toShowUserLocation() => CameraPosition(
        target: toLatLng(),
        zoom: 17,
      );
}
