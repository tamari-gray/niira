import 'package:flutter/material.dart';

class GameService extends ChangeNotifier {
  String currentGameId = '';

  void joinGame(String gameId) {
    currentGameId = gameId;
    notifyListeners();
  }

  void leaveCurrentGame() {
    currentGameId = '';
    notifyListeners();
  }
}
