import 'package:flutter_test/flutter_test.dart';
import 'package:niira/services/game_service.dart';

void main() {
  test('sets game id', () {
    final gameService = GameService();
    expect(gameService.currentGameId, '');

    gameService.currentGameId = 'test_id';
    expect(gameService.currentGameId, 'test_id');
  });
  test('resets current gameId to empty string', () {
    final gameService = GameService();
    gameService.currentGameId = 'Id123';

    gameService.leaveCurrentGame();
    expect(gameService.currentGameId, '');
  });
}
