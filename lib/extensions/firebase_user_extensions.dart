import 'package:firebase_auth/firebase_auth.dart' as auth;

extension FirebaseUserExt on auth.User {
  String toUserId() => (this != null) ? uid : null;
}
