// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:niira/models/player.dart';
// import 'package:niira/navigation/navigation.dart';
// import 'package:niira/screens/joined_game_screens/waiting_screen/waiting_for_game_to_start.dart';
// import 'package:niira/services/auth/auth_service.dart';
// import 'package:niira/services/database/database_service.dart';
// import 'package:provider/provider.dart';
// import '../../mocks/services/mock_auth_service.dart';
// import '../../mocks/services/mock_database_service.dart';

void main() {
  testWidgets('after admin choose tagger, show user the chosen tagger',
      (WidgetTester tester) async {
    // // add mock list of joined players to mock database
    // final _mockJoinedPlayerscontroller = StreamController<List<Player>>();
    // final _mockJoinedPlayers = [
    //   Player(
    //       id: 'ui1',
    //       username: 'pete',
    //       isTagger: false,
    //       hasBeenTagged: false,
    //       hasItem: false),
    //   Player(
    //       id: 'ui12',
    //       username: 'yeet',
    //       isTagger: false,
    //       hasBeenTagged: false,
    //       hasItem: false),
    //   Player(
    //       id: 'ui123',
    //       username: 'wheat',
    //       isTagger: false,
    //       hasBeenTagged: false,
    //       hasItem: false),
    // ];
    // _mockJoinedPlayerscontroller.add(_mockJoinedPlayers);

    // await tester.pump();

    // // setup dependant services
    // final _mockDatabaseService = MockDatabaseService(
    //     playerStreamController: _mockJoinedPlayerscontroller);
    // final _fakeAuthService = FakeAuthService();
    // final _navigation = Navigation();

    // await tester.pumpWidget(
    //   MultiProvider(
    //       providers: [
    //         Provider<DatabaseService>.value(value: _mockDatabaseService),
    //         Provider<Navigation>.value(value: _navigation),
    //         Provider<AuthService>.value(value: _fakeAuthService)
    //       ],
    //       child: MaterialApp(
    //           navigatorKey: _navigation.navigatorKey,
    //           home: WaitingForGameToStartScreen(
    //             gameId: 'test_game_id',
    //           ))),
    // );

    // // ensure stream has recieved data
    // await tester.pumpAndSettle();

    // // observe list of joined players
    // expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[0].id}')),
    //     findsOneWidget);
    // expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[1].id}')),
    //     findsOneWidget);
    // expect(find.byKey(Key('created_game_tile_${_mockJoinedPlayers[2].id}')),
    //     findsOneWidget);

    // // mock admin choose a tagger by updating stream
    // final _mockJoinedPlayersWithTagger = [
    //   Player(id: 'ui1', username: 'pete', isTagger: false),
    //   Player(id: 'ui12', username: 'yeet', isTagger: true),
    //   Player(id: 'ui123', username: 'wheat', isTagger: false),
    // ];
    // _mockJoinedPlayerscontroller.add(_mockJoinedPlayersWithTagger);
    // await tester.pumpAndSettle();

    // // show user tagger has been chosen
    // expect(find.byKey(Key('tagger_tile_${_mockJoinedPlayers[1].id}')),
    //     findsOneWidget);
  });
}
