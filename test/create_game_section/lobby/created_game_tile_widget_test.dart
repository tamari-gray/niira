import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/screens/lobby/created_game_tile.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/navigation/mock_navigation.dart';
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
      final navigation = MockNavigation();
      final mockGame = MockGames().gamesToJoin[0];
      final mockdbService = MockDatabaseService();
      // create the widget under test
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Navigation>.value(value: navigation),
            Provider<DatabaseService>.value(value: mockdbService),
          ],
          child: MaterialApp(
            navigatorKey: navigation.navigatorKey,
            home: GameTile(mockGame, 0),
            routes: {
              InputPasswordScreen.routeName: (context) => InputPasswordScreen(),
            },
          ),
        ),
      );

      // find correct game tile
      expect(find.byKey(Key('created_game_tile_${mockGame.id}_index:${0}')),
          findsOneWidget);

      // tap to join a game
      final joinGameBtn =
          find.byKey(Key('join_created_game_tile__btn_${mockGame.id}'));
      expect((joinGameBtn), findsOneWidget);
      await tester.tap(joinGameBtn);
      await tester.pump();

      // check that current game has been set
      // verify(mockGameService.joinGame(any)).called(1);

      // check we navigate to input password screen
      verify(navigation.navigateTo(InputPasswordScreen.routeName)).called(1);
    });
  });
}
