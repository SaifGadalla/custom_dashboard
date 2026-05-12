import '../../common.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.isSelectable = false,
    this.style,
    this.overflow,
    this.textDirection,
    this.softWrap,
    this.showTooltip,
  });

  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool isSelectable;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextDirection? textDirection;
  final bool? softWrap;
  final bool? showTooltip;

  bool get _shouldAutoShowTooltip {
    if (maxLines == null) {
      return false;
    }
    final effectiveOverflow = overflow ?? TextOverflow.clip;
    return maxLines! > 0 && effectiveOverflow != TextOverflow.visible;
  }

  @override
  Widget build(BuildContext context) {
    final actualText = text.trim().isEmpty ? '-' : text;
    final child = isSelectable
        ? SelectableText(
            actualText,
            showCursor: true,
            textAlign: textAlign,
            maxLines: maxLines,
            style: style,
            textDirection: textDirection,
          )
        : Text(
            softWrap: softWrap,
            actualText,
            textAlign: textAlign,
            maxLines: maxLines,
            style: style,
            overflow: overflow,
            textDirection: textDirection,
          );

    final shouldShowTooltip = showTooltip ?? _shouldAutoShowTooltip;
    if (!shouldShowTooltip || text.trim().isEmpty) {
      return child;
    }

    return Tooltip(message: actualText, child: child);
  }
}
