import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

import 'created_game_tile.dart';

class ListOfCreatedGames extends StatelessWidget {
  // pass in userlocation to avoid async operations in build fn
  final Location _userLocation;
  ListOfCreatedGames(this._userLocation);

  @override
  Widget build(BuildContext context) {
    // init location service here in hopes of making createdGamesInOrderOfDistance more readable
    final locationService = context.watch<LocationService>();

    // get stream of created games in order of distanceFromUser, (nearest to furtherest)
    final createdGamesInOrderOfDistance =
        context.watch<DatabaseService>().streamOfCreatedGames.map<List<Game>>(
              (games) => locationService.updateAndOrderGamesByDistance(
                  games, _userLocation),
            );

    // build list of tiles that show a game's info
    return StreamBuilder<List<Game>>(
        stream: createdGamesInOrderOfDistance,
        builder: (context, snapshot) {
          // show empty screen if stream hasnt come through yet
          return snapshot.data == null
              ? Container(
                  key: Key('list_of_created_games_empty_screen'),
                )
              // check if any games have been made
              : snapshot.data.isEmpty
                  ? Center(
                      child: Container(
                        child: Text(
                          '''No games atm,
                          create the first! :)''',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          // put bottom padding on last game tile in list
                          // so user can scroll it past fab
                          final lastTilePadding =
                              index == snapshot.data.length - 1 ? 70.0 : 0.0;

                          return Padding(
                            padding:
                                EdgeInsets.fromLTRB(0, 0, 0, lastTilePadding),
                            child: GameTile(snapshot.data[index], index),
                          );
                        },
                      ),
                    );
        });
  }
}
