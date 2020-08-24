import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/sign_in.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/navigation_service.dart';
import 'package:provider/provider.dart';
import '../../../test_driver/mocks/services/mock_auth_service.dart';
import '../../../test_driver/mocks/mock_user_data.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockNavService extends Mock implements NavigationService {}

void main() {
  Finder emailField() {
    return find.byKey(Key('email_field'));
  }

  Finder passwordField() {
    return find.byKey(Key('password_field'));
  }

  Finder signInBtn() {
    return find.byKey(Key('sign_in_submit_btn'));
  }

  Finder loadingIndicator() {
    return find.byKey(Key('loading_indicator'));
  }

  void inputValidDetails(WidgetTester tester) async {
    expect(emailField(), findsOneWidget);
    await tester.enterText(emailField(), 'validEmail@gmail.com');

    expect(passwordField(), findsOneWidget);
    await tester.enterText(passwordField(), 'password-test');

    await tester.tap(signInBtn());
    await tester.pump();
    await tester.pump();
  }

  Widget makeTestableSignInWidget(
      NavigationService mockNav, MockAuthService mockAuth) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => mockAuth),
        ],
        child: MaterialApp(
          navigatorKey: mockNav.navigatorKey,
          home: SignInScreen(),
        ));
  }

  group('auth tests', () {
    testWidgets('navigate to lobby on successfull login',
        (WidgetTester tester) async {
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService = MockAuthService(
        _controller,
        _mockUserData,
        _mockNavService,
        true,
      );
      await tester.pumpWidget(
        makeTestableSignInWidget(
          _mockNavService,
          _mockAuthService,
        ),
      );

      // fill in and submit form
      await inputValidDetails(tester);

      // observe laoding
      expect(loadingIndicator(), findsOneWidget);
      await tester.pumpAndSettle();

      // expect pop sign in + observe welcome screen
      expect(emailField(), findsNothing);
    });
    testWidgets('auth error: shows dialog with error message',
        (WidgetTester tester) async {
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      // return firebase auth error
      final _mockAuthService =
          MockAuthService(_controller, _mockUserData, _mockNavService, false);
      await tester.pumpWidget(
          makeTestableSignInWidget(_mockNavService, _mockAuthService));

      // fill in and submit form
      await inputValidDetails(tester);

      verify(_mockNavService.displayError(any)).called(1);
    });
  });
  group('validation tests', () {
    testWidgets('show error messages on empty text feilds',
        (WidgetTester tester) async {
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService =
          MockAuthService(_controller, _mockUserData, _mockNavService, true);
      await tester.pumpWidget(
          makeTestableSignInWidget(_mockNavService, _mockAuthService));

      // press submit with empty form
      await tester.tap(signInBtn());
      await tester.pump();

      // look for error messages
      expect(find.text('Please enter email address'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);
    });
    testWidgets('show error messages on invalid email ',
        (WidgetTester tester) async {
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService =
          MockAuthService(_controller, _mockUserData, _mockNavService, true);
      await tester.pumpWidget(
          makeTestableSignInWidget(_mockNavService, _mockAuthService));

      // input invalid text into fields
      expect(emailField(), findsOneWidget);
      await tester.enterText(emailField(), 'invalid-email.com');

      await tester.tap(signInBtn());
      await tester.pump();

      // observe error messages on submit
      expect(find.text('Please enter valid email'), findsOneWidget);
    });
    testWidgets('show loading animation on successfull validation + submit',
        (WidgetTester tester) async {
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService =
          MockAuthService(_controller, _mockUserData, _mockNavService, true);
      await tester.pumpWidget(
          makeTestableSignInWidget(_mockNavService, _mockAuthService));

      // submit valid credentials
      await inputValidDetails(tester);

      // observe loading icon
      expect(loadingIndicator(), findsOneWidget);
    });
  });
  group('navigation tests', () {
    testWidgets(
        'clears form before navigating between sign in/create account screens',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SignInScreen(),
      ));

      expect(emailField(), findsOneWidget);

      await tester.enterText(emailField(), 'not_a_valid_email');

      await tester.tap(find.byKey(Key('navigate_to_create_account_link')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('navigate_to_sign_in_link')), findsOneWidget);

      await tester.tap(find.byKey(Key('navigate_to_sign_in_link')));
      await tester.pumpAndSettle();

      expect(
          find.byKey(Key('navigate_to_create_account_link')), findsOneWidget);

      expect(find.text('not_a_valid_email'), findsNothing);
    });
  });
}
