import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/user_data.dart';

import '../mocks/mock_user_data.dart';
import '../mocks/services/mock_auth_service.dart';
import '../mocks/services/mock_database_service.dart';
import '../mocks/services/mock_firebase_platform.dart';
import '../mocks/services/mock_nav_service.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = MockFirebasePlatform();
  });
  group('MyApp ', () {
    testWidgets('navigates to correct route based on auth state',
        (WidgetTester tester) async {
      // create a controller that the mock auth servive will hold
      final controller = StreamController<UserData>();
      final mockUserData = MockUser().userData;
      final mockNavService = MockNavService();
      final mockAuthService = MockAuthService(
        controller: controller,
        mockUserData: mockUserData,
        mockNavService: mockNavService,
        successfulAuth: true,
      );
      final mockDatabaseStreamController = StreamController<List<Game>>();
      final mockDatabaseService =
          MockDatabaseService(controller: mockDatabaseStreamController);

      // create the widget under test
      await tester.pumpWidget(MyApp(
        authService: mockAuthService,
        navigatorKey: GlobalKey<NavigatorState>(),
        databaseService: mockDatabaseService,
        navigation: mockNavService,
      ));

      // update auth stream to have no signed in user
      controller.add(null);
      await tester.pumpAndSettle();

      // check the welcome screen is present
      expect(find.byKey(Key('navigateToCreateAccount')), findsOneWidget);

      // get a user data object and make the service emit it
      final userData = await mockAuthService.signInWithEmail('a', 'b');
      controller.add(userData);

      await tester.pump();

      // check the welcome screen is no longer present
      expect(find.byKey(Key('navigateToCreateAccount')), findsNothing);
      // check that the lobby screen is present
      expect(find.text('Lobby'), findsOneWidget);
    });
  });
}
