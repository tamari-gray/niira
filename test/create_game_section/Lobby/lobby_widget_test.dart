import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/main.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/auth/auth_service.dart';

import '../../app_section/widget_test.dart';
import '../../mocks/mock_user_data.dart';

class FakeAuthServiceLobby extends Fake implements AuthService {
  final StreamController<UserData> _controller;

  FakeAuthServiceLobby(this._controller);

  @override
  Future<void> signOut() {
    _controller.add(null);
    return Future.value(true);
  }

  @override
  Stream<UserData> get streamOfAuthState => _controller.stream;
}

void main() {
  final mockUserData = MockUser().userData;
  testWidgets(
      'shows loading icon + redirects to welcome screen on successfull logout',
      (WidgetTester tester) async {
    // create a controller that the fake auth servive will hold
    final controller = StreamController<UserData>();
    final fakeAuthService = FakeAuthServiceLobby(controller);
    final fakeDBService = FakeDatabaseService();

    // create the widget under test
    await tester.pumpWidget(
      MyApp(fakeAuthService, GlobalKey<NavigatorState>(), fakeDBService),
    );

    //sign in the user
    controller.add(mockUserData);
    await tester.pump();

    // tap sign out btn
    final signOutBtn = find.byKey(Key('signOutBtn'));
    expect((signOutBtn), findsOneWidget);
    await tester.tap(signOutBtn);
    await tester.pump();

    // confirm sign out
    await tester.tap(find.byKey(Key('confirmSignOutBtn')));
    await tester.pumpAndSettle();

    // check the lobby screen is no longer present
    expect(find.text('Lobby'), findsNothing);
    // check that the welcome screen is present
    expect(find.byKey(Key('navigateToCreateAccount')), findsOneWidget);
  });
}
