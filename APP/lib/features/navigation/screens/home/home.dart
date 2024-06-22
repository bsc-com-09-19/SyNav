import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer.dart';
import 'package:sy_nav/common/widgets/k_height.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/nofications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/widgets/k_snack_bar.dart';
import 'package:alan_voice/alan_voice.dart';
import '../map/grid_map.dart';
import '../map/grid_routing/path_node.dart';
import '../navigation/navigationScreen.dart';
import '../wifi/algorithms/wifi_algorithms.dart';
import '../../../../utils/alan/alanutils.dart';

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
              heroTag: "add",
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
              heroTag: "location",
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                  wifiController.definePath(startRoom, endRoom);
                } else {
                  showErrorSnackBar(
                      context, 'Please enter start and end rooms.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Path Information:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(wifiController.pathString.value),
                      SizedBox(height: 5),
                      Text(wifiController.distanceString.value),
                      KHeight(height: 4),
                      Text(
                        "Directions: ${wifiController.directionsString.value}",
                        style: TextStyle(color: AppColors.primaryColor),
                      )
                    ],
                  ),
                ),
              )),
          SizedBox(height: 10),
          Obx(() => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      "Your location is: ${wifiController.getLocationName(homeController.location.value.x, homeController.location.value.y)}"
                      " (${homeController.location.value.x.toPrecision(1)}, ${homeController.location.value.y.toPrecision(1)})"),
                ),
              )),
          const SizedBox(height: 5),
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

                      bool isHighlighted =
                          wifiController.highlightedPath.isNotEmpty &&
                              wifiController.highlightedPath!.any(
                                  (node) => node.row == row && node.col == col);

                      return GestureDetector(
                        onTap: () {
                          handleGridCellTap(context, cell);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(2.0),
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

  void handleGridCellTap(BuildContext context, GridCell cell) {
    // Handle grid cell tap if needed
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
