import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/waiting_screen/joined_players_list.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/user_service.dart';
import 'package:provider/provider.dart';

class WaitingForGameToStartScreen extends StatefulWidget {
  static const routeName = '/waiting_for_game_to_start';

  @override
  _WaitingForGameToStartScreenState createState() =>
      _WaitingForGameToStartScreenState();
}

class _WaitingForGameToStartScreenState
    extends State<WaitingForGameToStartScreen> {
  String _gameId;

  @override
  void initState() {
    _gameId = context.select((GameService service) => service.currentGame.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _gameId == null
        ? Scaffold(
            body: Container(
            child: Loading(
              message: 'getting game...',
            ),
          ))
        : StreamBuilder<Game>(
            stream:
                context.watch<DatabaseService>().streamOfJoinedGame(_gameId),
            builder: (context, snapshot) {
              return Scaffold(
                key: Key('waiting_for_game_to_start_screen'),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Waiting for game to start'),
                  actions: [
                    FlatButton.icon(
                      key: Key('waiting_screen_quit_btn'),
                      label: Text('leave'),
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        // handle player leaving game
                        // TODO: if admin leaving, force all players to quit and redirect to lobby

                        final _navigation = context.read<Navigation>();

                        // remove user from game and navigate to lobby
                        void leaveGame() async {
                          await _navigation.popUntilLobby();

                          final userId =
                              await context.read<AuthService>().currentUserId;

                          // leave game in global state
                          context.read<GameService>().leaveCurrentGame();

                          // leave game in db
                          await context
                              .read<DatabaseService>()
                              .leaveGame(_gameId, userId);
                        }

                        _navigation.showConfirmationDialog(
                          onConfirmed: () => leaveGame(),
                          confirmText: 'Leave game',
                          cancelText: 'Return',
                        );
                      },
                    )
                  ],
                ),
                body: Container(
                  child: StreamBuilder<List<Player>>(
                      // get stream of players that have joined this game
                      stream: context
                          .watch<DatabaseService>()
                          .streamOfJoinedPlayers(_gameId),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Loading(
                            message: 'waiting for players to join...',
                          );
                        } else {
                          //render list of joined players
                          return JoinedPlayersList(
                              joinedPlayers: snapshot.data);
                        }
                      }),
                ),
              );
            });
  }
}
