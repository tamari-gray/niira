import 'package:flutter/material.dart';
import 'package:niira/screens/create_game2/create_game_map.dart';

class CreateGameScreen2 extends StatefulWidget {
  static const routeName = '/create_game2';

  @override
  _CreateGameScreen2State createState() => _CreateGameScreen2State();
}

class _CreateGameScreen2State extends State<CreateGameScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Create Game 2/2',
            style: TextStyle(color: Colors.white)),
      ),
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
