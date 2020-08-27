import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/create_account.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/mock_user_data.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_nav_service.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  Widget makeTestableCreateAccountWidget(MockNavService mockNavService,
      MockAuthService mockAuth, MockDatabaseService mockDBService) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => mockAuth),
          Provider<DatabaseService>(create: (_) => mockDBService)
        ],
        child: MaterialApp(
          navigatorKey: mockNavService.navigatorKey,
          home: CreateAccountScreen(),
        ));
  }

  group('auth tests', () {
    testWidgets('navigate to lobby on successfull create account',
        (WidgetTester tester) async {
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService = MockAuthService(
          controller: _controller,
          mockUserData: _mockUserData,
          mockNavService: _mockNavService);
      final _mockDBService = MockDatabaseService();
      await tester.pumpWidget(makeTestableCreateAccountWidget(
        _mockNavService,
        _mockAuthService,
        _mockDBService,
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
      await tester.pumpAndSettle();

      // expect pop sign in + observe welcome screen
      expect(find.byKey(Key('create_account_submit_btn')), findsNothing);
    });
  });
  group('validation tests', () {
    testWidgets('show error messages on empty text feilds',
        (WidgetTester tester) async {
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService = MockAuthService(
          controller: _controller,
          mockUserData: _mockUserData,
          mockNavService: _mockNavService);
      final _mockDBService = MockDatabaseService();
      await tester.pumpWidget(makeTestableCreateAccountWidget(
        _mockNavService,
        _mockAuthService,
        _mockDBService,
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
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService = MockAuthService(
          controller: _controller,
          mockUserData: _mockUserData,
          mockNavService: _mockNavService);
      final _mockDBService = MockDatabaseService();
      await tester.pumpWidget(makeTestableCreateAccountWidget(
        _mockNavService,
        _mockAuthService,
        _mockDBService,
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
      //set up for testing
      final _mockNavService = MockNavService();
      final _mockUserData = MockUser().userData;
      final _controller = StreamController<UserData>();

      final _mockAuthService = MockAuthService(
          controller: _controller,
          mockUserData: _mockUserData,
          mockNavService: _mockNavService);
      final _mockDBService = MockDatabaseService();
      await tester.pumpWidget(makeTestableCreateAccountWidget(
        _mockNavService,
        _mockAuthService,
        _mockDBService,
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
