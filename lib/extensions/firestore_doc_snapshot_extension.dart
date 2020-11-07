import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';

extension FirestoreDocumentSnapshotExt on DocumentSnapshot {
  Game toGame() {
    // convert gamephase into enum
    final gamePhase =
        EnumToString.fromString(GamePhase.values, data()['phase']?.toString());

    // map document to game object
    return Game(
      id: id ?? 'undefined',
      name: data()['name']?.toString() ?? 'undefined',
      adminName: data()['admin_name']?.toString() ?? 'undefined',
      adminId: data()['admin_id']?.toString() ?? 'undefined',
      adminQuitCreatingGame:
          data()['admin_quit_creating_game'] as bool ?? false,
      password: data()['password']?.toString() ?? 'undefined',
      sonarIntervals: data()['sonar_intervals'] as double,
      phase: gamePhase ?? GamePhase.created,
      boundarySize: data()['boundary_size'] as double,
      boundaryPosition: Location.fromMap(
        data()['boundary_position'] as Map<String, dynamic>,
      ),
    );
  }
}
