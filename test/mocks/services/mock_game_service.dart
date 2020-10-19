import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/view_models/create_game1.dart';
import 'package:niira/models/view_models/create_game2.dart';
import 'package:niira/services/game_service.dart';

class FakeGameService extends Fake implements GameService {
  @override
  Game currentGame;
  @override
  final createGameViewModel1 = CreateGameViewModel1();
  @override
  final createGameViewModel2 = CreateGameViewModel2(defaultBoundarySize: 150);

  @override
  bool get hasListeners => false;
}

class MockGameService extends Mock implements GameService {}
