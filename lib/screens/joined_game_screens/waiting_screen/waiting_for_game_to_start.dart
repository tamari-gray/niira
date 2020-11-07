import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

import 'joined_players_list.dart';

class WaitingForGameToStartScreen extends StatefulWidget {
  @override
  _WaitingForGameToStartScreenState createState() =>
      _WaitingForGameToStartScreenState();
}

class _WaitingForGameToStartScreenState
    extends State<WaitingForGameToStartScreen> {
  String _gameId;

  @override
  void initState() {
    _gameId = context.read<GameService>().currentGameId;
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
        : Scaffold(
            key: Key('waiting_for_gameId_to_start_screen'),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choosing tagger...'),
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
                      final userId =
                          await context.read<AuthService>().currentUserId;

                      // leave game in db
                      await context
                          .read<DatabaseService>()
                          .leaveGame(_gameId, userId);

                      // dismiss dialog
                      await _navigation.pop();

                      // leave game in global state auto navigates to lobby
                      context.read<GameService>().leaveCurrentGame();
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
                      return JoinedPlayersList(joinedPlayers: snapshot.data);
                    }
                  }),
            ),
          );
  }
}
