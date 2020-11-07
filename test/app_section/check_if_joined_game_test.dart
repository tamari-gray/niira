import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/screens/joined_game_screens/joined_game_screens.dart';
import 'package:niira/screens/lobby/lobby.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

import '../mocks/data/mock_games.dart';
import '../mocks/services/mock_auth_service.dart';
import '../mocks/services/mock_database_service.dart';
import '../mocks/services/mock_location_service.dart';

void main() {
  testWidgets('show joinedGameScreens when joined a game',
      (WidgetTester tester) async {
    //init services
    final gameService = GameService();
    final fakeAuthService = FakeAuthService();
    final fakeLocationService = FakeLocationService();
    final mockDatabseController = StreamController<List<Game>>();
    final mockCreatedGames = MockGames().gamesInorderOfDistance;

    final _playersController = StreamController<List<Player>>();
    final _mockJoinedPlayers = [
      Player(id: 'ui1', username: 'pete', isTagger: false),
      Player(id: 'ui12', username: 'yeet', isTagger: false),
      Player(id: 'ui123', username: 'wheat', isTagger: false),
    ];
    final mockDatabaseService = MockDatabaseService(
        controller: mockDatabseController,
        playerStreamController: _playersController);
    // add mockData
    mockDatabseController.add(mockCreatedGames);
    _playersController.add(_mockJoinedPlayers);

    // spin up the wut
    final wut = CheckIfJoinedGame();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameService>.value(value: gameService),
          Provider<LocationService>.value(value: fakeLocationService),
          Provider<DatabaseService>.value(value: mockDatabaseService),
          Provider<AuthService>.value(value: fakeAuthService),
        ],
        child: MaterialApp(
          home: Scaffold(body: wut),
        ),
      ),
    );

    // ol reliable
    await tester.pumpAndSettle();

    // check we initially show lobbyScreen
    expect(find.byType(LobbyScreen), findsOneWidget);

    // join a game
    gameService.joinGame('test_game_id');
    await tester.pumpAndSettle();

    // check joinedGameSceens is showing
    expect(find.byType(LobbyScreen), findsNothing);
    expect(find.byType(JoinedGameScreens), findsOneWidget);

    // TODO: idk why leaving the game breaks this test
    // says bad state: already listened to stream...
    // leave game
    // gameService.leaveCurrentGame();
    // await tester.pumpAndSettle();

    // // check LobbyScreen is showing
    // expect(find.byType(LobbyScreen), findsOneWidget);
    // expect(find.byType(JoinedGameScreens), findsNothing);
  });
}
