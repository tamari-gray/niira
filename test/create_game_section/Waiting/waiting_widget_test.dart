import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/models/player.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/screens/waiting_for_game_to_start.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/navigation_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_nav_service.dart';

void main() {
  testWidgets('show player current tagger when its selected',
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
    final _mockNavigationService = MockNavService();

    // init waiting for game to start screen
    final mockGame = MockGames().gamesToJoin[0];
    await tester.pumpWidget(
      MultiProvider(
          providers: [
            Provider<DatabaseService>.value(value: _mockDatabaseService),
            Provider<NavigationService>.value(value: _mockNavigationService),
          ],
          child: MaterialApp(
              home: WaitingForGameToStartScreen(
            game: mockGame,
          ))),
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
  testWidgets('when tap leave game, pop routes until at lobby',
      (WidgetTester tester) async {
    // init dependant services
    final _controller = StreamController<List<Player>>();
    final _mockDatabaseService =
        MockDatabaseService(playerStreamController: _controller);
    final _mockNavigationService = MockNavService();

    // init waiting for game to start screen
    final mockGame = MockGames().gamesToJoin[0];
    await tester.pumpWidget(
      MultiProvider(providers: [
        Provider<DatabaseService>.value(value: _mockDatabaseService),
        Provider<NavigationService>.value(value: _mockNavigationService),
      ], child: MaterialApp(home: WaitingForGameToStartScreen(game: mockGame))),
    );

    // join a game from lobby

    // input correct password

    // show waiting screen

    //

    await tester.pumpAndSettle();

    // tap quit btn
    final quitButton = find.byKey(Key('waiting_screen_quit_btn'));
    expect((quitButton), findsOneWidget);
    await tester.tap(quitButton);
    await tester.pump();

    // confirm quit
    await tester.tap(find.byKey(Key('confirmBtn')));
    await tester.pumpAndSettle();

    // check the lobby screen is no longer present
    expect(find.byKey(Key('waiting_for_game_to_start_screen')), findsNothing);
    // check that the lobby screen is present
    expect(find.text('Lobby'), findsOneWidget);
  });
}
