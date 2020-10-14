import 'package:niira/models/game.dart';
import 'package:niira/models/view_models/create_game1.dart';
import 'package:niira/models/view_models/create_game2.dart';

class GameService {
  Game currentGame;
  final createGameViewModel1 = CreateGameViewModel1();
  final createGameViewModel2 = CreateGameViewModel2();

  GameService({this.currentGame});
}
