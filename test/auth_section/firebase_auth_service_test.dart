import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:test/test.dart';

import '../mocks/services/mock_firebase_auth.dart';
import '../mocks/navigation/mock_navigation.dart';

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockNavigation = MockNavigation();

  test(
      'if firebase auth error on create account, passes error msg to navigation to display it',
      () {
    final firebaseAuthService =
        FirebaseAuthService(mockFirebaseAuth, mockNavigation);
    final authError = FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'Email already in use, please try again');

    // setup listener to throw auth error
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'tamarigray@gmail.com', password: 'password123'))
        .thenThrow(authError);

    // call function
    firebaseAuthService.createUserAccount(
        'tamarigray@gmail.com', 'password123');

    // check that error message is displayed
    verify(mockNavigation
            .displayError('Email already in use, please try again'))
        .called(1);
  });
  test(
      'if firebase auth error on sign in, passes error msg to navigation to display it',
      () {
    final firebaseAuthService =
        FirebaseAuthService(mockFirebaseAuth, mockNavigation);
    final authError = FirebaseAuthException(
        code: 'user-not-found', message: 'No user found with this email.');

    // setup listener to throw auth error
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'tamarigray@gmail.com', password: 'password123'))
        .thenThrow(authError);

    // call function
    firebaseAuthService.signInWithEmail('tamarigray@gmail.com', 'password123');

    // check that error message is displayed
    verify(mockNavigation.displayError('No user found with this email.'))
        .called(1);
  });
}
