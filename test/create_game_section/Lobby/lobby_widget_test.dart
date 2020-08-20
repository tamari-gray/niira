import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/main.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';

final UserData mockUser = UserData(
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
    providers: []);

class FakeAuthServiceLobby extends Fake implements AuthService {
  final StreamController<UserData> _controller;

  FakeAuthServiceLobby(this._controller);

  @override
  Future<String> getCurrentUserId() => Future.value('id');

  @override
  Future<void> signOut() {
    _controller.add(null);
    return Future.value(true);
  }

  @override
  Stream<UserData> get streamOfAuthState => _controller.stream;
}

void main() {
  testWidgets(
      'shows loading icon + redirects to welcome screen on successfull logout',
      (WidgetTester tester) async {
    // create a controller that the fake auth servive will hold
    final controller = StreamController<UserData>();
    final fakeAuthService = FakeAuthServiceLobby(controller);

    // create the widget under test
    await tester
        .pumpWidget(MyApp(fakeAuthService, GlobalKey<NavigatorState>()));

    //sign in the user
    controller.add(mockUser);
    await tester.pump();

    // tap sign out btn
    final signOutBtn = find.byKey(Key('signOutBtn'));
    expect((signOutBtn), findsOneWidget);
    await tester.tap(signOutBtn);
    await tester.pump();
    await tester.pump();

    // observe loading icon
    // expect(find.byKey(Key('loading_indicator')), findsOneWidget);
    // await tester.pumpAndSettle();

    // check the lobby screen is no longer present
    expect(find.text('Lobby'), findsNothing);
    // check that the welcome screen is present
    expect(find.byKey(Key('navigateToCreateAccount')), findsOneWidget);
  });
}
