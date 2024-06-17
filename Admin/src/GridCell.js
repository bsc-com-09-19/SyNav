import React, { useState } from 'react';

const GridCell = ({ cell, onCellEdit }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [editedName, setEditedName] = useState(cell.name);
  const [editedIsObstacle, setEditedIsObstacle] = useState(cell.isObstacle);

  const handleNameChange = (e) => {
    setEditedName(e.target.value);
  };

  const handleIsObstacleChange = (e) => {
    setEditedIsObstacle(e.target.checked);
  };

  const saveChanges = () => {
    onCellEdit(cell, editedName, editedIsObstacle);
    setIsEditing(false);
  };

  return (
    <div onClick={() => setIsEditing(true)}>
      {isEditing ? (
        <div>
          <input type="text" value={editedName} onChange={handleNameChange} />
          <label>
            Is Obstacle:
            <input type="checkbox" checked={editedIsObstacle} onChange={handleIsObstacleChange} />
          </label>
          <button onClick={saveChanges}>Save</button>
        </div>
      ) : (
        <div>
          <p>Cell Name: {cell.name}</p>
          <p>Coordinates: ({cell.row}, {cell.col})</p>
          <p>Is Obstacle: {cell.isObstacle ? 'true' : 'false'}</p>
        </div>
      )}
    </div>
  );
};

export default GridCell;
