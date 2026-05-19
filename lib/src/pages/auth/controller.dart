import 'package:toastification/toastification.dart';
import '../../../common.dart';
import '../../routes.dart';

class AuthState {
  final bool isLoading;

  AuthState({this.isLoading = false});

  AuthState copyWith({bool? isLoading}) {
    return AuthState(isLoading: isLoading ?? this.isLoading);
  }
}

final authControllerProvider =
    NotifierProvider.autoDispose<AuthController, AuthState>(
      () => AuthController(),
    );

class AuthController extends Notifier<AuthState> {
  late final FormGroup form;

  AuthService get authService => ref.read(authServiceProvider);

  @override
  AuthState build() {
    form = FormGroup({
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
    });
    return AuthState();
  }

  Future<void> signIn(BuildContext context) async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final email = form.control('email').value as String;
      final password = form.control('password').value as String;

      await authService.signIn(email, password);

      if (context.mounted) {
        context.goNamed(AppRoutes.home);
      }
    } catch (e) {
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: Text(context.l10n.error),
          description: Text(e.toString()),
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
