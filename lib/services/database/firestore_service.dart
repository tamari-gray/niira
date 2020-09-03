import 'package:geolocator/geolocator.dart';
import 'package:niira/models/boundary.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class FirestoreService implements DatabaseService {
  final FirebaseFirestore _firestore;
  // final String _userId;

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
  Future<String> getUserName(String userId) async {
    return _firestore.doc('players/$userId').get().then(
          (doc) => doc.data()['username'].toString() ?? 'undefined',
        );
  }

  @override
  Stream<List<Game>> get streamOfCreatedGames => _firestore
      .collection('games')
      .snapshots()
      .map((QuerySnapshot snapshot) => snapshot.docs.map((gameDoc) {
            // convert gamephase into enum
            final gamePhase = EnumToString.fromString(
                GamePhase.values, gameDoc.data()['phase'].toString());
            // return Game(
            //     name: gameDoc.data()['name'].toString(),
            //     creatorName: 'tam',
            //     id: '034280',
            //     sonarIntervals: 5,
            //     phase: GamePhase.created,
            //     boundary: Boundary(position: Position(), size: 10),
            //     password: 'password123');
            return Game(
              id: gameDoc.data()['id']?.toString() ?? 'undefined',
              name: gameDoc.data()['name']?.toString() ?? 'undefined',
              creatorName:
                  gameDoc.data()['creatorName']?.toString() ?? 'undefined',
              password: gameDoc.data()['password']?.toString() ?? 'undefined',
              sonarIntervals: gameDoc.data()['sonarIntervals'] as int,
              phase: gamePhase ?? GamePhase.created,
              boundary: Boundary(
                size: gameDoc.data()['boundary']['position'] as int ?? 0,
                position: Position(
                  latitude: gameDoc.data()['boundary']['position']['latitude']
                          as double ??
                      0,
                  longitude: gameDoc.data()['boundary']['position']['longitude']
                          as double ??
                      0,
                ),
              ),
            );
          }).toList());

  @override
  Future<void> joinGame(String gameId, String userId) async {
    // create player object
    final username = await getUserName(userId);
    final player = Player(
      id: userId,
      username: username,
      isTagger: false,
      hasBeenTagged: false,
      hasItem: false,
      isAdmin: false,
    );

    // add player to game in db
    return _firestore
        .doc('games/$gameId/players/${player.id}')
        .set(<String, dynamic>{
      'username': player.username,
      'has_been_tagged': player.hasBeenTagged,
      'has_item': player.hasItem,
      'is_tagger': player.isTagger,
      'is_admin': player.isAdmin
    }, SetOptions(merge: true));
  }
}
