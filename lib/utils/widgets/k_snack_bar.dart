import 'package:flutter/material.dart';
import 'package:sy_nav/utils/constants/colors.dart';

void showGoldenSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      backgroundColor: AppColors.primaryColor
          .withOpacity(0.4), // Golden color with 0.5 opacity
      duration: const Duration(seconds: 4), // Adjust the duration as needed
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}

void showErrorSnackBAr(BuildContext context, String message) {
  // Get the current ScaffoldMessengerState
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  //hides the current snack bar
  scaffoldMessenger.hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      backgroundColor: AppColors.secondaryColor
          .withOpacity(0.5), // Golden color with 0.5 opacity
      duration: const Duration(seconds: 5), // Adjust the duration as needed
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
