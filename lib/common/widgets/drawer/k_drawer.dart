import 'package:flutter/material.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer_item.dart';
import 'package:sy_nav/features/navigation/screens/wifi/temp_accesspoints_screen.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({super.key});

  static const String email = "abc@bgc.ag";
  static const String profileName = "Don Chilcson";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(profileName),
            accountEmail: Text(email),
          ),
          const Divider(),
          const KDrawerItem(leadingIcon: Icons.person, title: profileName),
          const KDrawerItem(leadingIcon: Icons.settings, title: "Settings"),
          const KDrawerItem(leadingIcon: Icons.color_lens, title: "Theme"),
          KDrawerItem(
              leadingIcon: Icons.wifi,
              title: "Access points",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AccessPointsScreen()))),
          const KDrawerItem(
              leadingIcon: Icons.logout_outlined, title: profileName),
        ],
      ),
    );
  }
}
