import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/screens/waiting_for_game_to_start.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/navigation_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/data/mock_games.dart';
import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_nav_service.dart';

void main() {
  testWidgets('show player current tagger when its selected',
      (WidgetTester tester) async {
    final _controller = StreamController<List<Player>>();

    final _mockJoinedPlayers = [
      Player(username: 'pete', isTagger: false),
      Player(username: 'yeet', isTagger: false),
      Player(username: 'wheat', isTagger: false),
    ];
    _controller.add(_mockJoinedPlayers);
    final mockDatabaseService =
        MockDatabaseService(playerStreamController: _controller);
    final _mockNavigationService = MockNavService();

    // init lobby page
    final mockGame = MockGames().gamesToJoin[0];
    await tester.pumpWidget(
      MultiProvider(
          providers: [
            Provider<DatabaseService>.value(value: mockDatabaseService),
            Provider<NavigationService>.value(value: _mockNavigationService),
          ],
          child: MaterialApp(
              home: WaitingForGameToStartScreen(
            game: mockGame,
          ))),
    );

    // observe list of joined players
    expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[0].id}')),
        findsOneWidget);
    expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[1].id}')),
        findsOneWidget);
    expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[2].id}')),
        findsOneWidget);

    // choose tagger
    final _mockJoinedPlayersWithTagger = [
      Player(username: 'pete', isTagger: false),
      Player(username: 'yeet', isTagger: true),
      Player(username: 'wheat', isTagger: false),
    ];
    _controller.add(_mockJoinedPlayersWithTagger);

    // show player tagger has been chosen
  });
  testWidgets('when tap leave game, pop routes until at lobby',
      (WidgetTester tester) async {
    // create a controller that the fake auth servive will hold
    final controller = StreamController<UserData>();
    final navService = NavigationService();
    final mockAuthService = MockAuthService(controller: controller);
    final createdGamesStreamContoller = StreamController<List<Game>>();
    final mockDBService =
        MockDatabaseService(controller: createdGamesStreamContoller);
    final mockUserData = MockUser().userData;

    //sign in the user
    controller.add(mockUserData);
    // create the widget under test
    await tester.pumpWidget(
      MyApp(
        mockAuthService,
        navService.navigatorKey,
        mockDBService,
        navService,
      ),
    );

    await tester.pumpAndSettle();

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
