import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/services/database/database_service.dart';

import '../data/mock_games.dart';

class MockDatabaseService extends Mock implements DatabaseService {
  final StreamController<List<Game>> _controller;
  final StreamController<List<Player>> _playerStreamController;
  final StreamController<UserData> _userDataController;
  final StreamController<Game> _currentGame;

  MockDatabaseService({
    StreamController<List<Game>> controller,
    StreamController<List<Player>> playerStreamController,
    StreamController<UserData> userDataController,
    StreamController<Game> currentGame,
  })  : _controller = controller,
        _playerStreamController = playerStreamController,
        _userDataController = userDataController,
        _currentGame = currentGame;

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

  @override
  Stream<Game> streamOfJoinedGame(String gameId) => _currentGame.stream;

  @override
  Future<Game> currentGame(String gameId) =>
      Future.value(MockGames().gamesToJoin[0]);

  @override
  Stream<UserData> userData(String userId) => _userDataController.stream;

  @override
  Future<bool> checkIfAdmin(String userId) => Future.value(true);
}

class FakeDatabaseService extends Fake implements DatabaseService {
  @override
  Future<String> getUserName(String userId) => Future.value('username_123');

  @override
  Future<String> createGame(Game game, String userId) =>
      Future.value('gameId_123');

  final test = [
    Player(
        id: 'ui1',
        username: 'pete',
        isTagger: false,
        hasBeenTagged: false,
        hasItem: false),
    Player(
        id: 'ui12',
        username: 'yeet',
        isTagger: false,
        hasBeenTagged: false,
        hasItem: false),
    Player(
        id: 'ui123',
        username: 'wheat',
        isTagger: false,
        hasBeenTagged: false,
        hasItem: false),
  ];
  // @override
  // Stream<List<Player>> streamOfJoinedPlayers(String gameId) =>
  //     Stream.fromIterable(test);
}
