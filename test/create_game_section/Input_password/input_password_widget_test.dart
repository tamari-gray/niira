import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/navigation/mock_navigation.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';

void main() {
  group('on unsuccessfull password submission', () {
    testWidgets('show error message when incorrect password is submitted',
        (WidgetTester tester) async {
      final _authController = StreamController<String>();
      final _mockAuthService = MockAuthService(controller: _authController);
      final _mockDatabaseService = MockDatabaseService();
      // final _gameService = GameService();
      // _gameService.currentGameId = 'test_game_id';

      // init input password page
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<AuthService>.value(value: _mockAuthService),
          Provider<DatabaseService>.value(value: _mockDatabaseService),
        ],
        child: MaterialApp(
          home: InputPasswordScreen(),
        ),
      ));

      // ol reliable
      await tester.pump();

      // tap to join a game
      final passwordFeild = find.byKey(Key('input_password_screen_text_feild'));
      expect((passwordFeild), findsOneWidget);
      await tester.enterText(passwordFeild, 'incorrectPassword');
      await tester.tap(find.byKey(Key('input_password_screen_submit_btn')));
      await tester.pumpAndSettle();

      // show error message
      expect(find.text('Password is incorrect'), findsOneWidget);
    });
  });

  group('on successfull password submission', () {
    testWidgets(
        'add player to the game in firestore then navigate to waiting screen ',
        (WidgetTester tester) async {
      final _fakeAuthService = FakeAuthService();
      final _databaseController = StreamController<List<Game>>();
      final _playerStreamController = StreamController<List<Player>>();
      final _mockDatabaseService = MockDatabaseService(
          controller: _databaseController,
          playerStreamController: _playerStreamController);
      final _mockNavigation = MockNavigation();
      // _mockGameService.currentGameId = 'test_game_123';

      await tester.pumpAndSettle();

      // init input password page
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<AuthService>.value(value: _fakeAuthService),
          Provider<DatabaseService>.value(value: _mockDatabaseService),
          Provider<Navigation>.value(value: _mockNavigation),
        ],
        child: MaterialApp(
          home: InputPasswordScreen(),
        ),
      ));

      // ol reliable
      await tester.pump();

      // check inputPasswordScreen is showing
      final inputPasswordScreenTextField =
          find.byKey(Key('input_password_screen_text_feild'));
      expect(inputPasswordScreenTextField, findsOneWidget);

      // tap and join a game
      await tester.enterText(inputPasswordScreenTextField, 'password123');
      await tester.tap(find.byKey(Key('input_password_screen_submit_btn')));
      await tester.pump();

      // check user has been added to game
      verify(_mockDatabaseService.joinGame(any, any)).called(1);

      // check we remove current navigation stack
      verify(_mockNavigation.popUntilLobby()).called(1);

      // check we tell local state that user has joined a game
      // verify(_mockGameService.joinGame(any)).called(1);
    });
  });

  testWidgets('user exits InputPasswordScreen', (WidgetTester tester) async {
    final _authController = StreamController<String>();
    final _mockAuthService = MockAuthService(controller: _authController);
    final _mockDatabaseService = MockDatabaseService();
    final _mockNavigation = MockNavigation();
    // _mockGameService.currentGameId = 'test_game_id';

    // init input password page
    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<AuthService>.value(value: _mockAuthService),
        Provider<DatabaseService>.value(value: _mockDatabaseService),
        Provider<Navigation>.value(value: _mockNavigation),
      ],
      child: MaterialApp(
        home: InputPasswordScreen(),
      ),
    ));

    // ol reliable
    await tester.pump();

    // tap to cancel joining game
    await tester.tap(find.text('Cancel'));

    // check that we pop all routes
    verify(_mockNavigation.popUntilLobby()).called(1);

    // check that we update local state
    // verify(_mockGameService.leaveCurrentGame()).called(1);
  });
}
