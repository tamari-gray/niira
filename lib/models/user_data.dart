import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';

class UserData {
  final String id;
  String name;
  List<Game> gamesWon;

  UserData({@required this.id});
}
