import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/screens/lobby/created_game_tile.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

class ListOfCreatedGames extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // build list of tiles that show a game's info
    return StreamBuilder<List<Game>>(
        stream: context.watch<DatabaseService>().streamOfCreatedGames,
        builder: (context, snapshot) {
          // show empty screen if stream hasnt come through yet
          if (snapshot.data == null) {
            return Container(
              key: Key('list_of_created_games_empty_screen'),
            );
          } else {
            // build that list!
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    GameTile(snapshot.data[index], index),
              ),
            );
          }
        });
  }
}
