import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:niira/models/location.dart';
import 'package:niira/services/location_service.dart';

class FakeLocationService extends Fake implements LocationService {
  // get users currentLocation
  @override
  Future<Location> getUsersCurrentLocation() =>
      Future.value(Location(longitude: 0, latitude: 0));
}
