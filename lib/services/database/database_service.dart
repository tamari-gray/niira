import 'package:niira/models/game.dart';

abstract class DatabaseService {
  Future<bool> usernameAlreadyExists(String username);
  Future<void> addUsername(String userId, String username);
  Future<String> getUserName(String userId);
  Stream<List<Game>> get streamOfCreatedGames;
  Future<void> joinGame(String gameId, String userId);
}
