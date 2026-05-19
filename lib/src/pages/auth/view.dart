import '../../../common.dart';
import 'controller.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorManager.surfaceWhite,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: ColorManager.surfaceWhite,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(color: ColorManager.surfaceActive),
          ),
          child: ReactiveForm(
            formGroup: controller.form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 24,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    AppText(
                      l10n.sign_in,
                      style: textTheme.headlineMedium?.copyWith(
                        color: ColorManager.greyNormal,
                      ),
                    ),
                    AppText(
                      l10n.enter_credentials_to_continue, // Will add fallback later if missing
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                ReactiveTextField<String>(
                  formControlName: 'email',
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: 'admin@example.com',
                    border: const OutlineInputBorder(),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (error) => l10n.required,
                    ValidationMessage.email: (error) => l10n.invalid_email,
                  },
                ),
                ReactiveTextField<String>(
                  formControlName: 'password',
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    border: const OutlineInputBorder(),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (error) => l10n.required,
                    ValidationMessage.minLength: (error) =>
                        l10n.password_too_short,
                  },
                  onSubmitted: (_) => controller.signIn(context),
                ),
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton(
                        onPressed: () => controller.signIn(context),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: AppText(l10n.sign_in),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
