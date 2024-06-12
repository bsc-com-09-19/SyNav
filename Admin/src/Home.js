import React, { useState, useEffect } from 'react';
import { Table, Button } from 'react-bootstrap';
import { firestore } from './firebaseConfig';
import { collection, getDocs, deleteDoc, doc } from 'firebase/firestore';
import { Link, useNavigate } from 'react-router-dom';

const Home = () => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const querySnapshot = await getDocs(collection(firestore, 'accessPoints'));
        const fetchedData = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setData(fetchedData);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const handleDelete = async (id) => {
    try {
      await deleteDoc(doc(firestore, 'accessPoints', id));
      setData(data.filter(item => item.id !== id));
      console.log('Item deleted successfully!');
    } catch (error) {
      console.error('Error deleting item:', error);
      alert('An error occurred. Please try again later.');
    }
  };

  return (
    <div>
      <h2>Access Points</h2>
      {loading ? (
        <p>Loading data...</p>
      ) : data.length > 0 ? (
        <>
          <Table striped bordered hover>
            <thead>
              <tr>
                <th>#</th>
                <th>Name</th>
                <th>MAC Address</th>
                <th>Coordinates</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {data.map((item, index) => (
                <tr key={item.id}>
                  <td>{index + 1}</td>
                  <td>{item.SSID}</td> {/* Changed 'name' to 'SSID' to match the form */}
                  <td>{item.BSSID}</td> {/* Changed 'mac' to 'BSSID' to match the form */}
                  <td>{`(${item.xCoordinate}, ${item.yCoordinate})`}</td> {/* Changed 'coordinates' to 'xCoordinate' and 'yCoordinate' */}
                  <td>
                    <Link to={`/update/${item.id}`}>Edit</Link>
                    <Button variant="danger" onClick={() => handleDelete(item.id)} style={{ marginLeft: '10px' }}>
                      Delete
                    </Button>
                  </td>
                </tr>
              ))}
            </tbody>
          </Table>
          <Button variant="primary" onClick={() => navigate('/add')}>
            Add New Access Point
          </Button>
        </>
      ) : (
        <p>No access points found.</p>
      )}
    </div>
  );
};

export default Home;
