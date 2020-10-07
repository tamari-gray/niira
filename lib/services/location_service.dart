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

  // ask for location permission
  Future<LocationPermission> askForLocationPermission() =>
      _geolocator.requestPermission();

  // get users currentLocation
  Future<Location> getUsersCurrentLocation() async {
    final currentPosition = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Location(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);
  }

  // listen to users location
  Stream<Position> get listenToUsersLocation {
    return _geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
  }

  // update distance between user and games and order from nearest to furthest
  List<Game> updateAndOrderGamesByDistance(
      List<Game> games, Location userLocation) {
    // calculate and set distanceFromUser property in each game
    final gamesWithDistance = games.map<Game>((game) {
      game.distanceFromUser = distance(
        lat1: userLocation.latitude,
        lat2: game.location.latitude,
        lon1: userLocation.longitude,
        lon2: game.location.longitude,
      );
      return game;
    }).toList();

    // order games by distanceFromUser (nearest to furtherest)
    gamesWithDistance
        .sort((a, b) => a.distanceFromUser.compareTo(b.distanceFromUser));

    return gamesWithDistance;
  }
}
