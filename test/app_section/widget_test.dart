import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';

class FakeAuthService implements AuthService {
  final StreamController<UserData> _controller;

  FakeAuthService(this._controller);

  @override
  Future<String> getCurrentUserId() => Future.value('id');

  @override
  Future<UserData> createUserAccount(String email, String password) {}

  @override
  Future<UserData> signInWithEmail(String email, String password) =>
      Future.value(UserData(
          uid: 'uid',
          providerId: 'google.com',
          displayName: 'name',
          photoUrl: 'url',
          email: 'email@gmail.com',
          phoneNumber: '123',
          createdOn: DateTime.now(),
          lastSignedInOn: DateTime.now(),
          isAnonymous: true,
          isEmailVerified: true,
          providers: []));

  @override
  Future<void> signOut() => Future.value();

  @override
  Stream<UserData> get streamOfAuthState => _controller.stream;
}

void main() {
  group('MyApp ', () {
    testWidgets('navigates to correct route based on auth state',
        (WidgetTester tester) async {
      // create a controller that the fake auth servive will hold
      final controller = StreamController<UserData>();
      final fakeAuthService = FakeAuthService(controller);
      controller.add(null);

      // create the widget under test
      await tester
          .pumpWidget(MyApp(fakeAuthService, GlobalKey<NavigatorState>()));

      // check the welcome screen is present
      expect(find.byKey(Key('navigateToCreateAccount')), findsOneWidget);

      // get a user data object and make the service emit it
      final userData = await fakeAuthService.signInWithEmail('a', 'b');
      controller.add(userData);

      await tester.pump();

      // check the welcome screen is no longer present
      expect(find.byKey(Key('navigateToCreateAccount')), findsNothing);
      // check that the lobby screen is present
      expect(find.text('Lobby'), findsOneWidget);
    });
  });
}
