import 'dart:async';

import 'package:aft/ATESTS/provider/postPoll_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../utils/global_variables.dart';
import 'filter_provider.dart';

class PostProvider extends ChangeNotifier {
  Post? _mostLikedPost;
  List<Post> _mostLikedPosts = [];
  List<Post> _posts = [];
  List<Post> _userPosts = [];
  List<Post> _submissionScore = [];
  List<Post> _submissionDate = [];

  int _count = 0;
  bool _last = false;
  bool _userPostLast = false;
  bool _userPostLastDate = false;
  bool _userPostLastScore = false;
  bool _getPostBeingCalled = false;
  bool _getUserPostBeingCalled = false;
  bool _getUserPostBeingCalledScore = false;
  Post? _postSitterValue;

  bool _isButtonVisible = false;

  QuerySnapshot<Map<String, dynamic>>? _mostLikePostsSnapshot;
  QuerySnapshot<Map<String, dynamic>>? _postsSnapshot;
  QuerySnapshot<Map<String, dynamic>>? _userPostSnapshot;
  QuerySnapshot<Map<String, dynamic>>? _userPostSnapshotScore;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _snapshotListener;

  final _postPollProvider = Provider.of<PostPollProvider>(
      navigatorKey.currentContext!,
      listen: false);

  final bool _postsLoading = false;
  final bool _loading = false;
  bool _pLoading = false;
  bool _pageLoading = false;
  bool _pLoadingScore = false;
  bool _pageLoadingScore = false;
  bool _postPageLoading = false;
  final int _pageSize = 6;

  final ScrollController _postScrollController = ScrollController();

  startScrollListener() {
    _postScrollController.addListener(postNextScroll);
  }

  setButtonVisibility() async {
    await Future.delayed(const Duration(seconds: 1));
    _isButtonVisible = true;
    notifyListeners();
  }

  postNextScroll() {
    final filterProvider = Provider.of<FilterProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (_postScrollController.position.extentAfter < 1) {
      getNextPosts(
          filterProvider.twoValue,
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.durationInDay,
          filterProvider.oneValue);
    }
  }

  stopListener() {
    _postScrollController.removeListener(() {});
  }

  final db = FirebaseFirestore.instance;

