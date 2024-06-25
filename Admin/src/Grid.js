class GridCell {
  constructor(row, col, name, latitude, longitude, isObstacle = false) {
    this.row = row;
    this.col = col;
    this.name = name;
    this.latitude = latitude;
    this.longitude = longitude;
    this.isObstacle = isObstacle;
  }
}

class Grid {
  constructor(rows, cols, cellSize, startLatitude, startLongitude) {
    this.rows = rows;
    this.cols = cols;
    this.cellSize = cellSize;
    this.grid = this.createGrid(startLatitude, startLongitude);
  }

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

  getGrid() {
    return this.grid;
  }
}

export default Grid;
export { GridCell };
