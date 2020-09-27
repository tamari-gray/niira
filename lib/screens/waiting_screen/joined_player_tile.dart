import 'package:flutter/material.dart';
import 'package:niira/models/player.dart';

// show joined player including their name and indicating if they have been chosen as tagger
class JoinedPlayerTile extends StatelessWidget {
  JoinedPlayerTile({
    @required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: Key('created_game_tile_${player.id}'),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: player.isTagger
          ? Card(
              key: Key('tagger_tile_${player.id}'),
              color: Theme.of(context).accentColor,
              child: ListTile(
                title: Text(
                  player.username,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'is the tagger',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : Card(
              child: ListTile(
                title: Text(
                  player.username,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                subtitle: Text('has joined'),
              ),
            ),
    );
  }
}
