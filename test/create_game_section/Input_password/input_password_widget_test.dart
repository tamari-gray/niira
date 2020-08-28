import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/navigation_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';

void main() {
  testWidgets('back btn pops back to lobby', () {});
  group('unsuccessfull password submission', () {
    testWidgets('show error message when incorrect password is submitted',
        (WidgetTester tester) async {
      final _controller = StreamController<List<Game>>();
      final mockCreatedGames = MockGames().gamesToJoin;

      _controller.add(mockCreatedGames);
      final mockDatabaseService = MockDatabaseService(controller: _controller);

      // init lobby page
      await tester.pumpWidget(
        MultiProvider(providers: [
          Provider<DatabaseService>.value(value: mockDatabaseService),
        ], child: MaterialApp(home: LobbyScreen())),
      );

      // ol reliable
      await tester.pumpAndSettle();

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

  group('successfull password submission', () {
    testWidgets('add player to game in firestore ', () {});
  });
}
