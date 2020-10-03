import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';

class MockGames {
  List<Game> gamesInorderOfDistance = <Game>[
    Game(
      name: 'pullo',
      creatorName: 'fdsafd',
      id: 'closest',
      sonarIntervals: 5,
      phase: GamePhase.created,
      boundarySize: 0,
      location: Location(latitude: -37.861844, longitude: 144.989905),
      password: 'password12345',
      distanceFromUser: 10,
    ),
    Game(
      name: 'yeet',
      creatorName: 'tam',
      id: 'middle',
      sonarIntervals: 5,
      phase: GamePhase.created,
      boundarySize: 0,
      location: Location(latitude: -37.862655, longitude: 144.990368),
      password: 'password123',
      distanceFromUser: 20,
    ),
    Game(
      name: 'teet',
      creatorName: 'tam',
      id: 'furtherest',
      sonarIntervals: 5,
      phase: GamePhase.created,
      boundarySize: 0,
      location: Location(latitude: -37.862655, longitude: 144.990368),
      password: 'password123',
      distanceFromUser: 30,
    ),
  ];
}
