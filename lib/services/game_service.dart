import 'package:niira/models/game.dart';
import 'package:niira/models/view_models/create_game1.dart';

class GameService {
  Game currentGame;
  final createGameViewModel1 = CreateGameViewModel1();

  GameService({this.currentGame});
}
