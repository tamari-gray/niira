import 'package:niira/models/game.dart';
import 'package:niira/models/view_models/create_game1.dart';
import 'package:niira/models/view_models/create_game2.dart';

class GameService {
  Game currentGame;
  final createGameViewModel1 = CreateGameViewModel1();

  GameService({this.currentGame});

  Game createGameData(
          CreateGameViewModel2 vm2, String userId, String username) =>
      Game(
        id: '',
        name: createGameViewModel1.name,
        password: createGameViewModel1.password,
        adminName: username,
        adminId: userId,
        sonarIntervals: vm2.sonarIntervals,
        boundaryPosition: vm2.boundaryPosition,
        boundarySize: vm2.boundarySize,
        phase: GamePhase.created,
      );
}
