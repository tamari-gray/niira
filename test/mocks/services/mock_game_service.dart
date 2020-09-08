import 'package:niira/models/game.dart';
import 'package:niira/models/view_models/new_game1.dart';
import 'package:niira/services/game_service.dart';

class FakeGameService implements GameService {
  @override
  final newGameViewModel1 = NewGameViewModel1();
  @override
  Game currentGame;
}
