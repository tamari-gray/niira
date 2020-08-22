import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/auth/navigation_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // show user an error message
  }

  // init services
  final nav = NavigationService();
  final authService = FirebaseAuthService(FirebaseAuth.instance, nav);
  final firestoreInstance = FirebaseFirestore.instance;
  final dbService = FirestoreService(firestoreInstance);

  runApp(MyApp(authService, nav.navigatorKey, dbService));
}

class MyApp extends StatelessWidget {
  final AuthService _authService;
  final DatabaseService _firestoreService;
  final GlobalKey<NavigatorState> _navigatorKey;

  MyApp(this._authService, this._navigatorKey, this._firestoreService);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: _authService),
        Provider<DatabaseService>.value(value: _firestoreService),
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
