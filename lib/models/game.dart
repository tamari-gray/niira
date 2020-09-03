import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:niira/models/boundary.dart';

enum GamePhase { created, initialising, playing, finished }

class Game {
  final String id;
  final String name;
  final String creatorName;
  final String password;
  final int sonarIntervals;
  final Position location;
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

  Map<String, dynamic> toMap() =>
      <String, dynamic>{'name': name, 'id': id, 'creatorName': creatorName};
}
