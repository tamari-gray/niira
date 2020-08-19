import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/screens/create_account.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('validation tests', () {
    testWidgets('show error messages on empty text feilds',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateAccountScreen(),
      ));

      // press submit with empty form
      await tester.tap(find.byKey(Key('create_account_submit_btn')));
      await tester.pump();

      // look for error messages
      expect(find.text('Please enter username'), findsOneWidget);
      expect(find.text('Please enter email address'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);
      expect(find.text('Please re-enter password'), findsOneWidget);
    });
    testWidgets(
        'show error messages on invalid email + re-enter password feilds',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateAccountScreen(),
      ));

      // input invalid text into fields
      final emailField = find.byKey(Key('email_field'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'invalid-email.com');

      final usernameField = find.byKey(Key('username_field'));
      expect(usernameField, findsOneWidget);
      await tester.enterText(usernameField, 'tamari');

      final passwordField = find.byKey(Key('password_field'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'password-test-123');

      final rePasswordField = find.byKey(Key('re_password_field'));
      expect(rePasswordField, findsOneWidget);
      await tester.enterText(rePasswordField, 'password-test-000');

      await tester.tap(find.byKey(Key('create_account_submit_btn')));
      await tester.pump();

      // observe error messages on submit
      expect(find.text('Please enter valid email'), findsOneWidget);
      expect(find.text('Passwords do not match, please try again'),
          findsOneWidget);
    });
    testWidgets('show loading animation on successfull validation + submit',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateAccountScreen(),
      ));

      // submit valid credentials
      final emailField = find.byKey(Key('email_field'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'tamarigray97@gmail.com');

      final usernameFeild = find.byKey(Key('username_field'));
      expect(usernameFeild, findsOneWidget);
      await tester.enterText(usernameFeild, 'tamari');

      final passwordFeild = find.byKey(Key('password_field'));
      expect(passwordFeild, findsOneWidget);
      await tester.enterText(passwordFeild, 'password-test');

      final rePasswordFeild = find.byKey(Key('re_password_field'));
      expect(rePasswordFeild, findsOneWidget);
      await tester.enterText(rePasswordFeild, 'password-test');

      await tester.tap(find.byKey(Key('create_account_submit_btn')));
      await tester.pump();
      await tester.pump();

      // observe loading icon
      expect(find.byKey(Key('loading_indicator')), findsOneWidget);
    });
  });
}
