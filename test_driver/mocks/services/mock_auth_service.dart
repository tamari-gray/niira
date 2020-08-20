import 'dart:async';

import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';

class MockAuthService implements AuthService {
  final StreamController<UserData> _controller;

  MockAuthService(this._controller);

  @override
  Future<String> getCurrentUserId() => Future.value('uid');

  @override
  Stream<UserData> get streamOfAuthState => _controller.stream;

  @override
  Future<UserData> createUserAccount(String email, String password) {}

  @override
  Future<UserData> signInWithEmail(String email, String password) {
    final data = UserData(
        uid: 'uid',
        providerId: 'provideId',
        displayName: 'name',
        photoUrl: 'url',
        email: email,
        phoneNumber: '123',
        createdOn: DateTime.now(),
        lastSignedInOn: DateTime.now(),
        isAnonymous: false,
        isEmailVerified: false,
        providers: []);
    _controller.add(data);
    return Future.value(data);
  }

  @override
  Future<void> signOut() {
    _controller.add(null);
    return Future.value();
  }
}
