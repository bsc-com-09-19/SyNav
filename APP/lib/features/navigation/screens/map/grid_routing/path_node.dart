// path_node.dart

class PathNode {
  final int row;
  final int col;
  double gCost; // Cost from start to this node
  double hCost; // Heuristic cost from this node to end
  PathNode? parent; // Parent node in the path

  PathNode({
    required this.row,
    required this.col,
    this.gCost = 0,
    this.hCost = 0,
    this.parent, // Optional parent parameter in constructor
  });

  double get fCost => gCost + hCost;
}
