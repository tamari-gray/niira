/// Implemented by [FirebaseAuthService]
abstract class AuthService {
  String get currentUserId;
  Stream<String> get streamOfAuthState;
  Future<String> signInWithEmail(String email, String password);
  Future<String> createUserAccount(String email, String password);
  Future<void> signOut();
}
