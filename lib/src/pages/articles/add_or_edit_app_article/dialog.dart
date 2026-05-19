import 'package:custom_dashboard/src/pages/articles/add_or_edit_app_article/form/form.dart';

import '../../../../common.dart';

import 'controller.dart';

class AddOrEditArticleDialog extends ConsumerWidget {
  final Article? initialValue;
  const AddOrEditArticleDialog({super.key, this.initialValue});

  static Future<Article?> show(
    BuildContext context,
    Article? initialValue,
  ) async {
    return await showDialog<Article?>(
      context: context,
      builder: (context) => ProviderScope(
        child: AddOrEditArticleDialog(initialValue: initialValue),
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
      addOrEditArticleControllerProvider(initialValue),
    );

    final dialogTitle = initialValue != null
        ? l10n.article_editing
        : l10n.article_addition;
    final submitLabel = initialValue != null ? l10n.save : l10n.add;

    if (dialogState.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return ReactiveFormBuilder(
      form: () => ref
          .read(addOrEditArticleControllerProvider(initialValue).notifier)
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
                icon: Icon(Icons.article),
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
                  ReactiveDropDownMenuField<Category, Category>(
                    key: Key(ArticleModelForm.categoryControlName),
                    labelText: l10n.category,
                    controlledValue: Category(),
                    elements: dialogState.categories,
                    elementIdAccessor: (e) => e,
                    elementLabelAccessor: (e) => e.name ?? '',
                    formControlName: ArticleModelForm.categoryControlName,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: ColorManager.surfaceActive,
                      height: 1,
                    ),
                  ),
                  AppTextField(
                    formControlName: ArticleModelForm.titleControlName,
                    label: l10n.title,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: ColorManager.surfaceActive,
                      height: 1,
                    ),
                  ),
                  AppTextField(
                    formControlName: ArticleModelForm.contentControlName,
                    label: l10n.content,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: ColorManager.surfaceActive,
                      height: 1,
                    ),
                  ),
                  ReactiveDialogImageSection(
                    onDragDone: (details) async {
                      final file = details.files.last;
                      final data = await file.readAsBytes();
                      if (context.mounted) {
                        await ref
                            .read(
                              addOrEditArticleControllerProvider(
                                initialValue,
                              ).notifier,
                            )
                            .handleDragUpload(data, file.name, formGroup);
                      }
                    },
                    clickToUploadOnTap: () async {
                      await ref
                          .read(
                            addOrEditArticleControllerProvider(
                              initialValue,
                            ).notifier,
                          )
                          .pickAndUploadImage(formGroup);
                    },
                    formControlName: ArticleModelForm.imageUrlControlName,
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
                                      addOrEditArticleControllerProvider(
                                        initialValue,
                                      ).notifier,
                                    )
                                    .updateAndReturnArticle(context, formModel);
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
