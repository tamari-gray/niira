import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:niira/models/user_data.dart';

extension FirebaseUserExt on auth.User {
  UserData toUserData() => UserData(id: uid);
}
