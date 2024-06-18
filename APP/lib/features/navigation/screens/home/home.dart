import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer.dart';
import 'package:sy_nav/common/widgets/k_search_bar.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/navigation/navigationScreen.dart';
import 'package:sy_nav/features/navigation/screens/nofications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/widgets/k_snack_bar.dart';
import 'package:alan_voice/alan_voice.dart';

import '../../../../utils/alan/alanutils.dart';
import '../map/grid_routing/path_node.dart';
import '../wifi/algorithms/wifi_algorithms.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final wifiController = Get.find<WifiController>();

    final pages = [
      const ExploreWidget(),
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
        title: Obx(() => Text(homeController.appBarTitle.value)),
        centerTitle: true,
        actions: [Obx(() => homeController.iconButton.value)],
      ),
      drawer: const KDrawer(),
      body: Stack(
        children: [
          Obx(() => pages[homeController.currentIndex.value]),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                // Add your action here
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                homeController.currentIndex.value = 0;
                if (wifiController.wifiList.length < 3) {
                  showErrorSnackBar(
                    context,
                    "You don't have enough registered access points around you (${wifiController.wifiList.length} APs)",
                  );
                  AlanVoiceUtils.playText(
                      "You don't have enough registered access points around you");
                } else {
                  homeController.currentIndex.value = 0;
                  List<String> wifiList =
                      await wifiController.getTrilaterationWifi();
                  var estimatedLocation =
                      WifiAlgorithms.getEstimatedLocation(wifiList);
                  homeController.location.value = estimatedLocation;

                  String locationString =
                      "Your location is: ${homeController.location.value.x}, ${homeController.location.value.y}";
                  AlanVoiceUtils.playText(locationString);
                }
              },
              backgroundColor: AppColors.secondaryColor,
              child: const Icon(Icons.location_pin),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
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
    final wifiController = Get.find<WifiController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            KSearchBar(
              controller: homeController.textEditingController.value,
              hintText: "",
              onSearchTap: (name) {
                var destinationCell =
                    wifiController.gridMap.findCellByName(name);
                if (destinationCell != null) {
                  var locationCell = wifiController.grid.value
                      .findCellByCoordinates(homeController.location.value.x,
                          homeController.location.value.y);

                  if (locationCell != null) {
                    var distance = wifiController.gridMap
                        .calculateDistance(locationCell, destinationCell);
                    AlanVoiceUtils.playText(
                        "$name is available and it is $distance away from you");
                    if (kDebugMode) {
                      print("distance: $distance");
                    }

                    // A* algorithm for finding path
                    int startRow = locationCell.row;
                    int startCol = locationCell.col;
                    int endRow = destinationCell.row;
                    int endCol = destinationCell.col;

                    List<PathNode> path = wifiController.findPath(
                      wifiController.gridMap,
                      startRow,
                      startCol,
                      endRow,
                      endCol,
                    );

                    if (path.isNotEmpty) {
                      String pathString = "Path from $name:";
                      for (var node in path) {
                        pathString += " (${node.row}, ${node.col})";
                      }
                      AlanVoiceUtils.playText(pathString);
                    } else {
                      AlanVoiceUtils.playText("No path found to $name");
                    }
                  }
                } else {
                  AlanVoiceUtils.playText("The place $name is not available");
                }
              },
              onButtonTap: () {
                // Manipulate the button's state or behavior here
                // For example, change button color or perform an action
              },
            ),
            const SizedBox(
              height: kTextTabBarHeight + 30,
            ),
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        "Your location is: ${homeController.location.value.x}, ${homeController.location.value.y}"),
                  ),
                )),
            const SizedBox(height: 20),

            // generating wifi boxes

            Obx(() => wifiController.grid.value.rows == 0
                ? const Text("Grid is loading...")
                : Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: wifiController.grid.value.cols,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: wifiController.grid.value.rows *
                          wifiController.grid.value.cols,
                      itemBuilder: (context, index) {
                        int row = index ~/ wifiController.grid.value.cols;
                        int col = index % wifiController.grid.value.cols;
                        var cell = wifiController.grid.value.getCell(row, col);
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(2.0),
                          color: cell.isObstacle ? Colors.red : Colors.green,
                          child: Text(cell.name),
                        );
                      },
                    ),
                  )),
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
  final wifiController = Get.find<WifiController>();
  int currentIndex = 0;

  final List<String> navigationRoutes = [
    'Home',
    'Navigate',
    'History',
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
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: 0.785398,
              child: const Icon(Icons.navigation),
            ),
            label: "Navigate",
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined), label: "History"),
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
                onPressed: wifiController.getWifiList,
                icon: const Icon(Icons.refresh));
          }
        },
      ),
    );
  }
}

