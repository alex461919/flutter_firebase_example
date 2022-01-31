importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDWbELxOMeeYD8SyGpaVSJX0bJkKbPYl2E",
  authDomain: "test-firebase-project-44c66.firebaseapp.com",
  databaseURL: "https://test-firebase-project-44c66-default-rtdb.firebaseio.com",
  projectId: "test-firebase-project-44c66",
  storageBucket: "test-firebase-project-44c66.appspot.com",
  messagingSenderId: "664089236150",
  appId: "1:664089236150:web:a92e2f1414caef97ee8c17",
  measurementId: "G-HGYNPM96J8",
};

firebase.initializeApp(firebaseConfig);
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
