import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/auth/navigation_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final NavigationService nav = NavigationService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => FirebaseAuthService(FirebaseAuth.instance, nav)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: nav.navigatorKey,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(247, 152, 0, 1),
          accentColor: Color.fromRGBO(130, 250, 184, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
