import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/new_game1/new_game_screen1.dart';
import 'package:niira/screens/new_game2.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

void main() {
  group('NewGameScreen1 ', () {
    testWidgets('only navigates with invalid inputs',
        (WidgetTester tester) async {
      // spin up the wut
      final nav = Navigation();
      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<GameService>(create: (_) => GameService()),
            Provider<Navigation>.value(value: nav),
          ],
          child: MaterialApp(
            navigatorKey: nav.navigatorKey,
            home: NewGameScreen1(),
            routes: {NewGameScreen2.routeName: (context) => NewGameScreen2()},
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
      await tester.enterText(nameField, 'valid name');

      // attempt submit
      await tester.tap(submitButton);

      // ol reliable
      await tester.pumpAndSettle();

      // check game screen 2 widget is found (due to navigation)
      expect(find.text('New Game Screen 2'), findsOneWidget);
    });
  });
}
