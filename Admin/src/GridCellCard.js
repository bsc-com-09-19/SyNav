import React, { useState } from 'react';

const GridCellCard = ({ cell, onCellEdit }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [name, setName] = useState(cell.name);
  const [isObstacle, setIsObstacle] = useState(cell.isObstacle);

  const handleSave = () => {
    onCellEdit(cell, name, isObstacle);
    setIsEditing(false);
  };

  const handleCancel = () => {
    setName(cell.name);
    setIsObstacle(cell.isObstacle);
    setIsEditing(false);
  };

  return (
    <div className="grid-cell">
      {isEditing ? (
        <div>
          <label>
            Name:
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
          </label>
          <label>
            Is Obstacle:
            <input
              type="checkbox"
              checked={isObstacle}
              onChange={(e) => setIsObstacle(e.target.checked)}
            />
          </label>
          <div>
            <button onClick={handleSave}>Save</button>
            <button onClick={handleCancel}>Cancel</button>
          </div>
        </div>
      ) : (
        <div>
          <div>Cell Name: {cell.name}</div>
          <div>Coordinates: ({cell.latitude}, {cell.longitude})</div>
          <div>Is Obstacle: {cell.isObstacle ? 'True' : 'False'}</div>
          <button onClick={() => setIsEditing(true)}>Edit</button>
        </div>
      )}
    </div>
  );
};

export default GridCellCard;
