import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game1/create_game_screen1.dart';
import 'package:niira/screens/lobby/list_of_created_games.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  static const routeName = '/lobby';
  final bool _hasLocationPermission;

  LobbyScreen(this._hasLocationPermission);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
        actions: [
          FlatButton(
            key: Key('signOutBtn'),
            onPressed: () {
              // create a function to sign out user on dialog confirmation
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
      body: _hasLocationPermission
          ? GetCurrentLocationFutureBuilder()
          : NeedLocationCard(),
      floatingActionButton: _hasLocationPermission ? NewGameFAB() : null,
    );
  }
}

class NewGameFAB extends StatelessWidget {
  const NewGameFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () =>
          context.read<Navigation>().navigateTo(CreateGameScreen1.routeName),
      label: Text('New Game'),
      icon: Icon(Icons.add),
    );
  }
}

class NeedLocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        child: Container(
          width: 300,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi :)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(237, 125, 0, 1),
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enable location permission to play Niira',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: OutlineButton(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(237, 125, 0, 1),
                          width: 2,
                          style: BorderStyle.solid),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () async {
                        await Permission.location.request();
                        if (await Permission.location.request().isGranted) {
                          return LobbyScreen(true);
                        }
                      },
                      child: const Text(
                        'ENABLE',
                        style: TextStyle(
                          color: Color.fromRGBO(237, 125, 0, 1),
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GetCurrentLocationFutureBuilder extends StatelessWidget {
  const GetCurrentLocationFutureBuilder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Location>(
        future: context.watch<LocationService>().getUsersCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print(snapshot);
            return Loading();
          } else {
            return ListOfCreatedGames(snapshot.data);
          }
        });
  }
}
