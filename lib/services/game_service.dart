import 'package:niira/models/game.dart';
import 'package:niira/models/view_models/new_game1.dart';

class GameService {
  Game currentGame;
  final newGameViewModel1 = NewGameViewModel1();
  GameService({this.currentGame});
}
