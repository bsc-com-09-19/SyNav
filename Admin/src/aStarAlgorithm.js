// Utility to get the neighbors of a cell
const getNeighbors = (grid, cell) => {
    const { row, col } = cell;
    const neighbors = [];
  
    if (row > 0) neighbors.push(grid[row - 1][col]); // Top
    if (row < grid.length - 1) neighbors.push(grid[row + 1][col]); // Bottom
    if (col > 0) neighbors.push(grid[row][col - 1]); // Left
    if (col < grid[0].length - 1) neighbors.push(grid[row][col + 1]); // Right
  
    return neighbors.filter(neighbor => neighbor && !neighbor.isObstacle);
  };
  
  // Heuristic function for A* (Euclidean distance)
  const heuristic = (cell, endCell) => {
    return Math.sqrt((cell.row - endCell.row) ** 2 + (cell.col - endCell.col) ** 2);
  };
  
  // A* Algorithm implementation
  export const aStarAlgorithm = (grid, startCell, endCell) => {
    const openSet = [];
    const cameFrom = new Map();
    const gScore = new Map();
    const fScore = new Map();
  
    // Initialize gScore and fScore
    grid.flat().forEach(cell => {
      gScore.set(cell, Infinity);
      fScore.set(cell, Infinity);
    });
  
    gScore.set(startCell, 0);
    fScore.set(startCell, heuristic(startCell, endCell));
    openSet.push(startCell);
  
    while (openSet.length > 0) {
      // Get the cell with the lowest fScore
      const current = openSet.reduce((acc, cell) => (fScore.get(cell) < fScore.get(acc) ? cell : acc));
  
      if (current === endCell) {
        // Reconstruct the path
        const path = [];
        let temp = current;
        while (temp) {
          path.push(temp);
          temp = cameFrom.get(temp);
        }
        return path.reverse();
      }
  
      openSet.splice(openSet.indexOf(current), 1);
  
      getNeighbors(grid, current).forEach(neighbor => {
        const tentativeGScore = gScore.get(current) + 1;
  
        if (tentativeGScore < gScore.get(neighbor)) {
          cameFrom.set(neighbor, current);
          gScore.set(neighbor, tentativeGScore);
          fScore.set(neighbor, gScore.get(neighbor) + heuristic(neighbor, endCell));
  
          if (!openSet.includes(neighbor)) {
            openSet.push(neighbor);
          }
        }
      });
    }
  
    return null; // Return null if no path found
  };
  