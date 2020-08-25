import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
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
}
