  import 'package:collection/collection.dart';
  import 'package:sy_nav/features/navigation/screens/map/grid_routing/path_node.dart';
  import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';

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
  List<PathNode> findPath(Grid grid, int startRow, int startCol, int endRow, int endCol) {
    final openList = PriorityQueue<PathNode>((a, b) => a.fCost.compareTo(b.fCost));
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
        if (closedList.contains(neighbor) || grid.getCell(neighbor.row, neighbor.col).isObstacle) {
          continue;
        }

        final tentativeGCost = currentNode.gCost + 1; // Assuming uniform cost for each move

        if (tentativeGCost < neighbor.gCost) {
          neighbor.gCost = tentativeGCost;
          neighbor.hCost = heuristic(neighbor.row, neighbor.col, endNode.row, endNode.col);
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
      [0, -1],  // left
      [0, 1],   // right
      [-1, 0],  // up
      [1, 0],   // down
    ];

    for (var move in possibleMoves) {
      final newRow = node.row + move[0];
      final newCol = node.col + move[1];

      if (newRow >= 0 && newRow < grid.rows && newCol >= 0 && newCol < grid.cols) {
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
