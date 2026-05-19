import '../../../common.dart';

abstract class AuthService {
  AppUser? get currentUser;
  Future<AppUser> signIn(String email, String password);
  Future<void> signOut();
}
