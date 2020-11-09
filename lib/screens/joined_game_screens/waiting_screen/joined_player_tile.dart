import 'package:flutter/material.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

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
  String _gameId;

  @override
  void initState() {
    _checkIfAdmin();
    super.initState();
  }

  void _checkIfAdmin() async {
    final userId = context.read<AuthService>().currentUserId;
    final gameId = await context.read<DatabaseService>().currentGameId(userId);
    final isAdmin = await context.read<DatabaseService>().checkIfAdmin(userId);

    setState(() {
      _gameId = gameId;
      _userIsAdmin = isAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userIsAdmin == null && _gameId == null) {
      return Container();
    }
    return Padding(
      key: Key('created_game_tile_${widget.player.id}'),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: widget.player.isTagger
          ? TaggerTile(
              player: widget.player,
              userIsAdmin: _userIsAdmin,
              gameId: _gameId,
            )
          : PlayerTile(
              player: widget.player,
              userIsAdmin: _userIsAdmin,
              gameId: _gameId,
            ),
    );
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    Key key,
    @required this.player,
    @required this.userIsAdmin,
    @required this.gameId,
  }) : super(key: key);

  final Player player;
  final bool userIsAdmin;
  final String gameId;

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
                  await context
                      .read<DatabaseService>()
                      .chooseTagger(player.id, gameId);
                },
              )
            : Icon(Icons.person),
      ),
    );
  }
}

class TaggerTile extends StatelessWidget {
  const TaggerTile({
    Key key,
    @required this.player,
    @required this.userIsAdmin,
    @required this.gameId,
  }) : super(key: key);

  final Player player;
  final bool userIsAdmin;
  final String gameId;

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
        trailing: userIsAdmin ? Icon(Icons.close) : Icon(Icons.person),
        onTap: () async {
          // unselect tagger
          await context
              .read<DatabaseService>()
              .unSelectTagger(player.id, gameId);
        },
      ),
    );
  }
}
