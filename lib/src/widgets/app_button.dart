import '../../common.dart';
// TODO add a suitable replacment for loadable areas

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.height = 44,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    required this.child,
    this.side,
    this.isSmallScreen = false,
    this.icon,
    // this.area,
    this.tooltip,
    this.isLoading = false,
  });

  final double height;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget child;
  final Color? foregroundColor;
  final BorderSide? side;
  final bool isSmallScreen;
  final IconData? icon;
  final String? tooltip;
  final bool isLoading;
  // final SharedValue<BdayaLoadableArea>? area;

  @override
  Widget build(BuildContext context) {
    // final isLoading = area?.of(context).isLoading ?? false;

    final iconButton = IconButton(
      tooltip: tooltip,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? ColorManager.brownNormal,
        ),
      ),
      icon: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor ?? ColorManager.surfaceWhite,
                ),
              ),
            )
          : Icon(icon, color: foregroundColor ?? ColorManager.surfaceWhite),
      onPressed: isLoading ? null : onTap,
    );

    final button = Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          padding: isSmallScreen == true ? EdgeInsets.all(4) : null,
          fixedSize: Size.fromHeight(height),
          backgroundColor: backgroundColor ?? ColorManager.brownNormal,
          foregroundColor: foregroundColor ?? ColorManager.surfaceWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            // side: side ?? BorderSide(color: ColorManager.brownNormal),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor ?? ColorManager.surfaceWhite,
                  ),
                ),
              )
            : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [Icon(icon), child],
              )
            : child,
      ),
    );

    return isSmallScreen && icon != null ? iconButton : button;
  }
}
