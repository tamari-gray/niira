import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'firestore_doc_snapshot_extension.dart';
import 'firestore_query_doc_snapshot_extension.dart';

extension QuerySnapshotExt on QuerySnapshot {
  List<Game> toListOfGames() {
    return docs.map((gameDoc) => gameDoc.toGame()).toList();
  }

  List<Player> toListOfPlayers() {
    return docs.map((playerDoc) => playerDoc.toPlayer()).toList();
  }
}
