import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_account.dart';
import 'package:niira/screens/create_game1/create_game_screen1.dart';
import 'package:niira/screens/create_game2/create_game_screen2.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/screens/lobby/lobby.dart';
import 'package:niira/screens/sign_in.dart';
import 'package:niira/screens/waiting_screen/waiting_for_game_to_start.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

import 'utilities/firebase_wrapper.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final AuthService _authService;
  final DatabaseService _databaseService;
  final Navigation _navigation;
  final CreateGameViewModel _createGameVM;
  final LocationService _locationService;
  final FirebaseWrapper _firebase;
  final GameService _gameService;

  MyApp(
      {AuthService authService,
      DatabaseService databaseService,
      Navigation navigation,
      LocationService locationService,
      CreateGameViewModel createGameVM2,
      FirebaseWrapper firebase,
      GameService gameService})
      : _authService = authService,
        _gameService = gameService,
        _databaseService = databaseService,
        _navigation = navigation,
        _locationService = locationService,
        _createGameVM = createGameVM2,
        _firebase = firebase ?? FirebaseWrapper();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loadingServices;
  AuthService _authService;
  GameService _gameService;
  DatabaseService _databaseService;
  Navigation _navigation;
  LocationService _locationService;
  CreateGameViewModel _createGameVM;
  dynamic _firebaseInitError;
  bool _initializedFirebase;

  @override
  void initState() {
    super.initState();
    // show loading icon
    _loadingServices = true;
    _firebaseInitError = null;
    _initializedFirebase = false;
    initServices();
  }

  void initServices() async {
    // init firebase
    try {
      await widget._firebase.init();
      setState(() {
        _initializedFirebase = true;
      });
    } catch (e) {
      // show user an error message
      setState(() {
        _firebaseInitError = e;
      });
    }

    // create services to pass to app
    _navigation = widget._navigation ?? Navigation();

    _locationService =
        widget._locationService ?? LocationService(GeolocatorPlatform.instance);

    _createGameVM = widget._createGameVM ?? CreateGameViewModel();

    _authService = widget._authService ??
        FirebaseAuthService(FirebaseAuth.instance, _navigation);

    _gameService = widget._gameService ?? GameService();

    _databaseService =
        widget._databaseService ?? FirestoreService(FirebaseFirestore.instance);

    // initialise services in app
    setState(() {
      _loadingServices = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_firebaseInitError != null) {
      return ErrorPage(error: _firebaseInitError, trace: StackTrace.current);
    } else if (!_initializedFirebase || _loadingServices) {
      // Show a loader until FlutterFire is initialized
      return Loading();
    } else {
      return MultiProvider(
        providers: [
          Provider<AuthService>.value(value: _authService),
          Provider<GameService>.value(value: _gameService),
          Provider<DatabaseService>.value(value: _databaseService),
          Provider<Navigation>.value(value: _navigation),
          Provider<LocationService>.value(value: _locationService),
          ChangeNotifierProvider<CreateGameViewModel>.value(
            value: _createGameVM,
          )
        ],
        child: MaterialApp(
            title: 'Niira',
            navigatorKey: _navigation.navigatorKey,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Color.fromRGBO(247, 152, 0, 1),
              accentColor: Color.fromRGBO(130, 250, 184, 1),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routes: {
              WaitingForGameToStartScreen.routeName: (context) =>
                  WaitingForGameToStartScreen(),
              LobbyScreen.routeName: (context) => LobbyScreen(),
              CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
              SignInScreen.routeName: (context) => SignInScreen(),
              CreateGameScreen1.routeName: (context) => CreateGameScreen1(),
              CreateGameScreen2.routeName: (context) => CreateGameScreen2(),
              InputPasswordScreen.routeName: (context) => InputPasswordScreen(),
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
}

/// This widget just displays the available info if there is an error during
/// intialization.
///
/// It's not particularly pretty but it shouldn't ever be seen and if it is,
/// we just need to view the available info.
class ErrorPage extends StatelessWidget {
  final dynamic _error;
  final StackTrace _trace;
  const ErrorPage({
    @required dynamic error,
    @required StackTrace trace,
    Key key,
  })  : _error = error,
        _trace = trace,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SizedBox(height: 50),
            Text('Looks like there was a problem.',
                textDirection: TextDirection.ltr),
            SizedBox(height: 20),
            Text(_error.toString(), textDirection: TextDirection.ltr),
            SizedBox(height: 50),
            Text(_trace.toString(), textDirection: TextDirection.ltr),
          ],
        ),
      ),
    );
  }
}
