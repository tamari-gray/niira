import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:niira/models/auth_provider_data.dart';
import 'package:niira/models/user_data.dart';

import 'user_info_extensions.dart';

extension FirebaseUserExt on auth.User {
  UserData toData() => (this != null)
      ? UserData(
          uid: uid,
          displayName: displayName,
          photoURL: photoURL,
          email: email,
          phoneNumber: phoneNumber,
          createdOn: metadata.creationTime.toUtc(),
          lastSignedInOn: metadata.lastSignInTime.toUtc(),
          isAnonymous: isAnonymous,
          isEmailVerified: emailVerified,
          providers: providerData
              .map<AuthProviderData>(
                  (userInfo) => userInfo.toAuthProviderData())
              .toList(),
        )
      : null;
}
