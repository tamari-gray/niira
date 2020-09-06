import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';

class MockGames {
  List<Game> get gamesInorderOfDistance => <Game>[
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

  List<Game> get gamesToJoin => <Game>[
        Game(
          name: 'yeet',
          creatorName: 'tam',
          id: 'fadsg',
          sonarIntervals: 5,
          phase: GamePhase.created,
          boundarySize: 0,
          location: Location(latitude: -37.862655, longitude: 144.990368),
          password: 'password123',
          // distanceFromUser: 100,
        ),
        Game(
          name: 'very yeet',
          creatorName: 'stanley',
          id: '1000',
          sonarIntervals: 5,
          phase: GamePhase.created,
          boundarySize: 0,
          location: Location(latitude: -37.859845, longitude: 144.981232),
          password: 'password345',
          // distanceFromUser: 120,
        ),
        Game(
          name: 'yeeting',
          creatorName: 'kesha',
          id: 'fdfddgasgdshi',
          sonarIntervals: 5,
          phase: GamePhase.created,
          boundarySize: 0,
          location: Location(latitude: -37.854898, longitude: 144.989121),
          password: 'password678',
          // distanceFromUser: 1000,
        ),
        Game(
          name: 'seachuan',
          creatorName: 'timothy',
          id: 'gadsg',
          sonarIntervals: 5,
          phase: GamePhase.created,
          boundarySize: 0,
          location: Location(latitude: -37.872482, longitude: 144.991371),
          password: 'password910',
          // distanceFromUser: 10,
        ),
        Game(
          name: 'seek divine',
          creatorName: 'dave',
          id: 'fdfdshipdi98',
          sonarIntervals: 5,
          phase: GamePhase.created,
          boundarySize: 0,
          location: Location(latitude: -37.870585, longitude: 144.986638),
          password: 'password583490',
          // distanceFromUser: 150,
        )
      ].toList();
}
