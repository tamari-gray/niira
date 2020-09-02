import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/navigation/navigation.dart';
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
  final navigation = Navigation();
  final authService = FirebaseAuthService(FirebaseAuth.instance, navigation);
  final databaseService = FirestoreService(FirebaseFirestore.instance);

  final geolocator = Geolocator();
  final locationService = LocationService(geolocator);

  runApp(MyApp(
    authService,
    navigation.navigatorKey,
    databaseService,
    navigation,
    locationService,
  ));
}

class MyApp extends StatefulWidget {
  final AuthService _authService;
  final DatabaseService _databaseService;
  final Navigation _navigation;
  final LocationService _locationService;
  final GlobalKey<NavigatorState> _navigatorKey;

  MyApp(this._authService, this._navigatorKey, this._databaseService,
      this._navigation, this._locationService);

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
        Provider<LocationService>.value(value: widget._locationService),
        Provider<Navigation>.value(value: widget._navigation),
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
              // TODO: check for snapshot error and send to navigation manager for display
              return (snapshot.data == null) ? WelcomeScreen() : LobbyScreen();
            },
          )),
    );
  }
}
