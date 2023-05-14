import 'package:aft/ATESTS/models/poll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../models/postPoll.dart';

class PostPollProvider extends ChangeNotifier {
  List<PostPoll> _userPostPollList = [];

  bool _pageLoading = false;
  bool _pageScrollLoading = false;
  final int _pageSize = 6;

  QuerySnapshot<Map<String, dynamic>>? _userPostSnapShot;
  QuerySnapshot<Map<String, dynamic>>? _userPollSnapShot;

  int postSizeCount = 0;
  int pollSizeCount = 0;

  bool _postLast = false;
  bool _pollLast = false;

  getPostPollResult(String? userId) async {
    try {
      _pageLoading = true;
      notifyListeners();
      _userPostPollList = [];
      postSizeCount = 0;
      pollSizeCount = 0;
      var postQuery = FirebaseFirestore.instance
          .collection('posts')
          .where('votesUIDs', arrayContains: userId ?? "");
      var pollQuery = FirebaseFirestore.instance
          .collection('polls')
          .where('votesUIDs', arrayContains: userId ?? "");

      var postSnap = await postQuery.count().get();
      var pollSnap = await pollQuery.count().get();

      // debugPrint('post count is ${postSnap.count}');
      // debugPrint('poll count is ${pollSnap.count}');

      Future.delayed(Duration.zero);

      _userPostSnapShot = await postQuery.limit(_pageSize).get();
      _userPollSnapShot = await pollQuery.limit(_pageSize).get();

      for (var element in _userPostSnapShot!.docs) {
        Post post = Post.fromSnap(
          element,
        );
        _userPostPollList.add(
          PostPoll(
            datePublished: post.datePublished,
            postOrPollId: post.postId,
            postPollType: PostPollType.post,
            post: post,
          ),
        );
      }

      for (var element in _userPollSnapShot!.docs) {
        Poll poll = Poll.fromSnap(
          element,
        );
        _userPostPollList.add(
          PostPoll(
            datePublished: poll.datePublished,
            postOrPollId: poll.pollId,
            postPollType: PostPollType.poll,
            poll: poll,
          ),
        );
      }

      _userPostPollList.sort((a, b) {
        return b.datePublished.compareTo(a.datePublished);
      });

      _postLast = false;
      _pollLast = false;
      postSizeCount = _userPostSnapShot!.docs.length;
      pollSizeCount = _userPollSnapShot!.docs.length;
      if (postSizeCount < _pageSize || _pageSize == postSnap.count) {
        _postLast = true;
      }
      if (pollSizeCount < _pageSize || _pageSize == pollSnap.count) {
        _pollLast = true;
      }

      // debugPrint("user post poll length  : ${_userPostPollList.length}");
    } catch (e) {
      // debugPrint('PostProvider getUserPost error $e $st');
    } finally {
      _pageLoading = false;
      notifyListeners();
    }
  }

  // getPostPollResult(String? userId) async {
  //   try {
  //     _pageLoading = false;
  //     _userPostPollList = [];
  //     _postProvider.getUserPosts(userId);
  //     _pollProvider.getUserPolls(userId);
  //     for (var element in _postProvider.userProfilePost) {
  //       _userPostPollList.add(
  //         PostPoll(
  //           datePublished: element.datePublished,
  //           postOrPollId: element.postId,
  //           postPollType: PostPollType.post,
  //           post: element,
  //         ),
  //       );
  //     }
  //     for (var element in _pollProvider.userPolls) {
  //       _userPostPollList.add(
  //         PostPoll(
  //           datePublished: element.datePublished,
  //           postOrPollId: element.pollId,
  //           postPollType: PostPollType.poll,
  //           poll: element,
  //         ),
  //       );
  //     }
  //   } catch (e, st) {
  //     debugPrint('PostProvider getUserPost error $e $st');
  //   } finally {
  //     _pageLoading = false;
  //     notifyListeners();
  //   }
  // }

  //User Loading Page For Post And Poll
  getUserNextPostPollPageLoading(String? userId) async {
    try {
      _pageLoading = true;
      notifyListeners();
      _userPostPollList = [];
      var postQuery = FirebaseFirestore.instance
          .collection('posts')
          .where('votesUIDs', arrayContains: userId ?? "");
      var pollQuery = FirebaseFirestore.instance
          .collection('polls')
          .where('votesUIDs', arrayContains: userId ?? "");

      var postSnap = await postQuery.count().get();
      var pollSnap = await pollQuery.count().get();

      // debugPrint('post count is ${postSnap.count}');
      // debugPrint('poll count is ${pollSnap.count}');

      Future.delayed(Duration.zero);

      _userPostSnapShot = await postQuery
          .startAfterDocument(_userPostSnapShot!.docs.last)
          .limit(_pageSize)
          .get();
      _userPollSnapShot = await pollQuery
          .startAfterDocument(_userPollSnapShot!.docs.last)
          .limit(_pageSize)
          .get();

      for (var element in _userPostSnapShot!.docs) {
        Post post = Post.fromSnap(
          element,
        );
        _userPostPollList.add(
          PostPoll(
            datePublished: post.datePublished,
            postOrPollId: post.postId,
            postPollType: PostPollType.post,
            post: post,
          ),
        );
      }

      for (var element in _userPollSnapShot!.docs) {
        Poll poll = Poll.fromSnap(
          element,
        );
        _userPostPollList.add(
          PostPoll(
            datePublished: poll.datePublished,
            postOrPollId: poll.pollId,
            postPollType: PostPollType.poll,
            poll: poll,
          ),
        );
      }

      _userPostPollList.sort((a, b) {
        return b.datePublished.compareTo(a.datePublished);
      });

      _postLast = false;
      _pollLast = false;

      postSizeCount += _userPostSnapShot!.docs.length;
      pollSizeCount += _userPollSnapShot!.docs.length;

      if (pollSizeCount == postSnap.count) {
        _postLast = true;
      }
      if (pollSizeCount == pollSnap.count) {
        _pollLast = true;
      }

      // debugPrint("user post poll length  : ${_userPostPollList.length}");
    } catch (e) {
      // debugPrint('PostProvider getUserPost error $e $st');
    } finally {
      _pageLoading = false;
      notifyListeners();
    }
  }

  get userPostPollCombinedList => _userPostPollList;

  get pageLoading => _pageLoading;

  get pageScrollLoading => _pageScrollLoading;

  get postLastCheck => _postLast;

  get pollLastCheck => _pollLast;

  updatePostPollCombinedList({Post? post}) {
    if (post != null) {
      // debugPrint(
      //     "Matched Poll Post At :: ${_userPostPollList.indexWhere((element) => element.postOrPollId == post.postId)}");
      int index = _userPostPollList
          .indexWhere((element) => element.postOrPollId == post.postId);
      if (index != -1) {
        _userPostPollList[index].post = post;
        notifyListeners();
      }
    }
  }
}
