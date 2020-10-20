import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/screens/lobby/lobby.dart';
import 'package:niira/screens/waiting_screen/waiting_for_game_to_start.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/navigation/mock_navigation.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_game_service.dart';

void main() {
  testWidgets('after admin choose tagger, show user the chosen tagger',
      (WidgetTester tester) async {
    // add mock list of joined players to mock database
    final _controller = StreamController<List<Player>>();
    final _mockJoinedPlayers = [
      Player(id: 'ui1', username: 'pete', isTagger: false),
      Player(id: 'ui12', username: 'yeet', isTagger: false),
      Player(id: 'ui123', username: 'wheat', isTagger: false),
    ];
    _controller.add(_mockJoinedPlayers);

    // setup dependant services
    final _mockDatabaseService =
        MockDatabaseService(playerStreamController: _controller);
    final _fakeGameService = FakeGameService();
    final _navigation = Navigation();

    // init waiting for game to start screen
    final mockGame = MockGames().gamesToJoin[0];
    _fakeGameService.currentGame = mockGame;
    await tester.pumpWidget(
      MultiProvider(providers: [
        Provider<DatabaseService>.value(value: _mockDatabaseService),
        Provider<Navigation>.value(value: _navigation),
        ChangeNotifierProvider<GameService>.value(value: _fakeGameService)
      ], child: MaterialApp(home: WaitingForGameToStartScreen())),
    );

    // ensure stream has recieved data
    await tester.pumpAndSettle();

    // observe list of joined players
    expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[0].id}')),
        findsOneWidget);
    expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[1].id}')),
        findsOneWidget);
    expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[2].id}')),
        findsOneWidget);

    // mock admin choose a tagger by updating stream
    final _mockJoinedPlayersWithTagger = [
      Player(id: 'ui1', username: 'pete', isTagger: false),
      Player(id: 'ui12', username: 'yeet', isTagger: true),
      Player(id: 'ui123', username: 'wheat', isTagger: false),
    ];
    _controller.add(_mockJoinedPlayersWithTagger);
    await tester.pumpAndSettle();

    // show user tagger has been chosen
    expect(find.byKey(Key('tagger_tile_${_mockJoinedPlayers[1].id}')),
        findsOneWidget);
  });
  testWidgets('when tap leave game, pop routes until at first route',
      (WidgetTester tester) async {
    // init dependant services
    final _playerStreamController = StreamController<List<Player>>();
    final _gameStreamController = StreamController<List<Game>>();
    final _mockDatabaseService =
        MockDatabaseService(playerStreamController: _playerStreamController);
    final _navigation = Navigation();
    final _authService = MockAuthService();
    final _fakeGameService = FakeGameService();
    _fakeGameService.currentGame = MockGames().gamesToJoin[0];

    // init waiting for game to start screen
    final mockGames = MockGames().gamesToJoin;
    _gameStreamController.add(mockGames);
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<DatabaseService>.value(value: _mockDatabaseService),
          Provider<Navigation>.value(value: _navigation),
          Provider<GameService>.value(value: _fakeGameService),
          Provider<AuthService>.value(value: _authService)
        ],
        child: MaterialApp(
            navigatorKey: _navigation.navigatorKey,
            home: WaitingForGameToStartScreen()),
      ),
    );

    // tap quit btn
    final quitButton = find.byKey(Key('waiting_screen_quit_btn'));
    expect((quitButton), findsOneWidget);
    await tester.tap(quitButton);
    await tester.pumpAndSettle();

    // confirm quit
    final confirmButton = find.byKey(Key('confirmBtn'));
    expect((confirmButton), findsOneWidget);

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    // check that we are navigating to the initial route
    // verify(_mockNavigation.popUntilLobby()).called(1);
    // expect(_navigation.navigatorKey.currentWidget, matcher)
  });
}
