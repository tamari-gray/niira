import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/extensions/location_extension.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/utilities/map_styles/create_game_map.dart';
import 'package:provider/provider.dart';

class CreateGameMap extends StatefulWidget {
  @override
  State<CreateGameMap> createState() => CreateGameMapState();
}

class CreateGameMapState extends State<CreateGameMap> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Location>(
        future: context.watch<LocationService>().getUsersCurrentLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // if no map, we wait for map
            return Loading(
              message: 'loading map...',
            );
          } else {
            // create and set the boundary and player location icons
            final circles = <Circle>{
              Circle(
                circleId: CircleId('boundary'),
                center: snapshot.data.toLatLng(),
                radius: 100,
                strokeWidth: 3,
                strokeColor: Color.fromRGBO(247, 153, 0, 1),
                fillColor: Color.fromRGBO(247, 153, 0, 0.2),
              ),
              Circle(
                circleId: CircleId('player_position'),
                center: snapshot.data.toLatLng(),
                radius: 8,
                strokeWidth: 2,
                strokeColor: Colors.white,
                fillColor: Theme.of(context).accentColor,
              ),
            };

            // create the map!
            return Stack(children: [
              GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: snapshot.data.toShowUserLocation(),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(createGameMapStyle);
                  _controller.complete(controller);
                },
                circles: circles,
              ),
              // custom fab type button to show users location
              ShowLocationButton(
                controller: _controller,
                userPosition: snapshot.data.toShowUserLocation(),
              )
            ]);
          }
        },
      ),
    );
  }
}

class ShowLocationButton extends StatelessWidget {
  const ShowLocationButton(
      {Key key,
      @required Completer<GoogleMapController> controller,
      @required CameraPosition userPosition})
      : _controller = controller,
        _userPosition = userPosition,
        super(key: key);

  final Completer<GoogleMapController> _controller;
  final CameraPosition _userPosition;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: RawMaterialButton(
          onPressed: () async {
            // animate camera over users location
            final controller = await _controller.future;
            await controller
                .animateCamera(CameraUpdate.newCameraPosition(_userPosition));
          },
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.my_location,
            size: 25.0,
            color: Colors.grey,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
