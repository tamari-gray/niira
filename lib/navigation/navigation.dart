import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niira/screens/create_account.dart';
import 'package:niira/screens/sign_in.dart';

class Navigation {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void pop() {
    navigatorKey.currentState.pop();
  }

  void popUntilLobby() {
    navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> switchToSignIn() {
    return navigatorKey.currentState
        .pushReplacement<SignInScreen, CreateAccountScreen>(
      MaterialPageRoute<SignInScreen>(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  Future<dynamic> switchToCreateAccount() {
    return navigatorKey.currentState
        .pushReplacement<CreateAccountScreen, SignInScreen>(
      MaterialPageRoute<CreateAccountScreen>(
        builder: (context) => CreateAccountScreen(),
      ),
    );
  }

  void displayError(dynamic error) {
    final message = error.toString();

    // filter out messages user doesnt want to see here

    // show dialog
    final newContext = navigatorKey.currentState.overlay.context;
    showDialog<dynamic>(
        context: newContext,
        builder: (context) {
          return AlertDialog(
            key: Key('error_dialog'),
            title: Text('$message'),
            actions: [
              RaisedButton(
                child: Text('dismiss'),
                onPressed: (() {
                  Navigator.pop(context);
                }),
              )
            ],
          );
        });
  }

  /// Can be called from any widget via the Provider.
  /// Takes a [Function] that is called when the user confirms the choice.
  /// Also optionally takes Strings to set the button text for confirm and
  /// cancel options.
  Future<void> showConfirmationDialog(
      {@required void Function() onConfirmed,
      String confirmText = 'OK',
      String cancelText = 'Cancel'}) async {
    final keyContext = navigatorKey.currentState.overlay.context;
    return showDialog<void>(
      context: keyContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          actions: <Widget>[
            OutlineButton(
              color: Theme.of(context).primaryColor,
              highlightedBorderColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).primaryColor,
              key: Key('confirmBtn'),
              child: Text(confirmText),
              onPressed: () async => await onConfirmed(),
            ),
            FlatButton(
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              child: Text(cancelText),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
