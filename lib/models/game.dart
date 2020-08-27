import 'package:meta/meta.dart';
import 'package:niira/models/boundary.dart';

enum GamePhase { created, initialising, playing, finished }

class Game {
  final String name;
  final String creatorName;
  final String id;
  final int sonarIntervals;
  final Boundary boundary; //game location is boundary.position

  final GamePhase phase;
  Game({
    @required this.name,
    @required this.creatorName,
    @required this.id,
    @required this.sonarIntervals,
    @required this.boundary,
    @required this.phase,
  });
}
