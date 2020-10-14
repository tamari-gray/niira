import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/utilities/calc_player_icon_size.dart';

extension CameraPositionExt on CameraPosition {
  LatLng toLatLng() => LatLng(target.latitude, target.longitude);
  Set<Circle> toCircles(
      {@required double boundarySize, @required LatLng userLocation}) {
    return <Circle>{
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
        center: userLocation,
        // sets radius to be relative to zoom level
        radius: calcPlayerSizeFromCameraPosition(zoom),
        strokeWidth: 2,
        strokeColor: Colors.white,
        fillColor: Color.fromRGBO(130, 250, 184, 1),
      ),
    };
  }
}
