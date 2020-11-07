import 'package:flutter/material.dart';
import '../game.dart';
import '../location.dart';

/// set initial [boundarySize] and [sonarIntervals] value by manualy changing it here
class CreateGameViewModel extends ChangeNotifier {
  double boundarySize = 100;
  double sonarIntervals = 210;
  Location boundaryPosition;
  bool loadingMap = true;

  String name;
  String password;

  void updateBoundarySize(double size) {
    boundarySize = size;
    notifyListeners();
  }

  void updateBoundaryPosition(Location position) {
    boundaryPosition = position;
    notifyListeners();
  }

  void loadedMap() {
    loadingMap = false;
    notifyListeners();
  }

  void reset() {
    boundarySize = 100;
    sonarIntervals = 210;
    boundaryPosition = null;
    loadingMap = false;
    name = null;
    password = null;
  }

  Game createGameData(String userId, String username) => Game(
        id: '',
        name: name,
        password: password,
        adminName: username,
        adminId: userId,
        sonarIntervals: sonarIntervals,
        boundaryPosition: boundaryPosition,
        boundarySize: boundarySize,
        phase: GamePhase.created,
      );
}
