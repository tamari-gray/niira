import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/services/game_service.dart';

class MockGameService extends Mock implements GameService {
  @override
  Game currentGame;
}
