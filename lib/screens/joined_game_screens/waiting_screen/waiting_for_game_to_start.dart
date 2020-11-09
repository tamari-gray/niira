import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import 'joined_players_list.dart';

class WaitingForGameToStartScreen extends StatelessWidget {
  final String gameId;
  WaitingForGameToStartScreen({@required this.gameId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
        stream: context.watch<DatabaseService>().streamOfJoinedPlayers(gameId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Loading(
                message: 'waiting for players to join...',
              ),
            );
          } else {
            return Scaffold(
              key: Key('waiting_forgameId_to_start_screen'),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choosing tagger...'),
                actions: [
                  FlatButton.icon(
                    key: Key('waiting_screen_quit_btn'),
                    label: Text('leave'),
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      final _navigation = context.read<Navigation>();

                      // remove user from game and navigate to lobby
                      void leaveGame() async {
                        final userId =
                            await context.read<AuthService>().currentUserId;
                        final userIsAdmin = await context
                            .read<DatabaseService>()
                            .checkIfAdmin(userId);

                        // dismiss dialog
                        await _navigation.pop();

                        if (userIsAdmin) {
                          await context
                              .read<DatabaseService>()
                              .adminQuitCreatingGame(gameId);
                        } else {
                          // leave game in db
                          // triggers navigation to lobby
                          await context
                              .read<DatabaseService>()
                              .leaveGame(gameId, userId);
                        }
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
                //render list of joined players
                child: JoinedPlayersList(joinedPlayers: snapshot.data),
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: Text(
                  'Play game',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
                onPressed: () async {},
              ),
            );
          }
        });
  }
}
