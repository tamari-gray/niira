import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/loading.dart';
import 'package:niira/screens/create_game2/sonar_intervals_slider.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

void main() {
  group('CreateGameMap', () {
    testWidgets('shows loading icon while waiting to get users location',
        (WidgetTester tester) async {
      // spin up the wut
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<GameService>(create: (_) => ()),
          ],
          child: MaterialApp(
            home: SonarIntervalsSlider(),
          )));

      // save finders for each UI
      final loadingIcon = find.byType(Loading);
      final map = find.byType(GoogleMap);

      // check loading is showing
      expect(loadingIcon, findsOneWidget);
      expect(map, findsNothing);

      // wait for service to get users location
      await tester.pumpAndSettle();

      // check map is showing
      expect(loadingIcon, findsNothing);
      expect(map, findsOneWidget);
    });
  });
}
