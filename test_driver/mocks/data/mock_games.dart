import 'package:niira/models/boundary.dart';
import 'package:niira/models/game.dart';

class MockGames {
  List<Game> get gamesToJoin => <Game>[
        Game(
          'yeet',
          'tam',
          'fdhi',
          5,
          Boundary(5, 10),
        ),
        Game(
          'yeety',
          'tim',
          'fdhi',
          5,
          Boundary(5, 10),
        ),
        Game(
          'very yeet',
          'tedd',
          'fdhi',
          5,
          Boundary(5, 10),
        ),
        Game(
          'yeetin',
          'tom',
          'fdhi',
          5,
          Boundary(5, 10),
        ),
        Game(
          'yeet yeet',
          'trent',
          'fdhi',
          5,
          Boundary(5, 10),
        )
      ];
}
