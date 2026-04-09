// firebase-messaging-sw.js
// Service Worker for FCM background push notifications in Chrome / Edge.
//
// IMPORTANT: After running `flutterfire configure`, copy the web config values
// from lib/firebase_options.dart (the `web` entry) into this file below.
// Both this file AND firebase_options.dart must have the SAME project values.

importScripts(
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js',
  'https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js',
);

// Replace these with your real Firebase project values (same as firebase_options.dart → web)
firebase.initializeApp({
  apiKey:            'REPLACE_WITH_YOUR_WEB_API_KEY',
  appId:             'REPLACE_WITH_YOUR_WEB_APP_ID',
  messagingSenderId: 'REPLACE_WITH_YOUR_SENDER_ID',
  projectId:         'REPLACE_WITH_YOUR_PROJECT_ID',
  storageBucket:     'REPLACE_WITH_YOUR_PROJECT_ID.appspot.com',
});

const messaging = firebase.messaging();

// Handles notifications when the browser tab is closed or not focused.
messaging.onBackgroundMessage((payload) => {
  const { title, body, image } = payload.notification ?? {};
  if (title) {
    self.registration.showNotification(title, {
      body:  body  ?? '',
      icon:  '/favicon.png',
      image: image ?? undefined,
      badge: '/favicon.png',
      tag:   'manninsuvai-notification',
    });
  }
});
