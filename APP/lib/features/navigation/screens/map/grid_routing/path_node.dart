class PathNode {
  final int row;
  final int col;
  double gCost;
  double hCost;
  double get fCost => gCost + hCost;
  PathNode? parent;

  PathNode({
    required this.row,
    required this.col,
    this.gCost = double.infinity,
    this.hCost = double.infinity,
    this.parent,
  });
}
