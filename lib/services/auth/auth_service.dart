import 'package:niira/models/user_data.dart';

/// Implemented by [FirebaseAuthService]
abstract class AuthService {
  Future<String> getCurrentUserId();
  Future<UserData> signInWithEmail(String email, String password);
  Future<void> signOut();
}
