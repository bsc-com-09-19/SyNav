import React, { useState } from 'react';
import { Form, Button } from 'react-bootstrap';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { auth } from './firebaseConfig'; // Assuming firebaseConfig.js is in the same directory

const SignIn = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      console.log('User signed in successfully:', userCredential);
      // Handle successful sign-in (e.g., redirect or update UI)
    } catch (error) {
      console.error('Error signing in:', error);
      setError(error.message); // Set error message for UI display
    }
  };

  return (
    <div>
      <h2>Sign In</h2>
      <Form onSubmit={handleSubmit}>
        <Form.Group>
          <Form.Label>Email address</Form.Label>
          <Form.Control
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter email"
          />
        </Form.Group>
        <Form.Group>
          <Form.Label>Password</Form.Label>
          <Form.Control
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Password"
          />
        </Form.Group>
        {error && <p className="text-danger">{error}</p>}
        <Button variant="primary" type="submit">
          Sign In
        </Button>
      </Form>
    </div>
  );
};

export default SignIn;
