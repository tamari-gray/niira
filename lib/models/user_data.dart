import 'package:niira/models/auth_provider_data.dart';

import 'package:meta/meta.dart';

class UserData {
  final String uid;
  final String displayName;
  final String photoURL;
  final String email;
  final String phoneNumber;
  final DateTime createdOn;
  final DateTime lastSignedInOn;
  final bool isAnonymous;
  final bool isEmailVerified;
  final List<AuthProviderData> providers;

  UserData({
    @required this.uid,
    @required this.displayName,
    @required this.photoURL,
    @required this.email,
    @required this.phoneNumber,
    @required this.createdOn,
    @required this.lastSignedInOn,
    @required this.isAnonymous,
    @required this.isEmailVerified,
    @required this.providers,
  });
}
