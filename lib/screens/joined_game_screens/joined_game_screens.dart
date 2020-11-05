import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/joined_game_screens/waiting_screen/waiting_for_game_to_start.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class JoinedGameScreens extends StatefulWidget {
  const JoinedGameScreens({Key key}) : super(key: key);
  static const routeName = '/joined_game_screens';

  @override
  _JoinedGameScreensState createState() => _JoinedGameScreensState();
}

class _JoinedGameScreensState extends State<JoinedGameScreens> {
  String _gameId;

  @override
  void initState() {
    _gameId = context.read<GameService>().currentGameId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameId == null) {
      Loading(message: 'identifiying game...');
    }
    return StreamBuilder<Game>(
        stream: context.watch<DatabaseService>().streamOfJoinedGame(_gameId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            context.read<Navigation>().displayError(snapshot.error);
          }

          if (!snapshot.hasData) {
            return Loading(message: 'retrieving your game');
          }

          switch (snapshot.data.phase) {
            case GamePhase.initialising:
              return WaitingForGameToStartScreen();
              break;
            case GamePhase.playing:
              // return PlayingGame();

              break;
            case GamePhase.finished:
              // return PostGame();
              break;
            default:
              return WaitingForGameToStartScreen();
          }
        });
  }
}
