import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';
import '../navigation/mock_navigation.dart';

class FakeAuthService extends Fake implements AuthService {
  @override
  String get currentUserId => 'uid_123';
}

class MockAuthService implements AuthService {
  final StreamController<String> _controller;
  final UserData _mockUserData;
  final FakeNavigation _fakeNavigation;
  final bool _successfulAuth;

  MockAuthService({
    StreamController<String> controller,
    UserData mockUserData,
    FakeNavigation fakeNavigation,
    bool successfulAuth = true,
  })  : _controller = controller,
        _mockUserData = mockUserData,
        _fakeNavigation = fakeNavigation,
        _successfulAuth = successfulAuth = true;

  @override
  String get currentUserId => 'uid123';

  @override
  Stream<String> get streamOfAuthState => _controller.stream;

  @override
  Future<String> createUserAccount(String email, String password) async {
    if (_successfulAuth) {
      return Future.value('test_user_id');
    } else {
      final errors = ['email in use', 'wronf password'];
      _fakeNavigation.displayError(errors[0]);
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
      _fakeNavigation.displayError(errors[0]);
      return Future.value(null);
    }
  }

  @override
  Future<void> signOut() {
    _controller.add(null);
    return Future.value();
  }
}
