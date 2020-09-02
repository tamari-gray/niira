import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final GeolocatorPlatform _geolocator;
  LocationService(this._geolocator);

  // check if location services are enabled
  Future<LocationPermission> checkForLocationPermission() =>
      _geolocator.checkPermission();

  // get users currentLocation
  Future<Position> getUsersCurrentLocation() =>
      _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // listen to users location
  Stream<Position> get listenToUsersLocation {
    return _geolocator.getPositionStream();
  }
}
