import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:niira/models/player.dart';

extension QueryDocumentSnapshotExt on QueryDocumentSnapshot {
  Player toPlayer() => Player(
        id: id ?? 'undefined',
        username: data()['username'].toString() ?? 'undefined',
        isTagger: data()['is_tagger'] as bool ?? false,
        hasBeenTagged: data()['has_been_tagged'] as bool ?? false,
        hasItem: data()['has_item'] as bool ?? false,
        isAdmin: data()['has_item'] as bool ?? false,
      );
}
