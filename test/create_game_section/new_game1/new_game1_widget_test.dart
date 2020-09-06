import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/new_game1/new_game_screen1.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/services/mock_game_service.dart';

void main() {
  group('NewGameScreen1 ', () {
    testWidgets('only navigates with invalid inputs',
        (WidgetTester tester) async {
      // spin up the wut
      await tester.pumpWidget(MultiProvider(providers: [
        Provider<GameService>(create: (_) => MockGameService()),
        Provider<Navigation>(create: (_) => Navigation()),
      ], child: MaterialApp(home: NewGameScreen1())));

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

      // add invalid data
      await tester.enterText(nameField, 'valid name');

      // attempt submit
      await tester.tap(submitButton);

      // check input fields are no longer found (due to navigation)
      expect((nameField), findsNothing);
      expect((passwordField), findsNothing);
    });
  });
}
