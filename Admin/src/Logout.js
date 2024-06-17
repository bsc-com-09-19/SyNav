// src/Logout.js
import React, { useEffect } from 'react';
import { signOut } from 'firebase/auth';
import { auth } from './firebaseConfig';
import { useNavigate } from 'react-router-dom';

const Logout = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const handleSignOut = async () => {
      await signOut(auth);
      navigate('/signin'); // Redirect to the sign-in page after logging out
    };

    handleSignOut();
  }, [navigate]);

  return null; // This component does not render anything
};

export default Logout;
