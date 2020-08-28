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
          boundary: Boundary(position: 5, size: 10),
        ),
        Game(
          name: 'very yeet',
          creatorName: 'tam',
          id: 'fdhi',
          sonarIntervals: 5,
          phase: GamePhase.created,
          boundary: Boundary(position: 5, size: 10),
        ),
        Game(
          name: 'yeeting',
          creatorName: 'tam',
          id: 'fdfdshi',
          sonarIntervals: 5,
          phase: GamePhase.created,
          boundary: Boundary(position: 5, size: 10),
        )
      ].toList();
}