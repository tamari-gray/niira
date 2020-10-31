import 'package:flutter_test/flutter_test.dart';
import 'package:niira/services/game_service.dart';

import '../mocks/data/mock_games.dart';

void main() {
  test('sets game id', () {
    final gameService = GameService();
    expect(gameService.currentGame.id, null);

    gameService.currentGame.id = 'test_id';
    expect(gameService.currentGame.id, 'test_id');
  });
  test('resets current game to empty object', () {
    final gameService = GameService();
    final mockGame = MockGames().gamesToJoin[0];
    gameService.currentGame = mockGame;

    gameService.leaveCurrentGame();
    expect(gameService.currentGame.id, null);
  });
}
