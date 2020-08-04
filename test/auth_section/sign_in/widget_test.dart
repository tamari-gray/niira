import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/screens/sign_in.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("validation tests", () {
    testWidgets("show error messages on empty text feilds",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SignInScreen(),
      ));

      // press submit with empty form
      await tester.tap(find.byKey(Key("sign_in_submit_btn")));
      await tester.pump();

      // look for error messages
      expect(find.text("Please enter email address"), findsOneWidget);
      expect(find.text("Please enter password"), findsOneWidget);
    });
    testWidgets("show error messages on invalid email ",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SignInScreen(),
      ));

      // input invalid text into fields
      final emailField = find.byKey(Key("email_field"));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, "invalid-email.com");

      await tester.tap(find.byKey(Key("sign_in_submit_btn")));
      await tester.pump();

      // observe error messages on submit
      expect(find.text("Please enter valid email"), findsOneWidget);
    });
    testWidgets("show loading animation on successfull validation + submit",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SignInScreen(),
      ));

      // submit valid credentials
      final emailField = find.byKey(Key("email_field"));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, "tamarigray97@gmail.com");

      final passwordFeild = find.byKey(Key("password_field"));
      expect(passwordFeild, findsOneWidget);
      await tester.enterText(passwordFeild, "password-test");

      await tester.tap(find.byKey(Key("sign_in_submit_btn")));
      await tester.pump();
      await tester.pump();

      // observe loading icon
      expect(find.byKey(Key("loading_indicator")), findsOneWidget);
    });
  });
  group('navigation tests', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets(
        'clears form before navigating between sign in/create account screens',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SignInScreen(),
        navigatorObservers: [mockObserver],
      ));

      final emailField = find.byKey(Key("email_field"));
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, "not_a_valid_email");

      await tester.tap(find.byKey(Key("navigate_to_create_account_link")));
      await tester.pump();

      expect(find.text("not_a_valid_email"), findsNothing);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));

      expect(find.byKey(Key("navigate_to_sign_in_link")), findsOneWidget);

      await tester.tap(find.byKey(Key("navigate_to_sign_in_link")));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));

      expect(
          find.byKey(Key("navigate_to_create_account_link")), findsOneWidget);

      expect(find.text("not_a_valid_email"), findsNothing);
    });
  });
}
