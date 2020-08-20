import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key key}) : super(key: key);

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Lobby'),
              actions: [
                FlatButton(
                  key: Key('signOutBtn'),
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    await context.read<AuthService>().signOut();
                  },
                  child: Text('log out'),
                )
              ],
            ),
          );
  }
}
