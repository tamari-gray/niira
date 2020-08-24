import 'dart:async';

import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';

import '../mock_user_data.dart';

class MockAuthService implements AuthService {
  final StreamController<UserData> _controller;

  MockAuthService(this._controller);

  @override
  String get currentUserId => 'uid';

  @override
  Stream<UserData> get streamOfAuthState => _controller.stream;

  @override
  Future<UserData> createUserAccount(String email, String password) {}

  @override
  Future<UserData> signInWithEmail(String email, String password) {
    final data = MockUser().userData;
    _controller.add(data);
    return Future.value(data);
  }

  @override
  Future<void> signOut() {
    _controller.add(null);
    return Future.value();
  }
}
