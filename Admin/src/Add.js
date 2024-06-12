import React, { useState } from 'react';
import { Form, Button } from 'react-bootstrap';
import { firestore } from './firebaseConfig';
import { collection, addDoc } from 'firebase/firestore'; // Import necessary Firestore methods

const Add = () => {
  const [form, setForm] = useState({ SSID: '', BSSID: '', xCoordinate: '', yCoordinate: '' });

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      await addDoc(collection(firestore, 'accessPoints'), form);
      console.log('Item added successfully!');
      // Handle successful submission (e.g., redirect or update UI)
    } catch (error) {
      console.error('Error adding item:', error);
      alert('An error occurred. Please try again later.');
    }
  };

  return (
    <div>
      <h2>Add Access Point</h2>
      <Form onSubmit={handleSubmit}>
        <Form.Group>
          <Form.Label>Name</Form.Label>
          <Form.Control
            type="text"
            name="SSID"
            value={form.SSID}
            onChange={handleChange}
            placeholder='Enter access point SSID'
          />
        </Form.Group>

        <Form.Group>
          <Form.Label>MAC Address</Form.Label>
          <Form.Control
            type="text"
            name="BSSID"
            value={form.BSSID}
            onChange={handleChange}
            placeholder='Enter access point MAC address'
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
          Add
        </Button>
      </Form>
    </div>
  );
};

export default Add;
