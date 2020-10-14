import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension CameraPositionExt on CameraPosition {
  LatLng toLatLng() => LatLng(target.latitude, target.longitude);
  Circle toBoundary() => Circle(
        circleId: CircleId('boundary'),
        center: toLatLng(),
        radius: 100,
        strokeWidth: 3,
        strokeColor: Color.fromRGBO(247, 153, 0, 1),
        fillColor: Color.fromRGBO(247, 153, 0, 0.2),
      );
}
