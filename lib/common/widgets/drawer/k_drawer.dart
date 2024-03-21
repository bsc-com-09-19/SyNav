import 'package:flutter/material.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer_item.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({super.key});

  static const String email = "abc@bgc.ag";
  static const String profileName = "Don Chilcson";

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(profileName),
            accountEmail: Text(email),
          ),
          Divider(),
          KDrawerItem(leadingIcon: Icons.person, title: profileName),
          KDrawerItem(leadingIcon: Icons.settings, title: "Settings"),
          KDrawerItem(leadingIcon: Icons.color_lens, title: "Theme"),
          KDrawerItem(leadingIcon: Icons.logout_outlined, title: profileName),
        ],
      ),
    );
  }
}
