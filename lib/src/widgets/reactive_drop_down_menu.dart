import '../../../common.dart';

/// A reactive dropdown menu field that works with reactive forms.
///
/// Type parameters:
/// - `R`: The type stored in the form control (e.g., `String` for ID, or `Category` for full object)
/// - `T`: The type of elements in the dropdown list (e.g., `Category`)
///
/// Use [valueAccessor] when `R` != `T` to convert between form value and display element.
class ReactiveDropDownMenuField<R, T> extends StatelessWidget {
  const ReactiveDropDownMenuField({
    super.key,
    required this.elements,
    required this.elementLabelAccessor,
    required this.elementIdAccessor,
    required this.formControlName,
    this.valueAccessor,
    this.labelText,
    this.description,
    this.onControlledValue,
    this.controlledValue,
  });

  final List<T> elements;
  final String Function(T element) elementLabelAccessor;
  final R Function(T element) elementIdAccessor;
  final String formControlName;
  final ControlValueAccessor<R, T>? valueAccessor;
  final String? labelText;
  final String? description;
  final VoidCallback? onControlledValue;
  final R? controlledValue;

  Widget _buildDropDownField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final targetLabel = (labelText?.trim().isNotEmpty ?? false)
        ? labelText!.trim()
        : l10n.item;

    return ReactiveFormField<R, T>(
      key: Key(formControlName),
      formControlName: formControlName,
      valueAccessor: valueAccessor,
      builder: (field) {
        // Get the current value from the form
        final R? currentValue = field.control.value;

        // Find the selected element from the list by matching the ID
        T? selectedElement;
        if (currentValue != null) {
          selectedElement = elements
              .where((e) => elementIdAccessor(e) == currentValue)
              .firstOrNull;
        }

        // Get the ID for the dropdown value
        final R? dropdownValue = selectedElement != null
            ? elementIdAccessor(selectedElement)
            : null;

        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            suffixIcon: field.value != null
                ? IconButton(
                    tooltip: l10n.clear,
                    onPressed: () {
                      field.control.value = null;
                      field.didChange(null);
                    },
                    icon: Icon(Icons.close),
                  )
                : null,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: field.control.valid
                    ? colorScheme.primaryContainer
                    : colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: DropdownButton<R>(
            value: dropdownValue,
            isExpanded: true,
            underline: SizedBox(),
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppText(
                l10n.select_something_of(targetLabel),
                style: textTheme.labelSmall,
              ),
            ),
            items: [
              ...elements.map(
                (e) => DropdownMenuItem<R>(
                  value: elementIdAccessor(e),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(
                      elementLabelAccessor(e),
                      style: textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
              if (controlledValue != null)
                DropdownMenuItem<R>(
                  value: controlledValue,
                  child: AppText(
                    l10n.add_something_of(targetLabel),
                    style: textTheme.labelLarge,
                  ),
                ),
            ],
            onChanged: (value) async {
              if (value == controlledValue) {
                onControlledValue?.call();
              } else {
                final selected = elements.firstWhere(
                  (i) => elementIdAccessor(i) == value,
                );
                field.didChange(selected);
                field.control.markAsDirty();
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrLess = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );
    final textTheme = Theme.of(context).textTheme;
    // final resolvedLabelText = labelText == null
    //     ? null
    //     : requiredLabel(
    //         context,
    //         label: labelText!,
    //         formControlName: formControlName,
    //       );

    Widget? labelWidget;
    if (labelText != null || description != null) {
      labelWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelText != null)
            AppText(labelText!, style: textTheme.bodyLarge),
          if (description != null) ...[
            const SizedBox(height: 4),
            AppText(
              description!,
              style: textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      );
    }

    if (isTabletOrLess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          if (labelWidget != null) labelWidget,
          _buildDropDownField(context),
        ],
      );
    }

    return Row(
      spacing: 12,
      children: [
        if (labelWidget != null) Expanded(flex: 1, child: labelWidget),
        Expanded(flex: 6, child: _buildDropDownField(context)),
      ],
    );
  }
}
