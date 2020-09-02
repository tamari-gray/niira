import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/services/location_service.dart';

class MockLocationService extends Mock implements LocationService {
  // get users currentLocation
  @override
  Future<Position> get getUsersCurrentLocation =>
      Future.value(Position(longitude: 0, latitude: 0));

  // set distance between user and games and order from nearest to furthest
  @override
  List<Game> setDistanceBetweenUserAndGames(
          List<Game> games, Position userLocation) =>
      games.map<Game>((game) {
        // give random different distances
        final distance = games.indexOf(game) * 100 as double;
        game.distanceFromUser = distance;
        return game;
      }).toList();
}
