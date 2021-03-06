import 'package:meta/meta.dart';

import 'location.dart';

// player is a user that has joined a game
class Player {
  final String id;
  final String username;
  final bool isTagger;
  final bool hasBeenTagged;
  final bool hasItem;
  final bool hasQuit;
  final bool locationSafe;

  Location location;

  Player(
      {@required this.id,
      @required this.username,
      @required this.isTagger,
      @required this.hasBeenTagged,
      @required this.hasItem,
      @required this.locationSafe,
      @required this.hasQuit});
}
