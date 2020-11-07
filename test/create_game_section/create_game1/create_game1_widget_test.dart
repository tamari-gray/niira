import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game1/create_game_screen1.dart';
import 'package:niira/screens/create_game2/create_game_screen2.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

import '../../mocks/create_game_vm_mocks.dart';
import '../../mocks/navigation/mock_navigation.dart';
import '../../mocks/services/game_service_mocks.dart';
import '../../mocks/services/mock_auth_service.dart';
import '../../mocks/services/mock_database_service.dart';
import '../../mocks/services/mock_location_service.dart';

void main() {
  group('CreateGameScreen1 ', () {
    testWidgets('quit creating game', (WidgetTester tester) async {
      // spin up the wut
      final nav = MockNavigation();
      final mockVm = MockcreateGameVm();
      final mockGameService = MockGameService();
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider<GameService>.value(value: mockGameService),
            Provider<AuthService>(create: (_) => MockAuthService()),
            Provider<DatabaseService>(create: (_) => FakeDatabaseService()),
            ChangeNotifierProvider<CreateGameViewModel>.value(value: mockVm),
            Provider<LocationService>(create: (_) => FakeLocationService()),
            Provider<Navigation>.value(value: nav),
          ],
          child: MaterialApp(
            home: CreateGameScreen1(),
          )));

      await tester.pumpAndSettle();

      // quit creating game
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // check that we pop all routes
      verify(nav.popUntilLobby()).called(1);

      // check that we clear any vm data
      verify(mockVm.reset()).called(1);

      // check that we navigate to lobby screen
      verify(mockGameService.leaveCurrentGame()).called(1);
    });
    testWidgets('only navigates with invalid inputs',
        (WidgetTester tester) async {
      // spin up the wut
      final nav = Navigation();
      await tester.pumpWidget(MultiProvider(
          providers: [
            Provider<GameService>(create: (_) => GameService()),
            Provider<AuthService>(create: (_) => MockAuthService()),
            Provider<DatabaseService>(create: (_) => FakeDatabaseService()),
            ChangeNotifierProvider<CreateGameViewModel>(
                create: (_) => CreateGameViewModel()),
            Provider<LocationService>(create: (_) => FakeLocationService()),
            Provider<Navigation>.value(value: nav),
          ],
          child: MaterialApp(
            navigatorKey: nav.navigatorKey,
            home: CreateGameScreen1(),
            routes: {
              CreateGameScreen2.routeName: (context) => CreateGameScreen2()
            },
          )));

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

      // add valid data
      await tester.enterText(nameField, 'valid');

      // attempt submit
      await tester.tap(submitButton);

      // ol reliable
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      // check game screen 2 widget is found (due to navigation)
      expect(find.text('loading map...'), findsOneWidget);
    });
  });
}
