import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/navigation_service.dart';
import 'package:provider/provider.dart';

class WaitingForGameToStartScreen extends StatefulWidget {
  final Game game;
  WaitingForGameToStartScreen({@required this.game});
  @override
  _WaitingForGameToStartScreenState createState() =>
      _WaitingForGameToStartScreenState();
}

class _WaitingForGameToStartScreenState
    extends State<WaitingForGameToStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('c'),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Waiting for game to start'),
        actions: [
          FlatButton.icon(
            key: Key('waiting_screen_quit_btn'),
            label: Text('leave'),
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // handle player leaving gamec
              // TODO: if admin leaving, force all players to quit and redirect to lobby

              // navigate to lobby route
              final lobbyRoute = MaterialPageRoute<dynamic>(
                builder: (context) => LobbyScreen(),
              );

              // TODO: use navigation service to pop until lobby screen
              context.read<NavigationService>().showConfirmationDialog(
                    onConfirmed: () => Navigator.of(context).popUntil(
                      (route) => route == lobbyRoute,
                    ),
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
                .streamOfJoinedPlayers(widget.game.id),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              } else {
                //render list of joined players
                return JoinedPlayersList(joinedPlayers: snapshot.data);
              }
            }),
      ),
    );
  }
}

// show list of all joined players to all joined players
class JoinedPlayersList extends StatelessWidget {
  final List<Player> joinedPlayers;

  JoinedPlayersList({
    @required this.joinedPlayers,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView.builder(
        itemCount: joinedPlayers.length,
        itemBuilder: (context, index) => JoinedPlayerTile(
          player: joinedPlayers[index],
        ),
      ),
    );
  }
}

// show joined player including their name and indicating if they have been chosen as tagger
class JoinedPlayerTile extends StatelessWidget {
  JoinedPlayerTile({
    @required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: Key('created_game_tile_${player.id}'),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: player.isTagger
          ? Card(
              key: Key('tagger_tile_${player.id}'),
              color: Theme.of(context).accentColor,
              child: ListTile(
                title: Text(
                  player.username,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'is the tagger',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : Card(
              child: ListTile(
                title: Text(
                  player.username,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                subtitle: Text('has joined'),
              ),
            ),
    );
  }
}
