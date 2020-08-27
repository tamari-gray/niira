import 'package:niira/models/game.dart';

abstract class DatabaseService {
  Future<bool> usernameAlreadyExists(String username);
  Future<void> addUsername(String userId, String username);
  Stream<List<Game>> get streamOfCreatedGames;
}
