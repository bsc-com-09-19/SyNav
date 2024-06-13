import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/sensor_manager.dart';
import 'package:sy_nav/utils/map/grid_map.dart';

class WifiController extends GetxController {
  var accelerometerValues = [0.0, 0.0, 0.0].obs;
  var gyroscopeValues = [0.0, 0.0, 0.0].obs;

  var wifiList = <String>[].obs;

  //creating grid map
  final int rows = 5;
  final int cols = 5;
  final double cellSize = 0.8;
  final double startLatitude = 4.0;
  final double startLongitude = 3.0;
  late Rx<Grid> grid =
      Grid(rows: 5, cols: 5, cellSize: 0.8, startLatitude: 4, startLongitude: 4)
          .obs;

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

  void createGridMap(int rows, int cols, double cellSize, double startLatitude,
      double startLongitude) {
    grid.value = Grid(
        rows: rows,
        cols: cols,
        cellSize: cellSize,
        startLatitude: startLatitude,
        startLongitude: startLongitude);
  }

  void updateGridMap() {
    ///TODO
  }
  String getLocationName(double latitude, double longitude) {
    String name = grid.value.findCellNameByCoordinates(latitude, longitude);
    if (name != 'Unknown') {
      return name;
    } else {
      return "Unknown";
      // throw Exception("The location is not within the map");
    }
  }
}
