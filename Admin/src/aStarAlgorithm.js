/**
 * Utility function to get the neighbors of a cell in the grid.
 *
 * @param {Array} grid - The grid represented as a 2D array.
 * @param {Object} cell - The current cell.
 * @param {number} cell.row - The row index of the cell.
 * @param {number} cell.col - The column index of the cell.
 * @returns {Array} - An array of neighboring cells that are not obstacles.
 */
const getNeighbors = (grid, cell) => {
  const { row, col } = cell;
  const neighbors = [];

  if (row > 0) neighbors.push(grid[row - 1][col]); // Top
  if (row < grid.length - 1) neighbors.push(grid[row + 1][col]); // Bottom
  if (col > 0) neighbors.push(grid[row][col - 1]); // Left
  if (col < grid[0].length - 1) neighbors.push(grid[row][col + 1]); // Right

  return neighbors.filter(neighbor => neighbor && !neighbor.isObstacle);
};

/**
 * Heuristic function for A* algorithm (Euclidean distance).
 *
 * @param {Object} cell - The current cell.
 * @param {number} cell.row - The row index of the cell.
 * @param {number} cell.col - The column index of the cell.
 * @param {Object} endCell - The target cell.
 * @param {number} endCell.row - The row index of the target cell.
 * @param {number} endCell.col - The column index of the target cell.
 * @returns {number} - The heuristic cost estimate (Euclidean distance) to reach the end cell from the current cell.
 */
const heuristic = (cell, endCell) => {
  return Math.sqrt((cell.row - endCell.row) ** 2 + (cell.col - endCell.col) ** 2);
};

/**
 * A* Algorithm implementation to find the shortest path in a grid.
 *
 * @param {Array} grid - The grid represented as a 2D array.
 * @param {Object} startCell - The starting cell.
 * @param {number} startCell.row - The row index of the starting cell.
 * @param {number} startCell.col - The column index of the starting cell.
 * @param {Object} endCell - The target cell.
 * @param {number} endCell.row - The row index of the target cell.
 * @param {number} endCell.col - The column index of the target cell.
 * @returns {Array|null} - The shortest path from startCell to endCell as an array of cells, or null if no path is found.
 */
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
