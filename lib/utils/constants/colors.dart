import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF274C90);
  static const Color secondaryColor = Color(0xFF967613);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);

  // Define a custom color swatch for the golden color
  // Define a custom color swatch for the golden color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (int i = 0; i < 10; i++) {
      final double strength = strengths[i];
      final double ds = 0.5 - strength;
      swatch[10 * i] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}

class AppStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  // Add more styles as needed
}

final ThemeData myTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.createMaterialColor(AppColors.secondaryColor),
    secondary: AppColors.primaryColor,
    background: AppColors.white,
    surface: AppColors.white,
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onBackground: AppColors.secondaryColor,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.secondaryColor,
  ),
  // Add more theme properties if needed
);
