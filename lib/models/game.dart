import 'package:niira/models/boundary.dart';

class Game {
  final String name;
  final String creatorName;
  final String id;
  final int sonarIntervals;
  final Boundary boundary; //game location is boundary.position

  Game(
    this.name,
    this.creatorName,
    this.id,
    this.sonarIntervals,
    this.boundary,
  );
}
