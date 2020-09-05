import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/screens/Lobby/created_game_tile.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

class ListOfCreatedGames extends StatelessWidget {
  // pass in userlocation to avoid async operations in build fn
  final Location _userLocation;
  ListOfCreatedGames(this._userLocation);

  @override
  Widget build(BuildContext context) {
    // init location service here in hopes of making the next fn call thing more readable
    final locationService = context.watch<LocationService>();

    // get stream of created games and set every game's distanceFromUser property
    final createdGamesWithDistance =
        context.watch<DatabaseService>().streamOfCreatedGames.map<List<Game>>(
              (games) => locationService.setDistanceBetweenUserAndGames(
                  games, _userLocation),
            );

    // build list of tiles that show a game's info
    return StreamBuilder<List<Game>>(
        stream: createdGamesWithDistance,
        builder: (context, snapshot) {
          // show empty screen if stream hasnt come through yet
          if (snapshot.data == null) {
            return Container(
              key: Key('list_of_created_games_empty_screen'),
            );
          } else {
            // sort games by distance from user (nearest to furtherest)
            snapshot.data.sort(
                (a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));

            // build that list!
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return GameTile(snapshot.data[index], index);
                  }),
            );
          }
        });
  }
}
