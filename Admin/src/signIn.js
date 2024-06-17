// src/SignIn.js
import React, { useState } from 'react';
import { Form, Button, Card } from 'react-bootstrap';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { auth } from './firebaseConfig'; // Ensure this import is correct
import { useNavigate } from 'react-router-dom'; // Import useNavigate
import './App.css'; // Import CSS file for styling

const SignIn = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);
  const navigate = useNavigate(); // Get the navigate function

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      console.log('User signed in successfully:', userCredential);
      navigate('/'); // Redirect to the home page
    } catch (error) {
      console.error('Error signing in:', error);
      setError(error.message); // Set error message for UI display
    }
  };

  return (
    <div className="d-flex align-items-center justify-content-center vh-100">
      <Card className="shadow p-4" style={{ width: '100%', maxWidth: '500px' }}>
        <Card.Body>
          <h2 className="text-center">Sign In</h2>
          <Form onSubmit={handleSubmit}>
            <Form.Group controlId="formEmail">
              <Form.Label>Email address</Form.Label>
              <Form.Control
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Enter email"
              />
            </Form.Group>
            <Form.Group controlId="formPassword" className="mt-3">
              <Form.Label>Password</Form.Label>
              <Form.Control
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Password"
              />
            </Form.Group>
            {error && <p className="text-danger mt-3">{error}</p>}
            <Button variant="primary" type="submit" className="mt-4 w-100">
              Sign In
            </Button>
          </Form>
        </Card.Body>
      </Card>
    </div>
  );
};

export default SignIn;
