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

    test(
      'opens on Welcome Screen when not signed in',
      () async {
        expect(
          driver.waitFor(createAccountFinder),
          completes,
        );
      },
    );

    // test('opens on Lobby when signed in', () async {
    //   // await driver.tap(createAccountFinder);

    //   expect(
    //     driver.waitFor(lobbyTextFinder),
    //     completes,
    //   );
    // });

    test('joins game and quits when on waiting screen', () async {
      // allow location
      final allowLocationButton = find.text('While');
      await driver.waitFor(allowLocationButton);
      await driver.tap(allowLocationButton);

      // join game in lobbyScreen
      final gameToJoin = find.text('pullo');
      await driver.waitFor(gameToJoin);
      await driver.tap(gameToJoin);

      // input correct password in inputPasswordScreen
      final passwordField = find.byValueKey('input_password_screen_text_feild');
      await driver.waitFor(passwordField);
      await driver.tap(passwordField);
      await driver.enterText('password12345');

      // leave game in waitingScreen
      final waitingScreenQuitButton =
          find.byValueKey('waiting_screen_quit_btn');
      await driver.waitFor(waitingScreenQuitButton);
      await driver.tap(waitingScreenQuitButton);

      final confirmQuitButton = find.byValueKey('confirmBtn');
      await driver.waitFor(confirmQuitButton);
      await driver.tap(confirmQuitButton);

      await driver.waitFor(gameToJoin);
    });
  });
}
