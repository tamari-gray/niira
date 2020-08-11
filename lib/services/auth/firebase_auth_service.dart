import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';

import 'package:niira/extensions/firebase_user_extensions.dart';
import 'package:niira/services/auth/navigation_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final NavigationService _navService;

  FirebaseAuthService(this._firebaseAuth, this._navService);

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
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user.toData();
    } on PlatformException catch (error) {
      String customErrorMessage;
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          customErrorMessage = 'Invalid email address.';
          break;
        case 'ERROR_WRONG_PASSWORD':
          customErrorMessage = 'Wrong password for this account.';
          break;
        case 'ERROR_USER_NOT_FOUND':
          customErrorMessage = 'No user found with this email.';
          break;
        case 'ERROR_USER_DISABLED':
          customErrorMessage = 'User with this email has been disabled.';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          customErrorMessage = 'Too many requests. Try again later.';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          customErrorMessage =
              'Signing in with Email and Password is not enabled.';
          break;
        default:
          customErrorMessage = 'An undefined Error happened.';
      }
      _navService.displayError(customErrorMessage);

      return null;
    } catch (e) {
      // non platform specific errors
      print('caught error: $e');
      _navService.displayError(e);
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
