import 'package:flutter/material.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
        actions: [
          FlatButton(
            onPressed: () => context.read<AuthService>().signOut(),
            child: Text('log out'),
          )
        ],
      ),
    );
  }
}
