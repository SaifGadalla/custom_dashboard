import 'package:custom_dashboard/src/pages/articles/add_or_edit_app_article/form/form.dart';

import '../../../../common.dart';

import 'controller.dart';

class AddOrEditArticleDialog extends StatelessWidget {
  final AddOrEditArticleDialogController controller;
  const AddOrEditArticleDialog({super.key, required this.controller});

  static Future<Article?> show(
    BuildContext context, {
    required AddOrEditArticleDialogParams params,
  }) async {
    return await showDialog<Article?>(
      context: context,
      builder: (context) => HookBuilder(
        builder: (_) => AddOrEditArticleDialog(
          controller: getIt<AddOrEditArticleDialogController>(param1: params),
        ),
      ),
      barrierDismissible: true,
      useRootNavigator: true,
      barrierColor: ColorManager.greyNormal.withValues(alpha: 0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isTablet = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );
    // final categories = controller.categoriesRx.of(context);
    final dialogTitle = controller.isEditing
        ? l10n.article_editing
        : l10n.article_addition;
    final submitLabel = controller.isEditing ? l10n.save : l10n.add;
    return ReactiveFormBuilder(
      form: () => controller.form,
      builder: (context, formGroup, child) => ReactiveForm(
        formGroup: formGroup,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // backgroundColor: colorScheme.surface,
          title: Row(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: AppText(dialogTitle, style: textTheme.titleLarge),
              ),
              // DialogIcon(
              //   icon: Icon(Icons.article),
              //   shape: BoxShape.rectangle,
              //   borderWidth: 1,
              // ),
              // Expanded(
              //   child: Column(
              //     spacing: 8,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       AppText(dialogTitle, style: textTheme.titleLarge),
              //       DialogCheckBox(
              //         formControlName:
              //             ArticlesModelForm.isEnglishEnabledControlName,
              //       ),
              //     ],
              //   ),
              // ),
              IconButton(
                tooltip: l10n.close,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          // TODO : find suitable replacment for Bdayaloadable area wrapper
          // content: BdayaLoadableAreaWrapper(
          //   area: controller.la,
          //   isLoadingBuilder: (context, error) =>
          //       const Center(child: CircularProgressIndicator()),
          //   builder: (context) =>
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
                      // color: colorScheme.primaryContainer,
                      height: 1,
                    ),
                  ),
                  ReactiveDropDownMenuField<Category, Category>(
                    key: Key(ArticleModelForm.categoryControlName),
                    labelText: l10n.category,
                    controlledValue: Category(),
                    // onControlledValue: () {
                    //   controller.isAddingCategory.$ = true;
                    // },
                    // elements: categories,
                    elements: [Category()],
                    elementIdAccessor: (e) => e,
                    elementLabelAccessor: (e) => e.name ?? '',
                    formControlName: ArticleModelForm.categoryControlName,
                  ),
                  // if (isAddingCategory == true)
                  //   LocaleEntryModelFormBuilder(
                  //     model: controller.newCategoryInitialModelRx.of(context),
                  //     initState: (context, fm) =>
                  //         controller.newCategoryFormRx.$ = fm,
                  //     builder: (context, fm, child) {
                  //       return Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         crossAxisAlignment: CrossAxisAlignment.end,
                  //         children: [
                  //           LocalesFormArray(
                  //             label: l10n.category_title,
                  //             isEnglishAllowed: true,
                  //             formControlName:
                  //                 LocaleEntryModelForm.localesControlName,
                  //           ),
                  //           Row(
                  //             children: [
                  //               Expanded(child: const SizedBox.shrink()),
                  //               Icon(
                  //                 Icons.add,
                  //                 size: 16,
                  //                 color: colorScheme.primary,
                  //               ),
                  //               SizedBox(width: 8),
                  //               GestureDetector(
                  //                 onTap: () async {
                  //                   await controller.addCategory(
                  //                     Map.fromEntries(
                  //                       (fm.form.control('locales').value
                  //                               as List<
                  //                                 MapEntry<String, String>?
                  //                               >)
                  //                           .nonNulls,
                  //                     ),
                  //                     l10n: l10n,
                  //                   );
                  //                   formModel.categoryControl.value =
                  //                       controller.addedCategory.$;
                  //                   controller.isAddingCategory.$ = false;
                  //                 },
                  //                 child: AppText(
                  //                   context.addSomethingOf(l10n.category_title),
                  //                   style: textTheme.bodyLarge?.copyWith(
                  //                     color: colorScheme.primary,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      // color: colorScheme.primaryContainer,
                      height: 1,
                    ),
                  ),
                  // ReactiveValueListenableBuilder(
                  //   formControlName:
                  //       ArticlesModelForm.isEnglishEnabledControlName,
                  //   builder: (context, control, child) => LocalesFormArray(
                  //     label: l10n.article_title,
                  //     formControlName: ArticlesModelForm.headlineControlName,
                  //     isEnglishAllowed:
                  //         formModel.isEnglishEnabledControl.value ?? false,
                  //     onSubmitted: (control) {
                  //       formModel.articleControl.focus();
                  //     },
                  //   ),
                  // ),
                  AppTextField(
                    formControlName: ArticleModelForm.titleControlName,
                    label: l10n.title,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      // color: colorScheme.primaryContainer,
                      height: 1,
                    ),
                  ),
                  // ReactiveValueListenableBuilder(
                  //   formControlName:
                  //       ArticlesModelForm.isEnglishEnabledControlName,
                  //   builder: (context, control, child) => LocalesFormArray(
                  //     maxLines: 4,
                  //     isEnglishAllowed:
                  //         formModel.isEnglishEnabledControl.value ?? false,
                  //     formControlName: ArticlesModelForm.articleControlName,
                  //     label: l10n.article_body,
                  //     onSubmitted: (control) {
                  //       formModel.shortTextControl.focus();
                  //     },
                  //   ),
                  // ),
                  AppTextField(
                    formControlName: ArticleModelForm.contentControlName,
                    label: l10n.content,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      // color: colorScheme.primaryContainer,
                      height: 1,
                    ),
                  ),
                  // ReactiveValueListenableBuilder(
                  //   formControlName:
                  //       ArticlesModelForm.isEnglishEnabledControlName,
                  //   builder: (context, control, child) => ReactiveFormConsumer(
                  //     builder: (context, formGroup, child) => LocalesFormArray(
                  //       isEnglishAllowed:
                  //           formModel.isEnglishEnabledControl.value ?? false,
                  //       formControlName: ArticlesModelForm.shortTextControlName,
                  //       label: l10n.short_text,
                  //     ),
                  //   ),
                  // ),
                  ReactiveDialogImageSection(
                    onDragDone: (details) async {
                      // final file = details.files.last;
                      // final data = await file.readAsBytes();
                      // if (context.mounted) {
                      //   await controller.dropZoneUploadImage(
                      //     fileName: file.name,
                      //     data: data,
                      //     mimetype: file.mimeType,
                      //     context: context,
                      //   );
                      // }
                    },
                    clickToUploadOnTap: () async {
                      // final result = await SelectImagesDialog.getImage(
                      //   context,
                      //   parameters: SelectImagesDialogParams(),
                      //   category: 'articles',
                      // );

                      // if (result != null) {
                      //   // Store storageRef for saving to backend
                      //   controller.pendingStorageRefRx.$ = result.storageRef;
                      //   // Set displayUrl to form for preview
                      //   controller.formRx.$?.imageUrlControl.value =
                      //       result.displayUrl;
                      // }
                    },
                    formControlName: ArticleModelForm.imageUrlControlName,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      // color: colorScheme.primaryContainer,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ),
          actions: [
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: AppButton(
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
                        onTap: () => Navigator.of(context).pop(),
                        child: AppText(submitLabel),
                      );
                    },
                  ),
                ),
                // Expanded(
                //   child: ReactiveArticlesModelFormConsumer(
                //     builder: (context, formModel, child) {
                //       final isDirty = formModel.form.dirty;
                //       return ActionButton(
                //         area: controller.saveLA,
                //         isSmallScreen: isTablet,
                //         tooltip: submitLabel,
                //         onTap: formModel.form.valid && isDirty
                //             ? () async {
                //                 await controller.updateAndReturnArticle(
                //                   context,
                //                 );
                //               }
                //             : null,
                //         backgroundColor: colorScheme.primary,
                //         foregroundColor: colorScheme.onPrimary,
                //         child: AppText(submitLabel),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
    // return ArticlesModelFormBuilder(
    //   model: controller.initialModelRx.of(context),
    //   initState: (context, formModel) => controller.formRx.$ = formModel,
    //   builder: (context, formModel, child) {
    //     return ReactiveForm(
    //       formGroup: formModel.form,
    //       child: AlertDialog(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(16),
    //         ),
    //         backgroundColor: colorScheme.surface,
    //         title: Row(
    //           spacing: 16,
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             DialogIcon(
    //               icon: Icon(Icons.article),
    //               shape: BoxShape.rectangle,
    //               borderWidth: 1,
    //             ),
    //             Expanded(
    //               child: Column(
    //                 spacing: 8,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   AppText(
    //                     dialogTitle,
    //                     style: textTheme.titleLarge,
    //                   ),
    //                   DialogCheckBox(
    //                     formControlName:
    //                         ArticlesModelForm.isEnglishEnabledControlName,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             IconButton(
    //               tooltip: l10n.close,
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //               icon: Icon(Icons.close),
    //             ),
    //           ],
    //         ),
    //         content: BdayaLoadableAreaWrapper(
    //           area: controller.la,
    //           isLoadingBuilder: (context, error) =>
    //               const Center(child: CircularProgressIndicator()),
    //           builder: (context) => SingleChildScrollView(
    //               child: SizedBox(
    //             width: 688,
    //             child: Column(
    //               spacing: 12,
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                   child: Divider(
    //                     color: colorScheme.primaryContainer,
    //                     height: 1,
    //                   ),
    //                 ),
    //                 ReactiveDropDownMenuField<Category, Category>(
    //                   key: Key(ArticlesModelForm.categoryControlName),
    //                   labelText: l10n.Category,
    //                   controlledValue: Category(),
    //                   onControlledValue: () {
    //                     controller.isAddingCategory.$ = true;
    //                   },
    //                   elements: categories,
    //                   elementIdAccessor: (e) => e,
    //                   elementLabelAccessor: (e) =>
    //                       e.categoryName.locales[currentLocale] ??
    //                       e.categoryName.currentValue.value,
    //                   formControlName: ArticlesModelForm.categoryControlName,
    //                 ),
    //                 if (isAddingCategory == true)
    //                   LocaleEntryModelFormBuilder(
    //                     model: controller.newCategoryInitialModelRx.of(context),
    //                     initState: (context, fm) =>
    //                         controller.newCategoryFormRx.$ = fm,
    //                     builder: (context, fm, child) {
    //                       return Column(
    //                         mainAxisSize: MainAxisSize.min,
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         children: [
    //                           LocalesFormArray(
    //                             label: l10n.category_title,
    //                             isEnglishAllowed: true,
    //                             formControlName:
    //                                 LocaleEntryModelForm.localesControlName,
    //                           ),
    //                           Row(
    //                             children: [
    //                               Expanded(child: const SizedBox.shrink()),
    //                               Icon(
    //                                 Icons.add,
    //                                 size: 16,
    //                                 color: colorScheme.primary,
    //                               ),
    //                               SizedBox(width: 8),
    //                               GestureDetector(
    //                                 onTap: () async {
    //                                   await controller.addCategory(
    //                                       Map.fromEntries(
    //                                         (fm.form.control('locales').value
    //                                                 as List<
    //                                                     MapEntry<String,
    //                                                         String>?>)
    //                                             .nonNulls,
    //                                       ),
    //                                       l10n: l10n);
    //                                   formModel.categoryControl.value =
    //                                       controller.addedCategory.$;
    //                                   controller.isAddingCategory.$ = false;
    //                                 },
    //                                 child: AppText(
    //                                   context
    //                                       .addSomethingOf(l10n.category_title),
    //                                   style: textTheme.bodyLarge?.copyWith(
    //                                     color: colorScheme.primary,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ],
    //                       );
    //                     },
    //                   ),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                   child: Divider(
    //                     color: colorScheme.primaryContainer,
    //                     height: 1,
    //                   ),
    //                 ),
    //                 ReactiveValueListenableBuilder(
    //                   formControlName:
    //                       ArticlesModelForm.isEnglishEnabledControlName,
    //                   builder: (context, control, child) => LocalesFormArray(
    //                     label: l10n.article_title,
    //                     formControlName: ArticlesModelForm.headlineControlName,
    //                     isEnglishAllowed:
    //                         formModel.isEnglishEnabledControl.value ?? false,
    //                     onSubmitted: (control) {
    //                       formModel.articleControl.focus();
    //                     },
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                   child: Divider(
    //                     color: colorScheme.primaryContainer,
    //                     height: 1,
    //                   ),
    //                 ),
    //                 ReactiveValueListenableBuilder(
    //                   formControlName:
    //                       ArticlesModelForm.isEnglishEnabledControlName,
    //                   builder: (context, control, child) => LocalesFormArray(
    //                     maxLines: 4,
    //                     isEnglishAllowed:
    //                         formModel.isEnglishEnabledControl.value ?? false,
    //                     formControlName: ArticlesModelForm.articleControlName,
    //                     label: l10n.article_body,
    //                     onSubmitted: (control) {
    //                       formModel.shortTextControl.focus();
    //                     },
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                   child: Divider(
    //                     color: colorScheme.primaryContainer,
    //                     height: 1,
    //                   ),
    //                 ),
    //                 ReactiveValueListenableBuilder(
    //                   formControlName:
    //                       ArticlesModelForm.isEnglishEnabledControlName,
    //                   builder: (context, control, child) =>
    //                       ReactiveFormConsumer(
    //                     builder: (context, formGroup, child) =>
    //                         LocalesFormArray(
    //                       isEnglishAllowed:
    //                           formModel.isEnglishEnabledControl.value ?? false,
    //                       formControlName:
    //                           ArticlesModelForm.shortTextControlName,
    //                       label: l10n.short_text,
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                   child: Divider(
    //                     color: colorScheme.primaryContainer,
    //                     height: 1,
    //                   ),
    //                 ),
    //                 ReactiveDialogImageSection(
    //                   onDragDone: (details) async {
    //                     final file = details.files.last;
    //                     final data = await file.readAsBytes();
    //                     if (context.mounted) {
    //                       await controller.dropZoneUploadImage(
    //                           fileName: file.name,
    //                           data: data,
    //                           mimetype: file.mimeType,
    //                           context: context);
    //                     }
    //                   },
    //                   clickToUploadOnTap: () async {
    //                     final result = await SelectImagesDialog.getImage(
    //                       context,
    //                       parameters: SelectImagesDialogParams(),
    //                       category: 'articles',
    //                     );

    //                     if (result != null) {
    //                       // Store storageRef for saving to backend
    //                       controller.pendingStorageRefRx.$ = result.storageRef;
    //                       // Set displayUrl to form for preview
    //                       controller.formRx.$?.imageUrlControl.value =
    //                           result.displayUrl;
    //                     }
    //                   },
    //                   formControlName: ArticlesModelForm.imageUrlControlName,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //                   child: Divider(
    //                     color: colorScheme.primaryContainer,
    //                     height: 1,
    //                   ),
    //                 ),
    //                 ReactiveStatusField(
    //                     disabledHint:
    //                         controller.parameters.initialValue?.isShown == true
    //                             ? l10n.is_shown_description
    //                             : null,
    //                     readOnly:
    //                         controller.parameters.initialValue?.isShown == true,
    //                     formControlName: ArticlesModelForm.statusControlName),
    //               ],
    //             ),
    //           )),
    //         ),
    //         actions: [
    //           Row(
    //             spacing: 12,
    //             children: [
    //               Expanded(
    //                 child: ActionButton(
    //                   side: BorderSide(color: colorScheme.primaryContainer),
    //                   isSmallScreen: isTablet,
    //                   tooltip: l10n.cancel,
    //                   onTap: () => Navigator.of(context).pop(),
    //                   backgroundColor: colorScheme.surface,
    //                   foregroundColor: colorScheme.onSurface,
    //                   child: AppText(l10n.cancel),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: ReactiveArticlesModelFormConsumer(
    //                   builder: (context, formModel, child) {
    //                     final isDirty = formModel.form.dirty;
    //                     return ActionButton(
    //                       area: controller.saveLA,
    //                       isSmallScreen: isTablet,
    //                       tooltip: submitLabel,
    //                       onTap: formModel.form.valid && isDirty
    //                           ? () async {
    //                               await controller
    //                                   .updateAndReturnArticle(context);
    //                             }
    //                           : null,
    //                       backgroundColor: colorScheme.primary,
    //                       foregroundColor: colorScheme.onPrimary,
    //                       child: AppText(submitLabel),
    //                     );
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
