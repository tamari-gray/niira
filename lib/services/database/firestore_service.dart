import 'package:niira/models/boundary.dart';
import 'package:niira/models/game.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      .map(
        (QuerySnapshot snapshot) => snapshot.docs
            .map((gameDoc) => Game(
                  id: gameDoc.data()['id'].toString() ?? 'undefined',
                  name: gameDoc.data()['name'].toString() ?? 'undefined',
                  creatorName:
                      gameDoc.data()['creatorName'].toString() ?? 'undefined',
                  sonarIntervals: gameDoc.data()['sonarIntervals'] as int,
                  // phase: gameDoc.data()['phase'].toString() ?? 'undefined', //TODO: how to turn int into enum?
                  boundary: Boundary(
                    size: gameDoc.data()['boundary']['position'] as int ?? 0,
                    position:
                        gameDoc.data()['boundary']['position'] as int ?? 0,
                  ),
                ))
            .toList(),
      );
}
