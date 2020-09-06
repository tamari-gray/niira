import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/screens/Lobby/list_of_created_games.dart';
import 'package:niira/screens/Lobby/created_game_tile.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

import '../../../mocks/data/mock_games.dart';
import '../../../mocks/services/mock_database_service.dart';
import '../../../mocks/services/mock_location_service.dart';
import '../../../mocks/services/mock_firebase_platform.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = MockFirebasePlatform();
  });
  testWidgets(
      'show list of games in order of distance from user (nearest to furtherest)',
      (WidgetTester tester) async {
    // init services
    final navigation = Navigation();
    final mockLocationService = MockLocationService();
    final mockDatabseController = StreamController<List<Game>>();
    final mockCreatedGames = MockGames().gamesInorderOfDistance;
    final mockDatabaseService =
        MockDatabaseService(controller: mockDatabseController);
    final mockUserLocation =
        Location(latitude: -37.865351, longitude: 144.989012);

    // add mockGames
    mockDatabseController.add(mockCreatedGames);
    await tester.pumpAndSettle();

    // create the widget under test
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<Navigation>.value(value: navigation),
          Provider<LocationService>.value(value: mockLocationService),
          Provider<DatabaseService>.value(value: mockDatabaseService)
        ],
        child: MaterialApp(
          home: ListOfCreatedGames(mockUserLocation),
        ),
      ),
    );

    // find empty screen while waiting for stream of created games
    expect(
        find.byKey(Key('list_of_created_games_empty_screen')), findsOneWidget);

    // ol reliable
    await tester.pumpAndSettle();

    // show correct widgets
    expect(find.byKey(Key('list_of_created_games_empty_screen')), findsNothing);
    expect(find.byType(GameTile), findsNWidgets(3));

    /// show list of created games inorder of distance from user.
    /// when building game tile, we are giving it an 'index' property,
    /// to help test that they are rendered in correct order
    expect(
      find.byKey(Key('created_game_tile_${mockCreatedGames[0].id}_index:${0}')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('created_game_tile_${mockCreatedGames[1].id}_index:${1}')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('created_game_tile_${mockCreatedGames[2].id}_index:${2}')),
      findsOneWidget,
    );
  });
}
