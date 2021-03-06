import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/location.dart';
import 'package:niira/models/player.dart';
import 'package:niira/models/user_data.dart';

abstract class DatabaseService {
  Future<bool> usernameAlreadyExists(String username);
  Future<void> addUsername(String userId, String username);
  Future<String> getUserName(String userId);
  Stream<List<Game>> get streamOfCreatedGames;
  Stream<List<Player>> streamOfJoinedPlayers(String gameId);
  Future<void> joinGame(String gameId, String userId);
  Future<void> leaveGame(String gameId, String userId);
  Future<String> createGame(Game game, String userId);
  Future<Game> currentGame(String gameId);
  Stream<Game> streamOfJoinedGame(String gameId);
  Future<void> chooseTagger(String playerId, String gameId);
  Future<void> unSelectTagger(String playerId, String gameId);
  Stream<UserData> userData(String userId);
  Future<void> adminQuitCreatingGame(String gameId);
  Future<String> currentGameId(String userId);
  Future<bool> checkIfAdmin(String userId);
  Future<void> startGame(String userId);
  Future<bool> checkIfPlayerIsTagger(String userId);
  Future<bool> checkIfPlayerIsLastTagger(String userId);
  Future<void> quitGame(String userId);
  Future<void> generateNewItems(Game game, double remainingPlayers);
  Stream<Set<Marker>> streamOfItems(String gameId);
  Stream<Set<Marker>> streamOfUnsafePlayers(String gameId);
  Future<void> showTaggerMyLocation(String gameId, String playerId);
  Future<void> hideMyLocationFromTagger(String gameId, String playerId);
  Future<bool> tryToPickUpItem(
      String gameId, Player player, Location playerLocation);
  Future<String> tryToTagPlayer(
      String gameId, Player player, Location playerLocation);
  Future<void> setHiderPosition(
      String gameId, String playerId, Location location);
  Future<void> finishGame(String gameId);
}
