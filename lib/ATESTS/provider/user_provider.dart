import 'dart:async';
import 'package:aft/ATESTS/services/firebase_notification.dart';
import 'package:aft/ATESTS/utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import '../methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserProvider() {
    refreshTokenAndTopic();
  }

  bool _fcmTopicLoading = false;

  final db = FirebaseFirestore.instance;
  User? _allUser;
  User? _user;

  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  User? get getAllUser => _allUser;

  Future<void> refreshUser() async {
    //User user = await _authMethods.getUserDetails();
    _user = await _authMethods.getUserDetails();
    notifyListeners();
  }

  Future<void> refreshAllUser(String uid) async {
    User? alluser = await _authMethods.getAllUserDetails(uid);
    _allUser = alluser;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _user = null;
    final GoogleSignIn googleSignIn=GoogleSignIn();
   await googleSignIn.signOut();
    notifyListeners();
  }

  Future<void> refreshTokenAndTopic() async {
    try {
      final fcmToken = await FirebaseNotification.getToken();
      final user = _authMethods.getCurrentUser();
      if (fcmToken != null && user != null) {
        // debugPrint('refreshTokenAndTopic passed');
        final userMap = (await db
            .collection(FirestoreValues.userCollection)
            .doc(user.uid)
            .get());
        final registeredFCMToken = userMap['fcmToken'];
        final topic = userMap['fcmTopic'].toString();
        String newTopic = '';
        // debugPrint('user registered fcm token $registeredFCMToken $topic');
        if (registeredFCMToken != fcmToken || topic.startsWith('n')) {
          await FirebaseNotification.unSubscribeTopic(topic);
          if (topic.startsWith('nm')) {
            newTopic = 'nm${userMap['aaCountry'].toString().toLowerCase()}';
            await FirebaseNotification.subscribeTopic(newTopic);
          } else if (topic.startsWith('np')) {
            newTopic = 'np${userMap['aaCountry'].toString().toLowerCase()}';
            await FirebaseNotification.subscribeTopic(newTopic);
          } else {
            newTopic = topic;
          }

          db
              .collection(FirestoreValues.userCollection)
              .doc(user.uid)
              .update({'fcmToken': fcmToken, 'fcmTopic': newTopic});
        }
      }
    } catch (e) {
      // debugPrint('updateFCMToken error $e $st');
    }
  }

  updateCountry(String country) async {
    await db.collection("users").doc(_user!.UID).update(
      {'aaCountry': country},
    ).then((value) => refreshUser());
  }

  subscribeTopic(String topic, User user) async {
    try {
      _fcmTopicLoading = true;
      notifyListeners();
      await Future.delayed(Duration.zero);
      if (user.fcmTopic != null && user.fcmTopic!.isNotEmpty) {
        await FirebaseNotification.unSubscribeTopic(user.fcmTopic!);
      }
      if (topic == 'nm' || topic == 'np') {
        topic = topic + user.aaCountry.toLowerCase();
      }

      await db
          .collection(FirestoreValues.userCollection)
          .doc(user.UID)
          .update({'fcmTopic': topic});
      await FirebaseNotification.subscribeTopic(topic);

      await refreshUser();
    } catch (e) {
      // debugPrint('error $e $st');
    } finally {
      _fcmTopicLoading = false;
    }
  }

  bool get fcmTopicLoading => _fcmTopicLoading;
}
