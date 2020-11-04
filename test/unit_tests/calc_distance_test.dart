import 'package:niira/models/location.dart';
import 'package:niira/utilities/calc_distance.dart';
import 'package:test/test.dart';

import '../mocks/data/mock_games.dart';

void main() {
  test('returns in km to nearest 100m e.g 1.5km', () {
    // init data
    final _userLocation = Location(latitude: -37.8654, longitude: 144.9814);
    final _gameLocation =
        MockGames().gamesInorderOfDistance[1].boundaryPosition;

    // calc distance
    final _distance = distance(
      lat1: _userLocation.latitude,
      lat2: _gameLocation.latitude,
      lon1: _userLocation.longitude,
      lon2: _gameLocation.longitude,
    );

    // check that distance is rounded to 1 decimal place e.g 1.5
    expect(_distance.toString().length, 3);
  });
}
