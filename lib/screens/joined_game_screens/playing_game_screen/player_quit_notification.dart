import 'package:flutter/material.dart';
import 'package:niira/models/player.dart';

class PlayerQuitNotification extends StatelessWidget {
  final Player player;
  const PlayerQuitNotification({Key key, @required this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [Text('We got a quitter'), Icon(Icons.delete)],
          ),
          Text('${player.username} has quit')
        ],
      ),
    );
  }
}
