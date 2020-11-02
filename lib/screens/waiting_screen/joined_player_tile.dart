import 'package:flutter/material.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

/// Show joined player including their name
/// and indicate if they have been chosen as tagger
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
          ? TaggerTile(player: player)
          : PlayerTile(player: player),
    );
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    Key key,
    @required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          player.username,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        subtitle: Text('is ready'),
        trailing: player.isAdmin
            ? OutlineButton(
                textColor: Theme.of(context).primaryColor,
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                child: Text('Select'),
                onPressed: () async {
                  // admin choose tagger
                  final gameId = context.read<GameService>().currentGame.id;
                  await context
                      .read<DatabaseService>()
                      .chooseTagger(player.id, gameId);
                },
              )
            : Container(),
      ),
    );
  }
}

class TaggerTile extends StatelessWidget {
  const TaggerTile({
    Key key,
    @required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Card(
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
        trailing: player.isAdmin ? Icon(Icons.close) : Container(),
      ),
    );
  }
}
