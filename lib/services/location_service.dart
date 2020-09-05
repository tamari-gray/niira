import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:niira/models/game.dart';
import 'dart:math';

import 'package:niira/models/location.dart';

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
          userLocation.latitude,
          game.location.latitude,
          userLocation.longitude,
          game.location.longitude,
        );
        return game;
      }).toList();
}

// algorithm from:
// https://www.geeksforgeeks.org/program-distance-two-points-earth/
double distance(double lat1, double lat2, double lon1, double lon2) {
  lon1 = degreesToRads(lon1);
  lon2 = degreesToRads(lon2);
  lat1 = degreesToRads(lat1);
  lat2 = degreesToRads(lat2);

  // Haversine formula
  final dlon = lon2 - lon1;
  final dlat = lat2 - lat1;
  final a = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2) as double;

  final c = 2 * asin(sqrt(a));

  // Radius of earth in kilometers. Use 3956 for miles
  final r = 6371;

  // returns result in km
  final resultInKm = (c * r);
  final resultInMetresRounded =
      double.parse((resultInKm * 1000).toStringAsFixed(0));
  return resultInMetresRounded;
}

double degreesToRads(double deg) {
  return (deg * pi) / 180.0;
}
