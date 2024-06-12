import 'package:flutter/material.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer_item.dart';
import 'package:sy_nav/features/navigation/screens/wifi/temp_accesspoints_screen.dart';
import 'package:sy_nav/utils/constants/colors.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({super.key});

  static const String email = "synav@synav.com";
  static const String profileName = "Don Chilcso";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: AppColors.primaryColor,
      backgroundColor: AppColors.backgroundColor,
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.secondaryColor),
            accountName: Text(profileName),
            accountEmail: Text(email),
          ),
          // const Divider(),
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
