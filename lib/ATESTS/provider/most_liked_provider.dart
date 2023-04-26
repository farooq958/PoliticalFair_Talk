import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../models/post.dart';
import '../utils/global_variables.dart';
import 'filter_provider.dart';

class MostLikedProvider extends ChangeNotifier {
  Post? _mostLikedPost;
  List<Post> _mostLikedPosts = [];
  int _postPageCount = 0;
  int _pollPageCount = 0;

  bool _lastPostPage = false;
  bool _lastPollPage = false;
  bool _isButtonVisible = false;
  bool _isPollButtonVisible = false;
  Poll? _mostLikedPoll;
  List<Poll> _mostLikedPolls = [];

  QuerySnapshot<Map<String, dynamic>>? _mostLikePostsSnapshot;
  QuerySnapshot<Map<String, dynamic>>? _mostLikePollsSnapshot;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _snapshotListener;

  final bool _postsLoading = false;
  bool _loading = false;
  bool _pLoading = false;
  bool _pageLoading = false;
  bool _postPageLoading = false;
  final int _pageSize = 6;

  final ScrollController _postScrollController = ScrollController();

  startScrollListener() {
    _postScrollController.addListener(postNextScroll);
  }

  postNextScroll() {
    final filterProvider = Provider.of<FilterProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (_postScrollController.position.extentAfter < 1) {
      //
      //   getNextPosts(
      //       filterProvider.twoValue,
      //       filterProvider.global,
      //       filterProvider.countryCode,
      //       filterProvider.durationInDay,
      //       filterProvider.oneValue);
    }
  }

  stopListener() {
    _postScrollController.removeListener(() {});
  }

  final db = FirebaseFirestore.instance;

