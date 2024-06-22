import 'dart:math';

import 'package:collection/collection.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/path_node.dart';

// List<GridCell> getNeighbors(List<List<GridCell>> grid, GridCell cell) {
//   List<GridCell> neighbors = [];

//   // Define row and column limits
//   int numRows = grid.length;
//   int numCols = grid[0].length;

//   // Top neighbor
//   if (cell.row > 0) neighbors.add(grid[cell.row - 1][cell.col]);
//   // Bottom neighbor
//   if (cell.row < numRows - 1) neighbors.add(grid[cell.row + 1][cell.col]);
//   // Left neighbor
//   if (cell.col > 0) neighbors.add(grid[cell.row][cell.col - 1]);
//   // Right neighbor
//   if (cell.col < numCols - 1) neighbors.add(grid[cell.row][cell.col + 1]);

//   // Filter out obstacles
//   return neighbors.where((neighbor) => !neighbor.isObstacle).toList();
// }

// double heuristic(GridCell cell, GridCell endCell) {
//   return ((cell.row - endCell.row).abs() + (cell.col - endCell.col).abs())
//       .toDouble();
// }

// List<GridCell> aStarAlgorithm(
//     List<List<GridCell>> grid, GridCell startCell, GridCell endCell) {
//   Set<GridCell> openSet = {};
//   Map<GridCell, GridCell?> cameFrom = {};
//   Map<GridCell, double> gScore = {};
//   Map<GridCell, double> fScore = {};

//   // Initialize scores
//   grid.forEach((row) {
//     row.forEach((cell) {
//       gScore[cell] = double.infinity;
//       fScore[cell] = double.infinity;
//     });
//   });

//   gScore[startCell] = 0;
//   fScore[startCell] = heuristic(startCell, endCell);
//   openSet.add(startCell);

//   while (openSet.isNotEmpty) {
//     // Get the cell with the lowest fScore in openSet
//     GridCell current =
//         openSet.reduce((a, b) => fScore[a]! < fScore[b]! ? a : b);

//     if (current == endCell) {
//       // Reconstruct the path
//       List<GridCell> path = [];
//       GridCell? temp = current;
//       while (temp != null) {
//         path.add(temp);
//         temp = cameFrom[temp];
//       }
//       return path.reversed.toList();
//     }

//     openSet.remove(current);

//     getNeighbors(grid, current).forEach((neighbor) {
//       double tentativeGScore =
//           gScore[current]! + 1; // Assuming each step cost is 1

//       if (tentativeGScore < gScore[neighbor]!) {
//         cameFrom[neighbor] = current;
//         gScore[neighbor] = tentativeGScore;
//         fScore[neighbor] = gScore[neighbor]! + heuristic(neighbor, endCell);

//         if (!openSet.contains(neighbor)) {
//           openSet.add(neighbor);
//         }
//       }
//     });
//   }

//   return []; // Return empty list if no path found
// }



double heuristic(PathNode node1, PathNode node2) {
  return sqrt(pow((node1.row - node2.row).abs(), 2) +
      pow((node1.col - node2.col).abs(), 2));
}

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

List<PathNode> reconstructPath(PathNode endNode) {
  final path = <PathNode>[];
  PathNode? currentNode = endNode;

  while (currentNode != null) {
    path.add(currentNode);
    currentNode = currentNode.parent;
  }

  return path.reversed.toList();
}

List<PathNode> aStarAlgorithm(Grid grid, GridCell startCell, GridCell endCell) {
  final openSet = PriorityQueue<PathNode>((a, b) => a.fCost.compareTo(b.fCost));
  final cameFrom = <PathNode, PathNode>{};
  final gScore = <PathNode, double>{};
  final fScore = <PathNode, double>{};

  final startNode = PathNode(row: startCell.row, col: startCell.col);
  final endNode = PathNode(row: endCell.row, col: endCell.col);

  grid.getGrid().expand((row) => row).forEach((cell) {
    final node = PathNode(row: cell.row, col: cell.col);
    gScore[node] = double.infinity;
    fScore[node] = double.infinity;
  });

  gScore[startNode] = 0;
  fScore[startNode] = heuristic(startNode, endNode);
  openSet.add(startNode);

  while (openSet.isNotEmpty) {
    final current = openSet.removeFirst();

    if (current == endNode) {
      return reconstructPath(current);
    }

    for (var neighbor in getNeighbors(grid, current)) {
      if (grid.getCell(neighbor.row, neighbor.col).isObstacle) continue;

      final tentativeGScore = gScore[current]! + 1;

      if (tentativeGScore < gScore[neighbor]!) {
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] = gScore[neighbor]! + heuristic(neighbor, endNode);

        if (!openSet.contains(neighbor)) {
          openSet.add(neighbor);
        }
      }
    }
  }

  return [];
}
