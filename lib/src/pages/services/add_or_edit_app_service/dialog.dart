import 'package:custom_dashboard/src/pages/services/add_or_edit_app_service/form/form.dart';

import '../../../../common.dart';

import 'controller.dart';

class AddOrEditAppServiceDialog extends StatelessWidget {
  final AddOrEditAppServiceDialogController controller;
  const AddOrEditAppServiceDialog({super.key, required this.controller});

  static Future<Service?> show(
    BuildContext context, {
    required AddOrEditAppServiceParams params,
  }) async {
    return await showDialog<Service?>(
      context: context,
      builder: (context) => HookBuilder(
        builder: (_) => AddOrEditAppServiceDialog(
          controller: AddOrEditAppServiceDialogController(
            getIt<FileService>(),
            getIt<ServiceService>(),
            params,
          ),
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
    final textTheme = Theme.of(context).textTheme;
    final isTablet = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );
    final dialogTitle = controller.isEditing
        ? l10n.service_editing
        : l10n.service_addition;
    final submitTitle = controller.isEditing ? l10n.save : l10n.add;

    return ReactiveFormBuilder(
      form: () => controller.form,
      builder: (context, formModel, child) {
        return ReactiveForm(
          formGroup: formModel,
          // formGroup: formModel.form,
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
                        // final file = details.files.last;
                        // final data = await file.readAsBytes();
                        // field.control.value = file.path;
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
                        //   category: 'services',
                        // );

                        // if (result != null) {
                        //   // Store storageRef for saving to backend
                        //   controller.pendingStorageRefRx.$ = result.storageRef;
                        //   // Set displayUrl to form for preview
                        //   controller.formRx.$?.imageControl.value =
                        //       result.displayUrl;
                        // }
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
                        // area: controller.saveLA,
                        isSmallScreen: isTablet,
                        tooltip: submitTitle,
                        onTap: formGroup.valid && formGroup.dirty
                            ? () async {
                                // await controller.updateAndReturnAppService(context);
                              }
                            : null,
                        backgroundColor: ColorManager.brownNormal,
                        foregroundColor: ColorManager.surfaceWhite,
                        child: AppText(submitTitle),
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

class DetailsSection extends StatefulWidget {
  const DetailsSection({
    super.key,
    required this.formControlName,
    required this.tableTitle,
    required this.additionLabel,
    required this.editingTitle,
    this.deleteDialogLabel,
    this.maxLines,
  });

  final String formControlName;
  final String tableTitle;
  final String additionLabel;
  final String editingTitle;
  final String? deleteDialogLabel;
  final int? maxLines;

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  final Set<int> _selectedIndices = {};

  void _onSelectAll(bool? value, int controlCount) {
    setState(() {
      if (value == true) {
        _selectedIndices.addAll(List.generate(controlCount, (i) => i));
      } else {
        _selectedIndices.clear();
      }
    });
  }

  void _onToggleSelect(int index, bool? value) {
    setState(() {
      if (value == true) {
        _selectedIndices.add(index);
      } else {
        _selectedIndices.remove(index);
      }
    });
  }

  bool? _getSelectAllValue(int controlCount) {
    if (_selectedIndices.length == controlCount) return true;
    if (_selectedIndices.isEmpty) return false;
    return null; // indeterminate
  }

  Future<String?> _showTextInputDialog({
    required BuildContext context,
    required String title,
    String? initialValue,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final result = await showDialog<String?>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: ColorManager.surfaceWhite,
        title: AppText(title, style: Theme.of(context).textTheme.titleMedium),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: controller,
            maxLines: widget.maxLines ?? 1,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: AppText(context.l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ColorManager.brownNormal,
            ),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(dialogContext, text);
              }
            },
            child: AppText(
              context.l10n.save,
              style: TextStyle(color: ColorManager.surfaceWhite),
            ),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.surfaceActive),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        width: double.infinity,
        child: ReactiveFormArray(
          formArrayName: widget.formControlName,
          builder: (context, fa, child) {
            // Clean up selected indices that are out of range
            _selectedIndices.removeWhere((i) => i >= fa.controls.length);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row
                SizedBox(
                  height: 44,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (fa.controls.length > 1)
                        AppCheckBox(
                          tristate: true,
                          onChanged: (value) =>
                              _onSelectAll(value, fa.controls.length),
                          checkBoxValue: _getSelectAllValue(fa.controls.length),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AppText(
                            widget.tableTitle,
                            style: textTheme.titleSmall,
                          ),
                        ),
                      ),
                      if (_selectedIndices.isNotEmpty && fa.controls.length > 1)
                        IconButton(
                          tooltip: l10n.delete,
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[600],
                          ),
                          onPressed: () {
                            // Remove in reverse order to preserve indices
                            final sorted = _selectedIndices.toList()
                              ..sort((a, b) => b.compareTo(a));
                            for (final index in sorted) {
                              fa.removeAt(index);
                            }
                            fa.markAsDirty();
                            setState(() => _selectedIndices.clear());
                            AppToast.show(l10n.delete_success);
                          },
                        ),
                      IconButton(
                        tooltip: l10n.add,
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          final result = await _showTextInputDialog(
                            context: context,
                            title: widget.additionLabel,
                          );
                          if (result != null) {
                            fa.add(FormControl<String>(value: result));
                            fa.markAsDirty();
                            AppToast.show(l10n.add_success);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: ColorManager.surfaceActive),
                // Detail items
                if (fa.controls.isNotEmpty)
                  ...fa.controls.mapIndexed((i, control) {
                    return _DetailArrayItem(
                      key: ValueKey(i),
                      index: i,
                      value: control.value?.toString() ?? '',
                      isChecked: _selectedIndices.contains(i),
                      showCheckbox: fa.controls.length > 1,
                      canDelete: fa.controls.length > 1,
                      onChanged: (value) => _onToggleSelect(i, value),
                      onEdit: () async {
                        final result = await _showTextInputDialog(
                          context: context,
                          title: widget.editingTitle,
                          initialValue: control.value?.toString(),
                        );
                        if (result != null) {
                          control.value = result;
                          control.markAsDirty();
                        }
                      },
                      onDelete: () {
                        fa.removeAt(i);
                        fa.markAsDirty();
                        setState(() => _selectedIndices.remove(i));
                        AppToast.show(l10n.delete_success);
                      },
                    );
                  }),
                if (fa.controls.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: AppText(
                        l10n.add_something_of(l10n.details),
                        style: textTheme.bodyMedium?.copyWith(
                          color: ColorManager.greyNormal,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// A single row inside the [DetailsSection] form array.
class _DetailArrayItem extends StatelessWidget {
  const _DetailArrayItem({
    super.key,
    required this.index,
    required this.value,
    required this.isChecked,
    required this.showCheckbox,
    required this.canDelete,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final String value;
  final bool isChecked;
  final bool showCheckbox;
  final bool canDelete;
  final void Function(bool?) onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorManager.surfaceActive, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (showCheckbox)
            SizedBox(
              width: 48,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                checkColor: ColorManager.brownNormal,
                fillColor: WidgetStatePropertyAll(ColorManager.surfaceWhite),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: WidgetStateBorderSide.resolveWith(
                  (states) =>
                      BorderSide(width: 1.0, color: ColorManager.brownNormal),
                ),
                value: isChecked,
                onChanged: onChanged,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: AppText(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          IconButton(
            tooltip: context.l10n.edit,
            icon: Icon(Icons.edit_outlined, size: 18),
            onPressed: onEdit,
          ),
          if (canDelete)
            IconButton(
              tooltip: l10n.delete,
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red[600],
              ),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
