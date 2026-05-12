import '../../../common.dart';
import 'package:firebase_auth/firebase_auth.dart';

@dev
@LazySingleton(as: AuthService)
class FakeAuthService extends AuthService {
  @override
  // TODO: implement currentUser
  User? get currentUser => null;

  @override
  Future<void> signIn() async {
    // TODO: implement signIn
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
  }
}
