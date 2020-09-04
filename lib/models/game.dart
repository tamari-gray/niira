import 'package:meta/meta.dart';
import 'package:niira/models/location.dart';

enum GamePhase { created, initialising, playing, finished }

class Game {
  final String id;
  final String name;
  final String creatorName;
  final String password;
  final int sonarIntervals;
  double distanceFromUser;
  final Location location;
  final int boundarySize;
  final GamePhase phase;

  Game({
    @required this.id,
    @required this.name,
    @required this.creatorName,
    @required this.sonarIntervals,
    @required this.password,
    @required this.location,
    @required this.boundarySize,
    @required this.phase,
  });
}
