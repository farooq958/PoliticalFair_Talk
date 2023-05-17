import 'package:aft/ATESTS/provider/postPoll_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/keywords.dart';
import '../utils/global_variables.dart';

class CreatePageProvider extends ChangeNotifier {
  bool showTrendingMessage = false;
  bool showTrendingPoll = false;
  List<Keyword> list = [];
  int postKeywordListCount = 0;
  bool postKeywordLast = false;
  bool Loading = false;
  int paginationNumber = 10;

  QuerySnapshot<Map<String, dynamic>>? _postKeywordListSnapshot;
  final _postPollProvider = Provider.of<PostPollProvider>(
      navigatorKey.currentContext!,
      listen: false);

  Future<void> getkeywordList(String global, String countryCode, durationInDay,
      {bool? getNextList1}) async {
    debugPrint("durations $durationInDay");
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      list.clear();

      querySnapshot.docs.forEach((element) {
        Keyword dataIn =
            Keyword.fromMap(element.data() as Map<String, dynamic>);

        list.add(dataIn);
      });
    }

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      // durationInDay = await DurationProvider.getDurationInDays();

      // FirebaseFirestore.instance
      //     .collection('keywords')
      //     .doc(durationInDay)
      //     .collection('globalPosts')
      //     .get()
      //     .then((value) {
      //   debugPrint("keyword working ");
      //   for (var i in value.docs) {
      //     debugPrint("keyword working ${i}");
      //   }
      // });

      var query1 = (global == "true"
          // ? FirebaseFirestore.instance.collectionGroup('globallyPost')
          ? FirebaseFirestore.instance
              .collection('keywords')
              .doc('$durationInDay')
              .collection('globalPosts')
          : FirebaseFirestore.instance
              .collection('keywordsByCountry')
              .doc('$durationInDay')
              .collection('countryByPosts')
              .where("country", isEqualTo: countryCode));
      // .where("lastDay", isEqualTo: durationInDay)

      //  .where("global", isEqualTo: global)
      //   .orderBy("length", descending: true);
      debugPrint("query1 working");

      var snap = await query1.count().get();
      debugPrint("query1 $snap");
      // var snap = twoValue == "All Days"
      //     ? await query1.count().get()
      //     : await query.count().get();
      if (getNextList1 != null) {
        if (getNextList1) {
          postKeywordListCount += 1;
          // if (twoValue == "All Days") {
          await query1
              .startAfterDocument(_postKeywordListSnapshot!.docs.last)
              .limit(paginationNumber)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _postKeywordListSnapshot = await query1
              .startAfterDocument(_postKeywordListSnapshot!.docs.last)
              .limit(paginationNumber)
              .get();
        } else {
          postKeywordListCount -= 1;
          await query1
              .endBeforeDocument(_postKeywordListSnapshot!.docs.first)
              .limitToLast(paginationNumber)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _postKeywordListSnapshot = await query1
              .endBeforeDocument(_postKeywordListSnapshot!.docs.first)
              .limitToLast(paginationNumber)
              .get();
        }
      } else {
        postKeywordListCount = 1;
        // if (twoValue == "All Days") {
        await query1.limit(paginationNumber).get().then(
            (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));
        _postKeywordListSnapshot = await query1.limit(paginationNumber).get();
      }
      postKeywordLast = false;
      // debugPrint(
      //     "_postKeywordListSnapshot!.docs.length ll $postKeywordLast ${_postKeywordListSnapshot!.docs.length}");
      if (_postKeywordListSnapshot!.docs.length < paginationNumber ||
          paginationNumber * postKeywordListCount == snap.count) {
        postKeywordLast = true;
      }
      // debugPrint("Post Keyword Last ---- : $postKeywordLast");
      Loading = false;
    } catch (e) {
      // print("Got Error While Trying to fetch posts Keywords listing ::: $st");
    } finally {
      notifyListeners();
    }
  }

  setShowTrendingMessage(bool value) async {
    showTrendingMessage = value;
    notifyListeners();
  }

  setShowTrendingPoll(bool value) async {
    showTrendingPoll = value;
    notifyListeners();
  }

  List<Keyword> listPoll = [];

  int pollKeywordListCount = 0;
  bool pollKeywordLast = false;
  QuerySnapshot<Map<String, dynamic>>? _pollKeywordListSnapshot;
  Future<void> getpollKeywordList(
      String global, String countryCode, durationInDay,
      {bool? getNextListPoll}) async {
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      // var datalist = querySnapshot.docs;

      listPoll.clear();
      querySnapshot.docs.forEach((element) {
        Keyword dataIn =
            Keyword.fromMap(element.data() as Map<String, dynamic>);
        listPoll.add(dataIn);
      });
    }

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      // durationInDay = await DurationProvider.getDurationInDays();
      var query1 = (global == "true"
          ? FirebaseFirestore.instance
              .collection('keywords')
              .doc('$durationInDay')
              .collection('globalPolls')
          : FirebaseFirestore.instance
              .collection('keywordsByCountry')
              .doc('$durationInDay')
              .collection('countryByPolls')
              .where("country", isEqualTo: countryCode));
      var snap = await query1.count().get();
      // var snap = twoValue == "All Days"
      //     ? await query.count().get()
      //     : await query1.count().get();
      if (getNextListPoll != null) {
        if (getNextListPoll) {
          pollKeywordListCount += 1;
          // if (twoValue == "All Days") {
          query1
              .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
              .limit(paginationNumber)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _pollKeywordListSnapshot = await query1
              .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
              .limit(paginationNumber)
              .get();
          // }
          // else {
          //   query
          //       .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
          //       .limit(6)
          //       .get()
          //       .then((QuerySnapshot querySnapshot) =>
          //           handleQueryResult(querySnapshot));
          //   _pollKeywordListSnapshot = await query
          //       .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
          //       .limit(6)
          //       .get();
          // }
        } else {
          pollKeywordListCount -= 1;
          // if (twoValue == "All Days") {
          await query1
              .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
              .limitToLast(paginationNumber)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _pollKeywordListSnapshot = await query1
              .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
              .limitToLast(paginationNumber)
              .get();
          // }
          // else {
          //   await query
          //       .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
          //       .limitToLast(6)
          //       .get()
          //       .then((QuerySnapshot querySnapshot) =>
          //           handleQueryResult(querySnapshot));
          //   _pollKeywordListSnapshot = await query
          //       .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
          //       .limitToLast(6)
          //       .get();
          // }
        }
      } else {
        pollKeywordListCount = 1;
        // if (twoValue == "All Days") {
        await query1.limit(paginationNumber).get().then(
            (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));
        _pollKeywordListSnapshot = await query1.limit(paginationNumber).get();
        // }
        // else {
        //   await query.limit(6).get().then((QuerySnapshot querySnapshot) =>
        //       handleQueryResult(querySnapshot));
        //   _pollKeywordListSnapshot = await query.limit(6).get();
        // }
      }
      pollKeywordLast = false;
      // debugPrint(
      //     "_postKeywordListSnapshot!.docs.length ${_postKeywordListSnapshot!.docs.length}");
      if (_pollKeywordListSnapshot!.docs.length < paginationNumber ||
          paginationNumber * pollKeywordListCount == snap.count) {
        pollKeywordLast = true;
      }
      // debugPrint("poll Keyword Last : $pollKeywordLast");
      Loading = false;
      notifyListeners();
      // setState(() {});
    } catch (e) {
      // print("Got Error While Trying to fetch posts Keywords listing ::: $st");
    }
  }
}
