import 'package:niira/models/game.dart';

class GameService {
  Game currentGame;
  GameService({this.currentGame});

  void setCurrentGame(Game _selectedGame) => currentGame = _selectedGame;
}
