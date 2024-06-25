import 'package:sy_nav/utils/constants/k_sizes.dart';

class KValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    //Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    // TODO:: minimum size of password has to be stored in the constant sizes file

    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < KSizes.minPasswordLength) {
      return 'Password must be at least ${KSizes.minPasswordLength} characters long.';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?:{}|<>"]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    //Regular Expression for phone number
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }
}
