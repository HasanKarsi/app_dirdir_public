import 'package:app_dirdir/Locator.dart';
import 'package:app_dirdir/ViewModel/UserViewModel.dart';
import 'package:app_dirdir/App/LandingPage.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Firebase imports removed for public repository
// To use Firebase features, add these imports:
// import 'package:app_dirdir/FireBaseOptions/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Firebase background message handler removed for public repository
// To enable Firebase messaging, uncomment and implement:
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("📱 Background message received: ${message.messageId}");
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization removed for public repository
  // To enable Firebase, uncomment the following code:
  /*
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // FCM background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // FCM permissions
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('📱 FCM permission status: ${settings.authorizationStatus}');
    debugPrint("Firebase connection successful ✅");
  } catch (e) {
    debugPrint("❌ Firebase connection failed: $e");
  }
  */

  setupLocator();

  // Navigator key for LocalNotificationService removed for public repository
  // To enable notifications, uncomment:
  // LocalNotificationService.setNavigatorKey(navigatorKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'DIRDIR',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppConstants.primaryGreen,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryGreen,
            primary: AppConstants.primaryGreen,
            secondary: AppConstants.lightYellow,
            surface: AppConstants.white,
            background: AppConstants.lightGrey,
            onPrimary: AppConstants.white,
            onSecondary: AppConstants.darkGreen,
            onSurface: AppConstants.black,
            onBackground: AppConstants.black,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstants.primaryGreen,
            foregroundColor: AppConstants.white,
            elevation: 0,
          ),
          scaffoldBackgroundColor: AppConstants.lightGrey,
          useMaterial3: true, // Modern Material Design
        ),
        home: LandingPage(),
        // Performance optimizations
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
