import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/screens/create_account.dart';
import 'package:niira/screens/sign_in.dart';
import 'package:niira/screens/welcome.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('navigation tests', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('navigates to sign in screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: WelcomeScreen(),
        navigatorObservers: [mockObserver],
      ));

      await tester.tap(find.byKey(WelcomeScreen.navigateToSignInBtn));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));

      expect(find.byType(SignInScreen), findsOneWidget);
    });
    testWidgets('navigates to create account screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: WelcomeScreen(),
        navigatorObservers: [mockObserver],
      ));

      await tester.tap(find.byKey(WelcomeScreen.navigateToCreateAccountBtn));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));

      expect(find.byType(CreateAccountScreen), findsOneWidget);
    });
  });
}
