import 'package:niira/models/player.dart';

extension PlayerExt on Player {
  Map<String, dynamic> toMap() => <String, dynamic>{
        'username': username,
        'has_been_tagged': hasBeenTagged,
        'has_item': hasItem,
        'is_tagger': isTagger,
        'has_quit': hasQuit
      };
}
