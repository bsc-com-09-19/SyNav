import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/a_star_algorithm.dart';

class WifiController extends GetxController {
  var accelerometerValues = [0.0, 0.0, 0.0].obs;
  var gyroscopeValues = [0.0, 0.0, 0.0].obs;

  var wifiList = <String>[].obs;

  //creating grid map
  final int rows = 9;
  final int cols = 7;
  final double cellSize = 1.3;
  final double startLatitude = 1.0;
  final double startLongitude = 1.0;

  late Rx<Grid> grid =
      Grid(rows: 9, cols: 7, cellSize: 1.3, startLatitude: 1, startLongitude: 1)
          .obs;

  var gridMap = Grid(
      rows: 9, cols: 7, cellSize: 1.3, startLatitude: 1, startLongitude: 1);

  static const platform = MethodChannel('com.example.sy_nav/wifi');

  @override
  void onInit() {
    super.onInit();
    getWifiList();
    createGridMap(rows, cols, cellSize, startLatitude, startLongitude);
    // Listen for updates when the app starts
    listenForWifiUpdates();
  }

  Future<void> getWifiList() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getWifiList');
      wifiList.value = result.cast<String>();
    } on PlatformException catch (e) {
      wifiList.value = ["Failed to get Wi-Fi list: '${e.message}'"];
    }
  }

  void listenForWifiUpdates() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'updateWifiList') {
        final List<dynamic> result = call.arguments;
        wifiList.value = result.cast<String>();
      }
    });
  }

  ///GEts the first 5 access points from the available APs to be used for trilateration.
  ///Only works if the number of available of APs is atleast 3.
  ///if the number of APs is less than 5, either 3 or 4 it will still return thos
  List<String> getTrilaterationWifi() {
    if (wifiList.isNotEmpty && wifiList.length >= 3) {
      return wifiList.take(5).toList();
    } else {
      return [];
    }
  }

  //TODO: fetch data from firebase
  void createGridMap(int rows, int cols, double cellSize, double startLatitude,
      double startLongitude) {
    grid.value = Grid(
        rows: rows,
        cols: cols,
        cellSize: cellSize,
        startLatitude: startLatitude,
        startLongitude: startLongitude);

    grid.value.updateCell(2, 1, isObstacle: false, name: "Room A");
    grid.value.updateCell(3, 4, isObstacle: false, name: "Room X");
    grid.value.updateCell(4, 5, isObstacle: false, name: "Room Y");
    for (int i = 1; i <= 9; i++) {
      grid.value.updateCell(1, i, isObstacle: true);
    }

    for (int i = 1; i <= 9; i++) {
      if (i == 4 || i == 9) continue;
      grid.value.updateCell(3, i, isObstacle: true);
    }

    for (int i = 1; i <= 9; i++) {
      if (i == 4 || i == 9) continue;
      grid.value.updateCell(5, i, isObstacle: true);
    }

    var value = findPath(grid.value, 1, 1, 2, 2);
    print(value.toString());
  }

  void updateGridMap() {
    ///TODO
  }
  String getLocationName(double longitude, double latitude) {
    String name = grid.value.findCellNameByCoordinates(longitude, latitude);
    if (name != 'Unknown') {
      return name;
    } else {
      return "Unknown";
      // throw Exception("The location is not within the map");
    }
  }
}
