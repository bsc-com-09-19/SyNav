import 'package:flutter/material.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer_item.dart';
import 'package:sy_nav/features/navigation/screens/bookmarks/bookmarks.dart';
import 'package:sy_nav/features/navigation/screens/nofications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/temp_accesspoints_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/wifi_screen.dart';
import 'package:sy_nav/utils/constants/colors.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({super.key});

  static const String email = "synav@synav.com";
  static const String profileName = "Synav1";

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
          KDrawerItem(
            leadingIcon: Icons.person,
            title: profileName,
            // onTap: () {
            //   // Add your navigation logic here for profile
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            // },
          ),
          // KDrawerItem(
          //   leadingIcon: Icons.settings,
          //   title: "Settings",
          //   onTap: () {
          //     // Add your navigation logic here for settings
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (_) => SettingsScreen()));
          //   },
          // ),
          KDrawerItem(
            leadingIcon: Icons.wifi,
            title: "Access points",
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => BookMarksScreen())),
          ),
          KDrawerItem(
            leadingIcon: Icons.logout_outlined,
            title: "History",
            // onTap: () {
            //   // Add your navigation logic here for history
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
            // },
          ),
        ],
      ),
    );
  }
}
