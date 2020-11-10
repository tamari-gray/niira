import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niira/main.dart';
import 'package:niira/models/game.dart';

import '../mocks/firebase_wrapper_mocks.dart';
import '../mocks/mock_user_data.dart';
import '../mocks/services/mock_auth_service.dart';
import '../mocks/services/mock_database_service.dart';
import '../mocks/services/mock_firebase_platform.dart';
import '../mocks/navigation/mock_navigation.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = MockFirebasePlatform();
  });
  group('MyApp ', () {
    testWidgets(
        'show loading icon until all services + firebase are initialised',
        (WidgetTester tester) async {
      // create mock services
      final controller = StreamController<String>();
      final mockUserData = MockUser().userData;

      final fakeNavigation = FakeNavigation();
      final mockAuthService = MockAuthService(
        controller: controller,
        mockUserData: mockUserData,
        fakeNavigation: fakeNavigation,
        successfulAuth: true,
      );
      final mockDatabaseStreamController = StreamController<List<Game>>();
      final mockDatabaseService =
          MockDatabaseService(controller: mockDatabaseStreamController);

      // create a fake firebase wrapper with a supplied completer
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // create the widget under test
      await tester.pumpWidget(MyApp(
        authService: mockAuthService,
        databaseService: mockDatabaseService,
        navigation: fakeNavigation,
        firebase: firebase,
      ));

      // check for loading widget
      expect(find.byKey(Key('loading_indicator')), findsOneWidget);

      // init firebase
      firebaseCompleter.complete();
      await tester.pumpAndSettle();

      expect(find.byKey(Key('loading_indicator')), findsNothing);
    });
    testWidgets('navigates to correct route based on auth state',
        (WidgetTester tester) async {
      // create a controller that the mock auth servive will hold
      final controller = StreamController<String>();
      final mockUserData = MockUser().userData;
      final fakeNavigation = FakeNavigation();
      final mockAuthService = MockAuthService(
        controller: controller,
        mockUserData: mockUserData,
        fakeNavigation: fakeNavigation,
        successfulAuth: true,
      );
      final mockDatabaseStreamController = StreamController<List<Game>>();
      final mockDatabaseService =
          MockDatabaseService(controller: mockDatabaseStreamController);

      // create a fake firebase wrapper with a supplied completer
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // create the widget under test
      await tester.pumpWidget(MyApp(
        authService: mockAuthService,
        databaseService: mockDatabaseService,
        navigation: fakeNavigation,
        firebase: firebase,
      ));

      // init firebase
      firebaseCompleter.complete();
      await tester.pumpAndSettle();

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
    testWidgets('show error message when error initialising firebase',
        (WidgetTester tester) async {
      // create a controller that the mock auth servive will hold
      final controller = StreamController<String>();
      final mockUserData = MockUser().userData;
      final fakeNavigation = FakeNavigation();
      final mockAuthService = MockAuthService(
        controller: controller,
        mockUserData: mockUserData,
        fakeNavigation: fakeNavigation,
        successfulAuth: true,
      );
      final mockDatabaseStreamController = StreamController<List<Game>>();
      final mockDatabaseService =
          MockDatabaseService(controller: mockDatabaseStreamController);

      // create a fake firebase wrapper with a supplied completer
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // create the widget under test
      await tester.pumpWidget(MyApp(
        authService: mockAuthService,
        databaseService: mockDatabaseService,
        navigation: fakeNavigation,
        firebase: firebase,
      ));

      // init firebase error
      final errorMsg = 'error initialising firebase';
      firebaseCompleter.completeError(
          errorMsg, StackTrace.fromString('stacktrace yee'));
      await tester.pumpAndSettle();

      // checks that error message is shown
      expect(find.text(errorMsg), findsOneWidget);
    });
  });
}
