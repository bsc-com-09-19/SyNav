
import "package:flutter/material.dart";
import "package:sy_nav/utils/themes/custom_themes/appbar_theme.dart";
import "package:sy_nav/utils/themes/custom_themes/botton_sheet_theme.dart";
import "package:sy_nav/utils/themes/custom_themes/checkbox_theme.dart";
import "package:sy_nav/utils/themes/custom_themes/chip_theme.dart";
import "package:sy_nav/utils/themes/custom_themes/elevated_button_theme.dart";
import "package:sy_nav/utils/themes/custom_themes/outlined_button_theme.dart";
import "package:sy_nav/utils/themes/custom_themes/text_field_theme.dart";
import "package:sy_nav/utils/themes/custom_themes/text_theme.dart";

class KTheme {
  KTheme._(); //This makes the constructor private
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: KTextTheme.lightTextTheme,
    chipTheme: KChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: KAppBarTheme.lightAppBarTheme,
    checkboxTheme: KCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: KBottomSheetTheme.lightBottomSheetThemeData,
    elevatedButtonTheme: KElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: KOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: KTextFieldThmeme.lightInputDecorationTheme,
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: KTextTheme.darkTextTheme,
    chipTheme: KChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: KAppBarTheme.darkAppBarTheme,
    checkboxTheme: KCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: KBottomSheetTheme.darkBottomSheetThemeData,
    elevatedButtonTheme: KElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: KOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: KTextFieldThmeme.darkInputDecorationTheme,
  );
}
