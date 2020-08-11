import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/auth/navigation_service.dart';
import 'package:provider/provider.dart';

void main() {
  final nav = NavigationService();

  final authService = FirebaseAuthService(FirebaseAuth.instance, nav);
  runApp(MyApp(authService, nav.navigatorKey));
}

class MyApp extends StatelessWidget {
  final AuthService _authService;
  final GlobalKey<NavigatorState> _navigatorKey;

  MyApp(this._authService, this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: _authService),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: _navigatorKey,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color.fromRGBO(247, 152, 0, 1),
            accentColor: Color.fromRGBO(130, 250, 184, 1),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: StreamBuilder(
            stream: _authService.streamOfAuthState,
            builder: (context, snapshot) {
              // TODO: check for snapshot error and send to navigation manager for display
              return (snapshot.data == null) ? WelcomeScreen() : LobbyScreen();
            },
          )),
    );
  }
}
