import 'package:firebase_auth/firebase_auth.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';

import 'package:niira/extensions/firebase_user_extensions.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  @override
  Future<String> getCurrentUserId() async {
    final user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  @override
  Stream<UserData> get streamOfAuthState => _firebaseAuth.onAuthStateChanged
      .map((firebaseUser) => firebaseUser.toData());

  @override
  Future<UserData> signInWithEmail(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult.user.toData();
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
