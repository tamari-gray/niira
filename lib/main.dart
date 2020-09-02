import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niira/screens/create_account.dart';
import 'package:niira/loading.dart';
import 'package:niira/screens/lobby.dart';
import 'package:niira/screens/sign_in.dart';
import 'package:niira/screens/waiting_for_game_to_start.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final AuthService _authService;
  final DatabaseService _databaseService;
  final Navigation _navigation;

  MyApp(
      {AuthService authService,
      DatabaseService databaseService,
      Navigation navigation})
      : _authService = authService,
        _databaseService = databaseService,
        _navigation = navigation;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loadingServices;
  AuthService _authService;
  DatabaseService _databaseService;
  Navigation _navigation;

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
    _navigation = widget._navigation ?? Navigation();
    _authService = widget._authService ??
        FirebaseAuthService(FirebaseAuth.instance, _navigation);
    _databaseService =
        widget._databaseService ?? FirestoreService(FirebaseFirestore.instance);

    // initialise services in app
    setState(() {
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
              Provider<Navigation>.value(value: _navigation),
            ],
            child: MaterialApp(
                title: 'Flutter Demo',
                navigatorKey: _navigation.navigatorKey,
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: Color.fromRGBO(247, 152, 0, 1),
                  accentColor: Color.fromRGBO(130, 250, 184, 1),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                routes: {
                  '/waiting_for_game_start': (context) =>
                      WaitingForGameToStartScreen(),
                  '/create_account': (context) => CreateAccountScreen(),
                  '/sign_in': (context) => SignInScreen(),
                  // TODO: complete when database strategy for games has been finalised
                  // '/input_password': (context) => InputPasswordScreen(),
                },
                home: StreamBuilder(
                  stream: _authService.streamOfAuthState,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      context.read<Navigation>().displayError(snapshot.error);
                    }

                    return (snapshot.data == null)
                        ? WelcomeScreen()
                        : LobbyScreen();
                  },
                )),
          );
  }
}
