import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/navigation/route_names.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
        actions: [
          FlatButton(
            key: Key('signOutBtn'),
            onPressed: () {
              // create a function to call on confirmation
              final signOut = () async {
                context.read<Navigation>().pop();
                await context.read<AuthService>().signOut();
              };

              context.read<Navigation>().showConfirmationDialog(
                    onConfirmed: signOut,
                    confirmText: 'Sign Out',
                    cancelText: 'Return',
                  );
            },
            child: Text('log out'),
          )
        ],
      ),
      body: Container(
        child: StreamBuilder<List<Game>>(
            stream: context.watch<DatabaseService>().streamOfCreatedGames,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GameTile(
                        snapshot.data[index],
                      );
                    },
                  ),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<Navigation>().navigateTo(new_game1),
        label: Text('New Game'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class GameTile extends StatelessWidget {
  final Game _game;
  GameTile(this._game);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('created_game_tile_${_game.id}'),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 100, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '500m away', //TODO: will replace with real data in ticket #60
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        _game.name, // title of game
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'created by ${_game.creatorName}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
                ),
                OutlineButton(
                  key: Key('join_created_game_tile__btn_${_game.id}'),
                  textColor: Theme.of(context).primaryColor,
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  child: Text('Join'),
                  onPressed: () async {
                    // make selected game available to all widgets
                    context.read<GameService>().currentGame = _game;
                    // navigate to input password screen
                    await context.read<Navigation>().navigateTo(input_password);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
