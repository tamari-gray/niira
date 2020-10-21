import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/models/view_models/create_game2.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game2/boundary_size_slider.dart';
import 'package:provider/provider.dart';

import '../../mocks/create_game_vm_2_mocks.dart';

void main() {
  group('BoundarySizeSlider', () {
    testWidgets('when user changes dslider value, update vm.boundarySize',
        (WidgetTester tester) async {
      // spin up the wut
      final nav = Navigation();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CreateGameViewModel2>(
              create: (_) => MockcreateGameVm2(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: nav.navigatorKey,
            home: BoundarySizeSlider(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // mock user interacting with slider
      //TODO: how to mock user using a slider?? => may need to do integration test

      // check that vm was updated
      // verify(MockCreateGameVm2.updateBoundarySize(any)).called(1);
    });
  });
}
