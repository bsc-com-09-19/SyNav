class GridCell {
  /**
   * Creates an instance of GridCell.
   * @param {number} row - The row number of the cell.
   * @param {number} col - The column number of the cell.
   * @param {string} name - The name of the cell.
   * @param {number} latitude - The latitude of the cell.
   * @param {number} longitude - The longitude of the cell.
   * @param {boolean} [isObstacle=false] - Whether the cell is an obstacle.
   */
  constructor(row, col, name, latitude, longitude, isObstacle = false) {
      /**
     * The row number of the cell.
     * @type {number}
     */
    this.row = row;
    /**
     * The column number of the cell.
     * @type {number}
     */
    this.col = col;/**
    * The name of the cell.
    * @type {string}
    */

    this.name = name;
    /**
     * The longitude of the cell.
     * @type {number}
     */
    this.latitude = latitude;
    /**
     * The longitude of the cell.
     * @type {number}
     */
    this.longitude = longitude;
    /**
     * Indicates whether the cell is an obstacle.
     * @type {boolean}
     * @default false
     */
    this.isObstacle = isObstacle;
  }
}

/**
 * Represents a grid of cells.
 */
class Grid {
  /**
   * Creates an instance of Grid.
   * @param {number} rows - The number of rows in the grid.
   * @param {number} cols - The number of columns in the grid.
   * @param {number} cellSize - The size of each cell.
   * @param {number} startLatitude - The starting latitude for the grid.
   * @param {number} startLongitude - The starting longitude for the grid.
   */
  constructor(rows, cols, cellSize, startLatitude, startLongitude) {
     /**
     * The number of rows in the grid.
     * @type {number}
     */
    this.rows = rows;
     /**
     * The number of rows in the grid.
     * @type {number}
     */
    this.cols = cols;
     /**
     * The grid of cells.
     * @type {GridCell[][]}
     */
    this.cellSize = cellSize;
    this.grid = this.createGrid(startLatitude, startLongitude);
  }
  /**
   * Creates the grid of cells.
   * @param {number} startLatitude - The starting latitude for the grid.
   * @param {number} startLongitude - The starting longitude for the grid.
   * @returns {GridCell[][]} The created grid of cells.
   */

  createGrid(startLatitude, startLongitude) {
    return Array.from({ length: this.rows }, (_, r) => 
      Array.from({ length: this.cols }, (_, c) => {
        const latitude = startLatitude + r * this.cellSize;
        const longitude = startLongitude + c * this.cellSize;
        const name = `Cell(${r + 1},${c + 1})`;
        return new GridCell(r, c, name, latitude, longitude, Math.random() < 0.2);
      })
    );
  }
  
   /**
   * Gets the grid of cells.
   * @returns {GridCell[][]} The grid of cells.
   */
  getGrid() {
    return this.grid;
  }
}

export default Grid;
export { GridCell };
