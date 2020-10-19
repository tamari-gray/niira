import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game2/create_game_map.dart';
import 'package:niira/services/game_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/services/mock_game_service.dart';
import '../../mocks/services/mock_location_service.dart';

void main() {
  group('CreateGameMap', () {
    testWidgets('sets vm.boundaryPosition to users location on load map',
        (WidgetTester tester) async {});
    testWidgets('when vm.boundarySize updates, boundary circle size updates',
        (WidgetTester tester) async {});
    testWidgets('when vm.position updates, boundary circle position updates',
        (WidgetTester tester) async {});
    testWidgets('tells createGameScreen2 when map has loaded',
        (WidgetTester tester) async {
      // mock loadedMap local state value in createGameScreen2
      // createGameScreen2 usues this to toggle loading widget
      // var testLoadedMap = false;

      // // spin up the wut
      // final nav = Navigation();
      // await tester.pumpWidget(MultiProvider(
      //     providers: [
      //       Provider<LocationService>(create: (_) => FakeLocationService()),
      //       ChangeNotifierProvider<GameService>(
      //         create: (_) => FakeGameService(),
      //       ),
      //     ],
      //     child: MaterialApp(
      //       navigatorKey: nav.navigatorKey,
      //       home: CreateGameMap(
      //         loadedMap: () => testLoadedMap = true,
      //         boundaryPosition: Location(longitude: 0, latitude: 0),
      //         boundarySize: 150,
      //       ),
      //     )));

      // await tester.pumpAndSettle();

      // expect(testLoadedMap, true);
    });
  });
}
