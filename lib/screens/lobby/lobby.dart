import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/screens/create_game1/create_game_screen1.dart';
import 'package:niira/screens/lobby/list_of_created_games.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  // TODO: decide on what happens when user refuses location
  static const routeName = '/lobby';

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
      body: FutureBuilder<Location>(
          future: context.watch<LocationService>().getUsersCurrentLocation(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListOfCreatedGames(snapshot.data)
                : Loading(
                    message: 'Searching for games...',
                  );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.read<Navigation>().navigateTo(CreateGameScreen1.routeName),
        label: Text('New Game'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
