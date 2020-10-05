import 'package:flutter/material.dart';
import 'package:niira/screens/create_game2/map.dart';

class CreateGameScreen2 extends StatefulWidget {
  static const routeName = '/create_game2';

  @override
  _CreateGameScreen2State createState() => _CreateGameScreen2State();
}

class _CreateGameScreen2State extends State<CreateGameScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              child: CreateGameMap(),
            )
          ],
        ),
      ),
    );
  }
}
