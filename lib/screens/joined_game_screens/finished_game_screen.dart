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
    return Scaffold(
      appBar: AppBar(
        title: Text('Niira'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Center(
                child: Text(
                  playerDoc.hasQuit || playerDoc.hasBeenTagged
                      ? 'You lose'
                      : 'You win!',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('Home'),
                onPressed: () async {
                  final userId =
                      await context.read<AuthService>().currentUserId;
                  await context
                      .read<DatabaseService>()
                      .leaveGame(game.id, userId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
