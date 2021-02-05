import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Set<Marker> toSetOfMarkers() {
    return docs
        .map((itemDoc) => Marker(
            markerId: MarkerId(itemDoc.id),
            position: LatLng(
              itemDoc.data()['position']['geopoint'].latitude as double,
              itemDoc.data()['position']['geopoint'].longitude as double,
            )))
        .toSet();
  }

  Set<Marker> toSetOfPlayerMarkers() {
    return docs
        .map((itemDoc) => Marker(
            markerId: MarkerId(itemDoc.id),
            infoWindow: InfoWindow(title: itemDoc.data()['username'] as String),
            position: LatLng(
              itemDoc.data()['position']['geopoint'].latitude as double,
              itemDoc.data()['position']['geopoint'].longitude as double,
            )))
        .toSet();
  }
}
