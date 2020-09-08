// Import the test package and Counter class
import 'package:niira/services/game_service.dart';
import 'package:test/test.dart';

void main() {
  test('add name + password when submit valid data in newgamescreen1', () {
    // init service
    final _gameService = GameService();

    // user inputs valid name & password
    final name = 'tims game';
    final password = 'password';
    _gameService.newGameViewModel1.name = name;
    _gameService.newGameViewModel1.password = password;

    // check that name + password is saved in service & accessible in newgamescreen2
    expect(_gameService.newGameViewModel1.name, name);
    expect(_gameService.newGameViewModel1.password, password);
  });
}
