import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/screens/new_game1/new_game_screen1.dart';

void main() {
  group('NewGameScreen1 ', () {
    testWidgets('won\'t navigate with invalid inputs',
        (WidgetTester tester) async {
      // spin up the wut
      await tester.pumpWidget(MaterialApp(home: NewGameScreen1()));

      // save finders for each UI
      final nameField = find.byKey(Key('new_game1_name_field'));
      final passwordField = find.byKey(Key('new_game1_password_field'));
      final submitButton = find.byKey(Key('new_game1_submit_button'));

      expect((passwordField), findsOneWidget);

      await tester.tap(submitButton);

      expect((nameField), findsOneWidget);
      expect((passwordField), findsOneWidget);
    });
  });
}
