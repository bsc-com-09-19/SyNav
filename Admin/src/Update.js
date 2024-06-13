import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Form, Button } from 'react-bootstrap';
import { firestore } from './firebaseConfig';
import { doc, getDoc, updateDoc } from 'firebase/firestore'; // Import necessary Firestore methods

const Update = () => {
  const { id } = useParams();
  const [form, setForm] = useState({ SSID: '', BSSID: '', xCoordinate: '', yCoordinate: '' });
  const [error, setError] = useState(null); // State for error handling (optional)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const docRef = doc(firestore, 'accessPoints', id);
        const docSnap = await getDoc(docRef);
        if (docSnap.exists()) {
          setForm(docSnap.data());
        } else {
          setError('Item not found'); // Handle item not found scenario
        }
      } catch (error) {
        console.error('Error fetching item data:', error);
        setError('An error occurred. Please try again later.'); // Handle error
      }
    };

    fetchData();
  }, [id]); // Dependency array to run on id change

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const docRef = doc(firestore, 'accessPoints', id);
      await updateDoc(docRef, form);
      console.log('Item updated successfully!');
      // Handle successful update (e.g., redirect or show confirmation)
    } catch (error) {
      console.error('Error updating item:', error);
      setError('An error occurred. Please try again later.'); // Handle error
    }
  };

  return (
    <div>
      <h2>Update Item</h2>
      {error ? (
        <p className="text-danger">{error}</p>
      ) : (
        <Form onSubmit={handleSubmit}>
          <Form.Group>
            <Form.Label>Name</Form.Label>
            <Form.Control
              type="text"
              name="SSID"
              value={form.SSID}
              onChange={handleChange}
            />
          </Form.Group>
          <Form.Group>
            <Form.Label>MAC Address</Form.Label>
            <Form.Control
              type="text"
              name="BSSID"
              value={form.BSSID}
              onChange={handleChange}
            />
          </Form.Group>
          <Form.Group>
            <Form.Label>x-Coordinate</Form.Label>
            <Form.Control
              type="text"
              name="xCoordinate"
              value={form.xCoordinate}
              onChange={handleChange}
            />
          </Form.Group>
          <Form.Group>
            <Form.Label>y-Coordinate</Form.Label>
            <Form.Control
              type="text"
              name="yCoordinate"
              value={form.yCoordinate}
              onChange={handleChange}
            />
          </Form.Group>
          <Button variant="primary" type="submit">
            Update
          </Button>
        </Form>
      )}
    </div>
  );
};

export default Update;
