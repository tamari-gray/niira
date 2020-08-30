import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/services/database/database_service.dart';

class MockDatabaseService extends Mock implements DatabaseService {
  final StreamController<List<Game>> _controller;

  MockDatabaseService({
    StreamController<List<Game>> controller,
  }) : _controller = controller;

  @override
  Future<bool> usernameAlreadyExists(String username) => Future.value(true);

  @override
  Future<void> addUsername(String userId, String username) => Future.value();

  @override
  Stream<List<Game>> get streamOfCreatedGames => _controller.stream;

  @override
  Future<String> getUserName(String userId) => Future.value('username123');

  // @override
  // Future<void> joinGame(String gameId, String userId) => Future.value();
}
