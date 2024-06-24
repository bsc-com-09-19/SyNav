import 'package:collection/collection.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_routing/path_node.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';

List<PathNode> aStarAlgorithm(Grid grid, GridCell start, GridCell goal) {
  final openList = PriorityQueue<PathNode>((a, b) => a.fCost.compareTo(
      b.fCost)); // Priority queue to select the node with the lowest fCost
  final closedList = <PathNode>[]; // List to keep track of visited nodes

  final startNode = PathNode(
    row: start.row,
    col: start.col,
    gCost: 0, // gCost is 0 for the start node
    hCost: heuristic(start.row, start.col, goal.row,
        goal.col), // Heuristic cost for start node
  );
  final goalNode = PathNode(row: goal.row, col: goal.col); // Goal node

  openList.add(startNode); // Add start node to the open list

  while (openList.isNotEmpty) {
    final currentNode =
        openList.removeFirst(); // Get the node with the lowest fCost
    closedList.add(currentNode); // Add current node to the closed list

    // Destination reached?
    if (currentNode.row == goalNode.row && currentNode.col == goalNode.col) {
      return reconstructPath(currentNode); // Reconstruct and return the path
    }

    for (var neighbor in getNeighbors(grid, currentNode)) {
      // Get neighbors of the current node
      if (closedList.contains(neighbor)) {
        // Skip if the neighbor is already visited
        continue;
      }

      final tentativeGCost =
          currentNode.gCost + 1; // Assuming uniform cost for each move

      if (!openList.contains(neighbor) || tentativeGCost < neighbor.gCost) {
        neighbor.gCost = tentativeGCost; // Update gCost
        neighbor.hCost = heuristic(neighbor.row, neighbor.col, goalNode.row,
            goalNode.col); // Update hCost
        neighbor.parent =
            currentNode; // Set parent node for path reconstruction

        if (!openList.contains(neighbor)) {
          openList.add(neighbor); // Add neighbor to the open list
        }
      }
    }
  }

  return []; // Return an empty list if no path is found
}

double heuristic(int row1, int col1, int row2, int col2) {
  return (row1 - row2).abs() +
      (col1 - col2).abs().toDouble(); // Manhattan distance heuristic
}

List<PathNode> getNeighbors(Grid grid, PathNode node) {
  final neighbors = <PathNode>[]; // List to store neighbors

  final possibleMoves = [
    [0, -1], // left
    [0, 1], // right
    [-1, 0], // up
    [1, 0], // down
  ];

  for (var move in possibleMoves) {
    final newRow = node.row + move[0]; // Calculate new row
    final newCol = node.col + move[1]; // Calculate new column

    if (newRow >= 0 &&
        newRow < grid.rows &&
        newCol >= 0 &&
        newCol < grid.cols &&
        !grid.getCell(newRow, newCol).isObstacle) {
      // Check if the move is within grid bounds and not an obstacle
      neighbors.add(PathNode(row: newRow, col: newCol)); // Add valid neighbor
    }
  }

  return neighbors; // Return list of neighbors
}

List<PathNode> reconstructPath(PathNode endNode) {
  final path = <PathNode>[]; // List to store the path
  PathNode? currentNode = endNode; // Start from the end node

  while (currentNode != null) {
    path.add(currentNode); // Add current node to the path
    currentNode = currentNode.parent; // Move to the parent node
  }

  return path.reversed.toList(); // Reverse the path to get the correct order
}
