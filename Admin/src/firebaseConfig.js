import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

import { getFirestore, collection, addDoc, getDocs } from "firebase/firestore";

/**
 * The Firebase configuration object containing the keys and identifiers for your app.
 * @constant {Object}
 */
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

/**
 * Initializes the Firebase application with the provided configuration.
 * @function
 * @returns {FirebaseApp} The initialized Firebase app.
 */
const app = initializeApp(firebaseConfig);
/**
 * Initializes Firebase Authentication and gets a reference to the service.
 * @function
 * @param {FirebaseApp} app - The initialized Firebase app.
 * @returns {Auth} The Firebase Authentication service.
 */

// Initialize Firebase Authentication and get a reference to the service
const auth = getAuth(app);

/**
 * Initializes Cloud Firestore and gets a reference to the service.
 * @function
 * @param {FirebaseApp} app - The initialized Firebase app.
 * @returns {Firestore} The Firestore service.
 */

// Initialize Cloud Firestore and get a reference to the service
const firestore = getFirestore(app);




export { firestore, collection, addDoc, getDocs ,auth};