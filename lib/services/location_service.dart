import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:niira/models/user_location.dart';

class LocationService {
  final Geolocator _geolocator;
  LocationService(this._geolocator);

  final _controller = StreamController<UserLocation>();

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
  void listenToUsersLocation() {
    var geolocator = _geolocator;
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    StreamSubscription positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      position != null
          ? _controller.add(
              UserLocation(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            )
          : print('no location');
    });
  }
}
