import 'package:geolocator/geolocator.dart';
import 'package:niira/models/boundary.dart';
import 'package:niira/models/game.dart';

class MockGames {
  List<Game> get gamesToJoin => <Game>[
        Game(
            name: 'yeet',
            creatorName: 'tam',
            id: '034280',
            sonarIntervals: 5,
            phase: GamePhase.created,
            boundary: Boundary(position: Position(), size: 10),
            password: 'password123'),
        Game(
            name: 'very yeet',
            creatorName: 'tam',
            id: 'fdhi',
            sonarIntervals: 5,
            phase: GamePhase.created,
            boundary: Boundary(position: Position(), size: 10),
            password: 'password345'),
        Game(
            name: 'yeeting',
            creatorName: 'tam',
            id: 'fdfdshi',
            sonarIntervals: 5,
            phase: GamePhase.created,
            boundary: Boundary(position: Position(), size: 10),
            password: 'password678')
      ].toList();
}
