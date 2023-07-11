import 'package:aft/ATESTS/utils/global_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class AutomateProvider extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> saveInitialScore(String score) async {
    final int? s = int.tryParse(score);
    if(s == null) return;
    final initialScoreRef = database.ref(RealTimeDBValues.initialScore);
       await initialScoreRef.set({'initialScore': s});
  }

  Future<void> addAdminUserToDb(User user) async {
    final userRef = database.ref(RealTimeDBValues.admins);
    if(user.admin) {
      userRef.ref.child(user.UID).set(user);
    }
  }
}