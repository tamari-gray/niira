import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/extensions/location_extension.dart';
import 'package:niira/models/player.dart';
import 'package:niira/screens/create_game2/show_location_btn.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/utilities/map_styles/create_game_map.dart';
import 'package:provider/provider.dart';

/// google map with draggable boundary and custom userlocation icon + btn
class PlayingGameMap extends StatefulWidget {
  final Game game;
  final Player currentPlayer;
  final Set<Circle> circles;
  final Iterable<Player> remainingPlayers;

  PlayingGameMap({
    @required this.game,
    @required this.currentPlayer,
    @required this.circles,
    @required this.remainingPlayers,
  });

  @override
  State<PlayingGameMap> createState() => PlayingGameMapState();
}

class PlayingGameMapState extends State<PlayingGameMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Location _userLocation;

  @override
  void initState() {
    _initMap();
    super.initState();
  }

  /// get users location from `LocationService`
  /// and set user + boundary icons on map
  void _initMap() async {
    final initialLocation =
        await context.read<LocationService>().getUsersCurrentLocation();
    setState(() {
      _userLocation = initialLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userLocation == null
        ? Loading(message: 'getting your location')
        : Stack(children: [
            // create the map!
            StreamBuilder<Set<Marker>>(
                stream: widget.currentPlayer.isTagger
                    ? context
                        .watch<DatabaseService>()
                        .streamOfUnsafePlayers(widget.game.id)
                    : context
                        .watch<DatabaseService>()
                        .streamOfItems(widget.game.id),
                builder: (context, snapshot) {
                  final _markers = snapshot.data;
                  return GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: _userLocation.toShowUserLocation(
                        boundarySize: widget.game.boundarySize),
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(createGameMapStyle);
                      _controller.complete(controller);
                    },
                    circles: widget.circles,
                    markers: _markers,
                  );
                }),
            // custom fab type button to show users location
            ShowLocationButton(
              controller: _controller,
              userPosition: _userLocation.toShowUserLocation(
                  boundarySize: widget.game.boundarySize),
            )
          ]);
  }
}
