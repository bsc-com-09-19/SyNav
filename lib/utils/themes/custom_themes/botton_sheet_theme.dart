import "package:flutter/material.dart";

class KBottomSheetTheme {
  KBottomSheetTheme._();

  //light bottom sheet theme
  static BottomSheetThemeData lightBottomSheetThemeData = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Colors.white,
    modalBackgroundColor: Colors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  //dark bottom sheet theme
  static BottomSheetThemeData darkBottomSheetThemeData = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Colors.white,
    modalBackgroundColor: Colors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
