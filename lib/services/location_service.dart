import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:niira/models/location.dart';

class LocationService {
  final GeolocatorPlatform _geolocator;
  LocationService(this._geolocator);

  // check if location services are enabled
  Future<LocationPermission> checkForLocationPermission() =>
      _geolocator.checkPermission();

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
}
