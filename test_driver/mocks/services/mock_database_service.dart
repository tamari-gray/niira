import 'package:niira/services/database/database_service.dart';

class MockDBService implements DatabaseService {
  Future<bool> usernameAlreadyExists(String username) {}
  Future<void> addUsername(String userId, String username) {}
}
