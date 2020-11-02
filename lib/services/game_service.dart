import 'package:niira/models/game.dart';

class GameService {
  Game currentGame = defaultGame();
  void leaveCurrentGame() => currentGame = defaultGame();
}

final defaultGame = () => Game(
    name: null,
    adminName: null,
    adminId: null,
    sonarIntervals: null,
    password: null,
    boundaryPosition: null,
    boundarySize: null,
    phase: null);
