import 'package:firebase_auth/firebase_auth.dart';
import 'package:niira/models/auth_provider_data.dart';

extension UserInfoExt on UserInfo {
  AuthProviderData toAuthProviderData() => AuthProviderData(
        providerId: providerId,
        uid: uid,
        displayName: displayName,
        photoURL: photoURL,
        email: email,
        phoneNumber: phoneNumber,
      );
}
