import 'dart:async';

import 'package:meta/meta.dart';
import 'package:niira/models/game.dart';
import 'package:niira/services/database/database_service.dart';

class MockDatabaseService implements DatabaseService {
  final StreamController<List<Game>> _controller;

  MockDatabaseService({
    @required StreamController<List<Game>> controller,
  }) : _controller = controller;

  Future<bool> usernameAlreadyExists(String username) {}
  Future<void> addUsername(String userId, String username) {}

  @override
  Stream<List<Game>> get streamOfCreatedGames => _controller.stream;
}
