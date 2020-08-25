import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/lobby.dart';
import 'package:provider/provider.dart';

import '../../app_section/widget_test.dart';
import 'package:niira/services/navigation_service.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';

void main() {
  final mockUserData = MockUser().userData;

  group('joining a game', () {
    testWidgets(
        'find a list of created games, tap to join ad navigate to inputPassword page',
        (WidgetTester tester) async {
      final controller = StreamController<List<Game>>();
      final mockDBService = MockDBService(controller: controller);

      // init lobby page
      await tester.pumpWidget(
        Provider<Stream<List<Game>>>(
          create: (_) => mockDBService.streamOfCreatedGames,
        ),
      );

      // pump mock data
      final mockCreatedGames = MockGames().gamesToJoin;
      controller.add(mockCreatedGames);

      // observe list of games

      // tap to join a game

      // observe navigation to input password screen
    });
  });
  testWidgets(
      'shows loading icon + redirects to welcome screen on successfull logout',
      (WidgetTester tester) async {
    // create a controller that the fake auth servive will hold
    final controller = StreamController<UserData>();
    final navService = NavigationService();
    final fakeAuthService = MockAuthService(controller: controller);
    final fakeDBService = FakeDatabaseService();

    // create the widget under test
    await tester.pumpWidget(
      MyApp(
          fakeAuthService, navService.navigatorKey, fakeDBService, navService),
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
    await tester.tap(find.byKey(Key('confirmBtn')));
    await tester.pumpAndSettle();

    // check the lobby screen is no longer present
    expect(find.text('Lobby'), findsNothing);
    // check that the welcome screen is present
    expect(find.byKey(Key('navigateToCreateAccount')), findsOneWidget);
  });
}
