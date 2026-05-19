import 'package:custom_dashboard/src/pages/services/add_or_edit_app_service/form/form.dart';

import '../../../../common.dart';

import 'controller.dart';

class AddOrEditAppServiceDialog extends ConsumerWidget {
  final Service? initialValue;
  const AddOrEditAppServiceDialog({super.key, this.initialValue});

  static Future<Service?> show(
    BuildContext context,
    Service? initialValue,
  ) async {
    return await showDialog<Service?>(
      context: context,
      builder: (context) => ProviderScope(
        child: AddOrEditAppServiceDialog(initialValue: initialValue),
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
      addOrEditServiceControllerProvider(initialValue),
    );

    final dialogTitle = initialValue != null
        ? l10n.service_editing
        : l10n.service_addition;
    final submitTitle = initialValue != null ? l10n.save : l10n.add;

    return ReactiveFormBuilder(
      form: () => ref
          .read(addOrEditServiceControllerProvider(initialValue).notifier)
          .form,
      builder: (context, formModel, child) {
        return ReactiveForm(
          formGroup: formModel,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: ColorManager.surfaceWhite,
            title: Row(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.surfaceActive),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.handshake),
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
                    AppTextField(
                      formControlName: ServiceModelForm.nameControlName,
                      label: l10n.service,
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
                                addOrEditServiceControllerProvider(
                                  initialValue,
                                ).notifier,
                              )
                              .handleDragUpload(data, file.name, formModel);
                        }
                      },
                      clickToUploadOnTap: () async {
                        await ref
                            .read(
                              addOrEditServiceControllerProvider(
                                initialValue,
                              ).notifier,
                            )
                            .pickAndUploadImage(formModel);
                      },
                      formControlName: ServiceModelForm.imageControlName,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(
                        color: ColorManager.surfaceActive,
                        height: 1,
                      ),
                    ),
                    DetailsSection(
                      formControlName: ServiceModelForm.detailsControlName,
                      tableTitle: l10n.service_details,
                      additionLabel: l10n.service_details_addition,
                      editingTitle: l10n.service_details_editing,
                      deleteDialogLabel: l10n.service_details_delete,
                      maxLines: 4,
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
                      isSmallScreen: isTablet,
                      tooltip: l10n.cancel,
                      onTap: () => Navigator.of(context).pop(),
                      backgroundColor: ColorManager.surfaceWhite,
                      foregroundColor: ColorManager.greyNormal,
                      child: AppText(l10n.cancel),
                    ),
                  ),
                  Expanded(
                    child: ReactiveFormConsumer(
                      builder: (context, formGroup, child) => AppButton(
                        isSmallScreen: isTablet,
                        tooltip: submitTitle,
                        onTap: formGroup.valid && formGroup.dirty
                            ? () async {
                                await ref
                                    .read(
                                      addOrEditServiceControllerProvider(
                                        initialValue,
                                      ).notifier,
                                    )
                                    .updateAndReturnAppService(
                                      context,
                                      formGroup,
                                    );
                              }
                            : null,
                        backgroundColor: ColorManager.brownNormal,
                        foregroundColor: ColorManager.surfaceWhite,
                        child: dialogState.isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorManager.surfaceWhite,
                                ),
                              )
                            : AppText(submitTitle),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
