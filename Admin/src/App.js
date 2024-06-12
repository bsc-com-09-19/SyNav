import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import CustomNavbar from './Navbar'; // Assuming the correct component name

import Home from './Home';
import Add from './Add';
import Update from './Update';
import SignUp from './signUp';
import SignIn from './signIn';

const App = () => {
  return (
    <Router>
      <CustomNavbar /> {/* Render the navbar at the top */}
      <div className="container mt-4">
        <Routes> {/* Use Routes instead of Switch for React Router v6 */}
          <Route path="/" exact element={<Home />} />
          <Route path="/add" element={<Add />} />
          <Route path="/update/:id" element={<Update />} />
          <Route path="/signup" element={<SignUp />} />
          <Route path="/signin" element={<SignIn />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;