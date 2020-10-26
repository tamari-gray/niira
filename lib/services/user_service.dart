import 'package:niira/models/game.dart';
import 'package:niira/models/user_data.dart';

class UserDataService {
  UserData user;
  Game joinedGame;

  void stopJoiningGame() => joinedGame = null;
}
