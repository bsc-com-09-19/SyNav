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
  const Home({super.key});

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
      //every scaffold has to use this key
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
      body: Obx(() => pages[homeController.currentIndex.value]),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.location_pin,color: Color.fromARGB(255, 255, 255, 255),),
        style: const ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(AppColors.secondaryColor)),
        onPressed: () async {
          homeController.currentIndex.value = 0;
          if (wifiController.wifiList.length < 3) {
            showErrorSnackBAr(context,
                "You dont have enough registered accesspoints around you( ${wifiController.wifiList.length} APs) ");
          } else {
            homeController.currentIndex.value = 0;
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

class ExploreWidget extends StatelessWidget {
  ExploreWidget({
    super.key,
  });

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
  KBottomNavigationBar({super.key});

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
              icon: Icon(Icons.notifications_rounded), label: "Notifications"),
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
          //sets the actoins icon for refreshing
          if (index == 1) {
            homeController.iconButton.value = IconButton(
                onPressed: wificontroller.getWifiList,
                icon: const Icon(Icons.refresh));
          } else {}
          // if (index == 1 || index == 2 || index == 3) {
          //   // Handle navigation for first three items
          //   // Get.toNamed(navigationRoutes[index]);
          // }
        },
      ),
    );
  }
}
