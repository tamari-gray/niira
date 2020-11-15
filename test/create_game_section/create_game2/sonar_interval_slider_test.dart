import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game2/sonar_intervals_slider.dart';
import 'package:provider/provider.dart';

void main() {
  group('SonarIntervalsSlider', () {
    testWidgets('when user changes slider value, update vm.sonarIntervals',
        (WidgetTester tester) async {
      // init services
      final nav = Navigation();
      final vm = CreateGameViewModel();
      expect(vm.sonarIntervals, 210);

      // spin up the wut
      final wut = SonarIntervalsSlider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CreateGameViewModel>.value(value: vm)
          ],
          child: MaterialApp(
            navigatorKey: nav.navigatorKey,
            home: Scaffold(body: wut),
          ),
        ),
      );

      // ol reliable
      await tester.pumpAndSettle();

      // mock user interacting with slider
      await tester.tap(find.byType(Slider));

      // ol reliable again
      await tester.pumpAndSettle();

      // check that vm was updated
      expect(vm.sonarIntervals, 180);
    });
  });
}
