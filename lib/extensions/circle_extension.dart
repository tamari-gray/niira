import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/models/location.dart';
import './location_extension.dart';

extension CircleExt on Circle {
  Circle toBoundary({@required double size, @required Location position}) =>
      Circle(
        circleId: CircleId('boundary'),
        center: position.toLatLng(),
        radius: size,
        strokeWidth: 3,
        strokeColor: Color.fromRGBO(247, 153, 0, 1),
        fillColor: Color.fromRGBO(247, 153, 0, 0.2),
      );
}
