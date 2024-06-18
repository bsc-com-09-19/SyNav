import React, { useState } from 'react';
import './GridCellCard.css';

const GridCellCard = ({ cell, onCellEdit, className }) => {
  const [name, setName] = useState(cell.name);
  const [isObstacle, setIsObstacle] = useState(cell.isObstacle);
  const [isEditing, setIsEditing] = useState(false);

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
    <div className={`grid-cell-card ${isObstacle ? 'obstacle' : ''} ${className}`}>
      {isEditing ? (
        <>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Name"
            className="grid-cell-input"
          />
          <label className="grid-cell-checkbox">
            Obstacle:
            <input
              type="checkbox"
              checked={isObstacle}
              onChange={(e) => setIsObstacle(e.target.checked)}
            />
          </label>
          <div className="grid-cell-buttons">
            <button onClick={handleSave} className="grid-cell-save">Save</button>
            <button onClick={handleCancel} className="grid-cell-cancel">Cancel</button>
          </div>
        </>
      ) : (
        <div onClick={() => setIsEditing(true)}>
          <div>{name}</div>
          <div>{isObstacle ? 'Obstacle' : 'Passable'}</div>
        </div>
      )}
    </div>
  );
};

export default GridCellCard;
