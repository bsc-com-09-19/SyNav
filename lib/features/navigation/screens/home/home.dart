import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer.dart';
import 'package:sy_nav/common/widgets/k_search_bar.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/helpers/wifi_algorithms.dart';
import 'package:sy_nav/utils/widgets/k_snack_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final wifiController = Get.find<WifiController>();

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
                controller: homeController.textEditingController.value,
                hintText: "Enter here",
              ),
              const SizedBox(
                height: kTextTabBarHeight,
              ),
              const Text("University of Malawi Campus Navigation",
                  textAlign: TextAlign.center),
              Obx(() => Card(
                    child: Text(
                        "Your location is: ${homeController.location.value.x}, ${homeController.location.value.y} "),
                  ))
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.location_pin),
        onPressed: () async {
          if (wifiController.wifiList.length < 3) {
            showErrorSnackBAr(context,
                "You dont have enough registered accesspoints around you. (${wifiController.wifiList.length}) APs  ");
          } else {
            List<String> wifiList = await wifiController.getTrilaterationWifi();
            homeController.location.value =
                WifiAlgorithms.getEstimatedLocation(wifiList);
          }
        },
      ),
      bottomNavigationBar: KBottomNavigationBar(),
    );
  }

  void handleMic() {
    //TODO
  }
}

class KBottomNavigationBar extends StatelessWidget {
  final List<String> navigationRoutes = [
    'explore',
    'bookmarks',
    'navigate',
    'notifications'
  ]; // Route names

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
        showUnselectedLabels: true,
        backgroundColor: AppColors.secondaryColor,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: "Explore"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_rounded), label: "Bookmarks"),
          BottomNavigationBarItem(
              icon: Transform.rotate(
                angle: 0.785398,
                child: const Icon(
                  Icons.navigation,
                ),
              ),
              label: "Navigate"),
          const BottomNavigationBarItem(
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
