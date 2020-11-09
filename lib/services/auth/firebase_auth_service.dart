import 'package:firebase_auth/firebase_auth.dart';
import 'package:niira/services/auth/auth_service.dart';

import 'package:niira/navigation/navigation.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final Navigation _navigation;

  FirebaseAuthService(this._firebaseAuth, this._navigation);

  @override
  String get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Stream<String> get streamOfAuthState =>
      _firebaseAuth.authStateChanges().map((firebaseUser) => firebaseUser.uid);

  @override
  Future<String> createUserAccount(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user.uid;
    } on FirebaseAuthException catch (error) {
      String customErrorMessage;
      switch (error.code) {
        case 'weak-password':
          customErrorMessage = 'password is too weak.';
          break;
        case 'invalid-email':
          customErrorMessage = 'Invalid email address';
          break;
        case 'email-already-in-use':
          customErrorMessage = 'Email already in use, please try again';
          break;
        case 'operation-not-allowed:':
          customErrorMessage = 'authentication error, operation not allowed';
          break;
        default:
          customErrorMessage = 'An undefined Error happened.';
      }
      _navigation.displayError(customErrorMessage);
      return null;
    } catch (e) {
      // non platform specific errors
      print('caught error: $e');
      _navigation.displayError(e);
      return null;
    }
  }

  @override
  Future<String> signInWithEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user.uid;
    } on FirebaseAuthException catch (error) {
      String customErrorMessage;
      switch (error.code) {
        case 'invalid-email':
          customErrorMessage = 'Invalid email address.';
          break;
        case 'wrong-password':
          customErrorMessage = 'Wrong password for this account.';
          break;
        case 'user-not-found':
          customErrorMessage = 'No user found with this email.';
          break;
        case 'user-disabled':
          customErrorMessage = 'User with this email has been disabled.';
          break;
        default:
          customErrorMessage = 'An undefined Error happened.';
      }
      _navigation.displayError(customErrorMessage);

      return null;
    } catch (e, trace) {
      // non platform specific errors
      print('caught unknown firebase auth error: $e');
      print('stacktrace of error: $trace');
      _navigation.displayError('unkown error occured');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _navigation.displayError(e);
    }
  }
}
