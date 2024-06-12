import 'package:flutter/material.dart';

class KIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final Color color;
  final bool hasBorder;
  final double borderWidth;
  final Color borderColor;
  final EdgeInsets padding;

  const KIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.size = 48.0, // Default size
    this.color = Colors.blue, // Default color
    this.hasBorder = true, // Default with border
    this.borderWidth = 2.0, // Default border width
    this.borderColor = Colors.transparent, // Default transparent border
    this.padding = const EdgeInsets.all(8.0), // Default padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2), // Adjust corner radius
        border: hasBorder
            ? Border.all(
                color: borderColor,
                width: borderWidth,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent, // Transparent button material
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: padding,
            child: Icon(
              icon,
              size: size - (borderWidth * 2), // Adjust icon size based on border
              color: Colors.white, // Default white icon color
            ),
          ),
        ),
      ),
    );
  }
}
