import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/models/game.dart';
import 'package:niira/screens/Lobby/created_game_tile.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

class ListOfCreatedGames extends StatelessWidget {
  // pass in userlocation to avoid async operations
  final Position _userLocation;
  ListOfCreatedGames(this._userLocation);

  @override
  Widget build(BuildContext context) {
    // init location service here in hopes of making the next fn call thing more readable
    final locationService = context.read<LocationService>();

    // get stream of created games and set every game's distanceFromUser property
    final createdGamesWithDistanceFromUser =
        context.watch<DatabaseService>().streamOfCreatedGames.map<List<Game>>(
              (games) => locationService.setDistanceBetweenUserAndGames(
                  games, _userLocation),
            );

    // build list of tiles that show a game's info
    return StreamBuilder<List<Game>>(
        stream: createdGamesWithDistanceFromUser,
        builder: (context, snapshot) {
          // show empty screen if stream hasnt come through yet
          if (snapshot.data == null) {
            return Container();
          } else {
            // sort games by distance from user (nearest to furtherest)
            snapshot.data.sort(
                (a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));

            // build that list!
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => GameTile(
                  snapshot.data[index],
                ),
              ),
            );
          }
        });
  }
}
