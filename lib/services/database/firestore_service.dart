import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/player.dart';
import 'package:niira/extensions/game_extension.dart';
import 'package:niira/extensions/player_extension.dart';
import 'package:niira/extensions/firestore_query_snapshot_extension.dart';
import 'package:niira/extensions/firestore_doc_snapshot_extension.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreService implements DatabaseService {
  final FirebaseFirestore _firestore;
  final Geoflutterfire _geoflutterfire;
  FirestoreService(this._firestore, this._geoflutterfire);

  DocumentReference userDoc(String playerId) {
    return _firestore.doc('players/$playerId');
  }

  DocumentReference joinedPlayerDoc(
      {@required String gameId, @required String playerId}) {
    return _firestore.doc('games/$gameId/players/${playerId}');
  }

  DocumentReference gameDoc(String gameId) {
    return _firestore.doc('games/$gameId');
  }

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
    return userDoc(userId).set(
      <String, String>{'username': username},
      SetOptions(merge: true),
    );
  }

  @override
  Future<String> getUserName(String userId) async {
    return await userDoc(userId).get().then((doc) {
      return doc.data()['username'].toString() ?? 'undefined';
    });
  }

  @override
  Stream<List<Game>> get streamOfCreatedGames => _firestore
      .collection('games')
      .where('phase', isEqualTo: 'created')
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
  Future<bool> checkIfPlayerIsTagger(String userId) async {
    try {
      final gameId = await currentGameId(userId);
      final playerDoc =
          await joinedPlayerDoc(gameId: gameId, playerId: userId).get();
      if (playerDoc.data()['is_tagger'] == true) {
        return true;
      } else if (playerDoc.data()['is_tagger'] == false) {
        return false;
      } else {
        return null;
      }
    } catch (e) {
      print('error checking if player is tagger');
      return null;
    }
  }

  @override
  Future<bool> checkIfPlayerIsLastTagger(String userId) async {
    try {
      final gameId = await currentGameId(userId);

      final taggers = await gameDoc(gameId)
          .collection('players')
          .where('is_tagger', isEqualTo: true)
          .get();

      if (taggers.docs.length == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('error checking if player is last tagger');
      return null;
    }
  }

  @override
  Future<void> quitGame(String userId) async {
    try {
      final gameId = await currentGameId(userId);

      final isLastTagger = await checkIfPlayerIsLastTagger(userId);
      if (isLastTagger) {
        await gameDoc(gameId).update(
            <String, dynamic>{'taggersLost': true, 'phase': 'finished'});
      }

      await joinedPlayerDoc(gameId: gameId, playerId: userId)
          .update(<String, bool>{'has_quit': true});
    } catch (e) {
      print('error quitting game, $e');
      return null;
    }
  }

  @override
  Future<void> leaveGame(String gameId, String playerId) async {
    try {
      await userDoc(playerId).update(<String, String>{'current_game': ''});

      return await joinedPlayerDoc(gameId: gameId, playerId: playerId).delete();
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

      await joinedPlayers.docs.forEach((doc) async =>
          await userDoc(doc.id).update(<String, String>{'current_game': ''}));

      return await gameDoc(gameId).delete();
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
      hasQuit: false,
    );

    try {
      // tell player doc that we have joined a game
      await userDoc(userId).update(<String, String>{'current_game': gameId});

      // add player to game
      return await joinedPlayerDoc(gameId: gameId, playerId: userId)
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
      return gameDoc(gameId).snapshots().map((doc) => doc.toGame());
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
        await joinedPlayerDoc(gameId: gameId, playerId: taggerId)
            .update(<String, bool>{'is_tagger': false});
      }

      // set new tagger
      return joinedPlayerDoc(gameId: gameId, playerId: playerId)
          .update(<String, bool>{'is_tagger': true});
    } catch (e) {
      print('error choosing tagger, $e');
      return null;
    }
  }

  @override
  Future<void> unSelectTagger(String playerId, String gameId) async {
    try {
      return await joinedPlayerDoc(gameId: gameId, playerId: playerId)
          .update(<String, bool>{'is_tagger': false});
    } catch (e) {
      print('error un-selecting tagger, $e');
      return null;
    }
  }

  @override
  Future<String> currentGameId(String userId) async {
    try {
      return await userDoc(userId)
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
      return await gameDoc(gameId).get().then((doc) => doc.toGame());
    } catch (e) {
      print('error getting current game from firestore: $e');
      return null;
    }
  }

  @override
  Stream<UserData> userData(String userId) {
    try {
      return userDoc(userId).snapshots().map((doc) => doc.toUserData());
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

  @override
  Future<void> startGame(String userId) async {
    try {
      final gameId = await currentGameId(userId);
      return await gameDoc(gameId).update(<String, String>{
        'phase': 'playing',
        'start_time': DateTime.now().toString()
      });
    } catch (e) {
      print('error when trying to start game, $e ');
    }
  }

  LatLng randomItemPosition(Location boundaryCentre, double radius) {
    var y0 = boundaryCentre.latitude;
    var x0 = boundaryCentre.longitude;
    var randomPoint = Random();

    // radius to degrees
    var radiusInDegrees = radius / 111000;

    // calcliations
    var u = randomPoint.nextDouble();
    var v = randomPoint.nextDouble();
    var w = radiusInDegrees * sqrt(u);
    var t = 2 * pi * v;
    var x = w * cos(t);
    var y = w * sin(t);

    var newX = x / cos(y0);
    var foundLongitude = newX + x0;
    var foundLatitude = y + y0;

    print('new item coords: $foundLatitude, $foundLongitude');

    return LatLng(foundLatitude, foundLongitude);
  }

  @override
  Future<void> generateNewItems(Game game, double remainingPlayers) async {
    // create hashset of markers
    final newItemsPositions = <LatLng>[];

    // loop through markers and give them random positions
    for (var i = 0; i < remainingPlayers / 2; i++) {
      newItemsPositions
          .add(randomItemPosition(game.boundaryPosition, game.boundarySize));
    }

    // delete old items
    await gameDoc(game.id).collection('items').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    // delete picked up items from player docs => make all players unsafe again
    await gameDoc(game.id).collection('players').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update(<String, bool>{'has_item': false});
      }
    });

    // put new squares in gamedoc
    for (var item in newItemsPositions) {
      final _itemLocation = _geoflutterfire.point(
          latitude: item.latitude, longitude: item.longitude);
      await gameDoc(game.id).collection('items').add(<String, dynamic>{
        'position': _itemLocation.data,
        'picked_up': false
      });
    }
    return;
  }

  @override
  Stream<Set<Marker>> streamOfItems(String gameId) {
    return _firestore
        .collection('games/$gameId/items')
        .where('picked_up', isEqualTo: false)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.toSetOfMarkers());
  }

  @override
  Future<void> showTaggerMyLocation(
      String gameId, String playerId, Location location) {
    final _myLocation = _geoflutterfire.point(
        latitude: location.latitude, longitude: location.longitude);
    return joinedPlayerDoc(gameId: gameId, playerId: playerId)
        .update(<String, dynamic>{
      'location_safe': false,
      'position': _myLocation.data
    });
  }

  @override
  Future<void> hideMyLocationFromTagger(String gameId, String playerId) {
    return joinedPlayerDoc(gameId: gameId, playerId: playerId)
        .update(<String, dynamic>{
      'position': null,
      'location_safe': true,
    });
  }

  @override
  Stream<Set<Marker>> streamOfUnsafePlayers(String gameId) {
    return gameDoc(gameId)
        .collection('players')
        .where('location_safe', isEqualTo: false)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.toSetOfPlayerMarkers());
  }

  @override
  Future<bool> tryToPickUpItem(
      String gameId, Player player, Location playerLocation) async {
    // geoquery.first (only grab one item if 2 are in same place)
    final center = _geoflutterfire.point(
        latitude: playerLocation.latitude, longitude: playerLocation.longitude);

    // get the collection reference or query
    var collectionReference = gameDoc(gameId).collection('items');
    // gameDoc(gameId).collection('items').where('picked_up', isEqualTo: true);

    final radius = 0.005; // 5m
    final field = 'position';

    final stream = _geoflutterfire
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius.toDouble(), field: field);

    // get item id => set item.picked.up == true
    final item = await stream.first;

    // print('error? $item');

    if (item.isNotEmpty && item[0].exists) {
      await item[0].reference.update(<String, bool>{'picked_up': true});

      // set player.has_item == true
      await joinedPlayerDoc(gameId: gameId, playerId: player.id)
          .update(<String, bool>{'has_item': true});

      // return true if successfull
      return true;
    } else {
      // return false if unsuccessfull
      return false;
    }
  }
}
