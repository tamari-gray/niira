import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';

class MockGames {
  List<Game> get gamesToJoin => <Game>[
        Game(
            name: 'yeet',
            creatorName: 'tam',
            id: '034280',
            sonarIntervals: 5,
            phase: GamePhase.created,
            boundarySize: 0,
            location: Location(latitude: 0, longitude: 0),
            password: 'password123'),
        Game(
            name: 'very yeet',
            creatorName: 'tam',
            id: 'fdhi',
            sonarIntervals: 5,
            phase: GamePhase.created,
            boundarySize: 0,
            location: Location(latitude: 0, longitude: 0),
            password: 'password345'),
        Game(
            name: 'yeeting',
            creatorName: 'tam',
            id: 'fdfdshi',
            sonarIntervals: 5,
            phase: GamePhase.created,
            boundarySize: 0,
            location: Location(latitude: 0, longitude: 0),
            password: 'password678')
      ].toList();
}
