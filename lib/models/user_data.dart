import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';

class UserData {
  final String id;
  final String currentGameId;
  final String name;
  List<Game> gamesWon;

  UserData({
    @required this.id,
    @required this.currentGameId,
    @required this.name,
  });
}
