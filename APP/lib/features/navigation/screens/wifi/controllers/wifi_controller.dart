import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/a_star_algorithm.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/path_node.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';

class WifiController extends GetxController {
  var accelerometerValues = [0.0, 0.0, 0.0].obs;
  var gyroscopeValues = [0.0, 0.0, 0.0].obs;
  var wifiList = <String>[].obs;

  var pathString = ''.obs;
  var distanceString = ''.obs;
  var highlightedPath = <PathNode>[].obs;
  var pathDirections = <String>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final cellSize = 1.3.obs;
  final startLatitude = 1.0.obs;
  final startLongitude = 1.0.obs;
  final numberOfRows = 3.obs;
  final numberOfCols = 3.obs;

  late Rx<Grid> grid;

  static const platform = MethodChannel('com.example.sy_nav/wifi');

  get gridMap => grid.value;

  @override
  void onInit() {
    super.onInit();
    getWifiList();
    fetchGridCellsFromFirestore();
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
    int maxRow = 0;
    int maxCol = 0;
    for (var data in cellsData) {
      if (data['row'] > maxRow) maxRow = data['row'];
      if (data['col'] > maxCol) maxCol = data['col'];
    }
    maxRow++;
    maxCol++;

    grid = Grid(
      rows: maxRow,
      cols: maxCol,
      cellSize: cellSize.value,
      startLatitude: startLatitude.value,
      startLongitude: startLongitude.value,
    ).obs;

    for (var data in cellsData) {
      int row = data['row'];
      int col = data['col'];
      String name = data['name'];
      bool isObstacle = data['isObstacle'];

      grid.value.updateCell(row, col, isObstacle: isObstacle, name: name);
    }
  }

  String getLocationName(double longitude, double latitude) {
    String name =
        grid.value.findCellNameByCoordinates(longitude, latitude) ?? 'Unknown';
    return name;
  }

  void fetchGridCellsFromFirestore() async {
    try {
      CollectionReference gridDataCollection =
          _firestore.collection('GridCellMetadata');
      QuerySnapshot metadataSnapshot = await gridDataCollection.get();

      if (metadataSnapshot.docs.isNotEmpty) {
        var data = metadataSnapshot.docs.first.data() as Map<String, dynamic>;
        cellSize.value = data["cellSize"];
        startLatitude.value = data["startLatitude"];
        startLongitude.value = data["startLongitude"];
      }

      CollectionReference gridCellsCollection =
          _firestore.collection('GridCells');
      QuerySnapshot querySnapshot = await gridCellsCollection.get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<Map<String, dynamic>> cellsData = [];
      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>;
        var cellList = data['cells'] as List<dynamic>;
        for (var cell in cellList) {
          cellsData.add(cell as Map<String, dynamic>);
        }
      }

      if (kDebugMode) {
        print('Fetched ${cellsData.length} grid cells from Firestore');
        print(
            'First cell data: ${cellsData.isNotEmpty ? cellsData[0] : "No data"}');
      }

      createGridMap(cellsData);
    } catch (e, stackTrace) {
      print('Failed to fetch grid cells from Firestore: $e');
      print(stackTrace);
    }
  }

  ///Finds the path from [startName] to the [endName] if they names exists in the grid map
  void definePath(String startName, String endName) {
    ///Clears the previous calculated path and distance
    clearPathDetails();

    try {
      //Checks if the gridMap exists and hads values
      if (grid.value != null && grid.value.grid.isNotEmpty) {
        final startCell = grid.value.findCellByName(startName);
        final endCell = grid.value.findCellByName(endName);
        //if the start and end have been found look for a path
        if (startCell != null && endCell != null) {
          List<PathNode> path =
              findPathUsingCells(grid.value, startCell, endCell);

          pathString.value = 'Path:';
          for (var node in path) {
            var gridName = grid.value.getCell(node.row, node.col).name;
            // pathString.value += " (${node.row + 1}, ${node.col + 1})";
            pathString.value += "$gridName -> ";
          }
          pathString.value += " End";

          highlightedPath.assignAll(path);

          double distance = grid.value.calculateDistance(startCell, endCell);
          distanceString.value =
              'Distance between start and end cells: $distance';

          pathDirections.value = generateDirections(path, cellSize.value);
          print("");
        } else {
          pathString.value = "Failed to find start or end cell.";
        }
      } else {
        pathString.value = "Grid is not initialized or empty.";
      }
    } catch (e, stackTrace) {
      print('Error defining path: $e');
      print(stackTrace);
      pathString.value = "Error defining path: $e";
    }
  }

  List<PathNode> findPathUsingCells(
      Grid grid, GridCell startCell, GridCell endCell) {
    return aStarAlgorithm(grid, startCell, endCell);
  }

  void clearPathDetails() {
    ///Clears the previous calculated path and distance
    pathString.value = distanceString.value = "";
    pathDirections.clear();
    highlightedPath.clear();
  }

  List<String> generateDirections(List<PathNode> path, double cellSize) {
    if (path.isEmpty) return [];

    final directions = <String>[];

    for (var i = 1; i < path.length; i++) {
      final current = path[i - 1];
      final next = path[i];
      final dx = next.row - current.row;
      final dy = next.col - current.col;
      final distance = (dx.abs() + dy.abs()) * cellSize;

      if (dx == 0 && dy != 0) {
        directions.add('Move forward ${distance} meters');
      } else if (dy == 0 && dx != 0) {
        directions.add(
            'Turn ${dx > 0 ? 'right' : 'left'} and move forward ${distance} meters');
      }
    }

    return directions;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
