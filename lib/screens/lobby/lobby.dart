import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/screens/lobby/list_of_created_games.dart';
import 'package:niira/screens/new_game1/new_game_screen1.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  // TODO: decide on what happens when user refuses location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
        actions: [
          FlatButton(
            key: Key('signOutBtn'),
            onPressed: () {
              // create a function to call and sign out on confirmation
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
          future: context.watch<LocationService>().getUsersCurrentLocation,
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Loading();
            } else {
              // pass in users location to list of created games
              final userLocation = Location(
                latitude: snapshot.data.latitude,
                longitude: snapshot.data.longitude,
              );
              return ListOfCreatedGames(userLocation);
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.read<Navigation>().navigateTo(NewGameScreen1.routeName),
        label: Text('New Game'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
