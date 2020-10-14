import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/models/location.dart';

extension LocationExt on Location {
  LatLng toLatLng() => LatLng(latitude, longitude);

  CameraPosition toShowUserLocation({@required double boundarySize}) {
    return CameraPosition(
      target: toLatLng(),
      zoom: 17,
    );
  }

  Set<Circle> toCircles({double boundarySize = 100}) => <Circle>{
        Circle(
          circleId: CircleId('boundary'),
          center: toLatLng(),
          radius: boundarySize,
          strokeWidth: 3,
          strokeColor: Color.fromRGBO(247, 153, 0, 1),
          fillColor: Color.fromRGBO(247, 153, 0, 0.2),
        ),
        Circle(
          circleId: CircleId('player_position'),
          center: toLatLng(),
          radius: 8,
          strokeWidth: 2,
          strokeColor: Colors.white,
          fillColor: Color.fromRGBO(130, 250, 184, 1),
        ),
      };
}
