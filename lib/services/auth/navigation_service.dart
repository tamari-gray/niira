import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:niira/screens/loading_screen.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  void displayError(dynamic error) {
    final message = error.toString();
    print('display error');

    // filter out messages user doesnt want to see here

    // show dialog
    final newContext = navigatorKey.currentState.overlay.context;
    showDialog<dynamic>(
        context: newContext,
        builder: (context) {
          print('making dialog');
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

  // Future<dynamic> handleAsync(Future<dynamic> Function() fbCall) async {
  //   try {
  //     // show loading screen
  //     final newContext = navigatorKey.currentState.overlay.context;
  //     await Navigator.push<dynamic>(
  //       newContext,
  //       MaterialPageRoute<dynamic>(builder: (context) => LoadingScreen()),
  //     );

  //     // send request
  //     final dynamic result = await fbCall();

  //     // pop loading screen
  //     Navigator.pop(newContext);

  //     // return result
  //     return result;
  //   } catch (e) {
  //     // handle error
  //     displayError(e);
  //     return null;
  //   }
  // }

  // void displayLoadingScreen(String title) {
  //   final newContext = navigatorKey.currentState.overlay.context;

  //   Navigator.push<dynamic>(
  //     newContext,
  //     MaterialPageRoute<dynamic>(builder: (context) => LoadingScreen()),
  //   );
  // }

}
