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

  Future<void> saveInitialScore(String score) async {
    final int? s = int.tryParse(score);
    if (s == null) return;
    final initialScoreRef = database.ref(RealTimeDBValues.initialScore);
    await initialScoreRef.set({RealTimeDBValues.initialScore: s});
  }

  Future<void> addAdminUserToDb(User user) async {
    final userRef = database.ref(RealTimeDBValues.admins);
    debugPrint('saving admin ${user.toJson()}');
    if (user.admin) {
      userRef.ref.child(user.UID).set(user.toRTDBJson());
    }
  }

  int get initialScore => _initialScore;
}
