import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_chat_app/src/models/index.dart';

class AuthApi {
  const AuthApi({required this.auth});

  final FirebaseAuth auth;

  Future<AppUser> createUser({required String email, required String password}) async {
    final UserCredential credentials = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = credentials.user!;
    final String displayName = email.split('@').first;

    await user.updateDisplayName(displayName);

    return AppUser(
      uid: user.uid,
      email: email,
      displayName: displayName,
    );
  }

  Future<AppUser> login({required String email, required String password}) async {
    final UserCredential credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = credentials.user!;

    return AppUser(
      uid: user.uid,
      email: email,
      displayName: user.displayName!,
      imageUrl: user.photoURL,
    );
  }

  Future<AppUser> updateName({required String name}) async {
    final String displayName = name;
    final User user = auth.currentUser!;

    await user.updateDisplayName(displayName);

    return AppUser(
      uid: user.uid,
      email: user.email!,
      displayName: displayName,
      imageUrl: user.photoURL,
    );
  }

  Future<AppUser> updatePhoto({required String url}) async {
    final User user = auth.currentUser!;

    await user.updatePhotoURL(url);

    return AppUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName!,
      imageUrl: url,
    );
  }

  Future<void> updatePassword({required String password}) async {
    final User user = auth.currentUser!;

    await user.updatePassword(password);
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
