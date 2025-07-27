// Firebase Options Template
// Copy this file and rename to firebase_options.dart
// Add your own Firebase configuration
// This is a template file for public repository

/*
To use Firebase in your project:

1. Install Firebase dependencies:
   Add these to pubspec.yaml dependencies:
   firebase_core: ^3.13.0
   firebase_auth: ^5.5.3
   firebase_messaging: ^15.2.9
   cloud_firestore: ^5.6.7
   firebase_storage: ^12.4.9

2. Create this file as firebase_options.dart with your actual Firebase config:

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY_HERE',
    appId: 'YOUR_APP_ID_HERE', 
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_HERE',
    projectId: 'YOUR_PROJECT_ID_HERE',
    storageBucket: 'YOUR_STORAGE_BUCKET_HERE',
  );
}

3. Add google-services.json to android/app/ directory
4. Uncomment Firebase code in main.dart and Locator.dart
5. Restore Firebase service files from your private repository
*/
