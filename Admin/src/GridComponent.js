import React, { useState } from 'react';
import Grid from './Grid';
import GridCellCard from './GridCellCard';
import { firestore, collection, addDoc, getDocs } from './firebaseConfig';
import './GridComponent.css';

const GridComponent = () => {
  const [rows, setRows] = useState(10); // Set default to 10 rows
  const [cols, setCols] = useState(10); // Set default to 10 columns
  const [cellSize, setCellSize] = useState(0.01);
  const [startLatitude, setStartLatitude] = useState(37.7749);
  const [startLongitude, setStartLongitude] = useState(-122.4194);
  const [grid, setGrid] = useState(null);
  const [loading, setLoading] = useState(false);

  const createGrid = () => {
    const newGrid = new Grid(rows, cols, cellSize, startLatitude, startLongitude);
    setGrid(newGrid.getGrid());
  };

  const saveGridToFirebase = async () => {
    if (!grid) return;

    setLoading(true);
    const gridCells = grid.flat();
    try {
      for (const cell of gridCells) {
        await addDoc(collection(firestore, 'gridCells'), { ...cell });
      }
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
      const querySnapshot = await getDocs(collection(firestore, 'gridCells'));
      const retrievedGrid = querySnapshot.docs.map(doc => doc.data());
      setGrid(retrievedGrid);
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
        c.row === cell.row && c.col === cell.col
          ? { ...c, name: newName, isObstacle: newIsObstacle }
          : c
      )
    );
    setGrid(updatedGrid);
  };

  return (
    <div>
      <h1>Grid Map</h1>
      <div>
        <label>
          Rows:
          <input type="number" value={rows} onChange={(e) => setRows(parseInt(e.target.value, 10))} />
        </label>
        <label>
          Columns:
          <input type="number" value={cols} onChange={(e) => setCols(parseInt(e.target.value, 10))} />
        </label>
        <label>
          Cell Size:
          <input type="number" step="0.001" value={cellSize} onChange={(e) => setCellSize(parseFloat(e.target.value))} />
        </label>
        <label>
          Start Latitude:
          <input type="number" step="0.0001" value={startLatitude} onChange={(e) => setStartLatitude(parseFloat(e.target.value))} />
        </label>
        <label>
          Start Longitude:
          <input type="number" step="0.0001" value={startLongitude} onChange={(e) => setStartLongitude(parseFloat(e.target.value))} />
        </label>
      </div>
      <button onClick={createGrid}>Create Grid</button>
      <button onClick={saveGridToFirebase} disabled={loading}>Save Grid to Firebase</button>
      <button onClick={retrieveGridFromFirebase} disabled={loading}>Retrieve Grid from Firebase</button>
      {grid && (
        <div className="grid-container">
          {grid.map((row, rowIndex) => (
            <div key={rowIndex} className="grid-row">
              {row.map((cell, cellIndex) => (
                <GridCellCard key={cellIndex} cell={cell} onCellEdit={handleCellEdit} />
              ))}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default GridComponent;
