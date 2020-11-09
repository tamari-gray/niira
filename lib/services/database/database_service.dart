import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/models/user_data.dart';

abstract class DatabaseService {
  Future<bool> usernameAlreadyExists(String username);
  Future<void> addUsername(String userId, String username);
  Future<String> getUserName(String userId);
  Stream<List<Game>> get streamOfCreatedGames;
  Stream<List<Player>> streamOfJoinedPlayers(String gameId);
  Future<void> joinGame(String gameId, String userId);
  Future<void> leaveGame(String gameId, String userId);
  Future<String> createGame(Game game, String userId);
  Future<Game> currentGame(String gameId);
  Stream<Game> streamOfJoinedGame(String gameId);
  Future<void> chooseTagger(String playerId, String gameId);
  Future<void> unSelectTagger(String playerId, String gameId);
  Stream<UserData> userData(String userId);
  Future<void> adminQuitCreatingGame(String gameId);
  Future<String> currentGameId(String userId);
  Future<bool> checkIfAdmin(String userId);
  Future<void> startGame(String userId);
}
