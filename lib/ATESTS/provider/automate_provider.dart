import 'package:aft/ATESTS/utils/global_variables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class AutomateProvider extends ChangeNotifier {
  AutomateProvider(FirebaseApp firebaseApp) {
    database = FirebaseDatabase.instanceFor(
        app: firebaseApp, databaseURL: RealTimeDBValues.automateAdminDbUrl);
  }

  late FirebaseDatabase database;
  int _initialScore = 0;
  String? _day;
  String? _global;
  String? _postType;

  Future<void> saveInitialScore(String score) async {
    final int? s = int.tryParse(score);
    if (s == null && _global != null && _day != null && _postType != null) {
      return;
    }
    final initialScoreRef = database.ref(RealTimeDBValues.initialScore);
    await initialScoreRef
        .child(_global!)
        .child(_postType!)
        .child(_day!)
        .set({RealTimeDBValues.initialScore: s});
  }

  Future<void> addAdminUserToDb(User user) async {
    final userRef = database.ref(RealTimeDBValues.admins);
    debugPrint('saving admin ${user.toJson()}');
    if (user.admin) {
      userRef.ref.child(user.UID).set(user.toRTDBJson());
    }
  }

  void setValues(
      {required bool global,
      required bool messages,
      required bool ca,
      required bool us,
      required bool one,
      required bool two,
      required bool three,
      required bool four,
      required bool five,
      required bool six,
      required bool seven}) {
    if (global) {
      _global = 'global';
    } else if (ca) {
      _global = 'ca';
    } else if (us) {
      _global = 'us';
    } else {
      _global = null;
    }
    if (one) {
      _day = '1';
    } else if (two) {
      _day = '2';
    } else if (three) {
      _day = '3';
    } else if (four) {
      _day = '4';
    } else if (five) {
      _day = '5';
    } else if (six) {
      _day = '6';
    } else if (seven) {
      _day = '7';
    } else {
      _day = null;
    }
    if (messages) {
      _postType = 'messages';
    } else if (!messages) {
      _postType = 'polls';
    } else {
      _postType = null;
    }
  }

  int get initialScore => _initialScore;

  String? get global => _global;
  String? get day => _day;
  String? get postType => _postType;
}
