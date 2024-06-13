import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer.dart';
import 'package:sy_nav/common/widgets/k_search_bar.dart';
import 'package:sy_nav/features/navigation/screens/buildings/building.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/navigation/navigationScreen.dart';
import 'package:sy_nav/features/navigation/screens/nofications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/wifi_screen.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart';
import 'package:sy_nav/utils/widgets/k_snack_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final wifiController = Get.find<WifiController>();

    final pages = [
      ExploreWidget(),
      WifiScreen(),
      const NavigationScreen(),
      const NotificationsScreen(),
    ];

    return Scaffold(
      key: DrawerManager.drawerKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: homeController.handleOpenDrawer,
        ),
        title: Obx(
          () => Text(homeController.appBarTitle.value),
        ),
        centerTitle: true,
        actions: [Obx(() => homeController.iconButton.value)],
      ),
      drawer: const KDrawer(),
      body: Stack(
        children: [
          Obx(() => pages[homeController.currentIndex.value]),
          Positioned(
            bottom: 16.0, // Adjust position as needed
            right: 16.0, // Adjust position as needed
            child: FloatingActionButton(
              onPressed: () {
                // Add your action here
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 80.0, // Adjust position as needed
            right: 16.0, // Adjust position as needed
            child: FloatingActionButton(
              onPressed: () async {
                homeController.currentIndex.value = 0;
                if (wifiController.wifiList.length < 3) {
                  showErrorSnackBar(
                    context,
                    "You don't have enough registered access points around you (${wifiController.wifiList.length} APs)",
                  );
                } else {
                  homeController.currentIndex.value = 0;
                  List<String> wifiList =
                      await wifiController.getTrilaterationWifi();
                  homeController.location.value =
                      WifiAlgorithms.getEstimatedLocation(wifiList);
                }
              },
              child: Icon(Icons.location_pin),
              backgroundColor: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
      bottomNavigationBar: KBottomNavigationBar(),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class ExploreWidget extends StatelessWidget {
  const ExploreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            KSearchBar(
              controller: homeController.textEditingController.value,
              hintText: "Enter here",
            ),
            const SizedBox(
              height: kTextTabBarHeight + 30,
            ),
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        "Your location is: ${homeController.location.value.x}, ${homeController.location.value.y} "),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class KBottomNavigationBar extends StatefulWidget {
  KBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<KBottomNavigationBar> createState() => _KBottomNavigationBarState();
}

class _KBottomNavigationBarState extends State<KBottomNavigationBar> {
  final homeController = Get.find<HomeController>();
  final wificontroller = Get.find<WifiController>();
  int currentIndex = 0;

  final List<String> navigationRoutes = [
    'Explore',
    'Bookmarks',
    'Buildings',
    'Notifications',
  ];

  @override
  Widget build(BuildContext context) {
    currentIndex = homeController.currentIndex.value;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      child: BottomNavigationBar(
        currentIndex: homeController.currentIndex.value,
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
              icon: Icon(Icons.notifications_rounded), label: "History"),
        ],
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.secondaryColor,
        elevation: 12.0,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          homeController.currentIndex.value = index;
          homeController.appBarTitle.value = navigationRoutes[index];
          if (index == 1) {
            homeController.iconButton.value = IconButton(
                onPressed: wificontroller.getWifiList,
                icon: const Icon(Icons.refresh));
          }
        },
      ),
    );
  }
}
