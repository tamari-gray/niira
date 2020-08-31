import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niira/map_page.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:niira/services/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // show user an error message
  }

  // init services
  final navigationService = NavigationService();
  final authService =
      FirebaseAuthService(FirebaseAuth.instance, navigationService);
  final databaseService = FirestoreService(FirebaseFirestore.instance);

  runApp(MyApp(authService, navigationService.navigatorKey, databaseService,
      navigationService));
}

class MyApp extends StatefulWidget {
  final AuthService _authService;
  final DatabaseService _databaseService;
  final NavigationService _navigationService;
  final GlobalKey<NavigatorState> _navigatorKey;

  MyApp(this._authService, this._navigatorKey, this._databaseService,
      this._navigationService);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _requestPermissions();
    super.initState();
  }

  void _requestPermissions() async {
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: widget._authService),
        Provider<DatabaseService>.value(value: widget._databaseService),
        Provider<NavigationService>.value(value: widget._navigationService),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: widget._navigatorKey,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color.fromRGBO(247, 152, 0, 1),
            accentColor: Color.fromRGBO(130, 250, 184, 1),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: StreamBuilder(
            stream: widget._authService.streamOfAuthState,
            builder: (context, snapshot) {
              return MapPage();
              // TODO: check for snapshot error and send to navigation manager for display
              // return (snapshot.data == null) ? WelcomeScreen() : LobbyScreen();
            },
          )),
    );
  }
}
