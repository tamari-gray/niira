import 'package:niira/models/location.dart';
import 'package:niira/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:niira/utilities/calc_distance.dart';
import 'package:test/test.dart';

import '../../../mocks/data/mock_games.dart';

void main() {
  test(
      'locationService.setDistanceBetweenUserAndGames returns list of games with distanceFromUser set',
      () {
    // init mock service
    final geolocator = GeolocatorPlatform.instance;
    final locationService = LocationService(geolocator);
    // init mock data
    final mockUserLocation =
        Location(latitude: -37.865351, longitude: 144.989012);
    final mockGames = MockGames().gamesWithoutDistance;

    // generate expected outcome
    final gameOneExpectedDistance = distance(
        lat1: mockGames[0].location.latitude,
        lon1: mockGames[0].location.longitude,
        lat2: mockUserLocation.latitude,
        lon2: mockUserLocation.longitude); // result = 820.0
    final gameTwoExpectedDistance = distance(
        lat1: mockGames[1].location.latitude,
        lon1: mockGames[1].location.longitude,
        lat2: mockUserLocation.latitude,
        lon2: mockUserLocation.longitude); // result = 323.0

    // call function with mockData
    final mockGamesWithDistance =
        locationService.setAndOrderGamesByDistance(mockGames, mockUserLocation);

    // check mockGame.distanceFromUser is equal to expected distance
    expect(mockGamesWithDistance[1].distanceFromUser, gameOneExpectedDistance);
    expect(mockGamesWithDistance[0].distanceFromUser, gameTwoExpectedDistance);

    // check mockGames are inorder from nearest to furtherest from user
    expect(mockGamesWithDistance[0].id, mockGames[1].id);
    expect(mockGamesWithDistance[1].id, mockGames[0].id);
  });
}
