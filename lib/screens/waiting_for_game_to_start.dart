import 'package:flutter/material.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Waiting...'),
      ),
      body: Container(
        child: Center(
          child: Text('waiting for game to start'),
        ),
      ),
    );
  }
}
