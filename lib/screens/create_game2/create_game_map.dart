import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/extensions/location_extension.dart';
import 'package:niira/extensions/camera_position.dart';
import 'package:niira/screens/create_game2/show_location_btn.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/utilities/map_styles/create_game_map.dart';
import 'package:provider/provider.dart';

/// google map with draggable boundary and custom userlocation icon + btn
class CreateGameMap extends StatefulWidget {
  @override
  State<CreateGameMap> createState() => CreateGameMapState();
}

class CreateGameMapState extends State<CreateGameMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Circle> _circles;
  bool _loading;
  Location _userLocation;

  @override
  void initState() {
    _loading = true;
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading(
            message: 'loading map...',
          )
        : Stack(children: [
            // create the map!
            GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: _userLocation.toShowUserLocation(),
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(createGameMapStyle);
                _controller.complete(controller);
              },
              // update boundary position when user moves the map
              onCameraMove: (cameraPosition) =>
                  _updateBoundaryPosition(cameraPosition),
              circles: _circles,
            ),
            // custom fab type button to show users location
            ShowLocationButton(
              controller: _controller,
              userPosition: _userLocation.toShowUserLocation(),
            )
          ]);
  }

  /// get users location from `LocationService` and update
  /// boundary position and user position on map
  void _getLocation() async {
    final userLocationFromService =
        await context.read<LocationService>().getUsersCurrentLocation();

    setState(() {
      _userLocation = userLocationFromService;
      _circles = userLocationFromService.toCircles();
      _loading = false;
    });
  }

  /// find the `boundary` circle and replace it with a new
  /// circle that has the `cameraPosition` coords
  void _updateBoundaryPosition(CameraPosition cameraPosition) {
    setState(() {
      _circles = _circles
          .map((circle) => circle.circleId == CircleId('boundary')
              ? cameraPosition.toBoundary()
              : circle)
          .toSet();
    });
  }
}
