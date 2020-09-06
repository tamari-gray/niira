import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/services/location_service.dart';

class MockLocationService extends Mock implements LocationService {
  // get users currentLocation
  @override
  Future<Position> get getUsersCurrentLocation =>
      Future.value(Position(longitude: 0, latitude: 0));

  // set distance between user and games
  @override
  List<Game> setAndOrderGamesByDistance(
          List<Game> games, Location userLocation) =>
      games;
}
