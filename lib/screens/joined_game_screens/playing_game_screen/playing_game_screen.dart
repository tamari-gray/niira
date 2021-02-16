import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/joined_game_screens/finished_game_screen.dart';
import 'package:niira/screens/joined_game_screens/playing_game_screen/playing_game_map.dart';
import 'package:niira/screens/joined_game_screens/playing_game_screen/tagger_button.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/extensions/location_extension.dart';
import 'package:provider/provider.dart';
import 'package:niira/utilities/calc_sonar_timer.dart';

import 'hider_button.dart';

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
              final _userLocation = context.watch<Location>();
              if (_userLocation == null) {
                return Loading();
              } else {
                return PlayingGameScreen(
                  playersRemaining: playersRemaining,
                  currentPlayer: currentPlayer,
                  game: game,
                  playerLocation: _userLocation,
                );
              }
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
    @required this.playerLocation,
  }) : super(key: key);

  final Iterable<Player> playersRemaining;
  final Player currentPlayer;
  final Location playerLocation;
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!widget.currentPlayer.isTagger) {
        await context.read<DatabaseService>().setHiderPosition(
              widget.game.id,
              widget.currentPlayer.id,
              widget.playerLocation,
            );
      }
      // on timer end
      final _time = sonarTimer(
        startTime: widget.game.startTime,
        timerLength: widget.game.sonarIntervals,
      );
      if (_time == widget.game.sonarIntervals) {
        // check if tagger
        if (widget.currentPlayer.isTagger) {
          // generate new items and update gameDoc
          await context.read<DatabaseService>().generateNewItems(
                widget.game,
                widget.playersRemaining.length.toDouble(),
              );

          // map will listen to items doc,
          // when updated, will check if tagger or not
          // then show items or remaining players
        } else {
          // if hider has an item, make them safe
          if (!widget.currentPlayer.hasItem) {
            // show location to tagger
            await context
                .read<DatabaseService>()
                .showTaggerMyLocation(widget.game.id, widget.currentPlayer.id);
          } else {
            // hide location from tagger
            await context.read<DatabaseService>().hideMyLocationFromTagger(
                  widget.game.id,
                  widget.currentPlayer.id,
                );
          }
        }
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
        title: widget.currentPlayer.isTagger
            ? Text(' Go hunt! ${widget.playersRemaining.length} players left',
                style: TextStyle(color: Colors.white))
            : Text(
                ' Go hide! ${widget.playersRemaining.length} other players left',
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
      floatingActionButton: widget.playerLocation == null
          ? Container()
          : widget.currentPlayer.isTagger
              ? TaggerButton(
                  currentPlayer: widget.currentPlayer,
                  gameId: widget.game.id,
                  playerLocation: widget.playerLocation,
                )
              : HiderButton(
                  currentPlayer: widget.currentPlayer,
                  gameId: widget.game.id,
                  playerLocation: widget.playerLocation,
                ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 400,
              child: PlayingGameMap(
                  game: widget.game,
                  currentPlayer: widget.currentPlayer,
                  remainingPlayers: widget.playersRemaining,
                  playerLocation: widget.playerLocation,
                  circles: widget.playerLocation.toMapIcons(
                    boundarySize: widget.game.boundarySize,
                    boundaryPosition: widget.game.boundaryPosition.toLatLng(),
                  )),
            ),
            !widget.currentPlayer.isTagger &&
                    widget.currentPlayer.locationSafe != null
                ? !widget.currentPlayer.isTagger &&
                        !widget.currentPlayer.locationSafe
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                title: Text('The Tagger knows where you are!'),
                                subtitle: Text('Be careful..'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container()
                : Container(),
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
