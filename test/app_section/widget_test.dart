import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/main.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/database/database_service.dart';
import '../../test_driver/mocks/services/mock_auth_service.dart';
import '../../test_driver/mocks/mock_user_data.dart';
import '../../test_driver/mocks/services/mock_nav_service.dart';

class FakeDatabaseService extends Fake implements DatabaseService {}

void main() {
  group('MyApp ', () {
    testWidgets('navigates to correct route based on auth state',
        (WidgetTester tester) async {
      // create a controller that the fake auth servive will hold
      final controller = StreamController<UserData>();
      final mockUserData = MockUser().userData;
      final mockNavService = MockNavService();
      final mockAuthService = MockAuthService(
        controller: controller,
        mockUserData: mockUserData,
        mockNavService: mockNavService,
        successfulAuth: true,
      );
      final fakeDBService = FakeDatabaseService();
      controller.add(null);

      // create the widget under test
      await tester.pumpWidget(
        MyApp(
          mockAuthService,
          GlobalKey<NavigatorState>(),
          fakeDBService,
        ),
      );

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
