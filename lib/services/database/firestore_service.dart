import 'package:firebase/firestore.dart';
import 'package:niira/services/database/database_service.dart';

class FirestoreService implements DatabaseService {
  final Firestore _firestore;

  FirestoreService(this._firestore);

  @override
  Future<bool> usernameAlreadyExists(String username) async {
    final snapshot = await _firestore
        .collection('players')
        .where('username', '==', username)
        .get();
    return !snapshot.empty;
  }

  @override
  Future<void> addUsername(String userId, String username) {
    return _firestore
        .doc('players/$userId')
        .set(<String, Object>{'username': username}, SetOptions(merge: true));
  }
}
