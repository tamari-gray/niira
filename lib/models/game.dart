import 'package:meta/meta.dart';
import 'package:niira/models/location.dart';

enum GamePhase { created, initialising, playing, finished }

class Game {
  String id;
  final String name;
  final String adminName;
  final String adminId;
  final String password;
  final double sonarIntervals;
  final Location boundaryPosition;
  final double boundarySize;
  final GamePhase phase;

  double distanceFromUser;

  Game({
    this.id,
    @required this.name,
    @required this.adminName,
    @required this.adminId,
    @required this.sonarIntervals,
    @required this.password,
    @required this.boundaryPosition,
    @required this.boundarySize,
    @required this.phase,
    this.distanceFromUser,
  });
}
