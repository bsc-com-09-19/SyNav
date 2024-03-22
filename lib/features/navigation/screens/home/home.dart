import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer.dart';
import 'package:sy_nav/common/widgets/k_search_bar.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/utils/constants/colors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      //every scaffold has to use this key
      key: DrawerManager.drawerKey,
      // appBar: AppBar(title: const Text("SyNav")),
      drawer: const KDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              KSearchBar(
                controller: controller.textEditingController.value,
                hintText: "Enter here",
              ),
              const SizedBox(
                height: kTextTabBarHeight,
              ),
              const Text("University of Malawi Campus Navigation",
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: bottomNavBar(),
    );
  }



  ClipRRect bottomNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0)),
      child: BottomNavigationBar(
        backgroundColor: AppColors.secondaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Exolore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_rounded), label: "Bookmarks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.navigation_rounded), label: "Navigate"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded), label: "Notifications"),
        ],
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.secondaryColor,
        elevation: 12.0,
      ),
    );
  }

  void handleMic() {
    //TODO
  }
}

class KBottomNavigationBar extends StatelessWidget {
  final List<String> navigationRoutes = ['explore', 'bookmarks', 'navigate', 'notifications']; // Route names

  KBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.secondaryColor,
        items: const  [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_rounded), label: "Bookmarks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.navigation_rounded), label: "Navigate"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded), label: "Notifications"),
        ],
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.secondaryColor,
        elevation: 12.0,
        onTap: (index) {
          if (index == 1 || index == 2 || index == 3) {
            // Handle navigation for first three items
            Get.toNamed(navigationRoutes[index]);
          }
        },
      ),
    );
  }
}
