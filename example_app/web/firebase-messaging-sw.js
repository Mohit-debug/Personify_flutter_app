importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

const firebaseConfig = {
    apiKey: "AIzaSyB7YFzgcfhEBkEVkJNuHp_B8lSQ6Ph-NtE",
    authDomain: "example-app-37bee.firebaseapp.com",
    projectId: "example-app-37bee",
    storageBucket: "example-app-37bee.appspot.com",
    messagingSenderId: "80340466304",
    appId: "1:80340466304:web:33707f9594d11a35410465"
};
  
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

self.addEventListener('push', (event) => {
  const options = {
    body: event.data.text(),
  };

  event.waitUntil(
    self.registration.showNotification('My Notification Title', options)
  );
});
