class Grid {
    constructor(rows, cols, cellSize, startLatitude, startLongitude) {
      this.rows = rows;
      this.cols = cols;
      this.cellSize = cellSize;
      this.grid = [];
  
      for (let r = 0; r < rows; r++) {
        let row = [];
        for (let c = 0; c < cols; c++) {
          const latitude = startLatitude + r * cellSize;
          const longitude = startLongitude + c * cellSize;
          const name = `Cell(${r + 1},${c + 1})`;
          row.push({
            row: r,
            col: c,
            name: name,
            latitude: latitude,
            longitude: longitude,
            isObstacle: false
          });
        }
        this.grid.push(row);
      }
    }
  
    getGrid() {
      return this.grid;
    }
  }
  
  export default Grid;
  