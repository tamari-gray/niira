import 'package:firebase_auth/firebase_auth.dart';
import 'package:niira/models/auth_provider_data.dart';
import 'package:niira/models/user_data.dart';

import 'user_info_extensions.dart';

extension FirebaseUserExt on FirebaseUser {
  UserData toData() => (this != null)
      ? UserData(
          providerId: providerId,
          uid: uid,
          displayName: displayName,
          photoUrl: photoUrl,
          email: email,
          phoneNumber: phoneNumber,
          createdOn: metadata.creationTime.toUtc(),
          lastSignedInOn: metadata.lastSignInTime.toUtc(),
          isAnonymous: isAnonymous,
          isEmailVerified: isEmailVerified,
          providers: providerData
              .map<AuthProviderData>(
                  (userInfo) => userInfo.toAuthProviderData())
              .toList(),
        )
      : null;
}
