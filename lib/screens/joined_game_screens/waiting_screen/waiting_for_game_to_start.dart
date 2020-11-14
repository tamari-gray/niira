import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import 'joined_players_list.dart';

class WaitingForGameToStartScreen extends StatefulWidget {
  final String gameId;
  WaitingForGameToStartScreen({@required this.gameId});

  @override
  _WaitingForGameToStartScreenState createState() =>
      _WaitingForGameToStartScreenState();
}

class _WaitingForGameToStartScreenState
    extends State<WaitingForGameToStartScreen> {
  bool _userIsAdmin;
  String _userId;

  @override
  void initState() {
    _checkIfAdmin();
    super.initState();
  }

  void _checkIfAdmin() async {
    final userId = context.read<AuthService>().currentUserId;
    final userIsAdmin =
        await context.read<DatabaseService>().checkIfAdmin(userId);

    setState(() {
      _userId = userId;
      _userIsAdmin = userIsAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userIsAdmin == null || _userId == null
        ? Loading(message: 'getting user data')
        : StreamBuilder<List<Player>>(
            stream: context
                .watch<DatabaseService>()
                .streamOfJoinedPlayers(widget.gameId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                context.read<Navigation>().displayError(snapshot.error);
              }
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
                            // dismiss dialog
                            await _navigation.pop();

                            if (_userIsAdmin) {
                              await context
                                  .read<DatabaseService>()
                                  .adminQuitCreatingGame(widget.gameId);
                            } else {
                              // leave game in db
                              // triggers navigation to lobby
                              await context
                                  .read<DatabaseService>()
                                  .leaveGame(widget.gameId, _userId);
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
                  floatingActionButton: !_userIsAdmin
                      ? Container()
                      : FloatingActionButton.extended(
                          label: Text(
                            'Play game',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (snapshot.data.length == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('wait for more players to join :)'),
                                ),
                              );
                            } else {
                              final chosenTagger = snapshot.data
                                  .where((player) => player.isTagger);
                              if (chosenTagger.length == 1) {
                                await context
                                    .read<Navigation>()
                                    .showConfirmationDialog(
                                        message: 'Are you ready?',
                                        confirmText: 'Yes',
                                        cancelText: 'No',
                                        onConfirmed: () async {
                                          // dismiss dialog
                                          await context
                                              .read<Navigation>()
                                              .pop();
                                          // admin start game and notify all players
                                          // triggers navigation to playingGameScreen
                                          await context
                                              .read<DatabaseService>()
                                              .startGame(_userId);
                                        });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('please choose tagger first'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                );
              }
            });
  }
}
