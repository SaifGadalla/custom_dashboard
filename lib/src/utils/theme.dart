import 'package:flutter/material.dart';

class AppTheme {
  static final theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}

class ColorManager {
  static const Color primaryColor = Color(0xFF1E90FF);
  static const Color secondaryColor = Color(0xFFFFD700);
}

class TestStyleManager {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle body1 = TextStyle(fontSize: 16, color: Colors.black);
  static const TextStyle body2 = TextStyle(fontSize: 14, color: Colors.black);
  static const TextStyle body3 = TextStyle(fontSize: 12, color: Colors.black);
}
