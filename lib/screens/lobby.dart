import 'package:flutter/material.dart';
import 'package:niira/models/boundary.dart';
import 'package:niira/models/game.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/auth/auth_service.dart';
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

    final games = <Game>[Game('yeet', 'tam', 'fdhi', 5, Boundary(5, 10))];
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
        child: ListView(
          children: <Widget>[for (var game in games) GameTile(game)],
        ),
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
      child: Padding(
        padding: EdgeInsets.all(20),
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
                        '500m away', // will get data in ticket #60
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
