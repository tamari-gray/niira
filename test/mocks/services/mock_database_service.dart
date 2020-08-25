import 'dart:async';

import 'package:niira/models/game.dart';
import 'package:niira/services/database/database_service.dart';

class MockDBService implements DatabaseService {
  final StreamController<List<Game>> _controller;

  MockDBService({
    StreamController<List<Game>> controller,
  }) : _controller = controller;

  Future<bool> usernameAlreadyExists(String username) {}
  Future<void> addUsername(String userId, String username) {}

  @override
  Stream<List<Game>> get streamOfCreatedGames => _controller.stream;
}
