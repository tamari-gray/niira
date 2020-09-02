import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:niira/services/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;
  final NavigationService navigation;
  final GlobalKey<NavigatorState> navigatorKey;

  MyApp(
      {this.authService,
      this.navigatorKey,
      this.databaseService,
      this.navigation});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loadingServices;
  AuthService _authService;
  DatabaseService _databaseService;
  NavigationService _navigation;
  GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    _requestPermissions();
    super.initState();
    // show loading icon
    _loadingServices = true;
    initServices();
  }

  void initServices() async {
    // init firebase
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // show user an error message
    }

    // create services to pass to app
    final navigation = widget.navigation ?? NavigationService();
    final navigatorKey =
        widget.navigation.navigatorKey ?? navigation.navigatorKey;
    final authService = widget.authService ??
        FirebaseAuthService(FirebaseAuth.instance, navigation);
    final databaseService =
        widget.databaseService ?? FirestoreService(FirebaseFirestore.instance);

    // initialise services in app
    setState(() {
      _navigation = navigation;
      _navigatorKey = navigatorKey;
      _authService = authService;
      _databaseService = databaseService;
      _loadingServices = false;
    });
  }

  void _requestPermissions() async {
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loadingServices
        ? Loading()
        : MultiProvider(
            providers: [
              Provider<AuthService>.value(value: _authService),
              Provider<DatabaseService>.value(value: _databaseService),
              Provider<NavigationService>.value(value: _navigation),
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
                  return (snapshot.data == null)
                      ? WelcomeScreen()
                      : LobbyScreen();
                },
              ),
            ),
          );
  }
}
