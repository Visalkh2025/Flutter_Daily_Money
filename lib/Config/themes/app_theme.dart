import 'package:flutter/material.dart';

const String poppinsFontFamily = 'Poppins';

ThemeData buildAppTheme() {
  return ThemeData(
    fontFamily: poppinsFontFamily,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.bold, fontSize: 32),
      displayMedium: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.bold, fontSize: 28),
      displaySmall: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.bold, fontSize: 24),
      headlineLarge: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.bold, fontSize: 20),
      headlineMedium: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.bold, fontSize: 18),
      headlineSmall: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.bold, fontSize: 16),
      titleLarge: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.w600, fontSize: 22),
      titleMedium: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.w600, fontSize: 18),
      titleSmall: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.w600, fontSize: 16),
      bodyLarge: TextStyle(fontFamily: poppinsFontFamily, fontSize: 16),
      bodyMedium: TextStyle(fontFamily: poppinsFontFamily, fontSize: 14),
      bodySmall: TextStyle(fontFamily: poppinsFontFamily, fontSize: 12),
      labelLarge: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.w500, fontSize: 16),
      labelMedium: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.w500, fontSize: 14),
      labelSmall: TextStyle(fontFamily: poppinsFontFamily, fontWeight: FontWeight.w500, fontSize: 12),
    ),
  );
}
