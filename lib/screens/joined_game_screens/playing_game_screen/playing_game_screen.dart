import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/joined_game_screens/playing_game_screen/playing_game_map.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

class PlayingGameScreen extends StatelessWidget {
  final Game game;
  const PlayingGameScreen({Key key, @required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
        stream: context.watch<DatabaseService>().streamOfJoinedPlayers(game.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            context.read<Navigation>().displayError(snapshot.error);
          }
          if (snapshot.data == null) {
            return Loading(message: 'loading game');
          } else {
            final playersRemaining = snapshot.data.where((player) =>
                player.hasBeenTagged == false && player.isTagger == false);
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: Text('${playersRemaining.length} players left',
                    style: TextStyle(color: Colors.white)),
                actions: [
                  FlatButton.icon(
                      onPressed: () {
                        // quit game
                        // redirect to lobby
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      label:
                          Text('Quit', style: TextStyle(color: Colors.white)))
                ],
              ),
              body: Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 250,
                        child: PlayingGameMap(game: game),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // notifications and sonar timer
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
