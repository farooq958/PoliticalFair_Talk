import 'dart:async';
import 'package:aft/ATESTS/methods/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aft/ATESTS/models/user.dart' as um;

import '../utils/utils.dart';

class UserReportProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _authMethods = AuthMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _userListener;
  UserReportProvider() {
    // debugPrint('started');
    if (_auth.currentUser != null) {
      _userListener = _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .snapshots()
          .listen((event) {
        if (event.data() != null) {
          // debugPrint('changes happening ${event.data()}');
          um.User user = um.User.fromMap(event.data()!);
          if (user.userReportCounter > 2) {
            _authMethods.signOut();
            goToLoginWithoutContext();
            stopObservingUser();
          }
        }
      });
    }
  }

  stopObservingUser() {
    _userListener?.cancel();
  }

  @override
  void dispose() {
    _userListener?.cancel();
    super.dispose();
  }
}
