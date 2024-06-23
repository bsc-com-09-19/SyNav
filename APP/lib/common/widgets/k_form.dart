import 'package:flutter/material.dart';
import 'package:sy_nav/utils/constants/colors.dart';

///Constant reusable text field
class KTextField extends StatelessWidget {
  const KTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputType,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines,
    this.maxLength,
    this.radius = 8,
    this.onTap,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType? inputType;
  final bool obscureText;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final double radius;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: TextField(
        keyboardType: inputType,
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
         
        // minLines: obscureText ? 1 : minLines,
        // //textfields with obscured texts cannot have multilines
        // maxLines: obscureText ? 1 : maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            gapPadding: 3,
            borderSide: const BorderSide(width: 1.5, color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: AppColors.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          // errorStyle: TextStyle(
          //   decorationColor: Colors.red.withOpacity(0.8),
          // ),
          errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: AppColors.red.withOpacity(0.8)),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}