import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/services/game_service.dart';

class MockGameService extends Mock implements GameService {
  Game game = Game(
    id: 'mock_game_123',
    name: null,
    creatorName: null,
    sonarIntervals: null,
    password: 'test_password',
    boundarySize: 0,
    location: Location(latitude: 0, longitude: 0),
    phase: null,
  );
  @override
  void setCurrentGame(Game _selectedGame) => game = _selectedGame;

  Game get getCurrentGame => Game(
      id: null,
      name: null,
      creatorName: null,
      sonarIntervals: null,
      password: null,
      location: null,
      boundarySize: null,
      phase: null);
}
