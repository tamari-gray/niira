import 'package:niira/models/game.dart';

class GameService {
  Game currentGame;
  void leaveCurrentGame() => currentGame = null;
}
