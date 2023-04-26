import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserListProvider extends ChangeNotifier {
  List<User> searchUserList = [];
  int userListingListCount = 0;
  int count = 0;
  bool userListingLast = true;
  int paginationLength = 15;
  bool Loading = false;
  bool firstLoading = true;
  QuerySnapshot<Map<String, dynamic>>? _userListSnapshot;
  Future<void> getUserListing(String searchText, {bool? getNextList}) async {
    var query = FirebaseFirestore.instance
        .collection('users')
        .where('userReportCounter', whereIn: [0, 1, 2])
        // .orderBy('userReportCounter')
        .orderBy(
          'usernameLower',
        )
        .startAt([searchText.toLowerCase()])
        .endAt(['${searchText.toLowerCase()}\uf8ff']);

    void handleQueryResult(QuerySnapshot querySnapshot) {
      getNextList == true ? null : searchUserList.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        searchUserList.add(User.fromSnap(querySnapshot.docs[i]));
      }
    }

    try {
      // print("firstLoading-->  $firstLoading");

      var snap = await query.count().get();
      if (getNextList != null) {
        if (getNextList) {
          userListingListCount += 1;
          // count += 1;
          query
              .startAfterDocument(_userListSnapshot!.docs.last)
              .limit(paginationLength)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _userListSnapshot = await query
              .startAfterDocument(_userListSnapshot!.docs.last)
              .limit(paginationLength)
              .get();
        } else {
          userListingListCount -= 1;
          // count -= 1;
          await query
              .endBeforeDocument(_userListSnapshot!.docs.first)
              .limitToLast(paginationLength)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _userListSnapshot = await query
              .endBeforeDocument(_userListSnapshot!.docs.first)
              .limitToLast(paginationLength)
              .get();
        }
      } else {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();

        userListingListCount = 1;
        // firstLoading == false;
        //
        await query.limit(paginationLength).get().then(
            (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));
        _userListSnapshot = await query.limit(paginationLength).get();
      }
      if (_userListSnapshot!.docs.length < paginationLength ||
          paginationLength * userListingListCount == snap.count) {
        userListingLast = true;
      } else {
        userListingLast = false;
      }

      Loading = false;
      notifyListeners();
    } catch (e) {
      // print("Got Error While Trying to fetch user listing ::: $st");
    }
  }
}
