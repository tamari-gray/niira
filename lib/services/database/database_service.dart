import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';

abstract class DatabaseService {
  Future<bool> usernameAlreadyExists(String username);
  Future<void> addUsername(String userId, String username);
  Future<String> getUserName(String userId);
  Stream<List<Game>> get streamOfCreatedGames;
  Stream<List<Player>> streamOfJoinedPlayers(String gameId);
  Future<void> joinGame(String gameId, String userId, bool isAdmin);
  Future<void> leaveGame(String gameId, String userId);
  Future<String> createGame(Game game, String userId);
  Stream<Game> streamOfJoinedGame(String gameId);
}
