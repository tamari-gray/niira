// Import the test package and Counter class
import 'package:niira/models/game.dart';
import 'package:niira/services/game_service.dart';
import 'package:test/test.dart';

void main() {
  test('current game should change when new game is created or joined ', () {
    // init service
    final _gameService = GameService();

    // user joins or creates a game
    final _selectedGame = Game(id: 'first_game');
    _gameService.setCurrentGame(_selectedGame);

    // user quits previous game, and joins or creates a new game
    final _secondSelectedGame = Game(id: 'second_game');
    _gameService.setCurrentGame(_secondSelectedGame);

    // check that second game has been set as current game
    expect(_gameService.currentGame.id, _secondSelectedGame.id);
  });
}
