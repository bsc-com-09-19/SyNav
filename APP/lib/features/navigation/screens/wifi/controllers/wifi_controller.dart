import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/path_node.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';

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

  get gridMap => grid.value;

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

      List<Map<String, dynamic>> cellsData = [];
      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>;
        var cellList = data['cells'] as List<dynamic>;
        for (var cell in cellList) {
          cellsData.add(cell as Map<String, dynamic>);
        }
      }

      print(
          'Fetched ${cellsData.length} grid cells from Firestore'); // Print number of cells fetched
      print(
          'First cell data: ${cellsData.isNotEmpty ? cellsData[0] : "No data"}'); // Print first cell data if available

      createGridMap(cellsData);

      // Define start and end positions
      int startRow = 0;
      int startCol = 0;
      int endRow = grid.value.rows - 1;
      int endCol = grid.value.cols - 1;

      // Find and display path
      definePath(startRow, startCol, endRow, endCol);
    } catch (e) {
      print('Failed to fetch grid cells from Firestore: $e');
    }
  }

  /// Finds the shortest path between a start and end cell in a grid using the A* algorithm.
  ///
  /// The function uses a priority queue to manage open nodes and a list to keep track of closed nodes.
  /// The cost of moving from one cell to another is assumed to be uniform.
  ///
  /// [grid] - The grid on which the pathfinding is performed.
  /// [startRow] - The row index of the starting cell.
  /// [startCol] - The column index of the starting cell.
  /// [endRow] - The row index of the destination cell.
  /// [endCol] - The column index of the destination cell.
  ///
  /// Returns a list of [PathNode]s representing the path from the start cell to the end cell.
  List<PathNode> findPath(
      Grid grid, int startRow, int startCol, int endRow, int endCol) {
    final openList =
        PriorityQueue<PathNode>((a, b) => a.fCost.compareTo(b.fCost));
    final closedList = <PathNode>[];

    final startNode = PathNode(
      row: startRow,
      col: startCol,
      gCost: 0,
      hCost: heuristic(startRow, startCol, endRow, endCol),
    );
    final endNode = PathNode(row: endRow, col: endCol);

    openList.add(startNode);

    while (openList.isNotEmpty) {
      final currentNode = openList.removeFirst();
      closedList.add(currentNode);

      // If the destination cell is reached, reconstruct the path.
      if (currentNode.row == endNode.row && currentNode.col == endNode.col) {
        return reconstructPath(currentNode);
      }

      // Evaluate neighbors of the current node.
      for (var neighbor in getNeighbors(grid, currentNode)) {
        if (closedList.contains(neighbor) ||
            grid.getCell(neighbor.row, neighbor.col).isObstacle) {
          continue;
        }

        final tentativeGCost =
            currentNode.gCost + 1; // Assuming uniform cost for each move

        if (tentativeGCost < neighbor.gCost) {
          neighbor.gCost = tentativeGCost;
          neighbor.hCost =
              heuristic(neighbor.row, neighbor.col, endNode.row, endNode.col);
          neighbor.parent = currentNode;

          if (!openList.contains(neighbor)) {
            openList.add(neighbor);
          }
        }
      }
    }

    // Return an empty list if no path is found.
    return [];
  }

  /// Heuristic function for A* algorithm.
  ///
  /// Calculates the Manhattan distance between two cells, which is the sum of the absolute differences
  /// of their row and column indices.
  ///
  /// [row1], [col1] - The row and column indices of the first cell.
  /// [row2], [col2] - The row and column indices of the second cell.
  ///
  /// Returns the heuristic distance between the two cells.
  double heuristic(int row1, int col1, int row2, int col2) {
    return (row1 - row2).abs() + (col1 - col2).abs() as double;
  }

  /// Retrieves the neighboring cells of a given cell in the grid.
  ///
  /// Considers up, down, left, and right neighbors, ensuring they are within grid bounds.
  ///
  /// [grid] - The grid containing the cells.
  /// [node] - The current cell node for which neighbors are to be found.
  ///
  /// Returns a list of [PathNode]s representing the neighboring cells.
  List<PathNode> getNeighbors(Grid grid, PathNode node) {
    final neighbors = <PathNode>[];

    final possibleMoves = [
      [0, -1], // left
      [0, 1], // right
      [-1, 0], // up
      [1, 0], // down
    ];

    for (var move in possibleMoves) {
      final newRow = node.row + move[0];
      final newCol = node.col + move[1];

      if (newRow >= 0 &&
          newRow < grid.rows &&
          newCol >= 0 &&
          newCol < grid.cols) {
              neighbors.add(PathNode(row: newRow, col: newCol));
      }
    }

    return neighbors;
  }

  /// Reconstructs the path from the end node to the start node.
  ///
  /// Follows the parent links from the end node to the start node to reconstruct the path.
  ///
  /// [endNode] - The end node of the path.
  ///
  /// Returns a list of [PathNode]s representing the path from start to end.
  List<PathNode> reconstructPath(PathNode endNode) {
    final path = <PathNode>[];
    PathNode? currentNode = endNode;

    while (currentNode != null) {
      path.add(currentNode);
      currentNode = currentNode.parent;
    }

    return path.reversed.toList();
  }

  /// Displays the grid in the console.
  void displayGrid(List<PathNode> path) {
    final pathSet = path.map((node) => '${node.row},${node.col}').toSet();

    for (int row = 0; row < grid.value.rows; row++) {
      String rowStr = '';
      for (int col = 0; col < grid.value.cols; col++) {
        final cell = grid.value.getCell(row, col);
        if (cell.isObstacle) {
          rowStr += ' X ';
        } else if (pathSet.contains('$row,$col')) {
          rowStr += ' P ';
        } else {
          rowStr += ' . ';
        }
      }
      print(rowStr);
    }
  }

  /// Finds and prints the path from a start to an end location.
  void definePath(int startRow, int startCol, int endRow, int endCol) {
    List<PathNode> path =
        findPath(grid.value, startRow, startCol, endRow, endCol);
    if (path.isNotEmpty) {
      print("Path found:");
      displayGrid(path);
    } else {
      print("No path found.");
    }
  }
}

