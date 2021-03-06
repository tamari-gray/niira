import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/models/location.dart';
import 'package:niira/extensions/location_extension.dart';
import 'package:niira/extensions/circle_extension.dart';
import 'package:niira/extensions/camera_position.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/screens/create_game2/show_location_btn.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/utilities/map_styles/create_game_map.dart';
import 'package:provider/provider.dart';

/// google map with draggable boundary and custom userlocation icon + btn
class CreateGameMap extends StatefulWidget {
  final double boundarySize;
  final Location boundaryPosition;

  CreateGameMap({
    @required this.boundarySize,
    @required this.boundaryPosition,
  });
  @override
  State<CreateGameMap> createState() => CreateGameMapState();
}

class CreateGameMapState extends State<CreateGameMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Circle> _mapIcons;
  Location _userLocation;

  @override
  void initState() {
    _initMap();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateGameMap oldWidget) {
    // update boundary when size or position is changed
    // if user location == null then we want initMap to be called
    if (_userLocation != null &&
        widget.boundarySize != null &&
        widget.boundaryPosition != null) {
      _updateBoundary(widget.boundarySize, widget.boundaryPosition);
    }
    super.didUpdateWidget(oldWidget);
  }

  /// get users location from `LocationService`
  /// and set user + boundary icons on map
  void _initMap() async {
    final userLocationFromService =
        await context.read<LocationService>().getUsersCurrentLocation();

    // update boundary position in vm
    context
        .read<CreateGameViewModel>()
        .updateBoundaryPosition(userLocationFromService);

    // get initial boundary size from vm
    final vmBoundarySize = context.read<CreateGameViewModel>().boundarySize;

    setState(() {
      _userLocation = userLocationFromService;
      _mapIcons = _userLocation.toMapIcons(boundarySize: vmBoundarySize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userLocation == null
        ? Container()
        : Stack(children: [
            // create the map!
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              initialCameraPosition: _userLocation.toShowUserLocation(
                  boundarySize: widget.boundarySize),
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(createGameMapStyle);
                _controller.complete(controller);
                // tell `createGameScreen2` that the map is loaded
                context.read<CreateGameViewModel>().loadedMap();
              },
              // update boundary position and user icon size when user moves map
              onCameraMove: (cameraPosition) => _updateMap(cameraPosition),
              circles: _mapIcons,
            ),
            // custom fab type button to show users location
            ShowLocationButton(
              controller: _controller,
              userPosition: _userLocation.toShowUserLocation(
                  boundarySize: widget.boundarySize),
            )
          ]);
  }

  /// Update boundary and user location icons in map.
  /// Also update boundaryPosition and boundarySize in vm.
  void _updateMap(CameraPosition cameraPosition) {
    // update local state
    setState(() {
      _mapIcons = cameraPosition.toMapIcons(
        boundarySize: widget.boundarySize,
        userLocation: _userLocation.toLatLng(),
      );
    });

    // update vm
    final boundaryPosition = cameraPosition.toLocation();
    context
        .read<CreateGameViewModel>()
        .updateBoundaryPosition(boundaryPosition);
  }

  /// whenever boundary size is changed in `boundarySizeSlider`
  /// or boundary position is changed when the user moves the map in `onCameraMove`
  /// update ui
  void _updateBoundary(double size, Location position) {
    setState(() {
      _mapIcons = _mapIcons
          .map((circle) => circle.circleId == CircleId('boundary')
              // required parameter 'circleId' will be added in toBoundary function
              // ignore: missing_required_param
              ? Circle().toBoundary(size: size, position: position)
              : circle)
          .toSet();
    });
  }
}
