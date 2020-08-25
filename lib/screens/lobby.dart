import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _confirmSignOutDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            actions: <Widget>[
              OutlineButton(
                color: Theme.of(context).primaryColor,
                highlightedBorderColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryColor,
                key: Key('confirmSignOutBtn'),
                child: Text('Sign out'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await context.read<AuthService>().signOut();
                },
              ),
              FlatButton(
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                child: Text('Return'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
        actions: [
          FlatButton(
            key: Key('signOutBtn'),
            onPressed: () {
              _confirmSignOutDialog();
            },
            child: Text('log out'),
          )
        ],
      ),
      body: Container(
        child: StreamBuilder<List<Game>>(
            stream: context.watch<DatabaseService>().streamOfCreatedGames,
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Loading()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: ListView(
                        children: <Widget>[
                          for (var game in snapshot.data) GameTile(game)
                        ],
                      ),
                    );
            }),
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
                        '500m away', // will replace with real data in ticket #60
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
                  textColor: Theme.of(context).primaryColor,
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  child: Text('Join'),
                  onPressed: () {
                    // navigate to input password screen
                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => InputPasswordScreen(),
                      ),
                    );
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
