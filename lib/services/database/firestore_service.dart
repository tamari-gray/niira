import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/extensions/game_extension.dart';
import 'package:niira/extensions/player_extension.dart';
import 'package:niira/extensions/firestore_query_snapshot_extension.dart';
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
    return await _firestore.doc('players/$userId').get().then((doc) {
      return doc.data()['username'].toString() ?? 'undefined';
    });
  }

  @override
  Stream<List<Game>> get streamOfCreatedGames => _firestore
      .collection('games')
      .snapshots()
      .map((QuerySnapshot snapshot) => snapshot.toListOfGames());

  @override
  Stream<List<Player>> streamOfJoinedPlayers(String gameId) {
    return _firestore
        .collection('games/$gameId/players')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.toListOfPlayers());
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
      isAdmin: isAdmin ?? false,
    );

    // add player to game in db
    try {
      return await _firestore
          .doc('games/$gameId/players/$userId')
          .set(player.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('error joining game: $e');
    }
  }

  @override
  Future<String> createGame(Game game, String userId) async {
    try {
      // create game
      final gameRef = await _firestore.collection('games').add(game.toMap());

      // join game as admin
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

  @override
  Future<void> chooseTagger(String playerId, String gameId) async {
    try {
      // check if there is already a tagger chosen
      final currentTaggerQuery = await _firestore
          .collection('games/$gameId/players')
          .where('is_tagger', isEqualTo: true)
          .get();
      if (currentTaggerQuery.size > 0) {
        final taggerId = currentTaggerQuery.docs.first.id;
        // un-choose current tagger
        await _firestore
            .doc('games/$gameId/players/$taggerId')
            .update(<String, bool>{'is_tagger': false});
      }

      // set new tagger
      return await _firestore
          .doc('games/$gameId/players/$playerId')
          .update(<String, bool>{'is_tagger': true});
    } catch (e) {
      print('error choosing tagger, $e');
      return null;
    }
  }

  @override
  Future<void> unSelectTagger(String playerId, String gameId) async {
    try {
      return await _firestore
          .doc('games/$gameId/players/$playerId')
          .update(<String, bool>{'is_tagger': false});
    } catch (e) {
      print('error un-selecting tagger, $e');
      return null;
    }
  }

  @override
  Future<Game> currentGame(String gameId) async {
    try {
      return await _firestore
          .doc('games/$gameId')
          .get()
          .then((doc) => doc.toGame());
    } catch (e) {
      print('error getting current game from firestore: $e');
      return null;
    }
  }
}
