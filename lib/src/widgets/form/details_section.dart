import '../../../common.dart';

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
