import 'package:aft/ATESTS/provider/automate_provider.dart';
import 'package:aft/ATESTS/provider/block_list_provider.dart';
import 'package:aft/ATESTS/provider/comments_replies_provider.dart';
import 'package:aft/ATESTS/provider/filter_provider.dart';
import 'package:aft/ATESTS/provider/google_sign_in.dart';
import 'package:aft/ATESTS/provider/most_liked_provider.dart';
import 'package:aft/ATESTS/provider/most_liked_key_provider.dart';
import 'package:aft/ATESTS/provider/poll_provider.dart';
import 'package:aft/ATESTS/provider/postPoll_provider.dart';
import 'package:aft/ATESTS/provider/post_provider.dart';
import 'package:aft/ATESTS/services/firebase_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ATESTS/provider/create_provider.dart';
import 'ATESTS/provider/search_userList.dart';
import 'ATESTS/provider/searchpage_provider.dart';
import 'ATESTS/provider/user_provider.dart';
import 'ATESTS/responsive/AMobileScreenLayout.dart';
import 'ATESTS/responsive/AResponsiveLayout.dart';
import 'ATESTS/responsive/AWebScreenLayout.dart';
import 'ATESTS/utils/global_variables.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC4ngM0ggQWrk2UieD8BYS84ZiXDzyR1oA",
          authDomain: "aft-flutter.firebaseapp.com",
          projectId: "aft-flutter",
          storageBucket: "aft-flutter.appspot.com",
          messagingSenderId: "424538767306",
          appId: "1:424538767306:web:bdbcc7892fbaa8cc9e9933"),
    );
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
  } else {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
  }

  final firebaseApp = Firebase.app();

  /// Notification setup
  await FirebaseNotification.grantNotificationPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseNotification.listenForegroundMessages();

  FirebaseNotification.setupLocalNotifications();

  FirebaseNotification.onBackgroundMessageTap();

  FirebaseNotification.onInitialMessageTap();

  /// Use firebase emulators
  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => FilterProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => PostProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => PollsProvider(),
    ),
    // ChangeNotifierProvider(
    //   create: (_) => LeftTimeProvider(),
    // ),
    ChangeNotifierProvider(
      create: (_) => BlockListProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => MostLikedProvider(),
    ),
    // ChangeNotifierProvider(
    //   create: (_) => PostPollProvider(),
    // ),
    ChangeNotifierProvider(
      create: (_) => CommentReplyProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => UserListProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => SearchPageProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CreatePageProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => MostLikedKeyProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => GoogleSignInProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => AutomateProvider(firebaseApp),
    ),

    // ChangeNotifierProvider(
    //   create: (_) => ChangeCountryProvider(),
    // ),
  ], child: const MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // debugPrint(
  //     'background message is ${message.data} ${message.notification?.toMap()}');
}

SharedPreferences? prefs;

class MyApp extends StatelessWidget {
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loadPref();
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ThemeData().colorScheme.copyWith(
              // primary: const darkBlue,
              primary: const Color.fromARGB(255, 70, 70, 70)),
        ),
        title: '0',
        home: const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ),
    );
  }
}

// DateTime dateEST = DateTime.now();

// Future<void> getDate() async {
//   try {
//     // Response response =
//     // await get(Uri.parse(
//     //     'https://us-central1-aft-flutter.cloudfunctions.net/getDateTime'));
//     //Map data = jsonDecode(response.body);

//     // String datetime = data['datetime'];
//     // String offset = data['utc_offset'];

//     // debugPrint('ntp date is $now');
//     // DateTime now = DateTime.parse(response.body);
//     // DateTime localdate = DateTime.parse(response.body).toLocal();

// // DateTime now = await NTP.now();
//     // dateEST = now;
//     dateEST = DateTime.now();
//   } catch (e) {
//     //
//   }
//   // debugPrint('Date from timer $datetime || $localdate  offset: $offset');
//
