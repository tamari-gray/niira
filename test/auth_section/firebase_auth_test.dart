import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/auth/navigation_service.dart';
import 'package:test/test.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockNavService extends Mock implements NavigationService {}

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockNav = MockNavService();
  test('if firebase auth error, passes error msg to navService to display it',
      () {
    final firebaseAuthService = FirebaseAuthService(mockFirebaseAuth, mockNav);
    final authError = PlatformException(
      code: 'ERROR_USER_NOT_FOUND',
    );

    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'tamarigray@gmail.com', password: 'password123'))
        .thenThrow(authError);
    firebaseAuthService.signInWithEmail('tamarigray@gmail.com', 'password123');

    verify(mockNav.displayError('No user found with this email.')).called(1);
  });
}
