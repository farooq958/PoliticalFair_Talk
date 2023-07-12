import 'package:flutter/material.dart';

import '../../main.dart';

const webScreenSize = 800;

loadPref() async {
  await MyApp.init();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const Color lightGrey = Color(0xffEAEAEA);

const Color gW = Color.fromARGB(255, 245, 245, 245);

const Color cardBottom = Color.fromARGB(255, 0, 0, 0);

String version = '1.0.1';
String year = '2023';
String email = 'contact@fairtalk.net';

const Color testing = Color.fromARGB(255, 245, 245, 245);

// const Color darkBlue = darkBlue;
// const Color darkBlue = Color.fromARGB(255, 43, 61, 83);
const Color darkBlue = Color.fromARGB(255, 0, 54, 120);

const Color whiteDialog = Color.fromARGB(255, 255, 255, 255);
// const Color testColor = Color.fromARGB(255, 0, 91, 202);
const Color testColor = Color.fromARGB(255, 0, 97, 216);
const Color testColor2 = Color.fromARGB(255, 26, 91, 172);

class FirestoreValues {
  static const String userCollection = 'users';
}

String twoValue1H = 'selected_radio1Home';
String twoValue11 = 'selected_radio1Search';


/// Firebase real time db constants
class RealTimeDBValues {
  static const automateAdminDbUrl = 'https://aft-flutter-admin.firebaseio.com';
  static const String initialScore = 'initialScore';
  static const String admins = 'admins';

}
