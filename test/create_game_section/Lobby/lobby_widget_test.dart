import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:provider/provider.dart';

import 'package:niira/services/navigation_service.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';

class MockFirebaseInstance extends Mock implements FirebaseFirestore {}

void main() {
  group('joining a game', () {
    testWidgets(
        'find a list of created games, tap to join ad navigate to inputPassword page',
        (WidgetTester tester) async {
      // final _controller = StreamController<List<Game>>();
      final mockCreatedGames = MockGames().gamesToJoin;
      // print('mock created games: $moc');

      final mockFirebaseInstance = MockFirebaseInstance();
      final firestoreService = FirestoreService(mockFirebaseInstance);
      // pump mock data
      // _controller.add(mockCreatedGames);

      // init lobby page
      await tester.pumpWidget(
        MultiProvider(providers: [
          Provider<DatabaseService>.value(value: firestoreService),
        ], child: MaterialApp(home: LobbyScreen())),
      );
      // _controller.add(mockCreatedGames);

      // observe list of created games
      expect(find.byKey(Key('created_game_tile_${mockCreatedGames[0].id}')),
          findsOneWidget);
      expect(find.byKey(Key('created_game_tile_${mockCreatedGames[1].id}')),
          findsOneWidget);
      expect(find.byKey(Key('created_game_tile_${mockCreatedGames[2].id}')),
          findsOneWidget);

      // tap to join a game
      final joinGameBtn = find
          .byKey(Key('join_created_game_tile__btn_${mockCreatedGames[0].id}'));
      expect((joinGameBtn), findsOneWidget);
      await tester.tap(joinGameBtn);
      await tester.pumpAndSettle();

      // observe navigation to input password screen
      expect(find.byKey(Key('inputPasswordScreen')), findsOneWidget);
    });
  });
  testWidgets(
      'shows loading icon + redirects to welcome screen on successfull logout',
      (WidgetTester tester) async {
    // create a controller that the fake auth servive will hold
    final controller = StreamController<UserData>();
    final navService = NavigationService();
    final mockAuthService = MockAuthService(controller: controller);
    final mockDBService = MockDBService();
    final mockUserData = MockUser().userData;

    // create the widget under test
    await tester.pumpWidget(
      MyApp(
        mockAuthService,
        navService.navigatorKey,
        mockDBService,
        navService,
      ),
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
