import '../../common.dart';

class AppTheme {
  static final theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: textTheme,
    searchBarTheme: SearchBarThemeData(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          side: BorderSide(color: ColorManager.greyLighter, width: 1),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: BorderSide(color: ColorManager.greyLighter, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: BorderSide(color: ColorManager.brownNormal, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: textTheme,
  );
}

class ColorManager {
  static const Color brownNormal = Color(0xFFC67C4E);
  static const Color brownLight = Color(0xFFF9F2ED);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF9F9F9);
  static const Color surfaceActive = Color(0xFFE3E3E3);
  static const Color greyNormal = Color(0xFF313131);
  static const Color greyActive = Color(0xFF242424);
  static const Color greyLighter = Color(0xFFA2A2A2);
  static const Color deliveryGreen = Color(0xFF36C07E);
  static const Color neutral100 = Color(0xFF101010);
}

const TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
  displayMedium: TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
  displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w100),
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.005,
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
  ),
  headlineSmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
  ),
  titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
  ),
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.5),
  bodyLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.01,
  ),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, height: 1.5),
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2),
  labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.2),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.5,
  ),
  labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, height: 1.2),
);

// class TestStyleManager {
//   static const TextStyle heading1 = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   );
//   static const TextStyle heading2 = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   );
//   static const TextStyle heading3 = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   );
//   static const TextStyle body1 = TextStyle(fontSize: 16, color: Colors.black);
//   static const TextStyle body2 = TextStyle(fontSize: 14, color: Colors.black);
//   static const TextStyle body3 = TextStyle(fontSize: 12, color: Colors.black);
// }
