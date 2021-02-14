import 'dart:async';

import 'package:flutter/material.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

class TaggerButton extends StatefulWidget {
  final Player currentPlayer;
  final Location playerLocation;
  final String gameId;
  const TaggerButton({
    Key key,
    @required this.currentPlayer,
    @required this.playerLocation,
    @required this.gameId,
  }) : super(key: key);

  @override
  _TaggerButtonState createState() => _TaggerButtonState();
}

class _TaggerButtonState extends State<TaggerButton> {
  bool attemptingTag;

  @override
  void initState() {
    attemptingTag = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      key: Key('tagger_tag_player_button'),
      label: attemptingTag ? Text('Tagging player...') : Text('Tag player'),
      onPressed: () async {
        if (!attemptingTag) {
          setState(() {
            attemptingTag = true;
          });

          final _taggedPlayerName =
              await context.read<DatabaseService>().tryToTagPlayer(
                    widget.gameId,
                    widget.currentPlayer,
                    widget.playerLocation,
                  );

          if (_taggedPlayerName == 'game_over') {
            await context.read<DatabaseService>().finishGame(widget.gameId);
          } else {
            setState(() {
              attemptingTag = false;
            });

            await _showTaggerDialog(_taggedPlayerName, context);
          }
        }
      },
    );
  }

  Future<void> _showTaggerDialog(
      String taggedPlayerName, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: taggedPlayerName != '' ? Text('Success!') : Text('Oh no!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                taggedPlayerName != ''
                    ? Text('You tagged $taggedPlayerName! ')
                    : Text('No players within 5m! try again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('hide'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
