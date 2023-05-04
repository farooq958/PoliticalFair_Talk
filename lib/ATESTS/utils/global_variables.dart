import 'package:firebase_database/firebase_database.dart';

import '../../main.dart';

import 'package:flutter/material.dart';

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
String email = 'fairtalk.assist@gmail.com';

const Color whiteDialog = Color.fromARGB(255, 255, 255, 255);

const Color darkBlue = Color.fromARGB(255, 36, 64, 101);

class FirestoreValues {
  static const String userCollection = 'users';
}
