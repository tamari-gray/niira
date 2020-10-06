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
          if (snapshot.hasData) {
            // create and set the boundary and player location icons
            final circles = <Circle>{
              Circle(
                circleId: CircleId('boundary_icon'),
                center: snapshot.data.toLatLng(),
                radius: 100,
                strokeWidth: 3,
                strokeColor: Color.fromRGBO(247, 153, 0, 1),
                fillColor: Color.fromRGBO(247, 153, 0, 0.3),
              ),
              Circle(
                circleId: CircleId('player_position_icon'),
                center: snapshot.data.toLatLng(),
                radius: 8,
                strokeWidth: 2,
                strokeColor: Colors.white,
                fillColor: Theme.of(context).accentColor,
              ),
            };

            // create the map!
            return GoogleMap(
              initialCameraPosition:
                  snapshot.data.toCreateGameInitialCameraPosition(),
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(createGameMapStyle);
                _controller.complete(controller);
              },
              circles: circles,
            );
          } else {
            // if no map, we wait for map :(
            return Loading();
          }
        },
      ),
    );
  }
}
