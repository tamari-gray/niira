import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/sign_in.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:provider/provider.dart';

import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/navigation/mock_navigation.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

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

  Widget makeTestableSignInWidget(MockAuthService mockAuth) {
    final navigation = Navigation();
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: mockAuth),
        Provider<Navigation>.value(value: navigation)
      ],
      child: MaterialApp(
        navigatorKey: navigation.navigatorKey,
        home: SignInScreen(),
      ),
    );
  }

  group('auth tests', () {
    testWidgets('navigate to lobby on successfull login',
        (WidgetTester tester) async {
      //set up for testing
      final _fakeNavigation = FakeNavigation();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<String>();

      final navigation = Navigation();

      final _mockAuthService = MockAuthService(
        controller: _controller,
        mockUserData: _mockUserData,
        fakeNavigation: _fakeNavigation,
      );
      await tester.pumpWidget(
        makeTestableSignInWidget(
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
  });
  group('validation tests', () {
    testWidgets('show error messages on empty text feilds',
        (WidgetTester tester) async {
      //set up for testing
      final _fakeNavigation = FakeNavigation();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<String>();

      final _mockAuthService = MockAuthService(
        controller: _controller,
        mockUserData: _mockUserData,
        fakeNavigation: _fakeNavigation,
        successfulAuth: true,
      );
      await tester.pumpWidget(makeTestableSignInWidget(_mockAuthService));

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
      final _fakeNavigation = FakeNavigation();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<String>();

      final _mockAuthService = MockAuthService(
        controller: _controller,
        mockUserData: _mockUserData,
        fakeNavigation: _fakeNavigation,
        successfulAuth: true,
      );
      await tester.pumpWidget(makeTestableSignInWidget(_mockAuthService));

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
      final _fakeNavigation = FakeNavigation();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<String>();

      final _mockAuthService = MockAuthService(
        controller: _controller,
        mockUserData: _mockUserData,
        fakeNavigation: _fakeNavigation,
        successfulAuth: true,
      );
      await tester.pumpWidget(makeTestableSignInWidget(_mockAuthService));

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
      final navigation = Navigation();
      await tester.pumpWidget(Provider.value(
          value: navigation,
          child: MaterialApp(
            home: SignInScreen(),
            navigatorKey: navigation.navigatorKey,
          )));

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
