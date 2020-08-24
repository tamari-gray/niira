import 'dart:async';

import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/navigation_service.dart';

class MockAuthService implements AuthService {
  final StreamController<UserData> _controller;
  final UserData _mockUserData;
  final NavigationService _nav;
  final bool _successfullAuth;

  MockAuthService(
    this._controller,
    this._mockUserData,
    this._nav,
    this._successfullAuth,
  );

  @override
  String get currentUserId => 'uid';

  @override
  Stream<UserData> get streamOfAuthState => _controller.stream;

  @override
  Future<UserData> createUserAccount(String email, String password) async {
    if (_successfullAuth) {
      return Future.value(UserData(
          uid: null,
          displayName: null,
          photoURL: null,
          email: null,
          phoneNumber: null,
          createdOn: null,
          lastSignedInOn: null,
          isAnonymous: null,
          isEmailVerified: null,
          providers: null));
    } else {
      final errors = ['email in use', 'wronf password'];
      _nav.displayError(errors[0]);
      return Future.value(null);
    }
  }

  @override
  Future<UserData> signInWithEmail(String email, String password) async {
    if (_successfullAuth) {
      _controller.add(_mockUserData);

      return Future.value(UserData(
          uid: null,
          displayName: null,
          photoURL: null,
          email: null,
          phoneNumber: null,
          createdOn: null,
          lastSignedInOn: null,
          isAnonymous: null,
          isEmailVerified: null,
          providers: null));
    } else {
      final errors = ['user not found', 'wronf password'];

      _nav.displayError(errors[0]);
      return Future.value(null);
    }
  }

  @override
  Future<void> signOut() {
    _controller.add(null);
    return Future.value();
  }
}
