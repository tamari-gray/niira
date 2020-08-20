import 'package:flutter/material.dart';
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
    );
  }
}