  listenForChanges(String global, String country, String oneValue) async {
    final ref = db.collection("mostLiked").limit(2);
    await getMostLikedPosts(global, country, oneValue);
    _snapshotListener = ref.snapshots().listen(
      (event) {
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
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

              break;
          }
        }
      },
      onError: (error) => debugPrint("$error"),
    );
  }

  closeListener() {
    _snapshotListener?.cancel();
  }

  getMostLikedPosts(String global, String country, String oneValue) async {
    try {
      _loading = true;
      _isButtonVisible = false;
      await Future.delayed(Duration.zero);
      notifyListeners();
      final query = global == 'true'
          ? db
              .collection('mostLiked')
              .where('reportRemoved', isEqualTo: false)
              .orderBy(oneValue == 'Highest Score' ? 'score' : 'time',
                  descending: true)
          : db
              .collection('mostLikedByCountry')
              .doc(country)
              .collection('mostLiked')
              .where('reportRemoved', isEqualTo: false)
              .orderBy(oneValue == 'Highest Score' ? 'score' : 'time',
                  descending: true);

      var snap = await query.count().get();
      _mostLikePostsSnapshot = await query.limit(_pageSize).get();
      _mostLikedPosts = _mostLikePostsSnapshot!.docs
          .map((e) => Post.fromMap(e.data()))
          .toList();

      _postPageCount = 1;
      _lastPostPage = false;
      if (_mostLikedPosts.length < _pageSize || _pageSize == snap.count) {
        _lastPostPage = true;
      }
      notifyListeners();
    } catch (e) {
      //
    } finally {
      _loading = false;
      setButtonVisibility();
      notifyListeners();
    }
  }

  getNextMostLikedPosts(String global, String country, String oneValue) async {
    try {
      if (_lastPostPage) {
        return;
      }
      if (_mostLikePostsSnapshot != null && !_loading) {
        _loading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        final query = global == 'true'
            ? db
                .collection('mostLiked')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'score' : 'time',
                    descending: true)
                .startAfterDocument(_mostLikePostsSnapshot!.docs.last)
            : db
                .collection('mostLikedByCountry')
                .doc(country)
                .collection('mostLiked')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'score' : 'time',
                    descending: true)
                .startAfterDocument(_mostLikePostsSnapshot!.docs.last);
        var snap = await query.count().get();
        final data = await query.limit(_pageSize).get();

        if (data.docs.isNotEmpty) {
          _mostLikePostsSnapshot = data;
          _postPageCount++;

          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _lastPostPage = true;
            // debugPrint('last is true');
          }
        } else {
          _lastPostPage = false;
        }
        _mostLikedPosts = _mostLikePostsSnapshot!.docs
            .map((e) => Post.fromMap(e.data()))
            .toList();
      }
    } catch (e) {
      //
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  getPreviousMostLikedPosts(
      String global, String country, String oneValue) async {
    try {
      if (_mostLikePostsSnapshot != null && !_loading) {
        _loading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        final query = global == 'true'
            ? db
                .collection('mostLiked')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'score' : 'time',
                    descending: true)
                .endBeforeDocument(_mostLikePostsSnapshot!.docs.first)
            : db
                .collection('mostLikedByCountry')
                .doc(country)
                .collection('mostLiked')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'score' : 'time',
                    descending: true)
                .endBeforeDocument(_mostLikePostsSnapshot!.docs.first);
        var snap = await query.count().get();
        final data = await query.limitToLast(_pageSize).get();

        if (data.docs.isNotEmpty) {
          _mostLikePostsSnapshot = data;
          _postPageCount--;
          _lastPostPage = false;
        }
        _mostLikedPosts = _mostLikePostsSnapshot!.docs
            .map((e) => Post.fromMap(e.data()))
            .toList();
      }
    } catch (e) {
      //
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  getMostLikedPolls(String global, String country, String oneValue) async {
    try {
      // debugPrint('getMostLikedPolls one value is $oneValue');
      _loading = true;
      _isPollButtonVisible = false;
      await Future.delayed(Duration.zero);
      notifyListeners();
      final query = global == 'true'
          ? db
              .collection('mostLikedPolls')
              .where('reportRemoved', isEqualTo: false)
              .orderBy(oneValue == 'Highest Score' ? 'totalVotes' : 'time',
                  descending: true)
          : db
              .collection('mostLikedByCountryPolls')
              .doc(country)
              .collection('mostLiked')
              .where('reportRemoved', isEqualTo: false)
              .orderBy(oneValue == 'Highest Score' ? 'totalVotes' : 'time',
                  descending: true);
      var snap = await query.count().get();
      _mostLikePollsSnapshot = await query.limit(_pageSize).get();
      _mostLikedPolls = _mostLikePollsSnapshot!.docs
          .map((e) => Poll.fromMap(e.data()))
          .toList();
      _pollPageCount = 1;
      _lastPollPage = false;
      if (_mostLikedPolls.length < _pageSize || _pageSize == snap.count) {
        _lastPollPage = true;
      }
      notifyListeners();
    } catch (e) {
      //
    } finally {
      _loading = false;
      setPollButtonVisibility();
      notifyListeners();
    }
  }

  getNextMostLikedPolls(String global, String country, String oneValue) async {
    try {
      if (_lastPollPage) {
        return;
      }
      if (_mostLikePollsSnapshot != null && !_loading) {
        _loading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        final query = global == 'true'
            ? db
                .collection('mostLikedPolls')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'totalVotes' : 'time',
                    descending: true)
                .startAfterDocument(_mostLikePollsSnapshot!.docs.last)
            : db
                .collection('mostLikedByCountryPolls')
                .doc(country)
                .collection('mostLiked')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'totalVotes' : 'time',
                    descending: true)
                .startAfterDocument(_mostLikePollsSnapshot!.docs.last);
        var snap = await query.count().get();
        final data = await query.limit(_pageSize).get();

        if (data.docs.isNotEmpty) {
          _mostLikePollsSnapshot = data;
          _pollPageCount++;

          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _lastPollPage = true;
            // debugPrint('last is true');
          }
        } else {
          _lastPollPage = false;
        }
        _mostLikedPolls = _mostLikePollsSnapshot!.docs
            .map((e) => Poll.fromMap(e.data()))
            .toList();
      }
    } catch (e) {
      //
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  getPreviousMostLikedPolls(
      String global, String country, String oneValue) async {
    try {
      if (_mostLikePollsSnapshot != null && !_loading) {
        _loading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        final query = global == 'true'
            ? db
                .collection('mostLikedPolls')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'totalVotes' : 'time',
                    descending: true)
                .endBeforeDocument(_mostLikePollsSnapshot!.docs.first)
            : db
                .collection('mostLikedByCountryPolls')
                .doc(country)
                .collection('mostLiked')
                .where('reportRemoved', isEqualTo: false)
                .orderBy(oneValue == 'Highest Score' ? 'totalVotes' : 'time',
                    descending: true)
                .endBeforeDocument(_mostLikePollsSnapshot!.docs.first);
        var snap = await query.count().get();
        final data = await query.limitToLast(_pageSize).get();

        if (data.docs.isNotEmpty) {
          _mostLikePollsSnapshot = data;
          _pollPageCount--;
          _lastPollPage = false;
        }
        _mostLikedPolls = _mostLikePollsSnapshot!.docs
            .map((e) => Poll.fromMap(e.data()))
            .toList();
      }
    } catch (e) {
      //
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  setButtonVisibility() async {
    await Future.delayed(const Duration(seconds: 1));
    _isButtonVisible = true;
    notifyListeners();
  }

  setPollButtonVisibility() async {
    await Future.delayed(const Duration(seconds: 1));
    _isPollButtonVisible = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _postScrollController.dispose();
    _snapshotListener?.cancel();
    super.dispose();
  }

  Post? get mostLikedPost => _mostLikedPost;

  List<Post> get mostLikedPosts => _mostLikedPosts;

  List<Poll> get mostLikedPolls => _mostLikedPolls;

  bool get loading => _loading;

  bool get pageLoading => _pageLoading;

  bool get pLoading => _pLoading;

  bool get lastPostPage => _lastPostPage;

  bool get lastPollPage => _lastPollPage;

  bool get isButtonVisible => _isButtonVisible;

  bool get isPollButtonVisible => _isPollButtonVisible;

  int get pageSize => _pageSize;

  int get postPageCount => _postPageCount;

  int get pollPageCount => _pollPageCount;

  ScrollController get postScrollController => _postScrollController;
}
