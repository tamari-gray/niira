import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/lobby/lobby.dart';
import 'package:niira/screens/lobby/list_of_created_games.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_game_service.dart';
import '../../mocks/services/mock_location_service.dart';
import '../../mocks/services/mock_firebase_platform.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = MockFirebasePlatform();
  });
  testWidgets(
      'show loading icon until have users location, then show list of created games ',
      (WidgetTester tester) async {
    // init services
    final controller = StreamController<UserData>();
    final navigation = Navigation();
    final mockAuthService = MockAuthService(controller: controller);
    final mockLocationService = MockLocationService();
    final mockGameService = FakeGameService();
    final mockDatabseController = StreamController<List<Game>>();
    final mockDatabaseService =
        MockDatabaseService(controller: mockDatabseController);

    // create the widget under test
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthService>.value(value: mockAuthService),
          Provider<Navigation>.value(value: navigation),
          Provider<LocationService>.value(value: mockLocationService),
          Provider<DatabaseService>.value(value: mockDatabaseService),
          Provider<GameService>.value(value: mockGameService),
        ],
        child: MaterialApp(
          home: LobbyScreen(),
        ),
      ),
    );

    // show loading icon
    expect(find.byKey(Key('loading_indicator')), findsOneWidget);

    // get users location
    await tester.pumpAndSettle();

    // show list of created games
    expect(find.byType(ListOfCreatedGames), findsOneWidget);
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
    final mockLocationService = MockLocationService();
    final mockUserData = MockUser().userData;

    // create the widget under test
    await tester.pumpWidget(MyApp(
      authService: mockAuthService,
      databaseService: mockDBService,
      locationService: mockLocationService,
      navigation: navigation,
    ));

    //sign in the user
    controller.add(mockUserData);
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
