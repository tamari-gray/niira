import 'dart:async';

import 'package:flutter/material.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

class HiderButton extends StatefulWidget {
  final Player currentPlayer;
  final Location playerLocation;
  final String gameId;
  const HiderButton({
    Key key,
    @required this.currentPlayer,
    @required this.playerLocation,
    @required this.gameId,
  }) : super(key: key);

  @override
  _HiderButtonState createState() => _HiderButtonState();
}

class _HiderButtonState extends State<HiderButton> {
  bool pickingUpItem;

  @override
  void initState() {
    pickingUpItem = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      key: Key('hider_pick_up_item_button'),
      label: pickingUpItem
          ? Text('picking up item...')
          : widget.currentPlayer.hasItem
              ? Text('You are safe')
              : Text('Pick up item'),
      onPressed: () async {
        if (widget.currentPlayer.hasItem) {
          return null;
        } else {
          if (!pickingUpItem) {
            setState(() {
              pickingUpItem = true;
            });

            final pickedUpItem =
                await context.read<DatabaseService>().tryToPickUpItem(
                      widget.gameId,
                      widget.currentPlayer,
                      widget.playerLocation,
                    );

            setState(() {
              pickingUpItem = false;
            });

            await _showHiderDialog(pickedUpItem, context);
          }
        }
      },
    );
  }

  Future<void> _showHiderDialog(
      bool itemPickUpSuccess, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: itemPickUpSuccess ? Text('Success!') : Text('Oh no!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                itemPickUpSuccess
                    ? Text('Your location will be safe on the next sonar!')
                    : Text('No items within 5m! try again'),
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
