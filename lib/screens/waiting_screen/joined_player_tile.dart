import 'package:flutter/material.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

import '../../loading.dart';

/// Show joined player including their name
/// and indicate if they have been chosen as tagger
class JoinedPlayerTile extends StatefulWidget {
  JoinedPlayerTile({
    @required this.player,
  });

  final Player player;

  @override
  _JoinedPlayerTileState createState() => _JoinedPlayerTileState();
}

class _JoinedPlayerTileState extends State<JoinedPlayerTile> {
  bool _userIsAdmin;

  @override
  void initState() {
    _checkIfAdmin();
    super.initState();
  }

  void _checkIfAdmin() async {
    final gameId = context.read<GameService>().currentGameId;
    final game = await context.read<DatabaseService>().currentGame(gameId);
    final adminId = game.adminId;
    final userId = context.read<AuthService>().currentUserId;

    // if adminId is equal to userId then set them as admin
    setState(() {
      _userIsAdmin = userId == adminId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userIsAdmin == null) {
      return Loading();
    }
    return Padding(
      key: Key('created_game_tile_${widget.player.id}'),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: widget.player.isTagger
          ? TaggerTile(player: widget.player, userIsAdmin: _userIsAdmin)
          : PlayerTile(player: widget.player, userIsAdmin: _userIsAdmin),
    );
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    Key key,
    @required this.player,
    @required this.userIsAdmin,
  }) : super(key: key);

  final Player player;
  final bool userIsAdmin;

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
        trailing: userIsAdmin
            ? OutlineButton(
                textColor: Theme.of(context).primaryColor,
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                child: Text('Select'),
                onPressed: () async {
                  // admin choose tagger
                  final gameId = context.read<GameService>().currentGameId;
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
    @required this.userIsAdmin,
  }) : super(key: key);

  final Player player;
  final bool userIsAdmin;

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
        trailing: userIsAdmin ? Icon(Icons.close) : Container(),
        onTap: () async {
          // unselect tagger
          final gameId = context.read<GameService>().currentGameId;
          await context
              .read<DatabaseService>()
              .unSelectTagger(player.id, gameId);
        },
      ),
    );
  }
}
