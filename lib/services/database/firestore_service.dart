import 'package:niira/models/boundary.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class FirestoreService implements DatabaseService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  @override
  Future<bool> usernameAlreadyExists(String username) async {
    final snapshot = await _firestore
        .collection('players')
        .where('username', isEqualTo: username)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<void> addUsername(String userId, String username) {
    return _firestore
        .doc('players/$userId')
        .set(<String, String>{'username': username}, SetOptions(merge: true));
  }

  @override
  Stream<List<Game>> get streamOfCreatedGames => _firestore
      .collection('games')
      .snapshots()
      .map((QuerySnapshot snapshot) => snapshot.docs.map((gameDoc) {
            // convert gamephase into enum
            final gamePhase = EnumToString.fromString(
                GamePhase.values, gameDoc.data()['phase'].toString());
            return Game(
              id: gameDoc.data()['id'].toString() ?? 'undefined',
              name: gameDoc.data()['name'].toString() ?? 'undefined',
              creatorName:
                  gameDoc.data()['creatorName'].toString() ?? 'undefined',
              sonarIntervals: gameDoc.data()['sonarIntervals'] as int,
              phase: gamePhase ?? GamePhase.created,
              boundary: Boundary(
                size: gameDoc.data()['boundary']['size'] as int ?? 0,
                position: gameDoc.data()['boundary']['position'] as int ?? 0,
              ),
            );
          }).toList());

  @override
  Stream<List<Player>> streamOfJoinedPlayers(String gameId) {
    return _firestore.collection('games/$gameId/players').snapshots().map(
          (QuerySnapshot snapshot) => snapshot.docs
              .map(
                (playerDoc) => Player(
                  id: playerDoc.data()['id'].toString() ?? 'undefined',
                  username:
                      playerDoc.data()['username'].toString() ?? 'undefined',
                  isTagger: playerDoc.data()['isTagger'] as bool ?? false,
                  hasBeenTagged:
                      playerDoc.data()['hasBeenTagged'] as bool ?? false,
                  hasItem: playerDoc.data()['hasItem'] as bool ?? false,
                  isAdmin: playerDoc.data()['isAdmin'] as bool ?? false,
                ),
              )
              .toList(),
        );
  }
}
