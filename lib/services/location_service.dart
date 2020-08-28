import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  final Geolocator _geolocator;
  LocationService(this._geolocator);

  // check if location services are enabled
  Future<GeolocationStatus> checkForLocationPermission() async {
    return await _geolocator.checkGeolocationPermissionStatus();
  }

  // get users currentLocation
  Future<Position> getUsersCurrentLocation() async {
    return await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // listen to users location
  Stream<Position> get listenToUsersLocation {
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    return _geolocator.getPositionStream(locationOptions);
  }
}
