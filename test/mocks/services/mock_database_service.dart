import 'dart:async';

import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';

class MockDatabaseService implements DatabaseService {
  final StreamController<List<Game>> _controller;
  final StreamController<List<Player>> _playerStreamController;

  MockDatabaseService({
    StreamController<List<Game>> controller,
    StreamController<List<Player>> playerStreamController,
  })  : _controller = controller,
        _playerStreamController = playerStreamController;

  @override
  Future<bool> usernameAlreadyExists(String username) {}
  @override
  Future<void> addUsername(String userId, String username) {}

  @override
  Stream<List<Game>> get streamOfCreatedGames => _controller.stream;

  @override
  Stream<List<Player>> streamOfJoinedPlayers(String gameId) =>
      _playerStreamController.stream;
}
