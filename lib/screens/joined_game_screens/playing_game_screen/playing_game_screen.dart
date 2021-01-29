import 'dart:async';

import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/joined_game_screens/finished_game_screen.dart';
import 'package:niira/screens/joined_game_screens/playing_game_screen/playing_game_map.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';
import 'package:niira/utilities/calc_sonar_timer.dart';

class PlayingGameScreenData extends StatelessWidget {
  final Game game;
  const PlayingGameScreenData({Key key, @required this.game}) : super(key: key);

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

            final userId = context.watch<AuthService>().currentUserId;
            final currentPlayer =
                snapshot.data.firstWhere((player) => player.id == userId);

            if (currentPlayer.hasBeenTagged == true ||
                currentPlayer.hasQuit == true ||
                game.phase == GamePhase.finished) {
              return FinishedGameScreen(game: game, playerDoc: currentPlayer);
            } else {
              return PlayingGameScreen(
                playersRemaining: playersRemaining,
                currentPlayer: currentPlayer,
                game: game,
              );
            }
          }
        });
  }
}

class PlayingGameScreen extends StatefulWidget {
  const PlayingGameScreen({
    Key key,
    @required this.playersRemaining,
    @required this.currentPlayer,
    @required this.game,
  }) : super(key: key);

  final Iterable<Player> playersRemaining;
  final Player currentPlayer;
  final Game game;

  @override
  _PlayingGameScreenState createState() => _PlayingGameScreenState();
}

class _PlayingGameScreenState extends State<PlayingGameScreen> {
  double _sonarTimerValue;
  Timer _timer;

  @override
  void initState() {
    _startSonar();
    super.initState();
  }

  void _startSonar() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final _time = sonarTimer(startTime: widget.game.startTime);
      if (_time == 0) {
        // check if tagger
        if (widget.currentPlayer.isTagger) {
          // generate new items and update gameDoc

          // map will listen to items doc,
          // when updated, will check if tagger or not
          // then show items or remaining players
          print('hi');
        } else {}
      }
      setState(() {
        _sonarTimerValue = _time;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('${widget.playersRemaining.length} players left',
            style: TextStyle(color: Colors.white)),
        actions: [
          FlatButton.icon(
              onPressed: () {
                // quit game
                // redirect to lobby
                context.read<Navigation>().showConfirmationDialog(
                    onConfirmed: () {
                  final userId = context.read<AuthService>().currentUserId;
                  // quit game
                  context.read<DatabaseService>().quitGame(userId);
                  // pop dialogue
                  context.read<Navigation>().pop();
                });
              },
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              label: Text('Quit', style: TextStyle(color: Colors.white)))
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              child: PlayingGameMap(game: widget.game),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                'Go hunt!',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text('Time until next sonar:',
                          style: TextStyle(fontSize: 15)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          '$_sonarTimerValue s',
                          style: TextStyle(fontSize: 35),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
