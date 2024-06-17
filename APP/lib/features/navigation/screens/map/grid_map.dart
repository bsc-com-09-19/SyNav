import 'dart:math';

/// Represents a single cell in the grid map
class GridCell {
  final int row;
  final int col;
  String name;
  final double latitude;
  final double longitude;
  bool isObstacle;

  GridCell({
    required this.row,
    required this.col,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.isObstacle = false,
  });
}

/// Manages the 2D grid, allowing for updates and retrieval of cells.
class Grid {
  final int rows;
  final int cols;
  final double cellSize;
  late List<List<GridCell>> grid;

  Grid(
      {required this.rows,
      required this.cols,
      required this.cellSize,
      required double startLongitude,
      required double startLatitude}) {
    grid = List.generate(
        rows,
        (r) => List.generate(cols, (c) {
              double latitude = startLatitude + r * cellSize;
              double longitude = startLongitude + c * cellSize;
              String name = 'Cell(${r + 1},${c + 1})';
              return GridCell(
                  row: r,
                  col: c,
                  name: name,
                  latitude: latitude,
                  longitude: longitude);
            }));
  }

  /// Calculates the Euclidean distance between two cells.
  double calculateDistance(GridCell cell1, GridCell cell2) {
    double deltaX = cell1.longitude - cell2.longitude;
    double deltaY = cell1.latitude - cell2.latitude;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
  }

  /// Retrieves a specific cell from the grid.
  GridCell getCell(int row, int col) => grid[row][col];

  /// Updates the properties of a specific cell.
  void updateCell(int row, int col, {bool? isObstacle, String? name}) {
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      if (isObstacle != null) grid[row][col].isObstacle = isObstacle;
      if (name != null) grid[row][col].name = name;
    }
  }

  /// Finds the cell containing the given latitude and longitude.
  String findCellNameByCoordinates(double longitude, double latitude) {
    for (var row in grid) {
      for (var cell in row) {
        if (latitude >= cell.latitude &&
            latitude < cell.latitude + cellSize &&
            longitude >= cell.longitude &&
            longitude < cell.longitude + cellSize) {
          return cell.name;
        }
      }
    }
    return 'Unknown';
  }

  GridCell? findCellByCoordinates(double longitude, double latitude) {
    for (var row in grid) {
      for (var cell in row) {
        if (latitude >= cell.latitude &&
            latitude < cell.latitude + cellSize &&
            longitude >= cell.longitude &&
            longitude < cell.longitude + cellSize) {
          return cell;
        }
      }
    }
    return null;
  }

  GridCell? findCellByName(String name) {
    for (var row in grid) {
      for (var cell in row) {
        if (cell.name == name) {
          return cell;
        }
      }
    }

    //if not found
    return null;
  }
}
