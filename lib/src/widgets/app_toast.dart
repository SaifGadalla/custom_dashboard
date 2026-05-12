import '../../common.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static void show(String msg) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.simple,
      title: AppText(msg),
      autoCloseDuration: const Duration(seconds: 3),
      backgroundColor: ColorManager.surfaceLight,
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: BorderSide(color: ColorManager.neutral100),
    );
  }
}
