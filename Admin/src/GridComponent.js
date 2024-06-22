import React, { useState, useEffect } from 'react';
import Grid from './Grid';
import GridCellCard from './GridCellCard';
import { firestore, collection, addDoc, getDocs } from './firebaseConfig';
import { aStarAlgorithm } from './aStarAlgorithm';
import './GridComponent.css';

const GridComponent = () => {
  const [rows, setRows] = useState(11);
  const [cols, setCols] = useState(8);
  const [cellSize, setCellSize] = useState(1.3);
  const [startLatitude, setStartLatitude] = useState(1.0);
  const [startLongitude, setStartLongitude] = useState(1.0);
  const [grid, setGrid] = useState([]);
  const [loading, setLoading] = useState(false);
  const [startName, setStartName] = useState('');
  const [endName, setEndName] = useState('');
  const [distance, setDistance] = useState(null);
  const [path, setPath] = useState([]);

  const createGrid = () => {
    const newGrid = new Grid(rows, cols, cellSize, startLatitude, startLongitude);
    const gridData = newGrid.getGrid();
    console.log('New Grid:', gridData);
    setGrid(gridData);
  };

  const saveGridToFirebase = async () => {
    if (!grid || grid.length === 0) return;

    setLoading(true);
    try {
      // Save grid cells
      for (let i = 0; i < grid.length; i++) {
        const row = grid[i];
        const rowData = row.map(cell => ({
          row: cell.row,
          col: cell.col,
          name: cell.name,
          latitude: cell.latitude,
          longitude: cell.longitude,
          isObstacle: cell.isObstacle,
        }));
        await addDoc(collection(firestore, 'GridCells'), { cells: rowData });
      }

      // Save grid map properties
      const lastLatitude = startLatitude + (rows - 1) * cellSize;
      const gridMapProperties = {
        cellSize: parseFloat(cellSize),
        startLatitude,
        startLongitude,
        lastLatitude,
        numberOfRows: rows,
        numberOfCols: cols,
      };
      await addDoc(collection(firestore, 'GridCellMetadata'), gridMapProperties);

      alert('Grid saved to Firebase successfully!');
    } catch (error) {
      console.error('Error saving grid to Firebase:', error);
      alert('Error saving grid to Firebase.');
    }
    setLoading(false);
  };

  const retrieveGridFromFirebase = async () => {
    setLoading(true);
    try {
      const querySnapshot = await getDocs(collection(firestore, 'GridCells'));
      const rowsData = querySnapshot.docs.map(doc => doc.data().cells);

      const maxRow = rowsData.length - 1;
      const maxCol = Math.max(...rowsData.map(row => row.length - 1));
      const processedGrid = Array.from({ length: maxRow + 1 }, () => Array(maxCol + 1).fill(null));

      rowsData.forEach((row, rowIndex) => {
        row.forEach(cell => {
          processedGrid[cell.row][cell.col] = cell;
        });
      });

      console.log('Retrieved Grid:', processedGrid);
      setGrid(processedGrid);
      alert('Grid retrieved from Firebase successfully!');
    } catch (error) {
      console.error('Error retrieving grid from Firebase:', error);
      alert('Error retrieving grid from Firebase.');
    }
    setLoading(false);
  };

  const handleCellEdit = (cell, newName, newIsObstacle) => {
    const updatedGrid = grid.map(row =>
      row.map(c =>
        c && c.row === cell.row && c.col === cell.col
          ? { ...c, name: newName, isObstacle: newIsObstacle }
          : c
      )
    );
    console.log('Updated Grid:', updatedGrid);
    setGrid(updatedGrid);
  };

  const calculateDistance = () => {
    const startCell = grid.flat().find(cell => cell && cell.name === startName);
    const endCell = grid.flat().find(cell => cell && cell.name === endName);

    console.log('Start Cell:', startCell);
    console.log('End Cell:', endCell);

    if (startCell && endCell) {
      const dx = startCell.latitude - endCell.latitude;
      const dy = startCell.longitude - endCell.longitude;
      const dist = Math.sqrt(dx * dx + dy * dy);
      console.log('Distance:', dist);
      setDistance(dist);
    } else {
      alert('One or both of the cell names are invalid.');
    }
  };

  const findBestPath = () => {
    const startCell = grid.flat().find(cell => cell && cell.name === startName);
    const endCell = grid.flat().find(cell => cell && cell.name === endName);

    console.log('Start Cell:', startCell);
    console.log('End Cell:', endCell);

    if (startCell && endCell) {
      const bestPath = aStarAlgorithm(grid, startCell, endCell);
      console.log('Best Path:', bestPath);
      setPath(bestPath);
    } else {
      alert('One or both of the cell names are invalid.');
    }
  };

  useEffect(() => {
    console.log('Updated Distance:', distance);
  }, [distance]);

  useEffect(() => {
    console.log('Updated Path:', path);
  }, [path]);

  return (
    <div className="grid-component">
      <h1>Grid Map</h1>
      <div>
        <label className="label-black">
          Rows:
          <input type="number" value={rows} onChange={(e) => setRows(parseInt(e.target.value, 10))} />
        </label>
        <label className="label-black">
          Columns:
          <input type="number" value={cols} onChange={(e) => setCols(parseInt(e.target.value, 10))} />
        </label>
        <label className="label-black">
          Cell Size:
          <input type="number" step="0.1" value={cellSize} onChange={(e) => setCellSize(parseFloat(e.target.value))} />
        </label>
        <label className="label-black">
          Start Latitude:
          <input type="number" step="0.0001" value={startLatitude} onChange={(e) => setStartLatitude(parseFloat(e.target.value))} />
        </label>
        <label className="label-black">
          Start Longitude:
          <input type="number" step="0.0001" value={startLongitude} onChange={(e) => setStartLongitude(parseFloat(e.target.value))} />
        </label>
      </div>
      <button onClick={createGrid}>Create Grid</button>
      <button onClick={saveGridToFirebase} disabled={loading}>Save Grid to Firebase</button>
      <button onClick={retrieveGridFromFirebase} disabled={loading}>Retrieve Grid from Firebase</button>
      <div>
        <label className="label-black">
          Start Cell Name:
          <input type="text" value={startName} onChange={(e) => setStartName(e.target.value)} />
        </label>
        <label className="label-black">
          End Cell Name:
          <input type="text" value={endName} onChange={(e) => setEndName(e.target.value)} />
        </label>
        <button onClick={calculateDistance}>Calculate Distance</button>
        <button onClick={findBestPath}>Find Best Path</button>
        {distance !== null && <div style={{ color: 'red' }}>Distance: {distance.toFixed(4)} units</div>}
      </div>
      {grid && (
        <div className="grid-container">
          {grid.map((row, rowIndex) => (
            <div key={rowIndex} className="grid-row">
              {row.map((cell, cellIndex) => {
                const isPathCell = path && path.includes(cell);
                return cell ? (
                  <GridCellCard
                    key={cellIndex}
                    cell={cell}
                    onCellEdit={handleCellEdit}
                    className={isPathCell ? 'path-cell' : ''}
                  />
                ) : (
                  <div key={cellIndex} className="grid-cell-empty" />
                );
              })}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default GridComponent;
