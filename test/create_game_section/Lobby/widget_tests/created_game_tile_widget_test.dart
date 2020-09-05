import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/screens/Lobby/created_game_tile.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:provider/provider.dart';

import '../../../mocks/data/mock_games.dart';
import '../../../mocks/services/mock_firebase_platform.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = MockFirebasePlatform();
  });
  group('joining a game', () {
    testWidgets('tap join game and navigate to input password screen',
        (WidgetTester tester) async {
      // init services
      final navigation = Navigation();
      final mockGame = MockGames().gamesToJoin[0];
      // create the widget under test
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<Navigation>.value(value: navigation),
          ],
          child: MaterialApp(
            home: GameTile(mockGame, 0),
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
      await tester.pumpAndSettle();

      // observe navigation to input password screen
      expect(find.byKey(Key('inputPasswordScreen')), findsOneWidget);
    });
  });
}
