import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/game.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  // TODO: decide on what happens when user refuses location accesss

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
                Navigator.of(context).pop();
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
      body: FutureBuilder<Position>(
        future: context.watch<LocationService>().getUsersCurrentLocation(),
        builder: (context, snapshot) => snapshot.hasData == false
            ? Loading()
            : Container(
                child: StreamBuilder<List<Game>>(
                    stream:
                        context.watch<DatabaseService>().streamOfCreatedGames,
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
                  onPressed: () {
                    // navigate to input password screen
                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => InputPasswordScreen(
                          game: _game,
                        ),
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
