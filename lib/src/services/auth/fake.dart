import '../../../common.dart';

class FakeAuthService extends AuthService {
  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<AppUser> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = AppUser(id: '1', name: 'Admin', email: email);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
  }
}
