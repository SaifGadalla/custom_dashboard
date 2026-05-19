import 'package:custom_dashboard/common.dart';

class DialogIcon extends StatelessWidget {
  const DialogIcon({
    super.key,
    required this.icon,
    this.borderRadius = kBorderRadius,
    this.shape = BoxShape.circle,
    this.borderWidth = 8,
    this.borderColor,
    this.backgroundColor,
  });

  final Widget icon;
  final double borderRadius;
  final BoxShape shape;
  final double borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border.all(
          color: borderColor ?? theme.colorScheme.primaryContainer,
          width: borderWidth,
        ),
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
        shape: shape,
      ),
      height: 56,
      width: 56,
      child: icon,
    );
  }
}
