import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:niira/models/game.dart';

import 'package:niira/models/location.dart';
import 'package:niira/utilities/calc_distance.dart';

class LocationService {
  final GeolocatorPlatform _geolocator;
  LocationService(this._geolocator);

  // check if location services are enabled
  Future<LocationPermission> checkForLocationPermission() =>
      _geolocator.checkPermission();

  // get users currentLocation
  Future<Position> get getUsersCurrentLocation =>
      _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

  // listen to users location
  Stream<Position> get listenToUsersLocation {
    return _geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
  }

  // set distance between user and games and order from nearest to furthest
  List<Game> setDistanceBetweenUserAndGames(
          List<Game> games, Location userLocation) =>
      games.map<Game>((game) {
        game.distanceFromUser = distance(
          lat1: userLocation.latitude,
          lat2: game.location.latitude,
          lon1: userLocation.longitude,
          lon2: game.location.longitude,
        );
        return game;
      }).toList();
}
