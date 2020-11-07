import 'package:flutter_test/flutter_test.dart';
import 'package:niira/services/game_service.dart';

void main() {
  test('sets game id', () {
    final gameService = GameService();
    expect(gameService.currentGameId, '');

    gameService.addListener(() {
      expect(gameService.currentGameId, 'test_id');
    });
    gameService.joinGame('test_id');
  });
  test('resets current gameId to empty string', () {
    final gameService = GameService();
    gameService.currentGameId = 'Id123';

    gameService.addListener(() {
      expect(gameService.currentGameId, '');
    });

    gameService.leaveCurrentGame();
  });
}
