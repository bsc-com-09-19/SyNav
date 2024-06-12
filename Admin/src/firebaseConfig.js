// firebaseConfig.js
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
    apiKey: "AIzaSyAOMPApcX-o4JY1S4riDEzj1J-vyPkrmhE",
    authDomain: "myapp-230eb.firebaseapp.com",
    databaseURL: "https://myapp-230eb-default-rtdb.firebaseio.com",
    projectId: "myapp-230eb",
    storageBucket: "myapp-230eb.appspot.com",
    messagingSenderId: "238202045982",
    appId: "1:238202045982:web:71ba01092b85315ec3d00f"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase Authentication and get a reference to the service
const auth = getAuth(app);

// Initialize Cloud Firestore and get a reference to the service
const firestore = getFirestore(app);

export { auth, firestore };
