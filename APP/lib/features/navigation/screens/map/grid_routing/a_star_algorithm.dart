import 'package:collection/collection.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/path_node.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';

List<PathNode> aStarAlgorithm(Grid grid, GridCell start, GridCell goal) {
  final openList =
      PriorityQueue<PathNode>((a, b) => a.fCost.compareTo(b.fCost));
  final closedList = <PathNode>[];

  final startNode = PathNode(
    row: start.row,
    col: start.col,
    gCost: 0,
    hCost: heuristic(start.row, start.col, goal.row, goal.col),
  );
  final goalNode = PathNode(row: goal.row, col: goal.col);

  openList.add(startNode);

  while (openList.isNotEmpty) {
    final currentNode = openList.removeFirst();
    closedList.add(currentNode);

    if (currentNode.row == goalNode.row && currentNode.col == goalNode.col) {
      return reconstructPath(currentNode);
    }

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
            heuristic(neighbor.row, neighbor.col, goalNode.row, goalNode.col);
        neighbor.parent = currentNode;

        if (!openList.contains(neighbor)) {
          openList.add(neighbor);
        }
      }
    }
  }

  return [];
}

double heuristic(int row1, int col1, int row2, int col2) {
  return (row1 - row2).abs() + (col1 - col2).abs().toDouble();
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
