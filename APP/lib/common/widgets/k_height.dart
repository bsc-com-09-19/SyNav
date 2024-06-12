import 'package:flutter/material.dart';

class KHeight extends StatelessWidget {
  final double height;
  const KHeight({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height,);
  }
}
