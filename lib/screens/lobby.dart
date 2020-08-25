import 'package:flutter/material.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/navigation_service.dart';
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
                Navigator.of(context).pop();
                await context.read<AuthService>().signOut();
              };

              context.read<NavigationService>().showConfirmationDialog(
                  onConfirmed: signOut,
                  confirmText: 'Sign Out',
                  cancelText: 'Return');
            },
            child: Text('log out'),
          )
        ],
      ),
    );
  }
}
