import 'package:firebase_auth/firebase_auth.dart';
import '../../../common.dart';

class RealAuthService extends AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      name: user.displayName ?? 'Admin',
      email: user.email ?? 'admin@email.com',
    );
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      return AppUser(
        id: user.uid,
        name: user.displayName ?? 'Admin',
        email: user.email ?? email,
      );
    }
    throw Exception('Failed to sign in');
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
