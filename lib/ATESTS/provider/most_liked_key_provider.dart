import 'dart:async';
import 'package:aft/ATESTS/provider/postPoll_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mostLiked_keywords.dart';
import '../models/poll.dart';
import '../models/post.dart';
import '../utils/global_variables.dart';

class MostLikedKeyProvider extends ChangeNotifier {
  List<MostLikedKeywords> list = [];
  int postKeywordListCount = 0;
  bool postKeywordLast = false;
  List<Post> _userPosts = [];
  bool Loading = false;
  int paginationLength = 6;
  int paginationLengthKeyword = 10;
  QuerySnapshot<Map<String, dynamic>>? _postKeywordListSnapshot;

  final _postPollProvider = Provider.of<PostPollProvider>(
      navigatorKey.currentContext!,
      listen: false);

  Future<void> getkeywordList(String global, String countryCode,
      {bool? getNextList1}) async {
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      // var datalist = querySnapshot.docs;
      list.clear();
      // print("querySnapshot.docs ${querySnapshot.docs[0].data()}");
      querySnapshot.docs.forEach((element) {
        MostLikedKeywords dataIn =
            MostLikedKeywords.fromJson(element.data() as Map<String, dynamic>);
        list.add(dataIn);
      });
    }

    var query1 = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLikedKeywordPosts')
            : FirebaseFirestore.instance
                .collection('mostLikedKeywordByCountry')
                .doc(countryCode)
                .collection("mostLikedPostKeywordByCountry")
                .where("country", isEqualTo: countryCode))
        .where("global", isEqualTo: global)
        .orderBy("length", descending: true);

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      var snap = await query1.count().get();

      if (getNextList1 != null) {
        if (getNextList1) {
          postKeywordListCount += 1;

          query1
              .startAfterDocument(_postKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _postKeywordListSnapshot = await query1
              .startAfterDocument(_postKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .get();
        } else {
          postKeywordListCount -= 1;

          await query1
              .endBeforeDocument(_postKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _postKeywordListSnapshot = await query1
              .endBeforeDocument(_postKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .get();
        }
      } else {
        postKeywordListCount = 1;

        await query1.limit(paginationLengthKeyword).get().then(
            (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));
        _postKeywordListSnapshot =
            await query1.limit(paginationLengthKeyword).get();
      }
      postKeywordLast = false;
      // debugPrint(
      //     "_postKeywordListSnapshot!.docs.length ll $postKeywordLast ${_postKeywordListSnapshot!.docs.length}");
      if (_postKeywordListSnapshot!.docs.length < paginationLengthKeyword ||
          paginationLengthKeyword * postKeywordListCount == snap.count) {
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

  List<MostLikedKeywords> listPoll = [];

  int pollKeywordListCount = 0;
  bool pollKeywordLast = false;
  QuerySnapshot<Map<String, dynamic>>? _pollKeywordListSnapshot;
  Future<void> getpollKeywordList(String global, String countryCode,
      {bool? getNextListPoll}) async {
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      // var datalist = querySnapshot.docs;
      listPoll.clear();
      querySnapshot.docs.forEach((element) {
        MostLikedKeywords dataIn =
            MostLikedKeywords.fromJson(element.data() as Map<String, dynamic>);
        listPoll.add(dataIn);
      });
    }

    var query1 = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLikedKeywordPolls')
            : FirebaseFirestore.instance
                .collection('mostLikedKeywordByCountry')
                .doc(countryCode)
                .collection("mostLikedPollsKeywordByCountry")
                .where("country", isEqualTo: countryCode))
        .where("global", isEqualTo: global)
        .orderBy("length", descending: true);

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      var snap = await query1.count().get();
      if (getNextListPoll != null) {
        if (getNextListPoll) {
          pollKeywordListCount += 1;

          query1
              .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _pollKeywordListSnapshot = await query1
              .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .get();
        } else {
          pollKeywordListCount -= 1;

          await query1
              .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _pollKeywordListSnapshot = await query1
              .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .get();
        }
      } else {
        pollKeywordListCount = 1;

        await query1.limit(paginationLengthKeyword).get().then(
            (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));
        _pollKeywordListSnapshot =
            await query1.limit(paginationLengthKeyword).get();
      }
      pollKeywordLast = false;
      // debugPrint(
      //     "_postKeywordListSnapshot!.docs.length ${_postKeywordListSnapshot!.docs.length}");
      if (_pollKeywordListSnapshot!.docs.length < paginationLengthKeyword ||
          paginationLengthKeyword * pollKeywordListCount == snap.count) {
        pollKeywordLast = true;
      }
      // debugPrint("poll Keyword Last : $pollKeywordLast");
      Loading = false;
      notifyListeners();
      // setState(() {});
    } catch (e) {
      // debugPrint("Got Error While Trying to fetch posts Keywords listing ::: $st");
    }
  }

  bool? getNextListSearchMeassage;
  List<MostLikedKeywords> searchResult = [];
  Future<void> getsearchData(String text, String global, String countryCode,
      {bool? getnextPage}) async {
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      // var datalist = querySnapshot.docs;

      searchResult.clear();
      querySnapshot.docs.forEach((element) {
        MostLikedKeywords dataIn =
            MostLikedKeywords.fromJson(element.data() as Map<String, dynamic>);
        searchResult.add(dataIn);
      });
    }

    var query1 = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLikedKeywordPosts')
            : FirebaseFirestore.instance
                .collection('mostLikedKeywordByCountry')
                .doc(countryCode)
                .collection("mostLikedPostKeywordByCountry")
                .where("country", isEqualTo: countryCode))
        .where("global", isEqualTo: global)
        .where('searchList', arrayContains: text)
        .orderBy("length", descending: true);

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      var snap = await query1.count().get();
      if (getnextPage != null) {
        if (getnextPage) {
          postKeywordListCount += 1;

          query1
              .startAfterDocument(_postKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .snapshots()
              .listen((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _postKeywordListSnapshot = await query1
              .startAfterDocument(_postKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .get();
        } else {
          postKeywordListCount -= 1;

          await query1
              .endBeforeDocument(_postKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .snapshots()
              .listen((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _postKeywordListSnapshot = await query1
              .endBeforeDocument(_postKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .get();
        }
      } else {
        postKeywordListCount = 1;

        await query1.limit(paginationLengthKeyword).get().then(
            (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));
        _postKeywordListSnapshot =
            await query1.limit(paginationLengthKeyword).get();
      }
      postKeywordLast = false;
      // debugPrint(
      //     "_postKeywordListSnapshot!.docs.length ${_postKeywordListSnapshot!.docs.length}");
      if (_postKeywordListSnapshot!.docs.length < paginationLengthKeyword ||
          paginationLengthKeyword * postKeywordListCount == snap.count) {
        postKeywordLast = true;
      }
      // debugPrint("Search Post Keyword Last : $postKeywordLast");
      // setState(() {});
      Loading = false;
      notifyListeners();
    } catch (e) {
      // debugPrint("Got Error While Trying to fetch posts Keywords listing ::: $st");
    }
  }

  // bool? getKeyNextListSearchMeassage;
  List<MostLikedKeywords> keypostList = [];
  Future<void> getPostKeyData(String text, String global, String countryCode,
      {bool? getnextPage}) async {
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      // var datalist = querySnapshot.docs;

      keypostList.clear();
      querySnapshot.docs.forEach((element) {
        MostLikedKeywords dataIn =
            MostLikedKeywords.fromJson(element.data() as Map<String, dynamic>);
        keypostList.add(dataIn);
      });
    }

    var query1 = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLikedKeywordPosts')
            : FirebaseFirestore.instance
                .collection('mostLikedKeywordByCountry')
                .doc(countryCode)
                .collection("mostLikedPostKeywordByCountry")
                .where("country", isEqualTo: countryCode))
        .where("global", isEqualTo: global)
        .where('keyName', isEqualTo: text)
        .orderBy("length", descending: true);

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }

      await query1.limit(paginationLengthKeyword).get().then(
          (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));

      Loading = false;
      notifyListeners();
    } catch (e) {
      // debugPrint("Got Error While Trying to fetch posts Keywords listing ::: $st");
    }
  }

//  bool? getKeyNextListSearchMeassage;
  List<MostLikedKeywords> keypollList = [];
  Future<void> getPollKeyData(String text, String global, String countryCode,
      {bool? getnextPage}) async {
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      // var datalist = querySnapshot.docs;

      keypollList.clear();
      querySnapshot.docs.forEach((element) {
        MostLikedKeywords dataIn =
            MostLikedKeywords.fromJson(element.data() as Map<String, dynamic>);
        keypollList.add(dataIn);
      });
    }

    var query1 = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLikedKeywordPolls')
            : FirebaseFirestore.instance
                .collection('mostLikedKeywordByCountry')
                .doc(countryCode)
                .collection("mostLikedPollsKeywordByCountry")
                .where("country", isEqualTo: countryCode))
        .where("global", isEqualTo: global)
        .where('keyName', isEqualTo: text)
        .orderBy("length", descending: true);

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }

      await query1.limit(paginationLengthKeyword).get().then(
          (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));

      Loading = false;
      notifyListeners();
    } catch (e) {
      // print("Got Error While Trying to fetch posts Keywords listing ::: $st");
    }
  }

  bool? getNextListSearchPoll;
  List<MostLikedKeywords> searchResultPoll = [];
  Future<void> getsearchDataPoll(String text, String global, String countryCode,
      {bool? getnextPage}) async {
    dynamic handleQueryResult(QuerySnapshot querySnapshot) {
      // var datalist = querySnapshot.docs;
      searchResultPoll.clear();
      querySnapshot.docs.forEach((element) {
        MostLikedKeywords dataIn =
            MostLikedKeywords.fromJson(element.data() as Map<String, dynamic>);
        searchResultPoll.add(dataIn);
      });
    }

    var query1 = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLikedKeywordPolls')
            : FirebaseFirestore.instance
                .collection('mostLikedKeywordByCountry')
                .doc(countryCode)
                .collection("mostLikedPollsKeywordByCountry")
                .where("country", isEqualTo: countryCode))
        .where("global", isEqualTo: global)
        .where('searchList', arrayContains: text)
        .orderBy("length", descending: true);

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      var snap = await query1.count().get();
      if (getnextPage != null) {
        if (getnextPage) {
          pollKeywordListCount += 1;

          query1
              .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _pollKeywordListSnapshot = await query1
              .startAfterDocument(_pollKeywordListSnapshot!.docs.last)
              .limit(paginationLengthKeyword)
              .get();
        } else {
          pollKeywordListCount -= 1;

          await query1
              .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .get()
              .then((QuerySnapshot querySnapshot) =>
                  handleQueryResult(querySnapshot));
          _pollKeywordListSnapshot = await query1
              .endBeforeDocument(_pollKeywordListSnapshot!.docs.first)
              .limitToLast(paginationLengthKeyword)
              .get();
        }
      } else {
        pollKeywordListCount = 1;

        await query1.limit(paginationLengthKeyword).get().then(
            (QuerySnapshot querySnapshot) => handleQueryResult(querySnapshot));
        _pollKeywordListSnapshot =
            await query1.limit(paginationLengthKeyword).get();
      }
      pollKeywordLast = false;
      // debugPrint(
      //     "_postKeywordListSnapshot!.docs.length ${_postKeywordListSnapshot!.docs.length}");
      if (_pollKeywordListSnapshot!.docs.length < paginationLengthKeyword ||
          paginationLengthKeyword * pollKeywordListCount == snap.count) {
        pollKeywordLast = true;
      }
      // debugPrint(
      //     "Poll Keyword Last : $pollKeywordLast  ${_pollKeywordListSnapshot!.docs.length} snap ${snap.count}");
      Loading = false;
      notifyListeners();
      // setState(() {});
    } catch (e) {
      // debugPrint("Got Error While Trying to fetch posts Keywords listing ::: $st");
    }
  }

  List<Post> postsList = [];
  int postPageCount = 0;
  bool onPostsLastPage = false;
  QuerySnapshot<Map<String, dynamic>>? _postsSnapshot;
  StreamSubscription? loadDataStream;
  StreamController<Post> updatingStream = StreamController.broadcast();
  ScrollController scrollController = ScrollController();

  List<Poll> pollsList = [];
  int pollPageCount = 0;
  bool onPollLastPage = false;
  QuerySnapshot<Map<String, dynamic>>? _pollsSnapshot;

  StreamSubscription? loadDataStreamPoll;
  StreamController<Poll> updatingStreamPoll = StreamController.broadcast();

  bool previousButtonVisible = false;
  bool nextButtonVisible = false;

  initList(String trendKey, String global, String countryCode, String oneValue,
      {bool? getNextList, String? keyWord}) async {
    if (loadDataStream != null) {
      loadDataStream!.cancel();
      postsList = [];
      nextButtonVisible = false;
      previousButtonVisible = false;
      // setState(() {});
    }

    var query = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLiked')
            : FirebaseFirestore.instance
                .collection('mostLikedByCountry')
                .doc(countryCode)
                .collection("mostLiked")
                .where("country", isEqualTo: countryCode))
        .where("global", isEqualTo: global)
        .where('reportRemoved', isEqualTo: false)
        .where("tagsLowerCase", arrayContains: trendKey)
        .orderBy(oneValue == "Highest Score" ? "score" : "datePublished",
            descending: true);

    void handleListenerEvents(event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            postsList.add(Post.fromMap({
              ...change.doc.data()!,
              'updatingStream': updatingStream
            })); // we are adding to a local list when the element is added in firebase collection
            break; //the Post element we will send on pair with updatingStream, because a Post constructor makes a listener on a stream.
          case DocumentChangeType.modified:
            updatingStream.add(Post.fromMap({
              ...change.doc.data()!
            })); // we are sending a modified object in the stream.
            break;
          case DocumentChangeType.removed:
            postsList.remove(Post.fromMap({
              ...change.doc.data()!
            })); // we are removing a Post object from the local list.
            break;
        }
      }
    }

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      var snap = await query.count().get();
      if (getNextList != null) {
        if (getNextList) {
          postPageCount += 1;
          loadDataStream = query
              .startAfterDocument(_postsSnapshot!.docs.last)
              .limit(paginationLength)
              .snapshots()
              .listen((event) {
            handleListenerEvents(event);
          });

          _postsSnapshot = await query
              .startAfterDocument(_postsSnapshot!.docs.last)
              .limit(paginationLength)
              .get();
        } else {
          postPageCount -= 1;
          loadDataStream = query
              .endBeforeDocument(_postsSnapshot!.docs.first)
              .limitToLast(paginationLength)
              .snapshots()
              .listen((event) {
            handleListenerEvents(event);
          });
          _postsSnapshot = await query
              .endBeforeDocument(_postsSnapshot!.docs.first)
              .limitToLast(paginationLength)
              .get();
        }
      } else {
        postPageCount = 1;
        loadDataStream =
            query.limit(paginationLength).snapshots().listen((event) {
          handleListenerEvents(event);
        });
        _postsSnapshot = await query.limit(paginationLength).get();
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (postPageCount > 1) {
          previousButtonVisible = true;
        }

        if (_postsSnapshot!.docs.length < paginationLength ||
            paginationLength * postPageCount == snap.count) {
          onPostsLastPage = true;
          nextButtonVisible = false;
        } else {
          onPostsLastPage = false;
          nextButtonVisible = true;
        }
        // _scrollController.animateTo(0.0,
        //     duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        Loading = false;
        notifyListeners();
      });

      // debugPrint(
      //     "postCount:: $postCount \n postLast:: $postLast \n _postsSnapshot::: ${_postsSnapshot!.docs.first.data()}");
    } catch (e) {
      // print("Got Error While Trying to fetch doc ::: $st");
    }
  }

  bool get _nextButtonVisible => nextButtonVisible;
  initPollList(
      String trendKey, String global, String countryCode, String oneValue,
      {bool? getNextList}) async {
    if (loadDataStreamPoll != null) {
      loadDataStreamPoll!.cancel();
      pollsList = [];
      previousButtonVisible = false;
      nextButtonVisible = false;
    }
    var query = (global == "true"
            ? FirebaseFirestore.instance.collection('mostLikedPolls')
            : FirebaseFirestore.instance
                .collection('mostLikedByCountryPolls')
                .doc(countryCode)
                .collection("mostLiked"))
        .where("global", isEqualTo: global)
        .where("tagsLowerCase", arrayContains: trendKey)
        .orderBy(oneValue == "Highest Score" ? "totalVotes" : "datePublished",
            descending: true);

    void handleListenerEvents(event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            pollsList.add(Poll.fromMap({
              ...change.doc.data()!,
              'updatingStreamPoll': updatingStreamPoll
            })); // we are adding to a local list when the element is added in firebase collection
            break; //the Post element we will send on pair with updatingStream, because a Post constructor makes a listener on a stream.
          case DocumentChangeType.modified:
            updatingStreamPoll.add(Poll.fromMap({
              ...change.doc.data()!
            })); // we are sending a modified object in the stream.
            break;
          case DocumentChangeType.removed:
            pollsList.remove(Poll.fromMap({
              ...change.doc.data()!
            })); // we are removing a Post object from the local list.
            break;
        }
      }
      // setState(() {
      // trendkeystore = trendKey;
      // });
    }

    try {
      if (Loading == false) {
        await Future.delayed(Duration.zero);
        Loading = true;
        notifyListeners();
      }
      var snap = await query.count().get();

      if (getNextList != null) {
        if (getNextList) {
          pollPageCount += 1;
          loadDataStreamPoll = query
              .startAfterDocument(_pollsSnapshot!.docs.last)
              .limit(paginationLength)
              .snapshots()
              .listen((event) {
            handleListenerEvents(event);
          });
          // _pollsSnapshot!.docs.clear();
          _pollsSnapshot = await query
              .startAfterDocument(_pollsSnapshot!.docs.last)
              .limit(paginationLength)
              .get();
        } else {
          pollPageCount -= 1;
          loadDataStreamPoll = query
              .endBeforeDocument(_pollsSnapshot!.docs.first)
              .limitToLast(paginationLength)
              .snapshots()
              .listen((event) {
            handleListenerEvents(event);
          });
          // _pollsSnapshot!.docs.clear();
          _pollsSnapshot = await query
              .endBeforeDocument(_pollsSnapshot!.docs.first)
              .limitToLast(paginationLength)
              .get();
        }
      } else {
        pollPageCount = 1;
        loadDataStreamPoll =
            query.limit(paginationLength).snapshots().listen((event) {
          handleListenerEvents(event);
        });
        // _pollsSnapshot!.docs.clear();
        _pollsSnapshot = await query.limit(paginationLength).get();
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (pollPageCount > 1) {
          previousButtonVisible = true;
        }

        if (_pollsSnapshot!.docs.length < paginationLength ||
            paginationLength * pollPageCount == snap.count) {
          onPollLastPage = true;
          nextButtonVisible = false;
        } else {
          onPollLastPage = false;
          nextButtonVisible = true;
        }

        // _scrollController.animateTo(0.0,
        //     duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        // setState(() {});
        Loading = false;
        notifyListeners();
      });
    } catch (e) {
      // print("Got Error While Trying to fetch doc ::: $st");
    }
  }

  plusPost(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(postsList, postId);
      // bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = postsList.where((element) => element.postId == postId).first;
      }
      // else if (userPostListContainsPost) {
      //   post = _userPosts.where((element) => element.postId == postId).first;
      // }
      if (post != null && post.plus.contains(uid)) {
        post.score--;
        post.plus.removeWhere((element) => element == uid);
        post.plusCount--;
        post.votesUIDs.removeWhere((element) => element == uid);
      } else if (post != null && post.neutral.contains(uid)) {
        post.score++;
        post.plus.add(uid);
        post.plusCount++;
        post.neutral.removeWhere((element) => element == uid);
        post.neutralCount--;
        post.votesUIDs.add(uid);
      } else if (post != null && post.minus.contains(uid)) {
        post.score += 2;
        post.plus.add(uid);
        post.plusCount++;
        post.minus.removeWhere((element) => element == uid);
        post.minusCount--;
        post.votesUIDs.add(uid);
      } else {
        post?.score++;
        post?.plus.add(uid);
        post?.plusCount++;
        post?.votesUIDs.add(uid);
      }
      if (post != null) {
        checkItemIndexAndUpdateInList(postsList, post);
        checkItemIndexAndUpdateInList(postsList, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }

      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  checkItemIndexAndUpdateInList(List<dynamic> list, dynamic item) {
    int? postIndex =
        list.indexWhere((element) => element.postId == item.postId);
    if (postIndex != -1) {
      list[postIndex] = item;
    }
  }

  bool elementFoundInList(List<Post> list, String postId) {
    bool foundInList = false;
    for (var element in list) {
      if (element.postId == postId) {
        foundInList = true;
      }
    }
    return foundInList;
  }

  bool elementFoundInpollList(List<Poll> list, String pollId) {
    bool foundInList = false;
    for (var element in list) {
      if (element.pollId == pollId) {
        foundInList = true;
      }
    }
    return foundInList;
  }

  List<Poll> _userPollsList = [];

  updatePollRealTime(Poll poll) async {
    await Future.delayed(Duration.zero);
    try {
      bool? elementFoundInPollList =
          elementFoundInpollList(pollsList, poll.pollId);
      bool? elementFoundInUserPollList =
          elementFoundInpollList(_userPollsList, poll.pollId);

      // debugPrint("elementFoundInPollList $elementFoundInPollList");
      // debugPrint("elementFoundInUserPollList $elementFoundInUserPollList");

      if (elementFoundInPollList) {
        pollsList[pollsList.indexOf(pollsList
            .firstWhere((element) => poll.pollId == element.pollId))] = poll;
      }
      if (elementFoundInUserPollList) {
        _userPollsList[_userPollsList.indexOf(_userPollsList
            .firstWhere((element) => poll.pollId == element.pollId))] = poll;
      }
      notifyListeners();
    } catch (e) {
      // debugPrint("Got Error While Getting Element From List $st");
    }
  }

  updatePoll(String pollId, String? uid, int optionIndex) {
    if (pollsList.isNotEmpty) {
      pollsList
          .firstWhere((element) => element.pollId == pollId)
          .votesUIDs
          .add(uid);
    }
    if (_userPollsList.isNotEmpty) {
      _userPollsList
          .firstWhere((element) => element.pollId == pollId)
          .votesUIDs
          .add(uid);
    }
    var poll;
    FirebaseFirestore.instance
        .collection("polls")
        .doc(pollId)
        .get()
        .then((value) {
      poll = Poll.fromMap(value.data()!);
      if (pollsList.isNotEmpty) {
        pollsList[pollsList.indexOf(
                pollsList.firstWhere((element) => element.pollId == pollId))] =
            poll;
      }
      if (_userPollsList.isNotEmpty) {
        _userPollsList[_userPollsList.indexOf(_userPollsList
            .firstWhere((element) => element.pollId == pollId))] = poll;
      }

      notifyListeners();
    });
    if (pollsList.isNotEmpty) {
      var uPoll = pollsList.firstWhere((element) => element.pollId == pollId);
      uPoll.votesUIDs.add(uid);
      uPoll.totalVotes++;
      uPoll.setVote(optionIndex, uid);
    }
    if (_userPollsList.isNotEmpty) {
      var userPoll =
          _userPollsList.firstWhere((element) => element.pollId == pollId);
      userPoll.votesUIDs.add(uid);
      userPoll.totalVotes++;
      userPoll.setVote(optionIndex, uid);
    }
    // searchpollcard = true;
    notifyListeners();
  }

  minusPost(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(postsList, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = postsList.where((element) => element.postId == postId).first;
      } else if (userPostListContainsPost) {
        post = _userPosts.where((element) => element.postId == postId).first;
      }
      if (post != null && post.minus.contains(uid)) {
        post.score++;
        post.minus.removeWhere((element) => element == uid);
        post.minusCount--;
        post.votesUIDs.removeWhere((element) => element == uid);
      } else if (post != null && post.neutral.contains(uid)) {
        post.score--;
        post.minus.add(uid);
        post.minusCount++;
        post.neutral.removeWhere((element) => element == uid);
        post.neutralCount--;
        post.votesUIDs.add(uid);
      } else if (post != null && post.plus.contains(uid)) {
        post.score -= 2;
        post.minus.add(uid);
        post.minusCount++;
        post.plus.removeWhere((element) => element == uid);
        post.plusCount--;
        post.votesUIDs.add(uid);
      } else {
        post?.score--;
        post?.minus.add(uid);
        post?.minusCount++;
        post?.votesUIDs.add(uid);
      }
      if (post != null) {
        checkItemIndexAndUpdateInList(postsList, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      // searchTabcard = true;
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  neutralPost(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(postsList, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = postsList.where((element) => element.postId == postId).first;
      } else if (userPostListContainsPost) {
        post = _userPosts.where((element) => element.postId == postId).first;
      }
      if (post != null && post.neutral.contains(uid)) {
        post.neutral.removeWhere((element) => element == uid);
        post.neutralCount--;
        post.votesUIDs.removeWhere((element) => element == uid);
      } else if (post != null && post.plus.contains(uid)) {
        post.score--;
        post.neutral.add(uid);
        post.neutralCount++;
        post.plus.removeWhere((element) => element == uid);
        post.plusCount--;
        post.votesUIDs.add(uid);
        //   batch.commit();
      } else if (post != null && post.minus.contains(uid)) {
        post.score++;
        post.neutral.add(uid);
        post.neutralCount++;
        post.minus.removeWhere((element) => element == uid);
        post.minusCount--;
        post.votesUIDs.add(uid);
      } else {
        post?.neutral.add(uid);
        post?.neutralCount++;
        post?.votesUIDs.add(uid);
      }
      if (post != null) {
        checkItemIndexAndUpdateInList(postsList, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      // searchTabcard = true;
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }
}
