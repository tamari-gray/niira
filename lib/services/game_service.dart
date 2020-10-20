import 'package:flutter/cupertino.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/view_models/create_game1.dart';
import 'package:niira/models/view_models/create_game2.dart';

class GameService extends ChangeNotifier {
  Game currentGame;
  final createGameViewModel1 = CreateGameViewModel1();
  final createGameViewModel2 = CreateGameViewModel2(defaultBoundarySize: 100);

  GameService({this.currentGame});

  void updateBoundarySize(double size) {
    createGameViewModel2.boundarySize = size;
    notifyListeners();
  }

  void updateBoundaryPosition(Location position) {
    createGameViewModel2.boundaryPosition = position;
    notifyListeners();
  }
}
