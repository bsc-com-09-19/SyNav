// firebaseConfig.js
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
    apiKey: "AIzaSyA69iRhadZxTLAW_z7nm-dS7WYOsfE8lRo",
  authDomain: "sy-nav.firebaseapp.com",
  databaseURL: "https://sy-nav-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "sy-nav",
  storageBucket: "sy-nav.appspot.com",
  messagingSenderId: "674222803730",
  appId: "1:674222803730:web:80659d407334d92437c1cb",
  measurementId: "G-PPRNNTKZNR"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase Authentication and get a reference to the service
const auth = getAuth(app);

// Initialize Cloud Firestore and get a reference to the service
const firestore = getFirestore(app);

export { auth, firestore };
