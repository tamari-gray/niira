import 'package:niira/models/user_data.dart';

/// Implemented by [FirebaseAuthService]
abstract class AuthService {
  Future<String> getCurrentUserId();
  Stream<UserData> get streamOfAuthState;
  Future<UserData> signInWithEmail(String email, String password);
  Future<UserData> createUserAccount(String email, String password);
  Future<void> signOut();
}
