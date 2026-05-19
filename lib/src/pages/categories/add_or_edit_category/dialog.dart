import '../../../../common.dart';
import 'controller.dart';
import 'form/form.dart';

class AddOrEditCategoryDialog extends ConsumerWidget {
  final Category? initialValue;
  const AddOrEditCategoryDialog({super.key, this.initialValue});

  static Future<Category?> show(
    BuildContext context,
    Category? initialValue,
  ) async {
    return await showDialog<Category?>(
      context: context,
      builder: (context) => ProviderScope(
        child: AddOrEditCategoryDialog(initialValue: initialValue),
      ),
      barrierDismissible: true,
      useRootNavigator: true,
      barrierColor: ColorManager.greyNormal.withValues(alpha: 0.2),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final isTablet = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );

    final dialogState = ref.watch(
      addOrEditCategoryControllerProvider(initialValue),
    );

    final dialogTitle = initialValue != null ? l10n.edit : l10n.add;
    final submitLabel = initialValue != null ? l10n.save : l10n.add;

    return ReactiveFormBuilder(
      form: () => ref
          .read(addOrEditCategoryControllerProvider(initialValue).notifier)
          .form,
      builder: (context, formGroup, child) => ReactiveForm(
        formGroup: formGroup,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: ColorManager.surfaceWhite,
          title: Row(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogIcon(
                icon: Icon(Icons.category),
                shape: BoxShape.rectangle,
                borderWidth: 1,
              ),
              Expanded(
                child: AppText(dialogTitle, style: textTheme.titleLarge),
              ),
              IconButton(
                tooltip: l10n.close,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 688,
              child: Column(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: ColorManager.surfaceActive,
                      height: 1,
                    ),
                  ),
                  AppTextField(
                    formControlName: CategoryModelForm.nameControlName,
                    label: l10n.title,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: ColorManager.surfaceActive,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: AppButton(
                    side: BorderSide(color: ColorManager.surfaceActive),
                    backgroundColor: ColorManager.surfaceWhite,
                    foregroundColor: ColorManager.neutral100,
                    isSmallScreen: isTablet,
                    tooltip: l10n.cancel,
                    onTap: () => Navigator.of(context).pop(),
                    child: AppText(l10n.cancel),
                  ),
                ),
                Expanded(
                  child: ReactiveFormConsumer(
                    builder: (context, formModel, child) {
                      return AppButton(
                        isSmallScreen: isTablet,
                        tooltip: submitLabel,
                        backgroundColor: ColorManager.brownNormal,
                        foregroundColor: ColorManager.surfaceWhite,
                        onTap: formModel.valid && formModel.dirty
                            ? () async {
                                await ref
                                    .read(
                                      addOrEditCategoryControllerProvider(
                                        initialValue,
                                      ).notifier,
                                    )
                                    .updateAndReturnCategory(
                                      context,
                                      formModel,
                                    );
                              }
                            : null,
                        child: dialogState.isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorManager.surfaceWhite,
                                ),
                              )
                            : AppText(submitLabel),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
