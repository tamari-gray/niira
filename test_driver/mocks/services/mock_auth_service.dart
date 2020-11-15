import 'dart:async';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';
import '../navigation/mock_navigation.dart';

import 'package:meta/meta.dart';

class MockAuthService implements AuthService {
  final StreamController<String> _controller;
  final UserData _mockUserData;
  final MockNavigation _mockNavigation;
  final bool _successfulAuth;

  MockAuthService({
    @required StreamController<String> controller,
    UserData mockUserData,
    MockNavigation mockNavigation,
    bool successfulAuth = true,
  })  : _controller = controller,
        _mockUserData = mockUserData,
        _mockNavigation = mockNavigation,
        _successfulAuth = successfulAuth = true;

  @override
  String get currentUserId => 'uid';

  @override
  Stream<String> get streamOfAuthState => _controller.stream;

  @override
  Future<String> createUserAccount(String email, String password) async {
    if (_successfulAuth) {
      return Future.value('test_user_id');
    } else {
      final errors = ['email in use', 'wronf password'];
      _mockNavigation.displayError(errors[0]);
      return Future.value(null);
    }
  }

  @override
  Future<String> signInWithEmail(String email, String password) async {
    if (_successfulAuth) {
      _controller.add('test_user_id');
      return Future.value('test_user_id');
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
