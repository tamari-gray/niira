import 'package:niira/models/game.dart';

extension GameExt on Game {
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'admin_name': adminName,
        'admin_id': adminId,
        'password': password,
        'sonarIntervals': sonarIntervals,
        'boundarySize': boundarySize,
        'boundaryPosition': <String, double>{
          'latitude': boundaryPosition.latitude,
          'longitude': boundaryPosition.longitude
        },
        'phase': 'created'
      };
}
