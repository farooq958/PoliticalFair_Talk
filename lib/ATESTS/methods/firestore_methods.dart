import 'package:aft/ATESTS/models/user.dart';
import 'package:aft/ATESTS/provider/most_liked_key_provider.dart';
import 'package:aft/ATESTS/provider/post_provider.dart';
import 'package:aft/ATESTS/utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/comment.dart';
import '../models/keywords.dart';
import '../models/poll.dart';
import '../models/post.dart';
import '../models/reply.dart';
import '../models/reportedBug.dart';
import '../models/submission.dart';
import '../provider/comments_replies_provider.dart';
import '../provider/poll_provider.dart';
import '../provider/searchpage_provider.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPoll(
    // ignore: non_constant_identifier_names
    String UID,
    String bUsername,
    String bProfImage,
    String country,
    String global,
    String aPollTitle,
    String bOption1,
    String bOption2,
    String bOption3,
    String bOption4,
    String bOption5,
    String bOption6,
    String bOption7,
    String bOption8,
    String bOption9,
    String bOption10,
    int time,
    int datePublishedCounter,
    List<String>? tagsLowerCase,
  ) async {
    String res = "Some error occurred.";

    var timeNow = await NTP.now();
    // var timeNow = DateTime.now();
    // var timeNow = dateEST;
    // String trimmedText = trimText(text: aPollTitle);

    try {
      String pollId = const Uuid().v1();

      Poll poll = Poll(
        pollId: pollId,
        UID: UID,
        votesUIDs: [],
        bUsername: bUsername,
        bProfImage: bProfImage,
        country: country,
        datePublished: datePublishedCounter,
        datePublishedNTP: timeNow,
        global: global,
        // endDate: timeNow.add(Duration(
        //   days: 6,
        //   hours: 23 - timeNow.hour,
        //   minutes: 59 - timeNow.minute,
        //   seconds: 59 - timeNow.second,
        //   // days: 0,
        //   // hours: 0,
        //   // minutes: 1,
        // )),
        aPollTitle: aPollTitle,
        bOption1: bOption1,
        bOption2: bOption2,
        bOption3: bOption3,
        bOption4: bOption4,
        bOption5: bOption5,
        bOption6: bOption6,
        bOption7: bOption7,
        bOption8: bOption8,
        bOption9: bOption9,
        bOption10: bOption10,
        vote1: [],
        vote2: [],
        vote3: [],
        vote4: [],
        vote5: [],
        vote6: [],
        vote7: [],
        vote8: [],
        vote9: [],
        vote10: [],
        voteCount1: 0,
        voteCount2: 0,
        voteCount3: 0,
        voteCount4: 0,
        voteCount5: 0,
        voteCount6: 0,
        voteCount7: 0,
        voteCount8: 0,
        voteCount9: 0,
        voteCount10: 0,
        totalVotes: 0,
        reportCounter: 0,
        commentCount: 0,
        reportChecked: false,
        reportRemoved: false,
        time: time,
        tagsLowerCase: tagsLowerCase,
      );

      _firestore.collection('polls').doc(pollId).set(
            poll.toJson(),
          );
      res = "success";
      addKeywords(pollId, UID, tagsLowerCase, country, global, "polls", time);
      postCounter('poll');
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void postCounter(String type) async {
    try {
      await _firestore
          .collection('postCounter')
          .doc(type == 'post'
              ? 'messageCounter'
              : type == 'poll'
                  ? 'pollCounter'
                  : type == 'comment'
                      ? 'commentCounter'
                      : type == 'user'
                          ? 'userCounter'
                          : 'verifiedCounter')
          .update({
        'counter': FieldValue.increment(1),
      });
    } catch (e) {
      // print(
    }
  }

  Future<String> poll({
    required Poll poll,
    required String uid,
    required int optionIndex,
  }) async {
    String res = "Some error occurred.";

    try {
      String pollId = poll.pollId;

      // ignore: unused_local_variable
      String pollUId = poll.UID;
      String country = poll.country;
      // var pollsProvider = Provider.of<PollsProvider>(
      //     navigatorKey.currentContext!,
      //     listen: false);
      if (poll.votesUIDs.contains(uid)) {
        // debugPrint('votes contain  uid');
      } else {
        // debugPrint('vote does not contain uid');
        _firestore.collection('polls').doc(pollId).update({
          'votesUIDs': FieldValue.arrayUnion([uid]),
          'totalVotes': FieldValue.increment(1),
          'vote$optionIndex': FieldValue.arrayUnion([uid]),
          'voteCount$optionIndex': FieldValue.increment(1),
        });

        _firestore.collection('users').doc(poll.UID).update({
          'profileScoreValue': FieldValue.increment(1),
        });
      }
      poll.global == "true"
          ? _firestore
              .collection("mostLikedPolls")
              .where("pollId", isEqualTo: pollId)
              .get()
              .then((querySnapshot) {
              querySnapshot.docs.forEach((document) {
                document.reference.update({
                  'votesUIDs': FieldValue.arrayUnion([uid]),
                  'totalVotes': FieldValue.increment(1),
                  'vote$optionIndex': FieldValue.arrayUnion([uid]),
                  'voteCount$optionIndex': FieldValue.increment(1),
                });
              });
            })
          : _firestore
              .collection("mostLikedByCountryPolls")
              .doc(country)
              .collection("mostLiked")
              .where("pollId", isEqualTo: pollId)
              .get()
              .then((querySnapshot) {
              querySnapshot.docs.forEach((document) {
                document.reference.update({
                  'votesUIDs': FieldValue.arrayUnion([uid]),
                  'totalVotes': FieldValue.increment(1),
                  'vote$optionIndex': FieldValue.arrayUnion([uid]),
                  'voteCount$optionIndex': FieldValue.increment(1),
                });
              });
            });
      // updatePollVoteNotification(uid, pollId, pollUId);

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> pollUnverified({
    required Poll poll,
    required String uid,
    required int optionIndex,
  }) async {
    String res = "Some error occurred.";
    try {
      String pollId = poll.pollId;
      // ignore: unused_local_variable
      String pollUId = poll.UID;
      if (poll.votesUIDs.contains(uid)) {
      } else {
        _firestore.collection('polls').doc(pollId).update({
          'votesUIDs': FieldValue.arrayUnion([uid]),
          // 'totalVotes': FieldValue.increment(1),
          'vote$optionIndex': FieldValue.arrayUnion([uid]),
          // 'voteCount$optionIndex': FieldValue.increment(1),
        });
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadSubmission(String uid, String username, String profImage,
      String aTitle, bool fairtalk) async {
    String res = "Some error occurred.";
    try {
      var timeNow = await NTP.now();
      String submissionId = const Uuid().v1();
      Submission submission = Submission(
        submissionId: submissionId,
        UID: uid,
        bUsername: username,
        bProfImage: profImage,
        datePublishedNTP: timeNow,
        aTitle: aTitle,
        fairtalk: fairtalk,
        plusCount: 0,
        neutralCount: 0,
        minusCount: 0,
        plus: [],
        neutral: [],
        minus: [],
        votesUIDs: [],
        reportChecked: false,
        reportRemoved: false,
        reportCounter: 0,
        commentCount: 0,
        score: 0,
      );
      _firestore.collection('submissions').doc(submissionId).set(
            submission.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> uploadSubmission(
  //   // ignore: non_constant_identifier_names
  //   String UID,
  //   String bUsername,
  //   String bProfImage,
  //   String aTitle,
  //   // bool fairtalk,
  // ) async {
  //   String res = "Some error occurred.";
  //   try {
  //     var timeNow = await NTP.now();
  //     String postId = const Uuid().v1();
  //     Submission post = Submission(
  //       postId: postId,
  //       UID: UID,
  //       bUsername: bUsername,
  //       bProfImage: bProfImage,
  //       datePublishedNTP: timeNow,
  //       aTitle: aTitle,
  //       fairtalk: false,
  //       plusCount: 0,
  //       neutralCount: 0,
  //       minusCount: 0,
  //       plus: [],
  //       neutral: [],
  //       minus: [],
  //       votesUIDs: [],
  //       reportChecked: false,
  //       reportRemoved: false,
  //       reportCounter: 0,
  //       commentCount: 0,
  //       score: 0,
  //     );
  //     _firestore.collection('submissions').doc(postId).set(
  //           post.toJson(),
  //         );
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  //upload post
  Future<String> uploadPost(
      // ignore: non_constant_identifier_names
      String UID,
      String bUsername,
      String bProfImage,
      String country,
      String global,
      String aTitle,
      String aBody,
      String aVideoUrl,
      // Uint8List file,
      String aPhotoUrl,
      // int selected,
      int datePublishedCounter,
      int time,
      List<String>? tagsLowerCase) async {
    String res = "Some error occurred.";
    try {
      var timeNow = await NTP.now();
      // var timeNow = dateEST;

      //dateEST;
      // String photoUrl =
      //     await StorageMethods().uploadImageToStorage('posts', file, true);
      // String trimmedText = trimText(text: aTitle);
      String postId = const Uuid().v1();

      Post post = Post(
          postId: postId,
          UID: UID,
          bUsername: bUsername,
          bProfImage: bProfImage,
          country: country,
          datePublished: datePublishedCounter,
          datePublishedNTP: timeNow,
          global: global,
          aTitle: aTitle,
          aBody: aBody,
          aVideoUrl: aVideoUrl,
          aPostUrl: aPhotoUrl,
          // selected: selected,
          plusCount: 0,
          neutralCount: 0,
          minusCount: 0,
          plus: [],
          neutral: [],
          minus: [],
          votesUIDs: [],
          // reportUIDs: [],
          reportChecked: false,
          reportRemoved: false,
          reportCounter: 0,
          commentCount: 0,
          score: 0,
          time: time,
          // endDate: timeNow.add(Duration(
          //   days: 6,
          //   hours: 23 - timeNow.hour,
          //   minutes: 59 - timeNow.minute,
          //   seconds: 59 - timeNow.second,
          //   // days: 0,
          //   // hours: 0,
          //   // minutes: 1,
          // )),
          tagsLowerCase: tagsLowerCase);

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );

      res = "success";
      addKeywords(postId, UID, tagsLowerCase, country, global, "posts", time);
      postCounter('post');
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> addKeywords(
    String postId,
    String uid,
    List<String>? tagsLowerCase,
    String country,
    String global,
    String type,
    int time,
  ) async {
    try {
      debugPrint("firestore method working  time :$time");
      List<String>? tagsList;
      tagsList = tagsLowerCase!.toSet().toList();
      tagsList.forEach((element) {
        final batch = _firestore.batch();
        var _keyRef = global == "true"
            ? _firestore
                .collection('keywords')
                .doc("$time")
                .collection(type == "posts" ? "globalPosts" : "globalPolls")
                .doc(element)
            : _firestore
                .collection('keywordsByCountry')
                .doc("$time")
                .collection(
                    type == "posts" ? "countryByPosts" : "countryByPolls")
                .doc("$element-$country");
        _keyRef.get().then((adminstatus) {
          // print(adminstatus.data());
          if (adminstatus.data() == null) {
            List<String> searchList = setSearchParam(element);
            // print("----if----");
            List<int> weekList = [];
            for (int i = 0; i < 7; i++) {
              weekList.add(time + i);
            }

            Keyword _keyword = Keyword(
              keyName: element,
              postIds: [postId],
              // userIds: [uid],
              postType: type,
              length: 1,
              country: country,
              global: global,
              nameSearchList: searchList,
              time: time,
            );
            // FirebaseFirestore.instance
            //     .collection('keywords')
            //     .doc("${time}")
            //     .collection("posts")
            //     .doc(global == "true" ? "$element" : "$element-$country")
            _keyRef.set(_keyword.toJson());
          } else {
            _keyRef.update({
              'postIds': FieldValue.arrayUnion([postId]),
              // 'userIds': FieldValue.arrayUnion([uid]),
              'length': FieldValue.increment(1)
            });
          }
        });
        var weeklyRef = type == "posts"
            ? (global == "true"
                ? _firestore
                    .collectionGroup("globallyPost")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isEqualTo: element)
                    .where("global", isEqualTo: "true")
                : _firestore
                    .collectionGroup("byCountryWeeklyPost")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isEqualTo: element)
                    .where("country", isEqualTo: country))
            : (global == "true"
                ? _firestore
                    .collectionGroup("globallyPolls")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isEqualTo: element)
                    .where("global", isEqualTo: "true")
                : _firestore
                    .collectionGroup("byCountryWeeklyPolls")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isEqualTo: element)
                    .where("country", isEqualTo: country));

        var weeklyRefElse = type == "posts"
            ? (global == "true"
                ? _firestore
                    .collectionGroup("globallyPost")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isNotEqualTo: element)
                    .where("global", isEqualTo: "true")
                : _firestore
                    .collectionGroup("byCountryWeeklyPost")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isNotEqualTo: element)
                    .where("country", isEqualTo: country))
            : (global == "true"
                ? _firestore
                    .collectionGroup("globallyPolls")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isNotEqualTo: element)
                    .where("global", isEqualTo: "true")
                : _firestore
                    .collectionGroup("byCountryWeeklyPolls")
                    .where("weekList", arrayContains: time)
                    .where("keyName", isNotEqualTo: element)
                    .where("country", isEqualTo: country));

        weeklyRef.get().then((QuerySnapshot compareValue) {
          if (compareValue.docs == null || compareValue.docs.length == 0) {
            for (int n = 0; n < 7; n++) {
              List<String> searchList = setSearchParam(element);
              List<int> weekList = [];
              for (int i = 0; i < 7; i++) {
                weekList.add(time - n + i);
              }
              Keyword _keyword = Keyword(
                keyName: element,
                postIds: [postId],
                // userIds: [uid],
                postType: type,
                length: 1,
                country: country,
                global: global,
                nameSearchList: searchList,
                time: time - n,
                weekList: weekList,
                WeekName: "week ${time - n}-${time - n + 6}",
                lastDay: time - n + 6,
              );
              if (type == "posts") {
                // FirebaseFirestore.instance
                //     .collection('weeklyKeywordsPost')
                //     .doc("week ${time - n}-${time - n + 6}")
                //     .collection(global == "true"
                //         ? "globallyPost"
                //         : "byCountryWeeklyPost")
                //     .doc(global == "true" ? element : "$element-$country")
                //     .set(_keyword.toJson());
              } else {
                // FirebaseFirestore.instance
                //     .collection('weeklyKeywordsPolls')
                //     .doc("week ${time - n}-${time - n + 6}")
                //     .collection(global == "true"
                //         ? "globallyPolls"
                //         : "byCountryWeeklyPolls")
                //     .doc(global == "true" ? element : "$element-$country")
                //     .set(_keyword.toJson());
              }
            }
          } else {
            if (type == "posts") {
              compareValue.docs.forEach(
                (element1) {
                  FirebaseFirestore.instance
                      .collection('weeklyKeywordsPost')
                      .doc(
                          "week ${element1["weekList"][0]}-${element1["weekList"][6]}")
                      .collection(global == "true"
                          ? "globallyPost"
                          : "byCountryWeeklyPost")
                      .doc(global == "true" ? element : "$element-$country")
                      .update({
                    'postIds': FieldValue.arrayUnion([postId]),
                    // 'userIds': FieldValue.arrayUnion([uid]),
                    'length': FieldValue.increment(1)
                  });
                },
              );

              for (int i = 0; i < 7; i++) {
                (global == "true"
                        ? FirebaseFirestore.instance
                            .collectionGroup("globallyPost")
                            .where("WeekName",
                                isEqualTo: "week ${time - i}-${(time - i) + 6}")
                            .where("keyName", isEqualTo: element)
                            .where("global", isEqualTo: "true")
                        : FirebaseFirestore.instance
                            .collectionGroup("byCountryWeeklyPost")
                            .where("WeekName",
                                isEqualTo: "week ${time - i}-${(time - i) + 6}")
                            .where("keyName", isEqualTo: element)
                            .where("country", isEqualTo: country))
                    .get()
                    .then((QuerySnapshot Query) {
                  // print("Query.docs-- ${Query.docs[0]["weekList"]}");
                  if (Query.docs == null || Query.docs.length == 0) {
                    List<String> searchList = setSearchParam(element);

                    List<int> weekList = [];
                    for (int inV = 0; inV < 7; inV++) {
                      weekList.add(time - 1 + inV);
                    }
                    Keyword _keyword = Keyword(
                      keyName: element,
                      postIds: [postId],
                      // userIds: [uid],
                      postType: type,
                      length: 1,
                      country: country,
                      global: global,
                      nameSearchList: searchList,
                      time: time - i,
                      weekList: weekList,
                      WeekName: "week ${time - i}-${(time - i) + 6}",
                      lastDay: time - i + 6,
                    );
                    FirebaseFirestore.instance
                        .collection('weeklyKeywordsPost')
                        .doc("week ${time - i}-${(time - i) + 6}")
                        .collection(global == "true"
                            ? "globallyPost"
                            : "byCountryWeeklyPost")
                        .doc(global == "true" ? element : "$element-$country")
                        .set(_keyword.toJson());
                  }
                });
              }
            } else {
              compareValue.docs.forEach((element1) {
                FirebaseFirestore.instance
                    .collection('weeklyKeywordsPolls')
                    .doc(
                        "week ${element1["weekList"][0]}-${element1["weekList"][6]}")
                    .collection(global == "true"
                        ? "globallyPolls"
                        : "byCountryWeeklyPolls")
                    .doc(global == "true" ? element : "$element-$country")
                    .update({
                  'postIds': FieldValue.arrayUnion([postId]),
                  // 'lastDay': time,
                  // 'userIds': FieldValue.arrayUnion([uid]),
                  'length': FieldValue.increment(1)
                });
              });
              for (int i = 0; i < 7; i++) {
                (global == "true"
                        ? FirebaseFirestore.instance
                            .collectionGroup("globallyPolls")
                            .where("WeekName",
                                isEqualTo: "week ${time - i}-${time - i + 6}")
                            .where("keyName", isEqualTo: element)
                            .where("global", isEqualTo: "true")
                        : FirebaseFirestore.instance
                            .collectionGroup("byCountryWeeklyPolls")
                            .where("WeekName",
                                isEqualTo: "week ${time - i}-${time - i + 6}")
                            .where("keyName", isEqualTo: element)
                            .where("country", isEqualTo: country))
                    .get()
                    .then((QuerySnapshot Query) {
                  if (Query.docs == null || Query.docs.length == 0) {
                    List<String> searchList = setSearchParam(element);

                    List<int> weekList = [];
                    for (int inV = 0; inV < 7; inV++) {
                      weekList.add(time - i + inV);
                    }
                    Keyword _keyword = Keyword(
                      keyName: element,
                      postIds: [postId],
                      // userIds: [uid],
                      postType: type,
                      length: 1,
                      country: country,
                      global: global,
                      nameSearchList: searchList,
                      time: time - i,
                      weekList: weekList,
                      WeekName: "week ${time - i}-${time - i + 6}",
                      lastDay: time - i + 6,
                    );
                    FirebaseFirestore.instance
                        .collection('weeklyKeywordsPolls')
                        .doc("week ${time - i}-${time - i + 6}")
                        .collection(global == "true"
                            ? "globallyPolls"
                            : "byCountryWeeklyPolls")
                        .doc(global == "true" ? element : "$element-$country")
                        .set(_keyword.toJson());
                  }
                });
              }
            }

            // weeklyRef.update({
            //   'postIds': FieldValue.arrayUnion([postId]),
            //   // 'userIds': FieldValue.arrayUnion([uid]),
            //   'length': FieldValue.increment(1)
            // });
          }
        });
      });
    } catch (err) {
      err.toString();
    }
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  Future<void> messageScore(
    String postId,
    String type,
    Post post,
  ) async {
    try {
      final batch = _firestore.batch();
      var postRef = _firestore.collection('posts').doc(postId);
      var postAuthorRef = _firestore.collection('users').doc(post.UID);

      if (type == 'plus') {
        batch.update(postRef, {
          'score': FieldValue.increment(1),
          'plusCount': FieldValue.increment(1),
        });
        batch.update(postAuthorRef, {
          'profileScoreValue': FieldValue.increment(1),
        });
      } else if (type == 'neutral') {
        batch.update(postRef, {
          'neutralCount': FieldValue.increment(1),
        });
      } else {
        batch.update(postRef, {
          'score': FieldValue.increment(-1),
          'minusCount': FieldValue.increment(1),
        });
      }

      batch.commit();
    } catch (e) {
      // print(
    }
  }

  Future<String> pollScore({
    required Poll poll,
    required int optionIndex,
  }) async {
    String res = "Some error occurred.";

    try {
      String pollId = poll.pollId;
      String pollUId = poll.UID;
      String country = poll.country;
      {
        _firestore.collection('polls').doc(pollId).update({
          'totalVotes': FieldValue.increment(1),
          'voteCount$optionIndex': FieldValue.increment(1),
        });

        _firestore.collection('users').doc(poll.UID).update({
          'profileScoreValue': FieldValue.increment(1),
        });
        poll.global == "true"
            ? _firestore
                .collection("mostLikedPolls")
                .where("pollId", isEqualTo: pollId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'totalVotes': FieldValue.increment(1),
                    'voteCount$optionIndex': FieldValue.increment(1),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountryPolls")
                .doc(country)
                .collection("mostLiked")
                .where("pollId", isEqualTo: pollId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'totalVotes': FieldValue.increment(1),
                    'voteCount$optionIndex': FieldValue.increment(1),
                  });
                });
              });
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> plusMessage(
    String postId,
    String uid,
    List plus,
    List neutral,
    List minus,
    Post post,
    String global,
    String country,
  ) async {
    try {
      final batch = _firestore.batch();
      var postRef = _firestore.collection('posts').doc(postId);
      var postAuthorRef = _firestore.collection('users').doc(post.UID);

      if (plus.contains(uid)) {
        // var postRef = _firestore.collection('posts').doc(postId);
        // var userRef = _firestore.collection('users').doc(uid);
        batch.update(postRef, {
          'score': FieldValue.increment(-1),
          'plus': FieldValue.arrayRemove([uid]),
          'plusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayRemove([uid]),
        });
        batch.update(postAuthorRef, {
          'profileScoreValue': FieldValue.increment(-1),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'plus': FieldValue.arrayRemove([uid]),
                    'plusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayRemove([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'plus': FieldValue.arrayRemove([uid]),
                    'plusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayRemove([uid]),
                  });
                });
              });

        //       batch.commit();
      } else if (neutral.contains(uid)) {
        batch.update(postRef, {
          'score': FieldValue.increment(1),
          'plus': FieldValue.arrayUnion([uid]),
          'plusCount': FieldValue.increment(1),
          'neutral': FieldValue.arrayRemove([uid]),
          'neutralCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        batch.update(postAuthorRef, {
          'profileScoreValue': FieldValue.increment(1),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'plus': FieldValue.arrayUnion([uid]),
                    'plusCount': FieldValue.increment(1),
                    'neutral': FieldValue.arrayRemove([uid]),
                    'neutralCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'plus': FieldValue.arrayUnion([uid]),
                    'plusCount': FieldValue.increment(1),
                    'neutral': FieldValue.arrayRemove([uid]),
                    'neutralCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
        //    batch.commit();
      } else if (minus.contains(uid)) {
        batch.update(postRef, {
          'score': FieldValue.increment(2),
          'plus': FieldValue.arrayUnion([uid]),
          'plusCount': FieldValue.increment(1),
          'minus': FieldValue.arrayRemove([uid]),
          'minusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        batch.update(postAuthorRef, {
          'profileScoreValue': FieldValue.increment(1),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(2),
                    'plus': FieldValue.arrayUnion([uid]),
                    'plusCount': FieldValue.increment(1),
                    'minus': FieldValue.arrayRemove([uid]),
                    'minusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(2),
                    'plus': FieldValue.arrayUnion([uid]),
                    'plusCount': FieldValue.increment(1),
                    'minus': FieldValue.arrayRemove([uid]),
                    'minusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
        //    batch.commit();
      } else {
        batch.update(postRef, {
          'score': FieldValue.increment(1),
          'plus': FieldValue.arrayUnion([uid]),
          'plusCount': FieldValue.increment(1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        batch.update(postAuthorRef, {
          'profileScoreValue': FieldValue.increment(1),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'plus': FieldValue.arrayUnion([uid]),
                    'plusCount': FieldValue.increment(1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'plus': FieldValue.arrayUnion([uid]),
                    'plusCount': FieldValue.increment(1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
        //  batch.commit();
      }
      // batch.update(postRef, {'score': post.plusCount - post.minusCount});
      // postRef.get().then((postSnap) {
      // if(postSnap.data() != null) {
      //   Post post = Post.fromMap(postSnap.data()!);
      //   debugPrint('plus is ${post.plusCount} and minus ${post.minusCount}');
      //   postRef.update({'score': post.plusCount - post.minusCount});
      // }});
      batch.commit();
      Provider.of<PostProvider>(navigatorKey.currentContext!, listen: false)
          .plusPost(postId, uid);
      Provider.of<SearchPageProvider>(navigatorKey.currentContext!,
              listen: false)
          .plusPost(postId, uid);
      Provider.of<MostLikedKeyProvider>(navigatorKey.currentContext!,
              listen: false)
          .plusPost(postId, uid);
    } catch (e) {
      // debugPrint('plus message error $e');
      // print(
      //   e.toString(),
      // );
    }
  }

  Future<void> neutralMessage(
    String postId,
    String uid,
    List plus,
    List neutral,
    List minus,
    Post post,
    String global,
    String country,
  ) async {
    try {
      var postRef = _firestore.collection('posts').doc(postId);
      var userRef = _firestore.collection('users').doc(uid);
      var postAuthorRef = _firestore.collection('users').doc(post.UID);
      final batch = _firestore.batch();
      if (neutral.contains(uid)) {
        batch.update(postRef, {
          'neutral': FieldValue.arrayRemove([uid]),
          'neutralCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayRemove([uid]),
        });

        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'neutral': FieldValue.arrayRemove([uid]),
                    'neutralCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayRemove([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'neutral': FieldValue.arrayRemove([uid]),
                    'neutralCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayRemove([uid]),
                  });
                });
              });
      } else if (plus.contains(uid)) {
        batch.update(postRef, {
          'score': FieldValue.increment(-1),
          'neutral': FieldValue.arrayUnion([uid]),
          'neutralCount': FieldValue.increment(1),
          'plus': FieldValue.arrayRemove([uid]),
          'plusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        batch.update(postAuthorRef, {
          'profileScoreValue': FieldValue.increment(-1),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'neutral': FieldValue.arrayUnion([uid]),
                    'neutralCount': FieldValue.increment(1),
                    'plus': FieldValue.arrayRemove([uid]),
                    'plusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'neutral': FieldValue.arrayUnion([uid]),
                    'neutralCount': FieldValue.increment(1),
                    'plus': FieldValue.arrayRemove([uid]),
                    'plusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
        //   batch.commit();
      } else if (minus.contains(uid)) {
        batch.update(postRef, {
          'score': FieldValue.increment(1),
          'neutral': FieldValue.arrayUnion([uid]),
          'neutralCount': FieldValue.increment(1),
          'minus': FieldValue.arrayRemove([uid]),
          'minusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'neutral': FieldValue.arrayUnion([uid]),
                    'neutralCount': FieldValue.increment(1),
                    'minus': FieldValue.arrayRemove([uid]),
                    'minusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'neutral': FieldValue.arrayUnion([uid]),
                    'neutralCount': FieldValue.increment(1),
                    'minus': FieldValue.arrayRemove([uid]),
                    'minusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
      } else {
        batch.update(postRef, {
          'neutral': FieldValue.arrayUnion([uid]),
          'neutralCount': FieldValue.increment(1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'neutral': FieldValue.arrayUnion([uid]),
                    'neutralCount': FieldValue.increment(1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'neutral': FieldValue.arrayUnion([uid]),
                    'neutralCount': FieldValue.increment(1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
      }
      //   batch.update(postRef, {'score': post.plusCount - post.minusCount});

      // batch..update(postRef, {'score': post.plusCount - post.minusCount});
      // postRef.get().then((postSnap) {
      //   if (postSnap.data() != null) {
      //     Post post = Post.fromMap(postSnap.data()!);
      //     debugPrint('plus is ${post.plusCount} and minus ${post.minusCount}');
      //      postRef.update({'score': post.plusCount - post.minusCount});
      //   }
      //});
      batch.commit();
      Provider.of<PostProvider>(navigatorKey.currentContext!, listen: false)
          .neutralPost(postId, uid);
      Provider.of<SearchPageProvider>(navigatorKey.currentContext!,
              listen: false)
          .neutralPost(postId, uid);
      Provider.of<MostLikedKeyProvider>(navigatorKey.currentContext!,
              listen: false)
          .neutralPost(postId, uid);
    } catch (e) {
      // print(
    }
  }

  Future<void> minusMessage(
    String postId,
    String uid,
    List plus,
    List neutral,
    List minus,
    Post post,
    String global,
    String country,
  ) async {
    try {
      var postRef = _firestore.collection('posts').doc(postId);
      var userRef = _firestore.collection('users').doc(uid);
      var postAuthorRef = _firestore.collection('users').doc(post.UID);
      final batch = _firestore.batch();

      if (minus.contains(uid)) {
        batch.update(postRef, {
          'score': FieldValue.increment(1),
          'minus': FieldValue.arrayRemove([uid]),
          'minusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayRemove([uid]),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'minus': FieldValue.arrayRemove([uid]),
                    'minusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayRemove([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(1),
                    'minus': FieldValue.arrayRemove([uid]),
                    'minusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayRemove([uid]),
                  });
                });
              });
      } else if (neutral.contains(uid)) {
        batch.update(postRef, {
          'score': FieldValue.increment(-1),
          'minus': FieldValue.arrayUnion([uid]),
          'minusCount': FieldValue.increment(1),
          'neutral': FieldValue.arrayRemove([uid]),
          'neutralCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'minus': FieldValue.arrayUnion([uid]),
                    'minusCount': FieldValue.increment(1),
                    'neutral': FieldValue.arrayRemove([uid]),
                    'neutralCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'minus': FieldValue.arrayUnion([uid]),
                    'minusCount': FieldValue.increment(1),
                    'neutral': FieldValue.arrayRemove([uid]),
                    'neutralCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
      } else if (plus.contains(uid)) {
        batch.update(postRef, {
          'score': FieldValue.increment(-2),
          'minus': FieldValue.arrayUnion([uid]),
          'minusCount': FieldValue.increment(1),
          'plus': FieldValue.arrayRemove([uid]),
          'plusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        batch.update(postAuthorRef, {
          'profileScoreValue': FieldValue.increment(-1),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-2),
                    'minus': FieldValue.arrayUnion([uid]),
                    'minusCount': FieldValue.increment(1),
                    'plus': FieldValue.arrayRemove([uid]),
                    'plusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-2),
                    'minus': FieldValue.arrayUnion([uid]),
                    'minusCount': FieldValue.increment(1),
                    'plus': FieldValue.arrayRemove([uid]),
                    'plusCount': FieldValue.increment(-1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
      } else {
        batch.update(postRef, {
          'score': FieldValue.increment(-1),
          'minus': FieldValue.arrayUnion([uid]),
          'minusCount': FieldValue.increment(1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
        global == "true"
            ? _firestore
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'minus': FieldValue.arrayUnion([uid]),
                    'minusCount': FieldValue.increment(1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              })
            : _firestore
                .collection("mostLikedByCountry")
                .doc(country)
                .collection("mostLiked")
                .where("postId", isEqualTo: postId)
                .get()
                .then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  document.reference.update({
                    'score': FieldValue.increment(-1),
                    'minus': FieldValue.arrayUnion([uid]),
                    'minusCount': FieldValue.increment(1),
                    'votesUIDs': FieldValue.arrayUnion([uid]),
                  });
                });
              });
      }

      //  batch.update(postRef, {'score': post.plusCount - post.minusCount});
      batch.commit();
      Provider.of<PostProvider>(navigatorKey.currentContext!, listen: false)
          .minusPost(postId, uid);
      Provider.of<SearchPageProvider>(navigatorKey.currentContext!,
              listen: false)
          .minusPost(postId, uid);
      Provider.of<MostLikedKeyProvider>(navigatorKey.currentContext!,
              listen: false)
          .minusPost(postId, uid);
      // postRef.get().then((postSnap) {
      //   if (postSnap.data() != null) {
      //     Post post = Post.fromMap(postSnap.data()!);
      //     debugPrint('plus is ${post.plusCount} and minus ${post.minusCount}');
      //      postRef.update({'score': post.plusCount - post.minusCount});
      //   }
      //});
    } catch (e) {
      // print(
      //   e.toString(),
      // );
    }
  }

  Future<void> plusMessageUnverified(
    String postId,
    String uid,
    List plus,
    List neutral,
    List minus,
    Post post,
    String global,
    String country,
  ) async {
    try {
      final batch = _firestore.batch();
      var postRef = _firestore.collection('posts').doc(postId);
      var postAuthorRef = _firestore.collection('users').doc(post.UID);
      if (plus.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(-1),
          'plus': FieldValue.arrayRemove([uid]),
          // 'plusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayRemove([uid]),
        });
      } else if (neutral.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(1),
          'plus': FieldValue.arrayUnion([uid]),
          // 'plusCount': FieldValue.increment(1),
          'neutral': FieldValue.arrayRemove([uid]),
          // 'neutralCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      } else if (minus.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(2),
          'plus': FieldValue.arrayUnion([uid]),
          // 'plusCount': FieldValue.increment(1),
          'minus': FieldValue.arrayRemove([uid]),
          // 'minusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      } else {
        batch.update(postRef, {
          // 'score': FieldValue.increment(1),
          'plus': FieldValue.arrayUnion([uid]),
          // 'plusCount': FieldValue.increment(1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      }
      batch.commit();
      Provider.of<PostProvider>(navigatorKey.currentContext!, listen: false)
          .plusPostUnverified(postId, uid);
      Provider.of<SearchPageProvider>(navigatorKey.currentContext!,
              listen: false)
          .plusPostUnverified(postId, uid);
    } catch (e) {
      // debugPrint('plus message error $e');
    }
  }

  Future<void> neutralMessageUnverified(
    String postId,
    String uid,
    List plus,
    List neutral,
    List minus,
    Post post,
    String global,
    String country,
  ) async {
    try {
      var postRef = _firestore.collection('posts').doc(postId);
      var userRef = _firestore.collection('users').doc(uid);
      var postAuthorRef = _firestore.collection('users').doc(post.UID);
      final batch = _firestore.batch();
      if (neutral.contains(uid)) {
        batch.update(postRef, {
          'neutral': FieldValue.arrayRemove([uid]),
          // 'neutralCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayRemove([uid]),
        });
      } else if (plus.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(-1),
          'neutral': FieldValue.arrayUnion([uid]),
          // 'neutralCount': FieldValue.increment(1),
          'plus': FieldValue.arrayRemove([uid]),
          // 'plusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      } else if (minus.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(1),
          'neutral': FieldValue.arrayUnion([uid]),
          // 'neutralCount': FieldValue.increment(1),
          'minus': FieldValue.arrayRemove([uid]),
          // 'minusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      } else {
        batch.update(postRef, {
          'neutral': FieldValue.arrayUnion([uid]),
          // 'neutralCount': FieldValue.increment(1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      }

      batch.commit();
      Provider.of<PostProvider>(navigatorKey.currentContext!, listen: false)
          .neutralPostUnverified(postId, uid);
      Provider.of<SearchPageProvider>(navigatorKey.currentContext!,
              listen: false)
          .neutralPostUnverified(postId, uid);
    } catch (e) {
      // print(
    }
  }

  Future<void> minusMessageUnverified(
    String postId,
    String uid,
    List plus,
    List neutral,
    List minus,
    Post post,
    String global,
    String country,
  ) async {
    try {
      var postRef = _firestore.collection('posts').doc(postId);
      var userRef = _firestore.collection('users').doc(uid);
      var postAuthorRef = _firestore.collection('users').doc(post.UID);
      final batch = _firestore.batch();

      if (minus.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(1),
          'minus': FieldValue.arrayRemove([uid]),
          // 'minusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayRemove([uid]),
        });
      } else if (neutral.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(-1),
          'minus': FieldValue.arrayUnion([uid]),
          // 'minusCount': FieldValue.increment(1),
          'neutral': FieldValue.arrayRemove([uid]),
          // 'neutralCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      } else if (plus.contains(uid)) {
        batch.update(postRef, {
          // 'score': FieldValue.increment(-2),
          'minus': FieldValue.arrayUnion([uid]),
          // 'minusCount': FieldValue.increment(1),
          'plus': FieldValue.arrayRemove([uid]),
          // 'plusCount': FieldValue.increment(-1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      } else {
        batch.update(postRef, {
          // 'score': FieldValue.increment(-1),
          'minus': FieldValue.arrayUnion([uid]),
          // 'minusCount': FieldValue.increment(1),
          'votesUIDs': FieldValue.arrayUnion([uid]),
        });
      }

      batch.commit();
      Provider.of<PostProvider>(navigatorKey.currentContext!, listen: false)
          .minusPostUnverified(postId, uid);
      Provider.of<SearchPageProvider>(navigatorKey.currentContext!,
              listen: false)
          .minusPostUnverified(postId, uid);
      // Provider.of<MostLikedKeyProvider>(navigatorKey.currentContext!,
      //         listen: false)
      //     .minusPost(postId, uid);
    } catch (e) {
      // print(
    }
  }

  Future<String> comment(String postId, String text, String uid,
      String username, int datePublishedCounter) async {
    String res = "Some error occurred.";
    try {
      if (text.isNotEmpty) {
        CommentReplyProvider commentReplyProvider =
            Provider.of<CommentReplyProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
        // await getDate();
        var timeNow = await NTP.now();
        // String trimmedText = trimText(text: text);
        String commentId = const Uuid().v1();
        Comment comment = Comment(
          parentId: postId,
          username: username,
          UID: uid,
          text: text,
          commentId: commentId,
          datePublished: datePublishedCounter,
          datePublishedNTP: timeNow,
          likes: [],
          likeCount: 0,
          dislikes: [],
          dislikeCount: 0,
          reportCounter: 0,
          reportChecked: false,
          reportRemoved: false,
        );

        commentReplyProvider.addNewCommentInPostPoll(
          postId: postId,
          text: text,
          uid: uid,
          username: username,
          commentId: commentId,
          datePublished: datePublishedCounter,
          datePublishedNTP: timeNow,
        );

        _firestore.collection('comments').doc(commentId).set(
              comment.toJson(),
            );

        res = "success";
        postCounter('comment');
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> reply(
    String postId,
    String commentId,
    String text,
    String uid,
    String username,
    bool isReply, {
    required int insertAt,
  }) async {
    String res = "Some error occurred.";
    try {
      if (text.isNotEmpty) {
        CommentReplyProvider commentReplyProvider =
            Provider.of<CommentReplyProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
        // String trimmedText = trimText(text: text);
        String replyId = const Uuid().v1();
        // await getDate();
        var timeNow = await NTP.now();
        Reply reply = Reply(
          parentMessageId: postId,
          parentCommentId: commentId,
          username: username,
          UID: uid,
          text: text,
          replyId: replyId,
          datePublished: timeNow,
          datePublishedNTP: timeNow,
          likes: [],
          likeCount: 0,
          dislikes: [],
          dislikeCount: 0,
          reportCounter: 0,
          reportChecked: false,
          reportRemoved: false,
        );

        commentReplyProvider.addNewReplyInPostPoll(
          postId: postId,
          text: text,
          uid: uid,
          username: username,
          commentId: commentId,
          replyId: replyId,
          insertAt: insertAt,
          datePublishedNTP: timeNow,
        );
        _firestore.collection('replies').doc(replyId).set(
              reply.toJson(),
            );

        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> scoreMessage(
      String postId, String uid, int score, String uploadUid) async {
    try {
      await _firestore.collection('posts').doc(postId).update(
        {'score': score},
      );
    } catch (e) {
      // print(
    }
  }

  Future<void> totalVotesPoll(String pollId, String uid, int totalVotes) async {
    try {
      await _firestore.collection('posts').doc(pollId).update(
        {'totalVotes': totalVotes},
      );
    } catch (e) {
      // print(
    }
  }

  Future<String> uploadReportedBug(
    String reportedBugText,
    String deviceType,
  ) async {
    String res = "Some error occurred.";
    try {
      var timeNow = await NTP.now();
      // var timeNow = dateEST;
      String bugId = const Uuid().v1();
      // String trimmedText = trimText(text: reportedBugText);
      // String trimmedDeviceType = trimText(text: deviceType);
      ReportedBug bugReport = ReportedBug(
        bugId: bugId,
        datePublished: timeNow,
        reportedBugText: reportedBugText,
        deviceType: deviceType,
        saved: false,
        removed: false,
      );
      _firestore.collection('reportedBugs').doc(bugId).set(
            bugReport.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> bugAction(String bugId, String action) async {
    try {
      action == 'save'
          ? await _firestore.collection('reportedBugs').doc(bugId).update({
              'saved': true,
            })
          : await _firestore.collection('reportedBugs').doc(bugId).update({
              'removed': true,
            });
    } catch (e) {
      //
    }
  }

  Future<void> reportCounter(
      String postId, bool reportChecked, String type) async {
    try {
      if (reportChecked == true) {
      } else {
        await _firestore
            .collection(type == 'message'
                ? 'posts'
                : type == 'poll'
                    ? 'polls'
                    : type == 'comment'
                        ? 'comments'
                        : 'replies')
            .doc(postId)
            .update({
          'reportCounter': FieldValue.increment(1),
        });
      }
    } catch (e) {
      // print(
    }
  }

  Future<void> keepReport(
    String postId,
    String type,
  ) async {
    try {
      await _firestore
          .collection(type == 'message'
              ? 'posts'
              : type == 'poll'
                  ? 'polls'
                  : type == 'comment'
                      ? 'comments'
                      : 'replies')
          .doc(postId)
          .update({
        'reportChecked': true,
      });
    } catch (e) {
      // print(
    }
  }

  Future<void> removeReport(String postId, String uid, String type) async {
    try {
      await _firestore
          .collection(type == 'message'
              ? 'posts'
              : type == 'poll'
                  ? 'polls'
                  : type == 'comment'
                      ? 'comments'
                      : 'replies')
          .doc(postId)
          .update({
        'reportRemoved': true,
      });
      await _firestore.collection('users').doc(uid).update({
        'userReportCounter': FieldValue.increment(1),
      });
    } catch (e) {
      // print(
    }
  }

  Future<void> removeProfPic(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'photoUrl': null,
      });
    } catch (e) {
      // print(
    }
  }

  //COMMENT COUNTER
  Future<void> commentCounter(
      String postId, String type, bool increment) async {
    try {
      await _firestore
          .collection(type == 'message' ? 'posts' : 'polls')
          .doc(postId)
          .update({
        'commentCount': increment == true
            ? FieldValue.increment(1)
            : FieldValue.increment(-1),
      });
    } catch (e) {
      // print(
    }
  }

//LIKE+DISLIKES COMMENTS/REPLIES
  Future<void> like(String id, String uid, List likes, List dislikes,
      int likeCount, int dislikeCount, String type,
      {String? parentMessageId}) async {
    try {
      var commentsAndRepliesProvider = Provider.of<CommentReplyProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );
      if (likes.contains(uid)) {
        likes.remove(uid);
        likeCount -= 1;
        commentsAndRepliesProvider.updateUserLikeDislike(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
        );
        commentsAndRepliesProvider.updatePostPollComment(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
          parentMessageId: parentMessageId,
        );
        await _firestore
            .collection(type == 'comment' ? 'comments' : 'replies')
            .doc(id)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        var updateMap = {
          'likes': FieldValue.arrayUnion([uid]),
          'likeCount': FieldValue.increment(1),
          'dislikes': FieldValue.arrayRemove([uid]),
        };
        likes.add(uid);
        likeCount += 1;

        if (dislikes.contains(uid)) {
          updateMap['dislikeCount'] = FieldValue.increment(-1);
          dislikes.remove(uid);
          dislikeCount -= 1;
        }
        commentsAndRepliesProvider.updateUserLikeDislike(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
        );
        commentsAndRepliesProvider.updatePostPollComment(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
          parentMessageId: parentMessageId,
        );
        await _firestore
            .collection(type == 'comment' ? 'comments' : 'replies')
            .doc(id)
            .update(updateMap);
      }
    } catch (e) {
      //e
    }
  }

  Future<void> dislike(String id, String uid, List likes, List dislikes,
      int likeCount, int dislikeCount, String type,
      {String? parentMessageId}) async {
    try {
      var commentsAndRepliesProvider = Provider.of<CommentReplyProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );

      if (dislikes.contains(uid)) {
        dislikes.remove(uid);
        dislikeCount -= 1;
        commentsAndRepliesProvider.updateUserLikeDislike(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
        );
        commentsAndRepliesProvider.updatePostPollComment(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
          parentMessageId: parentMessageId,
        );
        await _firestore
            .collection(type == 'comment' ? 'comments' : 'replies')
            .doc(id)
            .update({
          'dislikes': FieldValue.arrayRemove([uid]),
          'dislikeCount': FieldValue.increment(-1),
        });
      } else {
        var updateMap = {
          'dislikes': FieldValue.arrayUnion([uid]),
          'dislikeCount': FieldValue.increment(1),
          'likes': FieldValue.arrayRemove([uid]),
        };
        dislikes.add(uid);
        dislikeCount += 1;
        if (likes.contains(uid)) {
          updateMap['likeCount'] = FieldValue.increment(-1);
          likes.remove(uid);
          likeCount -= 1;
        }
        commentsAndRepliesProvider.updateUserLikeDislike(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
        );
        commentsAndRepliesProvider.updatePostPollComment(
          type: type,
          docId: id,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          likes: likes,
          dislikes: dislikes,
          parentMessageId: parentMessageId,
        );
        await _firestore
            .collection(type == 'comment' ? 'comments' : 'replies')
            .doc(id)
            .update(updateMap);
      }
    } catch (e) {
      // print(
    }
  }

  //deleting post
  Future<String> deletePost(dynamic postOrPoll, String type, User user) async {
    String postOrPollId = '';
    final userRef =
        _firestore.collection(FirestoreValues.userCollection).doc(user.UID);
    int plusCount = 0;
    String? globalPostorPolls;
    String? countryPostorPolls;
    if (postOrPoll is Post) {
      postOrPollId = postOrPoll.postId;
      plusCount = postOrPoll.plusCount;
      globalPostorPolls = postOrPoll.global;
      countryPostorPolls = postOrPoll.country;
    } else if (postOrPoll is Poll) {
      postOrPollId = postOrPoll.pollId;
      plusCount = postOrPoll.totalVotes;
      globalPostorPolls = postOrPoll.global;
      countryPostorPolls = postOrPoll.country;
    }

    String res = "Some error occurred.";
    try {
      _firestore
          .collection(type == 'message' ? 'posts' : 'polls')
          .doc(postOrPollId)
          .delete();
      QuerySnapshot<Map<String, dynamic>> findComments = await FirebaseFirestore
          .instance
          .collection('comments')
          .where('parentId', isEqualTo: postOrPollId)
          .get();
      for (var element in findComments.docs) {
        await element.reference.delete();
      }
      QuerySnapshot<Map<String, dynamic>> findReplies = await FirebaseFirestore
          .instance
          .collection('replies')
          .where('parentMessageId', isEqualTo: postOrPollId)
          .get();
      for (var element in findReplies.docs) {
        await element.reference.delete();
      }

      QuerySnapshot<Map<String, dynamic>> findMostLiked =
          await FirebaseFirestore.instance
              .collection(type == 'message' ? 'mostLiked' : 'mostLikedPolls')
              .where(type == 'message' ? 'postId' : 'pollId',
                  isEqualTo: postOrPollId)
              .get();
      for (var element in findMostLiked.docs) {
        await element.reference.delete();
      }

      QuerySnapshot<Map<String, dynamic>> findMostLikedByCountry =
          await FirebaseFirestore.instance
              .collection(type == 'message'
                  ? 'mostLikedByCountry'
                  : 'mostLikedByCountryPolls')
              .where(type == 'message' ? 'postId' : 'pollId',
                  isEqualTo: postOrPollId)
              .get();
      for (var element in findMostLikedByCountry.docs) {
        await element.reference.delete();
      }

      userRef.update({'profileScoreValue': FieldValue.increment(-plusCount)});

      res = "success";
      if (res == "success") {
        await deletePostorPollIdFromDailyKeyword(
            postOrPollId, countryPostorPolls, globalPostorPolls, postOrPoll);
        await deletePostorPollIdFromWeekly(
            postOrPollId, countryPostorPolls, globalPostorPolls, postOrPoll);
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  deletePostorPollIdFromDailyKeyword(String postOrPollId,
      String? countryPostorPolls, String? globalPostorPolls, postOrPoll) {
    // print("countryPostorPolls--> ${countryPostorPolls}");
    // print("postOrPollId--> ${postOrPollId}");
    // print("globalPostorPolls--> ${globalPostorPolls}");
    // print("postOrPoll--> ${postOrPoll}");

    FirebaseFirestore.instance
        .collectionGroup(postOrPoll is Post
            ? globalPostorPolls == "true"
                ? 'globalPosts'
                : "countryByPosts"
            : (globalPostorPolls == "true" || countryPostorPolls == "")
                ? 'globalPolls'
                : "countryByPolls")
        .where("postIds", arrayContains: postOrPollId)
        .where("postType", isEqualTo: postOrPoll is Post ? "posts" : "polls")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                if (document["length"] == 1) {
                  FirebaseFirestore.instance
                      .collection(globalPostorPolls == "true"
                          ? "keywords"
                          : "keywordsByCountry")
                      .doc("${document["time"]}")
                      .collection(globalPostorPolls == "true"
                          ? postOrPoll is Post
                              ? 'globalPosts'
                              : "globalPolls"
                          : postOrPoll is Post
                              ? 'countryByPosts'
                              : 'countryByPolls')
                      .doc(globalPostorPolls == "true"
                          ? document["keyName"]
                          : "${document["keyName"]}-$countryPostorPolls")
                      .delete();
                } else {
                  FirebaseFirestore.instance
                      .collection(globalPostorPolls == "true"
                          ? "keywords"
                          : "keywordsByCountry")
                      .doc("${document["time"]}")
                      .collection(globalPostorPolls == "true"
                          ? postOrPoll is Post
                              ? 'globalPosts'
                              : "globalPolls"
                          : postOrPoll is Post
                              ? 'countryByPosts'
                              : 'countryByPolls')
                      .doc(globalPostorPolls == "true"
                          ? document["keyName"]
                          : "${document["keyName"]}-$countryPostorPolls")
                      .update({
                    "postIds": FieldValue.arrayRemove([postOrPollId]),
                    "length": FieldValue.increment(-1),
                  });
                }
                // batch.update(, data)
              })
            });
  }

  deletePostorPollIdFromWeekly(String postOrPollId, String? countryPostorPolls,
      String? globalPostorPolls, postOrPoll) {
    // print("postOrPollId--> $postOrPollId");
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    FirebaseFirestore.instance
        .collectionGroup(postOrPoll is Post
            ? globalPostorPolls == "true"
                ? 'globallyPost'
                : "byCountryWeeklyPost"
            : (globalPostorPolls == "true" || countryPostorPolls == "")
                ? 'globallyPolls'
                : "byCountryWeeklyPolls")
        .where("postIds", arrayContains: postOrPollId)
        .where("postType", isEqualTo: postOrPoll is Post ? "posts" : "polls")
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                if (document["length"] == 1) {
                  FirebaseFirestore.instance
                      .collection(postOrPoll is Post
                          ? "weeklyKeywordsPost"
                          : "weeklyKeywordsPolls")
                      .doc(document["WeekName"])
                      .collection(postOrPoll is Post
                          ? globalPostorPolls == "true"
                              ? 'globallyPost'
                              : "byCountryWeeklyPost"
                          : (globalPostorPolls == "true" ||
                                  countryPostorPolls == "")
                              ? 'globallyPolls'
                              : "byCountryWeeklyPolls")
                      .doc(globalPostorPolls == "true"
                          ? document["keyName"]
                          : "${document["keyName"]}-$countryPostorPolls")
                      .delete();
                } else {
                  FirebaseFirestore.instance
                      .collection(postOrPoll is Post
                          ? "weeklyKeywordsPost"
                          : "weeklyKeywordsPolls")
                      .doc(document["WeekName"])
                      .collection(postOrPoll is Post
                          ? globalPostorPolls == "true"
                              ? 'globallyPost'
                              : "byCountryWeeklyPost"
                          : (globalPostorPolls == "true" ||
                                  countryPostorPolls == "")
                              ? 'globallyPolls'
                              : "byCountryWeeklyPolls")
                      .doc(globalPostorPolls == "true"
                          ? document["keyName"]
                          : "${document["keyName"]}-$countryPostorPolls")
                      .update({
                    "postIds": FieldValue.arrayRemove([postOrPollId]),
                    "length": FieldValue.increment(-1),
                  });
                }
                // batch.update(, data)
              })
            });
  }

  //deleting comment
  Future<String> deleteComment(String commentId) async {
    String res = "Some error occurred.";
    try {
      await _firestore.collection('comments').doc(commentId).delete();
      QuerySnapshot<Map<String, dynamic>> findReplies = await FirebaseFirestore
          .instance
          .collection('replies')
          .where('parentCommentId', isEqualTo: commentId)
          .get();
      for (var element in findReplies.docs) {
        await element.reference.delete();
      }
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

//deleting reply
  Future<String> deleteReply(
    String replyId,
  ) async {
    String res = "Some error occurred.";
    try {
      await _firestore.collection('replies').doc(replyId).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
