import 'package:flutter/material.dart';
import 'package:niira/models/player.dart';
import 'package:niira/screens/waiting_screen/joined_player_tile.dart';

// show list of all joined players to all joined players
class JoinedPlayersList extends StatelessWidget {
  final List<Player> joinedPlayers;

  JoinedPlayersList({
    @required this.joinedPlayers,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView.builder(
        itemCount: joinedPlayers.length,
        itemBuilder: (context, index) => JoinedPlayerTile(
          player: joinedPlayers[index],
        ),
      ),
    );
  }
}
