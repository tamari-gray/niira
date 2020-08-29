import 'package:flutter/material.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/navigation_service.dart';
import 'package:provider/provider.dart';

class WaitingForGameToStartScreen extends StatefulWidget {
  @override
  _WaitingForGameToStartScreenState createState() =>
      _WaitingForGameToStartScreenState();
}

class _WaitingForGameToStartScreenState
    extends State<WaitingForGameToStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('waiting_for_game_to_start_screen'),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Waiting for game to start'),
        actions: [
          FlatButton.icon(
            key: Key('waiting_screen_quit_btn'),
            label: Text('leave'),
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<NavigationService>().showConfirmationDialog(
                    onConfirmed: () => Navigator.of(context).pop(),
                    confirmText: 'Leave game',
                    cancelText: 'Return',
                  );
            },
          )
        ],
      ),
      body: Container(
        child: StreamBuilder<List<Player>>(
            // stream: context.watch<DatabaseService>().streamOfJoinedPlayers,
            builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      snapshot.data[index].toString(),
                    ),
                  ); // TODO: make list tile
                },
              ),
            );
          }
        }),
      ),
    );
  }
}
