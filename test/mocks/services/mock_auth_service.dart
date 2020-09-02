import 'dart:async';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';
import '../navigation/mock_navigation.dart';

import 'package:meta/meta.dart';

class MockAuthService implements AuthService {
  final StreamController<UserData> _controller;
  final UserData _mockUserData;
  final MockNavigation _mockNavigation;
  final bool _successfulAuth;

  MockAuthService({
    @required StreamController<UserData> controller,
    UserData mockUserData,
    MockNavigation mockNavigation,
    bool successfulAuth = true,
  })  : _controller = controller,
        _mockUserData = mockUserData,
        _mockNavigation = mockNavigation,
        _successfulAuth = successfulAuth = true;

  @override
  String get currentUserId => 'uid123';

  @override
  Stream<UserData> get streamOfAuthState => _controller.stream;

  @override
  Future<UserData> createUserAccount(String email, String password) async {
    if (_successfulAuth) {
      return Future.value(_mockUserData);
    } else {
      final errors = ['email in use', 'wronf password'];
      _mockNavigation.displayError(errors[0]);
      return Future.value(null);
    }
  }

  @override
  Future<UserData> signInWithEmail(String email, String password) async {
    if (_successfulAuth) {
      _controller.add(_mockUserData);
      return Future.value(_mockUserData);
    } else {
      final errors = ['user not found', 'wronf password'];
      _mockNavigation.displayError(errors[0]);
      return Future.value(null);
    }
  }

  @override
  Future<void> signOut() {
    _controller.add(null);
    return Future.value();
  }
}
