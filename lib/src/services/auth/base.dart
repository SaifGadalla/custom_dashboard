import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  User? get currentUser;
  Future<void> signIn();
  Future<void> signOut();
}
