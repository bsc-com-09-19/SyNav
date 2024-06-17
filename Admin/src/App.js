// src/App.js
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from './firebaseConfig';
import CustomNavbar from './Navbar'; // Ensure the correct path to the Navbar component
import Home from './Home';
import Add from './Add';
import Update from './Update';
import SignIn from './signIn';
import Logout from './Logout';
import GridComponent from './GridComponent';

const App = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setIsAuthenticated(!!user);
    });

    return () => unsubscribe();
  }, []);

  return (
    <Router>
      <CustomNavbar isAuthenticated={isAuthenticated} /> {/* Pass auth state */}
      <div className="container mt-4">
        <Routes>
          <Route path="/" exact element={isAuthenticated ? <Home /> : <SignIn />} />
          <Route path="/add" element={<Add />} />
          <Route path="/update/:id" element={<Update />} />
          <Route path="/signin" element={<SignIn />} />
          <Route path="/logout" element={<Logout />} />
          <Route path="/gride" element={<GridComponent />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
