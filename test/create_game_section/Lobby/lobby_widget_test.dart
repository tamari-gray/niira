import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/navigation/navigation.dart';
import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_firebase_platform.dart';
import '../../mocks/services/mock_game_service.dart';
import '../../mocks/services/mock_location_service.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = MockFirebasePlatform();
  });
  testWidgets(
      'shows loading icon + redirects to welcome screen on successfull logout',
      (WidgetTester tester) async {
    // create a controller that the fake auth servive will hold
    final controller = StreamController<UserData>();
    final navigation = Navigation();
    final mockAuthService = MockAuthService(controller: controller);
    final createdGamesStreamContoller = StreamController<List<Game>>();
    final mockDBService =
        MockDatabaseService(controller: createdGamesStreamContoller);
    final mockUserData = MockUser().userData;

    //sign in the user
    controller.add(mockUserData);
    await tester.pumpAndSettle();

    // create the widget under test
    await tester.pumpWidget(MyApp(
      authService: mockAuthService,
      databaseService: mockDBService,
      navigation: navigation,
      locationService: MockLocationService(),
      gameService: FakeGameService(),
    ));

    //ol reliable
    await tester.pumpAndSettle();

    // tap sign out btn
    final signOutBtn = find.byKey(Key('signOutBtn'));
    expect((signOutBtn), findsOneWidget);
    await tester.tap(signOutBtn);
    await tester.pump();

    // confirm sign out
    await tester.tap(find.byKey(Key('confirmBtn')));
    await tester.pumpAndSettle();

    // check the lobby screen is no longer present
    expect(find.text('Lobby'), findsNothing);

    // check that the welcome screen is present
    expect(find.byKey(Key('navigateToCreateAccount')), findsOneWidget);
  });
}
