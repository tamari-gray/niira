import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

class FinishedGameScreen extends StatelessWidget {
  final Game game;
  final Player playerDoc;
  const FinishedGameScreen(
      {Key key, @required this.game, @required this.playerDoc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (playerDoc.isTagger) {
      if (playerDoc.hasQuit) {
        // show "you lose"

      } else if (!playerDoc.hasQuit) {
        // show "you win! you tagged everybody!"
      }
    } else if (!playerDoc.isTagger) {
      // calculate position

    } else {
      print('huston we have a problem. finished game screen');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${game.name}'),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('play again'),
            onPressed: () async {
              final userId = await context.read<AuthService>().currentUserId;
              await context.read<DatabaseService>().leaveGame(game.id, userId);
            },
          ),
        ),
      ),
    );
  }
}
