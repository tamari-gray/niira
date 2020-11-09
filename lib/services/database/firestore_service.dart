import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/extensions/game_extension.dart';
import 'package:niira/extensions/player_extension.dart';
import 'package:niira/extensions/firestore_query_snapshot_extension.dart';
import 'package:niira/extensions/firestore_doc_snapshot_extension.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/database/database_service.dart';

// const currentGame = 'current_game';

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
    try {
      await _firestore
          .doc('players/$playerId')
          .update(<String, String>{'current_game': ''});

      return await _firestore.doc('games/$gameId/players/${playerId}').delete();
    } catch (e) {
      print('error leaving game, $e');
      return null;
    }
  }

  /// set all joined players 'current_game' to empty string
  /// and delete this game
  @override
  Future<void> adminQuitCreatingGame(String gameId) async {
    try {
      final joinedPlayers =
          await _firestore.collection('games/$gameId/players').get();

      await joinedPlayers.docs.forEach((QueryDocumentSnapshot playerDoc) async {
        await _firestore
            .doc('players/${playerDoc.id}')
            .update(<String, String>{'current_game': ''});

        return await _firestore.doc('games/$gameId').delete();
      });
    } catch (e) {
      print('error when trying to quit game as admin, $e');
    }
  }

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
    );

    try {
      // tell player doc that we have joined a game
      await _firestore
          .doc('players/$userId')
          .update(<String, String>{'current_game': gameId});

      // add player to game
      return await _firestore
          .doc('games/$gameId/players/$userId')
          .set(player.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('error joining game: $e');
      return null;
    }
  }

  @override
  Future<String> createGame(Game game, String userId) async {
    try {
      // create game
      final gameRef = await _firestore.collection('games').add(game.toMap());

      // join game as admin
      await joinGame(gameRef.id, userId);

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
  Future<String> currentGameId(String userId) async {
    try {
      return await _firestore
          .doc('players/$userId')
          .get()
          .then<String>((doc) => doc.data()['current_game'] as String);
    } catch (e) {
      print('error getting game id, $e');
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

  @override
  Stream<UserData> userData(String userId) {
    try {
      return _firestore
          .doc('players/$userId')
          .snapshots()
          .map((doc) => doc.toUserData());
    } catch (e) {
      print('error getting user data, $e');
      return null;
    }
  }

  @override
  Future<bool> checkIfAdmin(String userId) async {
    try {
      final gameId = await currentGameId(userId);
      final game = await currentGame(gameId);

      if (game.adminId == userId) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('error checking if user is admin, $e');
      return null;
    }
  }
}
