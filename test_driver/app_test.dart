import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Niira App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final lobbyTextFinder = find.text('Lobby');
    final createAccountFinder = find.text('Create account');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('opens on Welcome Screen when not signed in', () async {
      expect(
        driver.waitFor(createAccountFinder),
        completes,
      );
    }, skip: 'Integration tests are currently incomplete');

    test('opens on Lobby when signed in', () async {
      // await driver.tap(createAccountFinder);

      // expect(
      //   driver.waitFor(lobbyTextFinder),
      //   completes,
      // );
    });
  });
}
