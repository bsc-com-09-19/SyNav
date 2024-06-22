import React, { useState } from 'react';
import { Form, Button, Card } from 'react-bootstrap';
import { firestore } from './firebaseConfig';
import { collection, addDoc } from 'firebase/firestore';
import './App.css';



/**
 * Add component provides a form to add a new access point to Firebase.
 *
 * @component
 */
const Add = () => {
  /**
   * State to manage the form data.
   * @type {[{SSID: string, BSSID: string, xCoordinate: string, yCoordinate: string}, function]}
   */
  const [form, setForm] = useState({ SSID: '', BSSID: '', xCoordinate: '', yCoordinate: '' });
/**
   * Handles the change event for the form inputs.
   *
   * @param {Object} e - The event object.
   */
  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };
   /**
   * Handles the form submission.
   *
   * @param {Object} e - The event object.
   */

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      await addDoc(collection(firestore, 'AccessPoints'), form);
      console.log('Item added successfully!');
      // Clear the form after successful submission
      setForm({ SSID: '', BSSID: '', xCoordinate: '', yCoordinate: '' });
    } catch (error) {
      console.error('Error adding item:', error.message);
      alert(`An error occurred: ${error.message}`);
    }
  };

  return (
    <div className="d-flex align-items-center justify-content-center vh-100">
      <Card className="shadow p-4" style={{ width: '100%', maxWidth: '500px' }}>
        <Card.Body>
          <h2 className="text-center">Add Access Point</h2>
          <Form onSubmit={handleSubmit}>
            <Form.Group controlId="formSSID">
              <Form.Label>Name</Form.Label>
              <Form.Control
                type="text"
                name="SSID"
                value={form.SSID}
                onChange={handleChange}
                placeholder="Enter access point SSID"
              />
            </Form.Group>

            <Form.Group controlId="formBSSID" className="mt-3">
              <Form.Label>MAC Address</Form.Label>
              <Form.Control
                type="text"
                name="BSSID"
                value={form.BSSID}
                onChange={handleChange}
                placeholder="Enter access point MAC address"
              />
            </Form.Group>

            <Form.Group controlId="formXCoordinate" className="mt-3">
              <Form.Label>x-Coordinate</Form.Label>
              <Form.Control
                type="text"
                name="xCoordinate"
                value={form.xCoordinate}
                onChange={handleChange}
              />
            </Form.Group>

            <Form.Group controlId="formYCoordinate" className="mt-3">
              <Form.Label>y-Coordinate</Form.Label>
              <Form.Control
                type="text"
                name="yCoordinate"
                value={form.yCoordinate}
                onChange={handleChange}
              />
            </Form.Group>

            <Button variant="primary" type="submit" className="mt-4 w-100">
              Add
            </Button>
          </Form>
        </Card.Body>
      </Card>
    </div>
  );
};

export default Add;
