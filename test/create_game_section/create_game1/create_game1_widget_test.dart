import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game1/create_game_screen1.dart';
import 'package:niira/screens/create_game2/create_game_screen2.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/services/user_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/services/mock_location_service.dart';

void main() {
  group('CreateGameScreen1 ', () {
    testWidgets('only navigates with invalid inputs',
        (WidgetTester tester) async {
      // spin up the wut
      final nav = Navigation();
      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<GameService>(create: (_) => GameService()),
            ChangeNotifierProvider<CreateGameViewModel>(
                create: (_) => CreateGameViewModel()),
            Provider<LocationService>(create: (_) => FakeLocationService()),
            Provider<Navigation>.value(value: nav),
          ],
          child: MaterialApp(
            navigatorKey: nav.navigatorKey,
            home: CreateGameScreen1(),
            routes: {
              CreateGameScreen2.routeName: (context) => CreateGameScreen2()
            },
          )));

      // save finders for each UI
      final nameField = find.byKey(Key('new_game1_name_field'));
      final passwordField = find.byKey(Key('new_game1_password_field'));
      final submitButton = find.byKey(Key('new_game1_submit_button'));

      // check input fields can now be found
      expect((passwordField), findsOneWidget);
      expect((nameField), findsOneWidget);

      // attempt a submit
      await tester.tap(submitButton);

      // check input fields are still found, ie. no navigation performed
      expect((nameField), findsOneWidget);
      expect((passwordField), findsOneWidget);

      // add valid data
      await tester.enterText(nameField, 'name');
      await tester.enterText(passwordField, 'pwd');

      // add invalid data
      await tester.enterText(
          nameField, 'a really long name more than fifteen chars');

      // attempt submit
      await tester.tap(submitButton);

      // check input fields are still found after valid then invalid data
      expect((nameField), findsOneWidget);
      expect((passwordField), findsOneWidget);

      // add valid data
      await tester.enterText(nameField, 'valid');

      // attempt submit
      await tester.tap(submitButton);

      // ol reliable
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      // check game screen 2 widget is found (due to navigation)
      expect(find.text('loading map...'), findsOneWidget);
    });
  });
}
