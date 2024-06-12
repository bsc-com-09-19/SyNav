import 'package:flutter/material.dart';

class KDrawerItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final VoidCallback? onTap;
  const KDrawerItem({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
