import 'package:custom_dashboard/common.dart';
import 'package:custom_dashboard/generated/l10n.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/gestures.dart';

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

  bool _hasImage(String? value) => value != null && value.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isMobile = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: false,
      desktop: false,
    );
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32,
      children: [
        AppText(l10n.image, style: textTheme.bodyLarge),
        if (!isMobile)
          Expanded(
            child: ReactiveValueListenableBuilder<String?>(
              formControlName: formControlName,
              builder: (context, control, child) {
                final hasImage = _hasImage(control.value);
                return DropTarget(
                  onDragDone: onDragDone,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: hasImage
                        ? _ImagePreview(
                            key: ValueKey(control.value),
                            imageUrl: control.value!,
                            onChangeImage: clickToUploadOnTap,
                          )
                        : _UploadPlaceholder(
                            key: const ValueKey('placeholder'),
                            onTap: clickToUploadOnTap,
                            l10n: l10n,
                            textTheme: textTheme,
                          ),
                  ),
                );
              },
            ),
          ),
        if (isMobile)
          ReactiveValueListenableBuilder<String?>(
            formControlName: formControlName,
            builder: (context, control, child) {
              final hasImage = _hasImage(control.value);
              return hasImage
                  ? _MobileImagePreview(
                      imageUrl: control.value!,
                      onChangeImage: clickToUploadOnTap,
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: ColorManager.surfaceActive,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: clickToUploadOnTap,
                        icon: Icon(Icons.add_photo_alternate_outlined),
                      ),
                    );
            },
          ),
      ],
    );
  }
}

/// Displays the image preview with a hover overlay to change the image.
class _ImagePreview extends StatefulWidget {
  const _ImagePreview({
    super.key,
    required this.imageUrl,
    required this.onChangeImage,
  });

  final String imageUrl;
  final VoidCallback? onChangeImage;

  @override
  State<_ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<_ImagePreview> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 160,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.surfaceActive),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: widget.imageUrl, fit: BoxFit.contain),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHovered ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: TextButton.icon(
                    onPressed: widget.onChangeImage,
                    icon: Icon(
                      Icons.cloud_upload_outlined,
                      color: ColorManager.surfaceWhite,
                    ),
                    label: AppText(
                      l10n.click_to_upload,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ColorManager.surfaceWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Upload placeholder shown when no image is selected (desktop).
class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder({
    super.key,
    required this.onTap,
    required this.l10n,
    required this.textTheme,
  });

  final VoidCallback? onTap;
  final S l10n;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.surfaceActive),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 32,
              color: ColorManager.greyNormal,
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = onTap,
                    text: l10n.click_to_upload,
                    style: textTheme.bodyLarge?.copyWith(
                      color: ColorManager.brownNormal,
                    ),
                  ),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: '${l10n.drag_and_drop_description(2)} MB',
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorManager.greyNormal,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Mobile image preview — a small circle with the image.
class _MobileImagePreview extends StatelessWidget {
  const _MobileImagePreview({
    required this.imageUrl,
    required this.onChangeImage,
  });

  final String imageUrl;
  final VoidCallback? onChangeImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChangeImage,
      child: Container(
        width: 64,
        height: 64,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorManager.surfaceActive),
        ),
        child: AppNetworkImage(url: imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
