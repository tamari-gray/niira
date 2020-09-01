import 'dart:async';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/models/game.dart';

class LocationService {
  final Geolocator _geolocator;
  LocationService(this._geolocator);

  // check if location services are enabled
  Future<GeolocationStatus> checkForLocationPermission() =>
      _geolocator.checkGeolocationPermissionStatus();

  // get users currentLocation
  Future<Position> get getUsersCurrentLocation =>
      _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // listen to users location
  Stream<Position> get listenToUsersLocation {
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    return _geolocator.getPositionStream(locationOptions);
  }

  // get distance between user and games and order from nearest to furthest
  Future<Stream<List<Game>>> getDistanceBetweenUserAndGames(
      Stream<List<Game>> games) async {
    final usersCurrentLocation = await getUsersCurrentLocation;

    for (var game in games) {
      final distance = await _geolocator.distanceBetween(
        game.boundary.position.latitude,
        game.boundary.position.longitude,
        usersCurrentLocation.latitude,
        usersCurrentLocation.longitude,
      );
      game.distanceFromUser = distance;
    }
  }
}
