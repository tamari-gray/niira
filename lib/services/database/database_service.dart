abstract class DatabaseService {
  Future<bool> usernameAlreadyExists(String username);
  Future<void> addUsername(String userId, String username);
}
