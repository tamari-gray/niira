import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/screens/lobby/created_game_tile.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/navigation/mock_navigation.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_firebase_platform.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = MockFirebasePlatform();
  });
  group('joining a game', () {
    testWidgets('tap join game and navigate to input password screen',
        (WidgetTester tester) async {
      // init services
      final mockGame = MockGames().gamesToJoin[0];
      final _fakeAuthService = FakeAuthService();
      final _databaseController = StreamController<List<Game>>();
      final _playerStreamController = StreamController<List<Player>>();
      final mockCurrentGameController = StreamController<Game>();
      final _mockDatabaseService = MockDatabaseService(
        controller: _databaseController,
        playerStreamController: _playerStreamController,
        currentGame: mockCurrentGameController,
      );
      final _mockNavigation = MockNavigation();

      // add game to stream
      mockCurrentGameController.add(mockGame);

      // init input password page
      await tester.pumpWidget(MultiProvider(
        providers: [
          Provider<AuthService>.value(value: _fakeAuthService),
          Provider<DatabaseService>.value(value: _mockDatabaseService),
          Provider<Navigation>.value(value: _mockNavigation),
        ],
        child: MaterialApp(
          navigatorKey: _mockNavigation.navigatorKey,
          routes: {
            InputPasswordScreen.routeName: (context) => InputPasswordScreen()
          },
          home: GameTile(mockGame, 0),
        ),
      ));

      // find correct game tile
      expect(find.byKey(Key('created_game_tile_${mockGame.id}_index:${0}')),
          findsOneWidget);

      // tap to join a game
      final joinGameBtn =
          find.byKey(Key('join_created_game_tile__btn_${mockGame.id}'));
      expect((joinGameBtn), findsOneWidget);
      await tester.tap(joinGameBtn);
      await tester.pumpAndSettle();

      // check we navigate to input password screen
      verify(_mockNavigation.navigateTo(InputPasswordScreen.routeName,
              gameId: 'test_game_123'))
          .called(1);
    });
  });
}
