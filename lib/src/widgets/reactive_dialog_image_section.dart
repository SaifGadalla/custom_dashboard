import 'package:custom_dashboard/common.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReactiveDialogImageSection extends StatelessWidget {
  const ReactiveDialogImageSection({
    super.key,
    required this.onDragDone,
    required this.clickToUploadOnTap,
    required this.formControlName,
  });

  final void Function(DropDoneDetails)? onDragDone;
  final void Function()? clickToUploadOnTap;
  final String? formControlName;

  @override
  Widget build(BuildContext context) {
    final isMobile = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: false,
      desktop: false,
    );
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32,
      children: [
        AppText(l10n.image, style: textTheme.bodyLarge),
        if (!isMobile) ...[
          ReactiveValueListenableBuilder<String?>(
            formControlName: formControlName,
            builder: (context, control, child) => Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: control.value == null
                  ? IconButton(
                      onPressed: clickToUploadOnTap,
                      icon: Icon(Icons.add_photo_alternate_outlined),
                    )
                  : InkWell(
                      onTap: () {
                        launchUrlString(control.value ?? '');
                      },
                      child: AppNetworkImage(url: control.value ?? ''),
                    ),
            ),
          ),
          Expanded(
            child: ReactiveFormField<String?, String?>(
              formControlName: formControlName,
              builder: (field) => DropTarget(
                onDragDone: onDragDone,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  height: 74,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.primaryContainer),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = clickToUploadOnTap,
                          text: l10n.click_to_upload,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        TextSpan(text: ' '),
                        TextSpan(
                          text: '${l10n.drag_and_drop_description(2)} MB',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (isMobile) ...[
          ReactiveFormField<String?, String?>(
            formControlName: formControlName,
            builder: (field) {
              final control = field.control;
              return Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: control.value == null
                    ? IconButton(
                        onPressed: clickToUploadOnTap,
                        icon: Icon(Icons.add_photo_alternate_outlined),
                      )
                    : InkWell(
                        onTap: () {
                          launchUrlString(control.value ?? '');
                        },
                        child: AppNetworkImage(url: control.value ?? ''),
                      ),
              );
            },
          ),
        ],
      ],
    );
  }
}
