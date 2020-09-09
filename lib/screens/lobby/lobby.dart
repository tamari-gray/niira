import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/lobby/created_game_tile.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
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
                      return GameTile(snapshot.data[index], index);
                    },
                  ),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<Navigation>().navigateTo('/new_game1'),
        label: Text('New Game'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
