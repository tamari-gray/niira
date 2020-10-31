import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/services/database/database_service.dart';

class MockDatabaseService extends Mock implements DatabaseService {
  final StreamController<List<Game>> _controller;
  final StreamController<List<Player>> _playerStreamController;

  MockDatabaseService({
    StreamController<List<Game>> controller,
    StreamController<List<Player>> playerStreamController,
  })  : _controller = controller,
        _playerStreamController = playerStreamController;

  @override
  Future<bool> usernameAlreadyExists(String username) => Future.value(true);

  @override
  Future<void> addUsername(String userId, String username) => Future.value();

  @override
  Stream<List<Game>> get streamOfCreatedGames => _controller.stream;

  @override
  Stream<List<Player>> streamOfJoinedPlayers(String gameId) =>
      _playerStreamController.stream;

  @override
  Future<String> getUserName(String userId) => Future.value('username123');
}

class FakeDatabaseService extends Fake implements DatabaseService {
  @override
  Future<String> getUserName(String userId) => Future.value('username_123');

  @override
  Future<String> createGame(Game game, String userId) =>
      Future.value('gameId_123');
}
