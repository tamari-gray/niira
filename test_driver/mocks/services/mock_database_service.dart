import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';

class MockDatabaseService extends Mock implements DatabaseService {
  final StreamController<List<Game>> _controller;

  MockDatabaseService({
    @required StreamController<List<Game>> controller,
  }) : _controller = controller;

  @override
  Future<bool> usernameAlreadyExists(String username) => Future.value(true);

  @override
  Future<void> addUsername(String userId, String username) => Future.value();

  @override
  Stream<List<Game>> get streamOfCreatedGames => _controller.stream;

  @override
  Stream<List<Player>> streamOfJoinedPlayers(String gameId) {
    throw UnimplementedError();
  }

  @override
  Future<String> getUserName(String userId) => Future.value('username123');

  @override
  Future<void> joinGame(String gameIdPlayer, String userId) =>
      Future.value();
}
