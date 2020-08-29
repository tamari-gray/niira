import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';

void main() {
  group('on unsuccessfull password submission', () {
    testWidgets('show error message when incorrect password is submitted',
        (WidgetTester tester) async {
      final _authController = StreamController<UserData>();
      final _mockAuthService = MockAuthService(controller: _authController);
      final _mockDatabaseService = MockDatabaseService();
      final mockGame = Game(
          id: 'mock_game_123',
          name: null,
          creatorName: null,
          sonarIntervals: null,
          password: 'test_password',
          boundary: null,
          phase: null);

      // init input password page
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<AuthService>.value(value: _mockAuthService),
          Provider<DatabaseService>.value(value: _mockDatabaseService),
        ],
        child: MaterialApp(
          home: InputPasswordScreen(
            game: mockGame,
          ),
        ),
      ));

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
      final _authController = StreamController<UserData>();
      final _mockAuthService = MockAuthService(controller: _authController);
      final _databaseController = StreamController<List<Game>>();
      final _mockDatabaseService =
          MockDatabaseService(controller: _databaseController);
      final mockGame = Game(
          id: 'mock_game_123',
          name: null,
          creatorName: null,
          sonarIntervals: null,
          password: 'test_password',
          boundary: null,
          phase: null);

      // init input password page
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<AuthService>.value(value: _mockAuthService),
          Provider<DatabaseService>.value(value: _mockDatabaseService),
        ],
        child: MaterialApp(
          home: InputPasswordScreen(
            game: mockGame,
          ),
        ),
      ));

      // tap and join a game
      await tester.enterText(
          find.byKey(Key('input_password_screen_text_feild')), 'test_password');
      await tester.tap(find.byKey(Key('input_password_screen_submit_btn')));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // check user has been added to game
      verify(_mockDatabaseService.joinGame(any, any)).called(1);

      // navigate to waiting screen
      expect(
          find.byKey(Key('waiting_for_game_to_start_screen')), findsOneWidget);
    });
  });
}
