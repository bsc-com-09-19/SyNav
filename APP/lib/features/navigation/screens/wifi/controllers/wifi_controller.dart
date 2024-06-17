import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/a_star_algorithm.dart';

class WifiController extends GetxController {
  var accelerometerValues = [0.0, 0.0, 0.0].obs;
  var gyroscopeValues = [0.0, 0.0, 0.0].obs;
  var wifiList = <String>[].obs;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Creating grid map
  final double cellSize = 1.3;
  final double startLatitude = 1.0;
  final double startLongitude = 1.0;

  late Rx<Grid> grid = Grid(
    rows: 0, // Initial value; will be updated based on Firestore data
    cols: 0, // Initial value; will be updated based on Firestore data
    cellSize: cellSize,
    startLatitude: startLatitude,
    startLongitude: startLongitude,
  ).obs;

  static const platform = MethodChannel('com.example.sy_nav/wifi');

  get gridMap => null;

  @override
  void onInit() {
    super.onInit();
    getWifiList();
    // Fetch data from Firestore and create grid map
    fetchGridCellsFromFirestore();
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

  List<String> getTrilaterationWifi() {
    if (wifiList.isNotEmpty && wifiList.length >= 3) {
      return wifiList.take(5).toList();
    } else {
      return [];
    }
  }

  void createGridMap(List<Map<String, dynamic>> cellsData) {
    // Calculate the number of rows and columns based on the data
    int maxRow = 0;
    int maxCol = 0;
    for (var data in cellsData) {
      if (data['row'] > maxRow) maxRow = data['row'];
      if (data['col'] > maxCol) maxCol = data['col'];
    }
    maxRow++; // Since rows and cols are zero-indexed
    maxCol++;

    print(
        'Creating grid map with $maxRow rows and $maxCol columns'); // Print grid dimensions

    grid.value = Grid(
      rows: maxRow,
      cols: maxCol,
      cellSize: cellSize,
      startLatitude: startLatitude,
      startLongitude: startLongitude,
    );

    for (var data in cellsData) {
      int row = data['row'];
      int col = data['col'];
      String name = data['name'];
      bool isObstacle = data['isObstacle'];

      grid.value.updateCell(row, col, isObstacle: isObstacle, name: name);
    }

    print(
        'Grid map created successfully'); // Print confirmation after grid creation
  }

  String getLocationName(double longitude, double latitude) {
    String name = grid.value.findCellNameByCoordinates(longitude, latitude);
    if (name != 'Unknown') {
      return name;
    } else {
      return "Unknown";
    }
  }

  void fetchGridCellsFromFirestore() async {
    try {
      CollectionReference gridCellsCollection =
          _firestore.collection('gridCells');
      QuerySnapshot querySnapshot = await gridCellsCollection.get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<Map<String, dynamic>> cellsData = documents.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'row': data['row'],
          'col': data['col'],
          'name': data['name'],
          'isObstacle': data['isObstacle'],
        };
      }).toList();

      print(
          'Fetched ${cellsData.length} grid cells from Firestore'); // Print number of cells fetched
      print(
          'First cell data: ${cellsData.isNotEmpty ? cellsData[0] : "No data"}'); // Print first cell data if available

      createGridMap(cellsData);
    } catch (e) {
      print('Failed to fetch grid cells from Firestore: $e');
    }
  }
}
