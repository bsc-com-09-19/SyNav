import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

import { getFirestore, collection, addDoc, getDocs } from "firebase/firestore";
const firebaseConfig = {
  apiKey: "AIzaSyC_WC9AmvUEYZ_4STk8CocQq9YI5LMuvT0",
  authDomain: "my-applic345-22ad3.firebaseapp.com",
  projectId: "my-applic345-22ad3",
  storageBucket: "my-applic345-22ad3.appspot.com",
  messagingSenderId: "1072500702130",
  appId: "1:1072500702130:web:d97b6637eed2e4db6e02ab"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase Authentication and get a reference to the service
const auth = getAuth(app);

// Initialize Cloud Firestore and get a reference to the service
const firestore = getFirestore(app);




export { firestore, collection, addDoc, getDocs ,auth};