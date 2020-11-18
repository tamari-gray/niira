import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/joined_game_screens/finished_game_screen.dart';
import 'package:niira/screens/joined_game_screens/waiting_screen/waiting_for_game_to_start.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import 'playing_game_screen/playing_game_screen.dart';

class JoinedGameScreens extends StatefulWidget {
  final String gameId;
  const JoinedGameScreens({Key key, @required this.gameId}) : super(key: key);
  static const routeName = '/joined_game_screens';

  @override
  _JoinedGameScreensState createState() => _JoinedGameScreensState();
}

class _JoinedGameScreensState extends State<JoinedGameScreens> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Game>(
        stream:
            context.watch<DatabaseService>().streamOfJoinedGame(widget.gameId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            context.watch<Navigation>().displayError(snapshot.error);
          }

          if (!snapshot.hasData) {
            return Scaffold(body: Loading(message: 'retrieving your game'));
          }

          switch (snapshot.data.phase) {
            case GamePhase.created:
              return WaitingForGameToStartScreen(
                gameId: snapshot.data.id,
              );
              break;
            case GamePhase.playing:
              return PlayingGameScreen(
                game: snapshot.data,
              );
              break;
            case GamePhase.finished:
              return FinishedGameScreen();
              break;
            default:
              return WaitingForGameToStartScreen(gameId: snapshot.data.id);
          }
        });
  }
}
