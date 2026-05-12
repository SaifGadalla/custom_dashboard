import '../../common.dart';

class AppCheckBox extends StatelessWidget {
  const AppCheckBox({
    super.key,
    this.tristate = false,
    required this.checkBoxValue,
    this.onChanged,
  });

  final bool tristate;
  final void Function(bool?)? onChanged;
  final bool? checkBoxValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: 68,
      child: Center(
        child: Checkbox(
          tristate: tristate,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          checkColor: ColorManager.brownNormal,
          fillColor: WidgetStatePropertyAll(ColorManager.surfaceWhite),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(width: 1.0, color: ColorManager.brownNormal),
          ),
          value: checkBoxValue,
          onChanged: onChanged,
          splashRadius: 0,
        ),
      ),
    );
  }
}
