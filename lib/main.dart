import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/models/user_id.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_account.dart';
import 'package:niira/screens/create_game1/create_game_screen1.dart';
import 'package:niira/screens/create_game2/create_game_screen2.dart';
import 'package:niira/screens/input_password.dart';
import 'package:niira/screens/joined_game_screens/joined_game_screens.dart';
import 'package:niira/screens/lobby/lobby.dart';
import 'package:niira/screens/sign_in.dart';
import 'package:niira/screens/welcome.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/auth/firebase_auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/database/firestore_service.dart';
import 'package:niira/services/location_service.dart';
import 'package:provider/provider.dart';

import 'screens/error_page.dart';
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

  MyApp(
      {AuthService authService,
      DatabaseService databaseService,
      Navigation navigation,
      LocationService locationService,
      CreateGameViewModel createGameVM2,
      FirebaseWrapper firebase})
      : _authService = authService,
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

    _databaseService = widget._databaseService ??
        FirestoreService(FirebaseFirestore.instance, Geoflutterfire());

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
            LobbyScreen.routeName: (context) => LobbyScreen(),
            CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
            SignInScreen.routeName: (context) => SignInScreen(),
            CreateGameScreen1.routeName: (context) => CreateGameScreen1(),
            CreateGameScreen2.routeName: (context) => CreateGameScreen2(),
            InputPasswordScreen.routeName: (context) => InputPasswordScreen(),
          },
          home: StreamBuilder<String>(
              stream: _authService.streamOfAuthState,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  // context.watch<Navigation>().displayError(snapshot.error);
                }
                // check if user is signed in
                if (snapshot.data == null) {
                  return WelcomeScreen();
                } else {
                  // check if can ask for position with a seperate call then if have position
                  // return the location stream
                  return StreamProvider<Location>(
                    create: (_) =>
                        context.read<LocationService>().listenToUsersLocation,
                    child: HandleLocation(userId: snapshot.data),
                  );
                }
              }),
        ),
      );
    }
  }
}

class HandleLocation extends StatefulWidget {
  const HandleLocation({Key key, @required this.userId}) : super(key: key);

  final String userId;

  @override
  _HandleLocationState createState() => _HandleLocationState();
}

class _HandleLocationState extends State<HandleLocation> {
  LocationPermission _locationPermission;

  @override
  void initState() {
    super.initState();
    _askForPermission();
  }

  void _askForPermission() async {
    final _permission =
        await context.read<LocationService>().checkForLocationPermission();
    setState(() {
      _locationPermission = _permission;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_locationPermission == null) {
      return Loading(
          message: 'location permission is null, waiting for miracle');
    } else if (_locationPermission == LocationPermission.always ||
        _locationPermission == LocationPermission.whileInUse) {
      return CheckIfJoinedGame(userId: widget.userId);
    } else if (_locationPermission == LocationPermission.deniedForever) {
      return Scaffold(
        body: Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  title: Text(
                      'Please enable location services for niira in your phones settings, then tap refresh'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Refresh'),
                      onPressed: () async {
                        final _newPermission = await context
                            .read<LocationService>()
                            .requestPermission();
                        setState(() {
                          _locationPermission = _newPermission;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_locationPermission == LocationPermission.denied) {
      return Scaffold(
        body: Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  title:
                      Text('Please enable location services to play Niira :)'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Enable'),
                      onPressed: () async {
                        final _newPermission = await context
                            .read<LocationService>()
                            .requestPermission();
                        setState(() {
                          _locationPermission = _newPermission;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Loading(
        message: 'getting user location, tam check handle location widget',
      );
    }
  }
}

/// gets user data from db,
/// then checks if user has joined a game already to show appropriate screen
class CheckIfJoinedGame extends StatelessWidget {
  final String userId;
  const CheckIfJoinedGame({Key key, @required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: context.watch<DatabaseService>().userData(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            context.read<Navigation>().displayError(snapshot.error);
          }

          if (snapshot.data != null) {
            return snapshot.data.currentGameId == ''
                ? LobbyScreen()
                : JoinedGameScreens(gameId: snapshot.data.currentGameId);
          } else {
            return Scaffold(body: Loading(message: 'Getting your data...'));
          }
        });
  }
}
