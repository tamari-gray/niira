import 'package:niira/models/user_data.dart';

class MockUser {
  UserData get userData => UserData(
        uid: 'uid',
        displayName: 'name',
        photoURL: 'url',
        email: 'email',
        phoneNumber: '123',
        createdOn: DateTime.now(),
        lastSignedInOn: DateTime.now(),
        isAnonymous: false,
        isEmailVerified: false,
        providers: [],
      );
}
