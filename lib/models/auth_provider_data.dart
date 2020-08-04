import 'package:meta/meta.dart';

class AuthProviderData {
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final String phoneNumber;

  AuthProviderData({
    @required this.providerId,
    @required this.uid,
    @required this.displayName,
    @required this.photoUrl,
    @required this.email,
    @required this.phoneNumber,
  });
}
