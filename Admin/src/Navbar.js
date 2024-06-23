import React from 'react';
import { Navbar, Nav } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';
import './App.css';

/**
 * CustomNavbar component provides a responsive navigation bar.
 *
 * @component
 * @param {Object} props - The component's props.
 * @param {boolean} props.isAuthenticated - Indicates if the user is authenticated.
 */
const CustomNavbar = ({ isAuthenticated }) => {
  return (
    <Navbar className="custom-navbar" variant="dark" expand="lg">
      <Navbar.Brand href="/">My App</Navbar.Brand>
      <Navbar.Toggle aria-controls="basic-navbar-nav" />
      <Navbar.Collapse id="basic-navbar-nav">
        <Nav className="ml-auto">
          {isAuthenticated ? (
            <>
              <LinkContainer to="/">
                <Nav.Link>Home</Nav.Link>
              </LinkContainer>
              <LinkContainer to="/gride">
                <Nav.Link>GridComponent</Nav.Link>
              </LinkContainer>
              <LinkContainer to="/add">
                <Nav.Link>Add</Nav.Link>
              </LinkContainer>
              <LinkContainer to="/logout">
                <Nav.Link>Logout</Nav.Link>
              </LinkContainer>
            </>
          ) : (
            <LinkContainer to="/signin">
              <Nav.Link>Sign In</Nav.Link>
            </LinkContainer>
          )}
        </Nav>
      </Navbar.Collapse>
    </Navbar>
  );
};

export default CustomNavbar;
