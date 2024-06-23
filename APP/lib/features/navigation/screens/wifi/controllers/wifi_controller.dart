import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/a_star_algorithm.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/path_node.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';

class WifiController extends GetxController {
  // Observable variables for sensor data and Wi-Fi list
  var accelerometerValues = [0.0, 0.0, 0.0].obs;
  var gyroscopeValues = [0.0, 0.0, 0.0].obs;
  var wifiList = <String>[].obs;
  var pathString = ''.obs;
  var distanceString = ''.obs;
  var highlightedPath = <PathNode>[].obs;
  var directionsString = "".obs;

  // Firestore instance for database interactions
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables for grid properties
  final cellSize = 1.3.obs;
  final startLatitude = 1.0.obs;
  final startLongitude = 1.0.obs;
  final numberOfRows = 3.obs;
  final numberOfCols = 3.obs;

  // Observable grid object
  var grid = Grid(
    rows: 1,
    cols: 1,
    cellSize: 1.3,
    startLongitude: 1.0,
    startLatitude: 1.3,
  ).obs;

  // Platform channel for native method calls
  static const platform = MethodChannel('com.example.sy_nav/wifi');

  // Getter for grid map
  get gridMap => grid.value;

  @override
  void onInit() async {
    super.onInit();
    await fetchGridCellsFromFirestore(); // Fetch grid cells from Firestore on initialization
    getWifiList(); // Get Wi-Fi list
    listenForWifiUpdates(); // Listen for Wi-Fi updates
  }

  // Method to get the Wi-Fi list
  Future<void> getWifiList() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getWifiList');
      wifiList.value = result.cast<String>();
    } on PlatformException catch (e) {
      wifiList.value = ["Failed to get Wi-Fi list: '${e.message}'"];
    }
  }

  // Method to listen for Wi-Fi updates
  void listenForWifiUpdates() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'updateWifiList') {
        final List<dynamic> result = call.arguments;
        wifiList.value = result.cast<String>();
      }
    });
  }

  // Method to get Wi-Fi list for trilateration
  List<String> getTrilaterationWifi() {
    if (wifiList.isNotEmpty && wifiList.length >= 3) {
      return wifiList.take(5).toList();
    } else {
      return [];
    }
  }

  // Method to create a grid map
  void createGridMap(List<Map<String, dynamic>> cellsData) {
    int maxRow = 0;
    int maxCol = 0;
    for (var data in cellsData) {
      if (data['row'] > maxRow) maxRow = data['row'];
      if (data['col'] > maxCol) maxCol = data['col'];
    }
    maxRow++;
    maxCol++;

    grid.value = Grid(
      rows: maxRow,
      cols: maxCol,
      cellSize: cellSize.value,
      startLatitude: startLatitude.value,
      startLongitude: startLongitude.value,
    );
    for (var data in cellsData) {
      int row = data['row'];
      int col = data['col'];
      String name = data['name'];
      bool isObstacle = data['isObstacle'];

      grid.value.updateCell(row, col, isObstacle: isObstacle, name: name);
    }
  }

  // Method to get location name based on coordinates
  String getLocationName(double longitude, double latitude) {
    String name = grid.value.findCellNameByCoordinates(longitude, latitude);
    return name;
  }

  // Method to fetch grid cells from Firestore
  Future<void> fetchGridCellsFromFirestore() async {
    try {
      // Fetch grid metadata
      CollectionReference gridDataCollection =
          _firestore.collection('GridCellMetadata');
      QuerySnapshot metadataSnapshot = await gridDataCollection.get();

      if (metadataSnapshot.docs.isNotEmpty) {
        var data = metadataSnapshot.docs.first.data() as Map<String, dynamic>;
        cellSize.value = data["cellSize"];
        startLatitude.value = (data["startLatitude"] as num).toDouble();
        startLongitude.value = (data["startLongitude"] as num).toDouble();
      }

      // Fetch grid cells
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
      if (kDebugMode) {
        print('Failed to fetch grid cells from Firestore: $e');
        print(stackTrace);
      }
    }
  }

  // Method to define a path from startName to endName
  Future<void> definePath(String startName, String endName) async {
    clearPathDetails(); // Clear previous path details
    try {
      await fetchGridCellsFromFirestore(); // Fetch latest grid data
      if (grid.value.grid.isNotEmpty) {
        final startCell = grid.value.findCellByName(startName);
        final endCell = grid.value.findCellByName(endName);

        if (startCell != null && endCell != null) {
          List<PathNode> path =
              findPathUsingCells(grid.value, startCell, endCell);

          pathString.value = 'Path:';
          for (var node in path) {
            var gridName = grid.value.getCell(node.row, node.col).name;
            pathString.value += "$gridName -> ";
          }
          pathString.value += " End";

          highlightedPath.assignAll(path);
          double distance = grid.value.calculateDistance(startCell, endCell);
          distanceString.value =
              'Distance between start and end cells: ${distance.toPrecision(1)}';

          for (var direction in generateDirections(path, cellSize.value)) {
            directionsString.value += "$direction ";
          }
        } else {
          pathString.value = "Failed to find start or end cell.";
        }
      } else {
        pathString.value = "Grid is not initialized or empty.";
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error defining path: $e');
        print(stackTrace);
      }
      pathString.value = "Error defining path: $e";
    }
  }

  // Method to find a path using A* algorithm
  List<PathNode> findPathUsingCells(
      Grid grid, GridCell startCell, GridCell endCell) {
    return aStarAlgorithm(grid, startCell, endCell);
  }

  // Method to generate directions from a path
  List<String> generateDirections(List<PathNode> path, double cellSize) {
    if (path.isEmpty) return [];

    final directions = <String>[];

    int dx = 0, dy = 0; // Variables to track direction
    double aggregatedDistance = 0; // Variable to accumulate distance

    // Iterate through the path
    for (var i = 1; i < path.length; i++) {
      final current = path[i - 1];
      final next = path[i];
      final currentDx = next.row - current.row;
      final currentDy = next.col - current.col;

      // Calculate the distance for the current move
      final distance = (currentDx.abs() + currentDy.abs()) * cellSize;

      // Check if the direction has changed
      if (currentDx != dx || currentDy != dy) {
        // Add the aggregated direction if there was a previous direction
        if (aggregatedDistance > 0) {
          if (dx == 0 && dy != 0) {
            directions.add(
                'Move forward ${aggregatedDistance.toStringAsFixed(2)} meters');
          } else if (dy == 0 && dx != 0) {
            directions.add(
                'Turn ${dx > 0 ? 'right' : 'left'} and move forward ${aggregatedDistance.toStringAsFixed(2)} meters');
          }
        }
        // Reset the aggregation
        dx = currentDx;
        dy = currentDy;
        aggregatedDistance = 0;
      }
      // Accumulate the distance
      aggregatedDistance += distance;
    }

    // Add the last aggregated direction
    if (aggregatedDistance > 0) {
      if (dx == 0 && dy != 0) {
        directions.add(
            'Move forward ${aggregatedDistance.toStringAsFixed(2)} meters');
      } else if (dy == 0 && dx != 0) {
        directions.add(
            'Turn ${dx > 0 ? 'right' : 'left'} and move forward ${aggregatedDistance.toStringAsFixed(2)} meters');
      }
    }

    return directions;
  }

  // Method to clear path details
  void clearPathDetails() {
    pathString.value = distanceString.value = directionsString.value = "";
    highlightedPath.clear();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
