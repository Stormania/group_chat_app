import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_chat_app/src/models/index.dart';

class AuthApi {
  const AuthApi({required this.auth, required this.firestore});

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Future<AppUser?> getUser() async {
    final User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    await _makeUserUserExists(user);
    return _convertUser(user);
  }

  Stream<List<AppUser>> getUsers() {
    return firestore
        .collection('users') //
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => AppUser.fromJson(doc.data()))
          .toList();
    });
  }

  Future<AppUser> createUser({required String email, required String password}) async {
    final UserCredential credentials = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = credentials.user!;
    final String displayName = email.split('@').first;

    await user.updateDisplayName(displayName);
    await _makeUserUserExists(user);

    return _convertUser(user);
  }

  Future<AppUser> login({required String email, required String password}) async {
    final UserCredential credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = credentials.user!;

    return _convertUser(user);
  }

  Future<AppUser> updatePhoto({required String url}) async {
    final User user = auth.currentUser!;

    await user.updatePhotoURL(url);

    return _convertUser(user);
  }

  Future<AppUser> updateName({required String name}) async {
    final String displayName = name;
    final User user = auth.currentUser!;

    await user.updateDisplayName(displayName);

    return _convertUser(user);
  }

  Future<void> updatePassword({required String password}) async {
    final User user = auth.currentUser!;

    await user.updatePassword(password);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  AppUser _convertUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName ?? user.email!.split('@').first,
      imageUrl: user.photoURL,
    );
  }

  Future<void> _makeUserUserExists(User user) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return;
    }
    final AppUser appUser = _convertUser(user);
    await firestore.collection('users').doc(user.uid).set(appUser.toJson());
  }
}
