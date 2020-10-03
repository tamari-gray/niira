import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class GameTile extends StatelessWidget {
  final Game _game;
  final int _index;
  GameTile(this._game, this._index);

  @override
  Widget build(BuildContext context) {
    return Container(
      // key is formatted with index to help with testing,
      // refer to created_game_tile_widget_test.dart
      key: Key('created_game_tile_${_game.id}_index:${_index}'),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${_game.distanceFromUser}m away',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
                        child: Text(
                          _game.name, // title of game
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Text(
                        'created by ${_game.creatorName}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
                ),
                OutlineButton(
                  key: Key('join_created_game_tile__btn_${_game.id}'),
                  textColor: Theme.of(context).primaryColor,
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  child: Text('Join'),
                  onPressed: () async {
                    // make selected game available to all widgets
                    context.read<GameService>().currentGame = _game;
                    // navigate to input password screen
                    await context
                        .read<Navigation>()
                        .navigateTo(InputPasswordScreen.routeName);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
