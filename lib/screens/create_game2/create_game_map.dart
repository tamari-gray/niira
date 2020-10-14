import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/models/location.dart';
import 'package:niira/extensions/location_extension.dart';
import 'package:niira/extensions/circle_extension.dart';
import 'package:niira/extensions/camera_position.dart';
import 'package:niira/screens/create_game2/show_location_btn.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/utilities/map_styles/create_game_map.dart';
import 'package:provider/provider.dart';

/// google map with draggable boundary and custom userlocation icon + btn
class CreateGameMap extends StatefulWidget {
  final double boundarySize;
  final Function loadedMap;
  CreateGameMap({@required this.boundarySize, @required this.loadedMap});
  @override
  State<CreateGameMap> createState() => CreateGameMapState();
}

class CreateGameMapState extends State<CreateGameMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Circle> _circles;
  Location _userLocation;
  LatLng _boundaryPosition;

  @override
  void initState() {
    _initMap();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateGameMap oldWidget) {
    /// boundarySize is passed down from slider in `createGameScreen2`
    /// we catch it here and update the map
    if (_userLocation != null) _updateBoundarySize(widget.boundarySize);
    super.didUpdateWidget(oldWidget);
  }

  /// get users location from `LocationService`
  /// and set user icon + boundary icon
  void _initMap() async {
    final userLocationFromService =
        await context.read<LocationService>().getUsersCurrentLocation();

    setState(() {
      _boundaryPosition = userLocationFromService.toLatLng();
      _userLocation = userLocationFromService;
      _circles = _userLocation.toCircles(boundarySize: widget.boundarySize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userLocation == null
        ? Container()
        : Stack(children: [
            // create the map!
            GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: _userLocation.toShowUserLocation(
                  boundarySize: widget.boundarySize),
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(createGameMapStyle);
                _controller.complete(controller);
                // tell `createGameScreen2` that the map is loaded
                widget.loadedMap();
              },
              // update boundary position when user moves the map
              onCameraMove: (cameraPosition) => _updateMap(cameraPosition),
              circles: _circles,
            ),
            // custom fab type button to show users location
            ShowLocationButton(
              controller: _controller,
              userPosition: _userLocation.toShowUserLocation(
                  boundarySize: widget.boundarySize),
            )
          ]);
  }

  /// Update boundary and user location icons. Also set
  /// `_boundaryPosition` in local state so `updateBoundarySize`
  /// can access it
  void _updateMap(CameraPosition cameraPosition) {
    setState(() {
      _circles = cameraPosition.toCircles(
        boundarySize: widget.boundarySize,
        userLocation: _userLocation.toLatLng(),
      );
      _boundaryPosition = cameraPosition.toLatLng();
    });
  }

  void _updateBoundarySize(double size) {
    setState(() {
      _circles = _circles
          .map((circle) => circle.circleId == CircleId('boundary')
              // required parameter 'circleId' will be added in toBoundary function
              // ignore: missing_required_param
              ? Circle().toBoundary(size: size, position: _boundaryPosition)
              : circle)
          .toSet();
    });
  }
}