  getPosts(String twoValue, String global, String countryCode,
      int durationInDay, String oneValue) async {
    try {
      debugPrint("working oneValue$oneValue ");
      //  _posts = [];

      debugPrint('two values : $twoValue');
      await Future.delayed(Duration.zero);
      _isButtonVisible = false;
      _pLoading = true;
      notifyListeners();
      // durationInDay = await DurationProvider.getDurationInDays();
      var query = (twoValue == "All Days"
          ?
          // "All Days"
          (global == "true"
                  ? FirebaseFirestore.instance.collection('posts')
                  : FirebaseFirestore.instance
                      .collection('posts')
                      .where("country", isEqualTo: countryCode))
              .where("global", isEqualTo: global)
              .where('reportRemoved', isEqualTo: false)
              .where('time', whereIn: [
              durationInDay - 0,
              durationInDay - 1,
              durationInDay - 2,
              durationInDay - 3,
              durationInDay - 4,
              durationInDay - 5,
              durationInDay - 6,
            ]).orderBy(oneValue == "Highest Score" ? "score" : "datePublished",
                  //    descending: oneValue == 'Highest Score' ? true : false)
                  descending: true)
          :
          // NOT "All Days"
          (global == "true"
                  ? FirebaseFirestore.instance.collection('posts')
                  : FirebaseFirestore.instance
                      .collection('posts')
                      .where("country", isEqualTo: countryCode))
              .where("global", isEqualTo: global)
              .where('reportRemoved', isEqualTo: false)
              .where('time',
                  // isEqualTo: widget.durationInDay
                  isEqualTo: twoValue == '≤ 1 Day'
                      ? durationInDay - 6
                      : twoValue == '≤ 2 Days'
                          ? durationInDay - 5
                          : twoValue == '≤ 3 Days'
                              ? durationInDay - 4
                              : twoValue == '≤ 4 Days'
                                  ? durationInDay - 3
                                  : twoValue == '≤ 5 Days'
                                      ? durationInDay - 2
                                      : twoValue == '≤ 6 Days'
                                          ? durationInDay - 1
                                          : durationInDay)
              .orderBy(oneValue == "Highest Score" ? "score" : "datePublished",
                  //  descending: true
                  // descending: oneValue == 'Highest Score' ? true : false
                  //  'score',
                  descending: true));

      var snap = await query.count().get();
      // debugPrint('count is ${snap.count}');

      // debugPrint("getPost working");
      if (!_getPostBeingCalled) {
        _getPostBeingCalled = true;
        notifyListeners();
        // debugPrint(
        //     'getPosts two val: $twoValue\n global $global\n country $countryCode\n duration $durationInDay\n one val $oneValue');

        // debugPrint('get posts called with page size ${_pageSize}');

        Future.delayed(Duration.zero);
        _postsSnapshot = await query.limit(_pageSize).get();

        // debugPrint('getPost query executed');
        _posts = _postsSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();
        // debugPrint("all post length  : ${_posts.length}");
        //  if (_posts.isNotEmpty) {
        _count = 1;
        _last = false;
        if (_posts.length < _pageSize || _pageSize == snap.count) {
          _last = true;
        }
        // debugPrint('count value ${_count}');
        // // }
        // debugPrint('post length ${_posts.length}');
      }
    } catch (e) {
      // debugPrint('PostProvider getPosts error $e $st');
    } finally {
      _getPostBeingCalled = false;
      _pLoading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getNextPosts(
    String twoValue,
    String global,
    String countryCode,
    int durationInDay,
    String oneValue,
  ) async {
    try {
      if (_last) {
        return;
      }
      // debugPrint(
      //     'one value at pagination $oneValue $twoValue $durationInDay $countryCode');
      if (_postsSnapshot != null &&
          _postsSnapshot!.docs.isNotEmpty &&
          _pLoading != true &&
          _postPageLoading != true) {
        if (oneValue == 'Highest Score') {
          _pLoading = true;
        } else {
          _postPageLoading = true;
          _pLoading = true;
        }
        notifyListeners();
        await Future.delayed(Duration.zero);
        // durationInDay = await DurationProvider.getDurationInDays();
        // debugPrint('last ${_postsSnapshot!.docs.last.data()}');
        var query = (twoValue == "All Days"
                ? (global == "true"
                        ? FirebaseFirestore.instance.collection('posts')
                        : FirebaseFirestore.instance
                            .collection('posts')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time', whereIn: [
                    durationInDay - 0,
                    durationInDay - 1,
                    durationInDay - 2,
                    durationInDay - 3,
                    durationInDay - 4,
                    durationInDay - 5,
                    durationInDay - 6,
                    // durationInDay - 7,
                  ])
                    // .where('time', isGreaterThanOrEqualTo: durationInDay - 6)
                    // .orderBy('time')
                    .orderBy(
                        oneValue == "Highest Score" ? "score" : "datePublished",
                        //  descending: oneValue == 'Highest Score' ? true : false)
                        descending: true)
                : (global == "true"
                        ? FirebaseFirestore.instance.collection('posts')
                        : FirebaseFirestore.instance
                            .collection('posts')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time',
                        // isEqualTo: widget.durationInDay
                        isEqualTo: twoValue == '≤ 1 Day'
                            ? durationInDay - 6
                            : twoValue == '≤ 2 Days'
                                ? durationInDay - 5
                                : twoValue == '≤ 3 Days'
                                    ? durationInDay - 4
                                    : twoValue == '≤ 4 Days'
                                        ? durationInDay - 3
                                        : twoValue == '≤ 5 Days'
                                            ? durationInDay - 2
                                            : twoValue == '≤ 6 Days'
                                                ? durationInDay - 1
                                                : durationInDay)
                    .orderBy(
                        oneValue == "Highest Score" ? "score" : "datePublished",
                        descending: true))
            //  descending: oneValue == 'Highest Score' ? true : false))
            .startAfterDocument(_postsSnapshot!.docs.last);

        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();
        //debugPrint('next post snap size ${snap.count}');
        // debugPrint('last name ${_postsSnapshot!.docs.last.data()}');
        // debugPrint('next data length ${data.docs.length}');
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count++;
          // debugPrint('count value $_count');
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
            // debugPrint('last is true');
          }
        } else {
          _last = false;
        }

        if (oneValue == 'Highest Score') {
          _posts =
              _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
        } else {
          // _posts =  _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
          _posts =
              _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
        }
        // _posts =
        //     _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostPosts error $e $st');
    } finally {
      _postPageLoading = false;
      _pLoading = false;
      notifyListeners();
    }
  }

  getPreviousPosts(String twoValue, String global, String countryCode,
      int durationInDay, String oneValue) async {
    try {
      // print(""
      //     " twoValue: $twoValue"
      //     " global: $global"
      //     " countryCode: $countryCode"
      //     " durationInDay: $durationInDay"
      //     " oneValue: $oneValue"
      //     "");

      // debugPrint('previous ${_postsSnapshot?.docs.length}');
      if (_postsSnapshot != null
          //  && oneValue == 'Highest Score'
          ) {
        _pLoading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        // durationInDay = await DurationProvider.getDurationInDays();
        var data = await (twoValue == "All Days"
                ? (global == "true"
                        ? FirebaseFirestore.instance.collection('posts')
                        : FirebaseFirestore.instance
                            .collection('posts')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time', whereIn: [
                    durationInDay - 0,
                    durationInDay - 1,
                    durationInDay - 2,
                    durationInDay - 3,
                    durationInDay - 4,
                    durationInDay - 5,
                    durationInDay - 6,
                    // durationInDay - 7,
                  ])
                    // .where('time', isGreaterThanOrEqualTo: durationInDay - 6)
                    // .orderBy('time', descending: true)
                    .orderBy(
                        oneValue == "Highest Score" ? "score" : "datePublished",
                        descending: true)
                : (global == "true"
                        ? FirebaseFirestore.instance.collection('posts')
                        : FirebaseFirestore.instance
                            .collection('posts')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time',
                        // isEqualTo: widget.durationInDay
                        isEqualTo: twoValue == '≤ 1 Day'
                            ? durationInDay - 6
                            : twoValue == '≤ 2 Days'
                                ? durationInDay - 5
                                : twoValue == '≤ 3 Days'
                                    ? durationInDay - 4
                                    : twoValue == '≤ 4 Days'
                                        ? durationInDay - 3
                                        : twoValue == '≤ 5 Days'
                                            ? durationInDay - 2
                                            : twoValue == '≤ 6 Days'
                                                ? durationInDay - 1
                                                : durationInDay)
                    .orderBy(
                        oneValue == "Highest Score" ? "score" : "datePublished",
                        descending: true))
            .endBeforeDocument(_postsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count--;
          _last = false;
        }
        // debugPrint('post snap ${_postsSnapshot!.docs.length}');
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getPreviousMessage error $e $st');
    } finally {
      _pLoading = false;
      notifyListeners();
    }
  }

