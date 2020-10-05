import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/loading.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game2/create_game_map.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/services/mock_location_service.dart';

void main() {
  group('CreateGameMap', () {
    testWidgets('shows loading icon until while waiting to get users location',
        (WidgetTester tester) async {
      // spin up the wut
      final nav = Navigation();
      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<LocationService>(create: (_) => FakeLocationService()),
          ],
          child: MaterialApp(
            navigatorKey: nav.navigatorKey,
            home: CreateGameMap(),
          )));

      // save finders for each UI
      final loadingIcon = find.byType(Loading);
      final map = find.byType(GoogleMap);

      // check loading is showing
      expect((loadingIcon), findsOneWidget);
      expect((map), findsNothing);

      // wait for service to get users location
      await tester.pumpAndSettle();

      // check map is showing
      expect((loadingIcon), findsNothing);
      expect((map), findsOneWidget);
    });
  });
}
