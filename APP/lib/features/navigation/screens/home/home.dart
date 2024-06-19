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
import '../map/grid_map.dart';
import '../map/grid_routing/path_node.dart';
import '../wifi/algorithms/wifi_algorithms.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final wifiController = Get.find<WifiController>();

    final pages = [
      ExploreWidget(),
      NavigationScreen(),
      NotificationsScreen(),
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
  final HomeController homeController = Get.find();
  final WifiController wifiController = Get.find();

  final TextEditingController startRoomController = TextEditingController();
  final TextEditingController endRoomController = TextEditingController();

  // Variable to hold the currently highlighted path
  List<PathNode>? highlightedPath;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // KSearchBar(
          //   controller: homeController.textEditingController.value,
          //   hintText: "Search...",
          //   onSearchTap: (name) => handleSearchTap(context, name),
          //   onButtonTap: () {
          //     // Handle button tap if needed
          //   },
          // ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: startRoomController,
                      decoration: InputDecoration(
                        labelText: 'Start Room',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: endRoomController,
                      decoration: InputDecoration(
                        labelText: 'End Room',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                String startRoom = startRoomController.text.trim();
                String endRoom = endRoomController.text.trim();
                if (startRoom.isNotEmpty && endRoom.isNotEmpty) {
                  definePath(context, startRoom, endRoom);
                } else {
                  // Handle empty fields error
                  showErrorSnackBar(
                      context, 'Please enter start and end rooms.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Get Route',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 10),
          Obx(() => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      "Your location is: ${homeController.location.value.x}, ${homeController.location.value.y}"),
                ),
              )),
          SizedBox(height: 20),
          Obx(() => wifiController.grid.value.rows == 0
              ? Text("Grid is loading...")
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

                      // Check if the current cell is part of the highlighted path
                      bool isHighlighted = highlightedPath != null &&
                          highlightedPath!.any(
                              (node) => node.row == row && node.col == col);

                      return GestureDetector(
                        onTap: () {
                          handleGridCellTap(context, cell);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(2.0),
                          // Set color based on whether the cell is highlighted
                          color: isHighlighted
                              ? Colors.blue
                              : (cell.isObstacle ? Colors.red : Colors.green),
                          child: Text(cell.name),
                        ),
                      );
                    },
                  ),
                )),
        ],
      ),
    );
  }

  void handleSearchTap(BuildContext context, String name) {
    var destinationCell = wifiController.gridMap.findCellByName(name);
    if (destinationCell != null) {
      var locationCell = wifiController.grid.value.findCellByCoordinates(
        homeController.location.value.x,
        homeController.location.value.y,
      );

      if (locationCell != null) {
        var distance = wifiController.gridMap
            .calculateDistance(locationCell, destinationCell);
        AlanVoiceUtils.playText(
            "$name is available and it is $distance away from you");

        List<PathNode> path = wifiController.findPathUsingCells(
          wifiController.grid.value,
          locationCell,
          destinationCell,
        );

        // Highlight the computed path
        highlightedPath = path;

        if (path.isNotEmpty) {
          String pathString = "Path from $name:";
          for (var node in path) {
            pathString += " (${node.row}, ${node.col})";
          }
          AlanVoiceUtils.playText(pathString);
        } else {
          AlanVoiceUtils.playText("No path found to $name");
        }

        // Force rebuild the UI to reflect changes
        Get.forceAppUpdate();
      }
    } else {
      AlanVoiceUtils.playText("The place $name is not available");
    }
  }

  void handleGridCellTap(BuildContext context, GridCell cell) {
    // Handle grid cell tap if needed
  }

  void definePath(BuildContext context, String startRoom, String endRoom) {
    wifiController.definePath(startRoom, endRoom);
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.red,
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
