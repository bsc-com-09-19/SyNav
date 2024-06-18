// path_node.dart

class PathNode {
  final int row;
  final int col;
  double gCost; // Cost from start to this node
  double hCost; // Heuristic cost from this node to end
  PathNode? parent;

  PathNode({
    required this.row,
    required this.col,
    this.gCost = 0,
    this.hCost = 0,
    this.parent,
  });

  double get fCost => gCost + hCost;
}