  getUpdatePost(String postId, int index) async {
    var post;
    try {
      //           post,
      //       notifyListeners(),
      //
      //    Future.delayed(Duration(seconds:0));
      //    db.collection('posts').doc(postId).get()
      //  db.collection("posts").doc(postId).get().then((value) => {
      // debugPrint("update Working ${value.data()}"),
      //       post = Post.fromMap(value.data()!),
      //       debugPrint("index $postId doc index ${value.id}"),
      //       // _posts.firstWhere((element) => element==postId)=post;
      //       _posts[_posts.indexWhere((element) => element.postId == postId)] =
      //           post,
      //       notifyListeners(),
      //       debugPrint(" value is ${value.data()}")
      //     });
    } catch (e) {
      // debugPrint("getUpdatePost error : $e $st");
    } finally {
      notifyListeners();
    }
    //notifyListeners();
  }

  neutralPost(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(_posts, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = _posts.where((element) => element.postId == postId).first;
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
        checkItemIndexAndUpdateInList(_posts, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  neutralPostUnverified(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(_posts, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = _posts.where((element) => element.postId == postId).first;
      } else if (userPostListContainsPost) {
        post = _userPosts.where((element) => element.postId == postId).first;
      }
      if (post != null && post.neutral.contains(uid)) {
        post.neutral.removeWhere((element) => element == uid);
        // post.neutralCount--;
        post.votesUIDs.removeWhere((element) => element == uid);
      } else if (post != null && post.plus.contains(uid)) {
        // post.score--;
        post.neutral.add(uid);
        // post.neutralCount++;
        post.plus.removeWhere((element) => element == uid);
        // post.plusCount--;
        post.votesUIDs.add(uid);
        //   batch.commit();
      } else if (post != null && post.minus.contains(uid)) {
        // post.score++;
        post.neutral.add(uid);
        // post.neutralCount++;
        post.minus.removeWhere((element) => element == uid);
        // post.minusCount--;
        post.votesUIDs.add(uid);
      } else {
        post?.neutral.add(uid);
        // post?.neutralCount++;
        post?.votesUIDs.add(uid);
      }
      if (post != null) {
        checkItemIndexAndUpdateInList(_posts, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  minusPost(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(_posts, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = _posts.where((element) => element.postId == postId).first;
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
        checkItemIndexAndUpdateInList(_posts, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  minusPostUnverified(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(_posts, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = _posts.where((element) => element.postId == postId).first;
      } else if (userPostListContainsPost) {
        post = _userPosts.where((element) => element.postId == postId).first;
      }
      if (post != null && post.minus.contains(uid)) {
        // post.score++;
        post.minus.removeWhere((element) => element == uid);
        // post.minusCount--;
        post.votesUIDs.removeWhere((element) => element == uid);
      } else if (post != null && post.neutral.contains(uid)) {
        // post.score--;
        post.minus.add(uid);
        // post.minusCount++;
        post.neutral.removeWhere((element) => element == uid);
        // post.neutralCount--;
        post.votesUIDs.add(uid);
      } else if (post != null && post.plus.contains(uid)) {
        // post.score -= 2;
        post.minus.add(uid);
        // post.minusCount++;
        post.plus.removeWhere((element) => element == uid);
        // post.plusCount--;
        post.votesUIDs.add(uid);
      } else {
        // post?.score--;
        post?.minus.add(uid);
        // post?.minusCount++;
        post?.votesUIDs.add(uid);
      }
      if (post != null) {
        checkItemIndexAndUpdateInList(_posts, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  plusPostUnverified(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(_posts, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = _posts.where((element) => element.postId == postId).first;
      } else if (userPostListContainsPost) {
        post = _userPosts.where((element) => element.postId == postId).first;
      }
      if (post != null && post.plus.contains(uid)) {
        // post.score--;
        post.plus.removeWhere((element) => element == uid);
        // post.plusCount--;
        post.votesUIDs.removeWhere((element) => element == uid);
      } else if (post != null && post.neutral.contains(uid)) {
        // post.score++;
        post.plus.add(uid);
        // post.plusCount++;
        post.neutral.removeWhere((element) => element == uid);
        // post.neutralCount--;
        post.votesUIDs.add(uid);
      } else if (post != null && post.minus.contains(uid)) {
        // post.score += 2;
        post.plus.add(uid);
        // post.plusCount++;
        post.minus.removeWhere((element) => element == uid);
        // post.minusCount--;
        post.votesUIDs.add(uid);
      } else {
        // post?.score++;
        post?.plus.add(uid);
        // post?.plusCount++;
        post?.votesUIDs.add(uid);
      }
      if (post != null) {
        checkItemIndexAndUpdateInList(_posts, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  plusPost(postId, uid) {
    try {
      Post? post;
      bool postListContainsPost = elementFoundInList(_posts, postId);
      bool userPostListContainsPost = elementFoundInList(_userPosts, postId);
      if (postListContainsPost) {
        post = _posts.where((element) => element.postId == postId).first;
      } else if (userPostListContainsPost) {
        post = _userPosts.where((element) => element.postId == postId).first;
      }
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
        checkItemIndexAndUpdateInList(_posts, post);
        checkItemIndexAndUpdateInList(_userPosts, post);
        _postPollProvider.updatePostPollCombinedList(post: post);
      }
      notifyListeners();
    } catch (e) {
      // debugPrint('error $e $st');
    }
  }

  // dynamic elementConditionMatch(List<dynamic> list, String postId,
  //     {bool isPostPollType = false}) {
  //   try {
  //     if (isPostPollType) {
  //       PostPoll postPoll =
  //           list.where((element) => element.postOrPollId == postId).first;
  //       return postPoll.post;
  //     } else {
  //       return list.where((element) => element.postId == postId).first;
  //     }
  //   } catch (e) {
  //     print("No Element Found Return Null");
  //     return null;
  //   }
  // }

  bool elementFoundInList(List<Post> list, String postId) {
    bool foundInList = false;
    for (var element in list) {
      if (element.postId == postId) {
        foundInList = true;
      }
    }
    return foundInList;
  }

  checkItemIndexAndUpdateInList(List<dynamic> list, dynamic item) {
    int? postIndex =
        list.indexWhere((element) => element.postId == item.postId);
    if (postIndex != -1) {
      list[postIndex] = item;
    }
  }

  updatePost(Post post) async {
    checkItemIndexAndUpdateInList(_posts, post);
    checkItemIndexAndUpdateInList(_userPosts, post);
    await Future.delayed(Duration.zero);
    notifyListeners();
  }

  listenForChanges() async {
    final ref = db.collection("most_liked").limit(2);
    // await getMostLikedPosts();
    _snapshotListener = ref.snapshots().listen(
      (event) {
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              // debugPrint("New : ${change.doc.data()}");
              if (change.doc.data() != null) {
                Post post = Post.fromMap(change.doc.data()!);
                if (_mostLikedPosts.any((element) =>
                    element.postId != post.postId &&
                    post.time > element.time)) {
                  _mostLikedPosts.insert(0, post);
                }
              }
              break;
            case DocumentChangeType.modified:
              // debugPrint("modified : ${change.doc.data()}");
              if (change.doc.data() != null) {
                Post post = Post.fromMap(change.doc.data()!);
                _mostLikedPosts[_mostLikedPosts.indexOf(
                    _mostLikedPosts.firstWhere(
                        (element) => element.postId == post.postId))] = post;
                notifyListeners();
              }
              break;
            case DocumentChangeType.removed:
              if (change.doc.data() != null) {
                Post post = Post.fromMap(change.doc.data()!);
                _mostLikedPosts
                    .removeWhere((element) => element.postId == post.postId);
                notifyListeners();
              }
              // debugPrint("Removed : ${change.doc.data()}");
              break;
          }
        }
        // debugPrint("current data: ${event.docChanges}");
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );
  }

  closeListener() {
    _snapshotListener?.cancel();
  }

  // getSubmissionsScore() async {
  //   try {
  //     _pLoadingScore = true;
  //     notifyListeners();
  //     var query = (FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('reportRemoved', isEqualTo: false)
  //         .where('sub', isEqualTo: 'fairtalk')
  //         .orderBy('score', descending: true));
  //     var snap = await query.count().get();
  //     // debugPrint('count is ${snap.count}');
  //     if (!_getUserPostBeingCalledScore) {
  //       _getUserPostBeingCalledScore = true;
  //       Future.delayed(Duration.zero);
  //       _userPostSnapshotScore = await query.limit(_pageSize).get();
  //       _submissionScore =
  //           _userPostSnapshotScore!.docs.map((e) => Post.fromSnap(e)).toList();
  //       // debugPrint("user post length  : ${_posts.length}");
  //       _userPostLastScore = false;
  //       if (_submissionScore.length < _pageSize || _pageSize == snap.count) {
  //         _userPostLastScore = true;
  //       }
  //       // debugPrint('post length ${_userPosts.length}');
  //     }
  //   } catch (e) {
  //     // debugPrint('PostProvider getUserPost error $e $st');
  //   } finally {
  //     _getUserPostBeingCalledScore = false;
  //     _pLoadingScore = false;
  //     notifyListeners();
  //   }
  // }

  // getSubmissionsScoreNext() async {
  //   try {
  //     _pageLoadingScore = true;
  //     notifyListeners();
  //     var query = (FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('reportRemoved', isEqualTo: false)
  //         .where('sub', isEqualTo: 'fairtalk')
  //         .orderBy('datePublished', descending: true));
  //     var snap = await query.count().get();
  //     // debugPrint('count is ${snap.count}');
  //     if (!_getUserPostBeingCalledScore) {
  //       _getUserPostBeingCalledScore = true;
  //       Future.delayed(Duration.zero);
  //       _userPostSnapshotScore = await query
  //           .startAfterDocument(_userPostSnapshotScore!.docs.last)
  //           .limit(_pageSize)
  //           .get();
  //       _submissionScore.addAll(
  //           _userPostSnapshotScore!.docs.map((e) => Post.fromSnap(e)).toList());
  //       // debugPrint("user post length  : ${_userPosts.length}");
  //       _userPostLastScore = false;
  //       if (_submissionScore.length < _pageSize ||
  //           _submissionScore.length == snap.count) {
  //         _userPostLastScore = true;
  //       }
  //       // debugPrint('post length ${_userPosts.length}');
  //     }
  //   } catch (e) {
  //     // debugPrint('PostProvider getUserPost error $e $st');
  //   } finally {
  //     _getUserPostBeingCalledScore = false;
  //     _pageLoadingScore = false;
  //     notifyListeners();
  //   }
  // }

  // getMostLikedPosts() async {
  //   try {
  //     _loading = true;
  //     await Future.delayed(Duration.zero);
  //     notifyListeners();
  //     _mostLikePostsSnapshot = await db
  //         .collection('most_liked')
  //         .orderBy('time', descending: true)
  //         .limit(_pageSize)
  //         .get();
  //     _mostLikedPosts =
  //         _mostLikePostsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
  //     notifyListeners();
  //   } catch (e, st) {
  //     debugPrint('getMostLikedPosts error $e $st');
  //   } finally {
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }
  //
  // getNextMostLikedPosts() async {
  //   try {
  //     if (_mostLikePostsSnapshot != null) {
  //       _pageLoading = true;
  //       notifyListeners();
  //       await Future.delayed(Duration.zero);
  //       _mostLikePostsSnapshot = await db
  //           .collection('most_liked')
  //           .orderBy('time', descending: true)
  //           .startAfterDocument(_mostLikePostsSnapshot!.docs.last)
  //           .limit(_pageSize)
  //           .get();
  //       _mostLikedPosts.addAll(
  //           _mostLikePostsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList());
  //     }
  //   } catch (e, st) {
  //     debugPrint('getNextMostLikedPosts error $e $st');
  //   } finally {
  //     _pageLoading = false;
  //     notifyListeners();
  //   }
  // }
  //
  //
  // getMostLikedPost(int durationInDay) async {
  //   try {
  //     _loading = true;
  //
  //     /// this is for getting current most liked post
  //     // await Future.delayed(Duration.zero);
  //     // var post = await db
  //     //     .collection('posts')
  //     //     .where('time', isEqualTo: durationInDay - 1)
  //     //     .orderBy('score', descending: true)
  //     //     .limit(1).get();
  //     // if (post.docs.isNotEmpty) {
  //     //   _mostLikedPost = Post.fromMap(post.docs.first.data());
  //     // }
  //     //debugPrint('data ${_mostLikedPost?.score}');
  //   } catch (e, st) {
  //     debugPrint('getMostLikedPost error $e $st');
  //   } finally {
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }

  getUserPosts(String? userId) async {
    try {
      _pLoading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('posts')
          .where('reportRemoved', isEqualTo: false)
          .where('UID', isEqualTo: userId ?? '')
          .orderBy('datePublished', descending: true));
      var snap = await query.count().get();
      // debugPrint('count is ${snap.count}');
      if (!_getUserPostBeingCalled) {
        _getUserPostBeingCalled = true;
        Future.delayed(Duration.zero);
        _userPostSnapshot = await query.limit(_pageSize).get();
        _userPosts =
            _userPostSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();
        // debugPrint("user post length  : ${_posts.length}");
        _userPostLast = false;
        if (_userPosts.length < _pageSize || _pageSize == snap.count) {
          _userPostLast = true;
        }
        // debugPrint('post length ${_userPosts.length}');
      }
    } catch (e) {
      // debugPrint('PostProvider getUserPost error $e $st');
    } finally {
      _getUserPostBeingCalled = false;
      _pLoading = false;
      notifyListeners();
    }
  }

  getNextUserPosts(String? userId) async {
    try {
      _pageLoading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('posts')
          .where('reportRemoved', isEqualTo: false)
          .where('UID', isEqualTo: userId ?? '')
          .orderBy('datePublished', descending: true));
      var snap = await query.count().get();
      // debugPrint('count is ${snap.count}');
      if (!_getUserPostBeingCalled) {
        _getUserPostBeingCalled = true;
        Future.delayed(Duration.zero);
        _userPostSnapshot = await query
            .startAfterDocument(_userPostSnapshot!.docs.last)
            .limit(_pageSize)
            .get();
        _userPosts.addAll(
            _userPostSnapshot!.docs.map((e) => Post.fromSnap(e)).toList());
        // debugPrint("user post length  : ${_userPosts.length}");
        _userPostLast = false;
        if (_userPosts.length < _pageSize || _userPosts.length == snap.count) {
          _userPostLast = true;
        }
        // debugPrint('post length ${_userPosts.length}');
      }
    } catch (e) {
      // debugPrint('PostProvider getUserPost error $e $st');
    } finally {
      _getUserPostBeingCalled = false;
      _pageLoading = false;
      notifyListeners();
    }
  }

  // getSubmissionsDate() async {
  //   try {
  //     _pLoading = true;
  //     notifyListeners();
  //     var query = (FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('reportRemoved', isEqualTo: false)
  //         .where('sub', isEqualTo: 'fairtalk')
  //         .orderBy('datePublished', descending: true));
  //     var snap = await query.count().get();
  //     // debugPrint('count is ${snap.count}');
  //     if (!_getUserPostBeingCalled) {
  //       _getUserPostBeingCalled = true;
  //       Future.delayed(Duration.zero);
  //       _userPostSnapshot = await query.limit(_pageSize).get();
  //       _submissionDate =
  //           _userPostSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();
  //       // debugPrint("user post length  : ${_posts.length}");
  //       _userPostLastDate = false;
  //       if (_submissionDate.length < _pageSize || _pageSize == snap.count) {
  //         _userPostLastDate = true;
  //       }
  //       // debugPrint('post length ${_userPosts.length}');
  //     }
  //   } catch (e) {
  //     // debugPrint('PostProvider getUserPost error $e $st');
  //   } finally {
  //     _getUserPostBeingCalled = false;
  //     _pLoading = false;
  //     notifyListeners();
  //   }
  // }

  // getSubmissionsDateNext() async {
  //   try {
  //     _pageLoading = true;
  //     notifyListeners();
  //     var query = (FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('reportRemoved', isEqualTo: false)
  //         .where('sub', isEqualTo: 'fairtalk')
  //         .orderBy('datePublished', descending: true));
  //     var snap = await query.count().get();
  //     // debugPrint('count is ${snap.count}');
  //     if (!_getUserPostBeingCalled) {
  //       _getUserPostBeingCalled = true;
  //       Future.delayed(Duration.zero);
  //       _userPostSnapshot = await query
  //           .startAfterDocument(_userPostSnapshot!.docs.last)
  //           .limit(_pageSize)
  //           .get();
  //       _submissionDate.addAll(
  //           _userPostSnapshot!.docs.map((e) => Post.fromSnap(e)).toList());
  //       // debugPrint("user post length  : ${_userPosts.length}");
  //       _userPostLastDate = false;
  //       if (_submissionDate.length < _pageSize ||
  //           _submissionDate.length == snap.count) {
  //         _userPostLastDate = true;
  //       }
  //       // debugPrint('post length ${_userPosts.length}');
  //     }
  //   } catch (e) {
  //     // debugPrint('PostProvider getUserPost error $e $st');
  //   } finally {
  //     _getUserPostBeingCalled = false;
  //     _pageLoading = false;
  //     notifyListeners();
  //   }
  // }

  getSubmissionsScore() async {
    try {
      await Future.delayed(Duration.zero);
      _isButtonVisible = false;
      _pLoading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('posts')
          .where('reportRemoved', isEqualTo: false)
          .where('sub', isEqualTo: 'sub')
          .orderBy('score', descending: true));
      var snap = await query.count().get();
      if (!_getPostBeingCalled) {
        _getPostBeingCalled = true;
        notifyListeners();
        Future.delayed(Duration.zero);
        _postsSnapshot = await query.limit(_pageSize).get();
        _posts = _postsSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();

        _count = 1;
        _last = false;
        if (_posts.length < _pageSize || _pageSize == snap.count) {
          _last = true;
        }
      }
    } catch (e) {
      // debugPrint('PostProvider getPosts error $e $st');
    } finally {
      _getPostBeingCalled = false;
      _pLoading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getUpdatesScore() async {
    try {
      await Future.delayed(Duration.zero);
      _isButtonVisible = false;
      _pLoading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('posts')
          .where('reportRemoved', isEqualTo: false)
          .where('sub', isEqualTo: 'fairtalk')
          .orderBy('score', descending: true));
      var snap = await query.count().get();
      if (!_getPostBeingCalled) {
        _getPostBeingCalled = true;
        notifyListeners();
        Future.delayed(Duration.zero);
        _postsSnapshot = await query.limit(_pageSize).get();
        _posts = _postsSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();

        _count = 1;
        _last = false;
        if (_posts.length < _pageSize || _pageSize == snap.count) {
          _last = true;
        }
      }
    } catch (e) {
      // debugPrint('PostProvider getPosts error $e $st');
    } finally {
      _getPostBeingCalled = false;
      _pLoading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getSubmissionsDate() async {
    try {
      await Future.delayed(Duration.zero);
      _isButtonVisible = false;
      _pLoading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('posts')
          .where('reportRemoved', isEqualTo: false)
          .where('sub', isEqualTo: 'sub')
          .orderBy('datePublished', descending: true));
      var snap = await query.count().get();
      if (!_getPostBeingCalled) {
        _getPostBeingCalled = true;
        notifyListeners();
        Future.delayed(Duration.zero);
        _postsSnapshot = await query.limit(_pageSize).get();
        _posts = _postsSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();
        _count = 1;
        _last = false;
        if (_posts.length < _pageSize || _pageSize == snap.count) {
          _last = true;
        }
      }
    } catch (e) {
      // debugPrint('PostProvider getPosts error $e $st');
    } finally {
      _getPostBeingCalled = false;
      _pLoading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getUpdatesDate() async {
    try {
      await Future.delayed(Duration.zero);
      _isButtonVisible = false;
      _pLoading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('posts')
          .where('reportRemoved', isEqualTo: false)
          .where('sub', isEqualTo: 'fairtalk')
          .orderBy('datePublished', descending: true));
      var snap = await query.count().get();
      if (!_getPostBeingCalled) {
        _getPostBeingCalled = true;
        notifyListeners();
        Future.delayed(Duration.zero);
        _postsSnapshot = await query.limit(_pageSize).get();
        _posts = _postsSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();
        _count = 1;
        _last = false;
        if (_posts.length < _pageSize || _pageSize == snap.count) {
          _last = true;
        }
      }
    } catch (e) {
      // debugPrint('PostProvider getPosts error $e $st');
    } finally {
      _getPostBeingCalled = false;
      _pLoading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getNextSubmissions() async {
    try {
      if (_last) {
        return;
      }

      if (_postsSnapshot != null &&
          _postsSnapshot!.docs.isNotEmpty &&
          _pLoading != true &&
          _postPageLoading != true) {
        {
          _postPageLoading = true;
          _pLoading = true;
        }
        notifyListeners();
        await Future.delayed(Duration.zero);
        var query = (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'sub')
                .orderBy('score', descending: true))
            .startAfterDocument(_postsSnapshot!.docs.last);
        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count++;
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
          }
        } else {
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostPosts error $e $st');
    } finally {
      _postPageLoading = false;
      _pLoading = false;
      notifyListeners();
    }
  }

  getNextUpdates() async {
    try {
      if (_last) {
        return;
      }

      if (_postsSnapshot != null &&
          _postsSnapshot!.docs.isNotEmpty &&
          _pLoading != true &&
          _postPageLoading != true) {
        {
          _postPageLoading = true;
          _pLoading = true;
        }
        notifyListeners();
        await Future.delayed(Duration.zero);
        var query = (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'fairtalk')
                .orderBy('score', descending: true))
            .startAfterDocument(_postsSnapshot!.docs.last);
        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count++;
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
          }
        } else {
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostPosts error $e $st');
    } finally {
      _postPageLoading = false;
      _pLoading = false;
      notifyListeners();
    }
  }

  getNextSubmissionsDate() async {
    try {
      if (_last) {
        return;
      }

      if (_postsSnapshot != null &&
          _postsSnapshot!.docs.isNotEmpty &&
          _pLoading != true &&
          _postPageLoading != true) {
        {
          _postPageLoading = true;
          _pLoading = true;
        }
        notifyListeners();
        await Future.delayed(Duration.zero);
        var query = (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'sub')
                .orderBy('datePublished', descending: true))
            .startAfterDocument(_postsSnapshot!.docs.last);
        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count++;
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
          }
        } else {
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostPosts error $e $st');
    } finally {
      _postPageLoading = false;
      _pLoading = false;
      notifyListeners();
    }
  }

  getPreviousSubmissions() async {
    try {
      if (_postsSnapshot != null) {
        _pLoading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        var data = await (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'sub')
                .orderBy('score', descending: true))
            .endBeforeDocument(_postsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count--;
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      //
    } finally {
      _pLoading = false;
      notifyListeners();
    }
  }

  getNextUpdatesDate() async {
    try {
      if (_last) {
        return;
      }

      if (_postsSnapshot != null &&
          _postsSnapshot!.docs.isNotEmpty &&
          _pLoading != true &&
          _postPageLoading != true) {
        {
          _postPageLoading = true;
          _pLoading = true;
        }
        notifyListeners();
        await Future.delayed(Duration.zero);
        var query = (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'fairtalk')
                .orderBy('datePublished', descending: true))
            .startAfterDocument(_postsSnapshot!.docs.last);
        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count++;
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
          }
        } else {
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostPosts error $e $st');
    } finally {
      _postPageLoading = false;
      _pLoading = false;
      notifyListeners();
    }
  }

  getPreviousUpdates() async {
    try {
      if (_postsSnapshot != null) {
        _pLoading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        var data = await (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'fairtalk')
                .orderBy('score', descending: true))
            .endBeforeDocument(_postsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count--;
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      //
    } finally {
      _pLoading = false;
      notifyListeners();
    }
  }

  getPreviousSubmissionsDate() async {
    try {
      if (_postsSnapshot != null) {
        _pLoading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        var data = await (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'sub')
                .orderBy('datePublished', descending: true))
            .endBeforeDocument(_postsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count--;
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      //
    } finally {
      _pLoading = false;
      notifyListeners();
    }
  }

  getPreviousUpdatesDate() async {
    try {
      if (_postsSnapshot != null) {
        _pLoading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        var data = await (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('sub', isEqualTo: 'fairtalk')
                .orderBy('datePublished', descending: true))
            .endBeforeDocument(_postsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count--;
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      //
    } finally {
      _pLoading = false;
      notifyListeners();
    }
  }

  getOrganicMessages(int durationInDay) async {
    try {
      await Future.delayed(Duration.zero);
      _isButtonVisible = false;
      _pLoading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('posts')
          .where('reportRemoved', isEqualTo: false)
          .where('bot', isEqualTo: false)
          .where('time', whereIn: [
        durationInDay - 0,
        durationInDay - 1,
        durationInDay - 2,
        durationInDay - 3,
        durationInDay - 4,
        durationInDay - 5,
        durationInDay - 6,
      ]).orderBy('datePublished', descending: true));
      var snap = await query.count().get();
      if (!_getPostBeingCalled) {
        _getPostBeingCalled = true;
        notifyListeners();
        Future.delayed(Duration.zero);
        _postsSnapshot = await query.limit(_pageSize).get();
        _posts = _postsSnapshot!.docs.map((e) => Post.fromSnap(e)).toList();

        _count = 1;
        _last = false;
        if (_posts.length < _pageSize || _pageSize == snap.count) {
          _last = true;
        }
      }
    } catch (e) {
      // debugPrint('PostProvider getPosts error $e $st');
    } finally {
      _getPostBeingCalled = false;
      _pLoading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getNextOrganicMessages(int durationInDay) async {
    try {
      if (_postsSnapshot != null) {
        _pLoading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        var data = await (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('bot', isEqualTo: false)
                .where('time', whereIn: [
          durationInDay - 0,
          durationInDay - 1,
          durationInDay - 2,
          durationInDay - 3,
          durationInDay - 4,
          durationInDay - 5,
          durationInDay - 6,
        ]).orderBy('datePublished', descending: true))
            .endBeforeDocument(_postsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count--;
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      //
    } finally {
      _pLoading = false;
      notifyListeners();
    }
  }

  getPreviousOrganicMessages(int durationInDay) async {
    try {
      if (_last) {
        return;
      }

      if (_postsSnapshot != null &&
          _postsSnapshot!.docs.isNotEmpty &&
          _pLoading != true &&
          _postPageLoading != true) {
        {
          _postPageLoading = true;
          _pLoading = true;
        }
        notifyListeners();
        await Future.delayed(Duration.zero);
        var query = (FirebaseFirestore.instance
                .collection('posts')
                .where('reportRemoved', isEqualTo: false)
                .where('bot', isEqualTo: false)
                .where('time', whereIn: [
          durationInDay - 0,
          durationInDay - 1,
          durationInDay - 2,
          durationInDay - 3,
          durationInDay - 4,
          durationInDay - 5,
          durationInDay - 6,
        ]).orderBy('datePublished', descending: true))
            .startAfterDocument(_postsSnapshot!.docs.last);
        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();
        if (data.docs.isNotEmpty) {
          _postsSnapshot = data;
          _count++;
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
          }
        } else {
          _last = false;
        }
        _posts =
            _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostPosts error $e $st');
    } finally {
      _postPageLoading = false;
      _pLoading = false;
      notifyListeners();
    }
  }

  deleteUserPost(String postId) {
    try {
      _userPosts.removeWhere((element) => element.postId == postId);
      _posts.removeWhere((element) => element.postId == postId);
      notifyListeners();
    } catch (e) {
      // debugPrint("Got Error While Deleting Post");
    }
  }

  @override
  void dispose() {
    _postScrollController.dispose();
    _snapshotListener?.cancel();
    stopListener();
    super.dispose();
  }

  Post? get mostLikedPost => _mostLikedPost;

  List<Post> get mostLikedPosts => _mostLikedPosts;

  List<Post> get posts => _posts;

  List<Post> get userProfilePost => _userPosts;

  List<Post> get submissionPostScore => _submissionScore;

  List<Post> get submissionPostDate => _submissionDate;

  bool get loading => _loading;

  bool get pageLoading => _pageLoading;

  bool get pageLoadingScore => _pageLoadingScore;

  bool get pLoading => _pLoading;
  bool get pLoadingScore => _pLoadingScore;

  bool get postLoading => _postsLoading;

  bool get postPageLoading => _postPageLoading;

  int get count => _count;

  bool get last => _last;

  int get pageSize => _pageSize;

  bool get isButtonVisible => _isButtonVisible;

  bool get isLastUserPost => _userPostLast;
  bool get isLastUserPostDate => _userPostLastDate;
  bool get isLastUserPostScore => _userPostLastScore;

  ScrollController get postScrollController => _postScrollController;

  get canUserPostLoadMore => !(_userPostLast);
  get canUserPostLoadMoreDate => !(_userPostLastDate);
  get canUserPostLoadMoreScore => !(_userPostLastScore);
}
