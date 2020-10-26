import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/models/location.dart';
import 'package:niira/extensions/game_extension.dart';
import 'package:niira/extensions/firestore_doc_snapshot_extension.dart';
import 'package:niira/services/database/database_service.dart';

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
  Future<String> getUserName(String userId) async {
    print('userid: $userId');
    return await _firestore.doc('players/$userId').get().then((doc) {
      print(doc.id);
      return doc.data()['username'].toString() ?? 'undefined';
    });
  }

  @override
  Stream<List<Game>> get streamOfCreatedGames => _firestore
      .collection('games')
      .snapshots()
      .map((QuerySnapshot snapshot) => snapshot.docs.map((gameDoc) {
            // convert gamephase into enum
            final gamePhase = EnumToString.fromString(
                GamePhase.values, gameDoc.data()['phase']?.toString());

            // map document to game object
            return Game(
              id: gameDoc.data()['id']?.toString() ?? 'undefined',
              name: gameDoc.data()['name']?.toString() ?? 'undefined',
              adminName:
                  gameDoc.data()['admin_name']?.toString() ?? 'undefined',
              adminId: gameDoc.data()['admin_id']?.toString() ?? 'undefined',
              password: gameDoc.data()['password']?.toString() ?? 'undefined',
              sonarIntervals: gameDoc.data()['sonar_intervals'] as double,
              phase: gamePhase ?? GamePhase.created,
              boundarySize: gameDoc.data()['boundary_size'] as double,
              boundaryPosition: Location.fromMap(
                  gameDoc.data()['boundary_position'] as Map<String, dynamic>),
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
                  isTagger: playerDoc.data()['is_tagger'] as bool ?? false,
                  hasBeenTagged:
                      playerDoc.data()['has_been_tagged'] as bool ?? false,
                  hasItem: playerDoc.data()['has_item'] as bool ?? false,
                  isAdmin: playerDoc.data()['is_admin'] as bool ?? false,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> leaveGame(String gameId, String playerId) async {
    return await _firestore.doc('games/$gameId/players/${playerId}').delete();
  }

  @override
  Future<void> joinGame(String gameId, String userId, bool isAdmin) async {
    // create player object
    final username = await getUserName(userId);
    final player = Player(
      id: userId,
      username: username,
      isTagger: false,
      hasBeenTagged: false,
      hasItem: false,
      isAdmin: isAdmin,
    );

    // add player to game in db
    return await _firestore
        .doc('games/$gameId/players/${player.id}')
        .set(<String, dynamic>{
      'username': player.username,
      'has_been_tagged': player.hasBeenTagged,
      'has_item': player.hasItem,
      'is_tagger': player.isTagger,
      'is_admin': player.isAdmin
    }, SetOptions(merge: true));
  }

  @override
  Future<String> createGame(Game game, String userId) async {
    try {
      final gameRef = await _firestore.collection('games').add(game.toMap());

      await joinGame(gameRef.id, userId, true);
      return gameRef.id;
    } catch (e) {
      // do something
      print('error creating game ${e}');
      return null;
    }
  }

  @override
  Stream<Game> streamOfJoinedGame(String gameId) {
    try {
      return _firestore
          .doc('games/$gameId')
          .snapshots()
          .map((doc) => doc.toGame());
    } catch (e) {
      print('error getting stream of joined game: $e');
      return null;
    }
  }
}
