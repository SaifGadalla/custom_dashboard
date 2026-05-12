import 'package:custom_dashboard/common.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.formControlName,
    this.label,
    this.description,
    this.formControl,
    this.obscureText = false,
  }) : assert(formControlName != null || formControl != null);

  final String? formControlName;
  final String? label;
  final String? description;
  final FormControl<String>? formControl;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final isTablet = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: true,
      desktop: false,
    );

    Widget? labelWidget;
    if (label != null || description != null) {
      labelWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) AppText(label!, style: textTheme.bodyLarge),
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

    final field = ReactiveTextField(
      formControlName: formControlName,
      formControl: formControl,
      obscureText: obscureText,
    );

    return !isTablet
        ? Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (labelWidget != null) Expanded(flex: 1, child: labelWidget),
              Expanded(flex: 6, child: field),
            ],
          )
        : Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [if (labelWidget != null) labelWidget, field],
          );
  }
}
