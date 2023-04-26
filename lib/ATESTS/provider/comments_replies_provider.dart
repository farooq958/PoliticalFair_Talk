import 'package:aft/ATESTS/models/comment.dart';
import 'package:aft/ATESTS/models/poll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';
import '../../main.dart';
import '../models/CommentsReplies.dart';
import '../models/post.dart';
import '../models/reply.dart';
import '../screens/full_message.dart';
import '../utils/utils.dart';

class CommentReplyProvider extends ChangeNotifier {
  List<CommentsReplies> _userCommentList = [];
  List<CommentsReplies> _userReplyList = [];
  List<CommentsAndReplies> _postPollCommentAndRepliesList = [];
  final Map<String, QuerySnapshot<Map<String, dynamic>>>
      _postPollRepliesSnapShotMap = {};
  Map<String, bool> _canRepliesLoadMore = {};
  Map<String, int> _pollPostRepliesSizeCount = {};
  Map<String, bool> _pollPostRepliesPaginationLoading = {};

  bool _pageLoading = false;
  bool _commentPageScrollLoading = false;
  bool _replyPageScrollLoading = false;

  final int _pageSize = 6;

  QuerySnapshot<Map<String, dynamic>>? _userCommentSnapShot;
  QuerySnapshot<Map<String, dynamic>>? _userReplySnapShot;

  int _userCommentSizeCount = 0;
  int _userReplySizeCount = 0;

  bool _userCommentLast = false;
  bool _userReplyLast = false;

  QuerySnapshot<Map<String, dynamic>>? _pollPostUserCommentSnapShot;

  bool _postPollCommentLoader = false;
  bool _postPollCommentPaginationLoader = false;

  int _pollPostUserCommentSizeCount = 0;

  bool _pollPostUserCommentLast = false;

  // Returns Combined List of Poll and posts done by user
  getCommentResult(
    String? userId, {
    bool getNextPage = false,
  }) async {
    try {
      if (getNextPage) {
        _commentPageScrollLoading = true;
        notifyListeners();
      } else {
        _pageLoading = true;
        notifyListeners();
        _userCommentList = [];
        _userCommentSizeCount = 0;
      }

      var commentQuery = FirebaseFirestore.instance
          .collection('comments')
          .where('UID', isEqualTo: userId ?? "")
          .orderBy("datePublished", descending: true)
          .where('reportRemoved', isEqualTo: false);

      var commentSnap = await commentQuery.count().get();

      Future.delayed(Duration.zero);

      if (getNextPage) {
        if (!_userCommentLast) {
          _userCommentSnapShot = await commentQuery
              .startAfterDocument(_userCommentSnapShot!.docs.last)
              .limit(_pageSize)
              .get();
        }
      } else {
        _userCommentSnapShot = await commentQuery.limit(_pageSize).get();
      }

      // List<CommentsReplies> temporaryListing = [];

      for (var element in _userCommentSnapShot!.docs) {
        Comment comment = Comment.fromSnap(
          element,
        );

        var pollQuery = FirebaseFirestore.instance.collection('polls').where(
              'pollId',
              isEqualTo: comment.parentId,
            );

        var postQuery = FirebaseFirestore.instance.collection('posts').where(
              'postId',
              isEqualTo: comment.parentId,
            );

        var pollQuerySnapShot = await pollQuery.get();
        var postQuerySnapShot = await postQuery.get();

        if (!checkIfAlreadyExistInUserCommentList(
            id: comment.commentId, isComment: true)) {
          if (pollQuerySnapShot.docs.isNotEmpty) {
            Poll poll = Poll.fromSnap(pollQuerySnapShot.docs[0]);
            _userCommentList.add(
              CommentsReplies(
                datePublished: comment.datePublished,
                datePublishedNTP: comment.datePublishedNTP,
                commentReplyType: CommentReplyType.comment,
                comment: comment,
                postOrPollComment: PostOrPollComment.poll,
                poll: poll,
              ),
            );
          }

          if (postQuerySnapShot.docs.isNotEmpty) {
            Post post = Post.fromSnap(postQuerySnapShot.docs[0]);
            _userCommentList.add(
              CommentsReplies(
                datePublished: comment.datePublished,
                datePublishedNTP: comment.datePublishedNTP,
                commentReplyType: CommentReplyType.comment,
                comment: comment,
                postOrPollComment: PostOrPollComment.post,
                post: post,
              ),
            );
          }
        }
      }

      if (getNextPage) {
        _userCommentSizeCount += _userCommentSnapShot!.docs.length;
        if (_userCommentSizeCount == commentSnap.count) {
          _userCommentLast = true;
        }
      } else {
        _userCommentLast = false;
        _userCommentSizeCount = _userCommentSnapShot!.docs.length;
        if (_userCommentSizeCount < _pageSize ||
            _pageSize == commentSnap.count) {
          _userCommentLast = true;
        }
      }

      // debugPrint("User Comment Length  : ${_userCommentList.length}");
    } catch (e) {
      // debugPrint('PostProvider getUserPost error $e $st');
    } finally {
      if (getNextPage) {
        _commentPageScrollLoading = false;
      } else {
        _pageLoading = false;
      }
      notifyListeners();
    }
  }

  // Returns Combined List of Poll and posts done by user
  getReplyResult(
    String? userId, {
    bool getNextPage = false,
  }) async {
    try {
      if (getNextPage) {
        _replyPageScrollLoading = true;
        notifyListeners();
      } else {
        _pageLoading = true;
        notifyListeners();
        _userReplyList = [];
        _userReplySizeCount = 0;
      }

      var replyQuery = FirebaseFirestore.instance
          .collection('replies')
          .where('UID', isEqualTo: userId ?? "")
          .orderBy("datePublished", descending: true)
          .where('reportRemoved', isEqualTo: false);

      var replySnap = await replyQuery.count().get();

      Future.delayed(Duration.zero);

      if (getNextPage) {
        if (!_userReplyLast) {
          _userReplySnapShot = await replyQuery
              .startAfterDocument(_userReplySnapShot!.docs.last)
              .limit(_pageSize)
              .get();
        }
      } else {
        _userReplySnapShot = await replyQuery.limit(_pageSize).get();
      }

      // List<CommentsReplies> temporaryListing = [];

      for (var element in _userReplySnapShot!.docs) {
        Reply reply = Reply.fromSnap(
          element,
        );
        var pollQuery = FirebaseFirestore.instance.collection('polls').where(
              'pollId',
              isEqualTo: reply.parentMessageId,
            );
        var postQuery = FirebaseFirestore.instance.collection('posts').where(
              'postId',
              isEqualTo: reply.parentMessageId,
            );

        var pollQuerySnapShot = await pollQuery.get();
        var postQuerySnapShot = await postQuery.get();

        if (!checkIfAlreadyExistInUserCommentList(
            id: reply.replyId, isComment: false)) {
          if (pollQuerySnapShot.docs.isNotEmpty) {
            Poll poll = Poll.fromSnap(pollQuerySnapShot.docs[0]);
            _userReplyList.add(
              CommentsReplies(
                datePublished: reply.datePublished,
                datePublishedNTP: reply.datePublishedNTP,
                commentReplyType: CommentReplyType.reply,
                reply: reply,
                postOrPollComment: PostOrPollComment.poll,
                poll: poll,
              ),
            );
          }

          if (postQuerySnapShot.docs.isNotEmpty) {
            Post post = Post.fromSnap(postQuerySnapShot.docs[0]);
            _userReplyList.add(
              CommentsReplies(
                datePublished: reply.datePublished,
                datePublishedNTP: reply.datePublishedNTP,
                commentReplyType: CommentReplyType.reply,
                reply: reply,
                postOrPollComment: PostOrPollComment.post,
                post: post,
              ),
            );
          }
        }
      }

      if (getNextPage) {
        _userReplySizeCount += _userReplySnapShot!.docs.length;
        if (_userReplySizeCount == replySnap.count) {
          _userReplyLast = true;
        }
      } else {
        _userReplyLast = false;
        _userReplySizeCount = _userReplySnapShot!.docs.length;
        if (_userReplySizeCount < _pageSize || _pageSize == replySnap.count) {
          _userReplyLast = true;
        }
      }
      // debugPrint("User Replies Length  : ${_userReplyList.length}");
    } catch (e) {
      // debugPrint('PostProvider getUserPost error $e $st');
    } finally {
      if (getNextPage) {
        _replyPageScrollLoading = false;
      } else {
        _pageLoading = false;
      }
      notifyListeners();
    }
  }

  getPollOrPostCommentList({
    required String postPollId,
    required CommentFilter selectedCommentFilter,
    required CommentSort selectedCommentSort,
    required Map<String, dynamic> postPoll,
    bool isFromProfile = false,
    bool isNextPage = false,
    String? clickedCommentId,
    String? clickedReplyId,
  }) async {
    try {
      if (isNextPage) {
        _postPollCommentPaginationLoader = true;
        notifyListeners();
      } else {
        _postPollCommentLoader = true;
        notifyListeners();
        _postPollCommentAndRepliesList = [];
        _pollPostUserCommentSizeCount = 0;
        _canRepliesLoadMore = {};
        _pollPostRepliesPaginationLoading = {};
        _pollPostRepliesSizeCount = {};
      }

      notifyListeners();

      var commentQueryForUser;

      if (selectedCommentFilter.value != "all") {
        commentQueryForUser = FirebaseFirestore.instance
            .collection('comments')
            .where("parentId", isEqualTo: postPollId)
            .where('reportRemoved', isEqualTo: false)
            .orderBy(
              selectedCommentSort.key,
              descending: selectedCommentSort.value,
            )
            .where(
              selectedCommentFilter.value,
              whereIn: (postPoll[selectedCommentFilter.key].isNotEmpty
                  ? postPoll[selectedCommentFilter.key]
                  : ['placeholder_uid']),
            );
      } else {
        commentQueryForUser = FirebaseFirestore.instance
            .collection('comments')
            .where("parentId", isEqualTo: postPollId)
            .where('reportRemoved', isEqualTo: false)
            .orderBy(
              selectedCommentSort.key,
              descending: selectedCommentSort.value,
            );
      }

      Future.delayed(Duration.zero);

      var userCommentSnap = await commentQueryForUser.count().get();

      if (isNextPage) {
        if (!_pollPostUserCommentLast) {
          _pollPostUserCommentSnapShot = await commentQueryForUser
              .startAfterDocument(_pollPostUserCommentSnapShot!.docs.last)
              .limit(_pageSize)
              .get();
        }
      } else {
        _pollPostUserCommentSnapShot =
            await commentQueryForUser.limit(_pageSize).get();
      }

      bool doesClickedCommentExistInList = false;

      for (var element in (_pollPostUserCommentSnapShot!.docs)) {
        Comment comment = Comment.fromSnap(
          element,
        );

        if (isFromProfile) {
          if (comment.commentId == clickedCommentId) {
            doesClickedCommentExistInList = true;
          }
        }

        if (!checkIfAlreadyExistInPostPollList(
            id: comment.commentId, isComment: true)) {
          _postPollCommentAndRepliesList
              .add(CommentsAndReplies(comment: comment, replyList: []));
          getPollOrPostReplyList(
            postId: postPollId,
            commentId: comment.commentId,
            clickedReplyId:
                comment.commentId == clickedCommentId ? clickedReplyId : null,
            isFromProfile: isFromProfile,
          );
        }
      }

      if (!doesClickedCommentExistInList &&
          isFromProfile &&
          clickedCommentId != null) {
        Comment comment = await getCommentOrReplyViaId(
            commentOrReplyId: clickedCommentId, isReply: false);
        getPollOrPostReplyList(
          postId: postPollId,
          commentId: comment.commentId,
          isFromProfile: isFromProfile,
          clickedReplyId:
              comment.commentId == clickedCommentId ? clickedReplyId : null,
        );
        _postPollCommentAndRepliesList
            .add(CommentsAndReplies(comment: comment, replyList: []));
      }

      if (isNextPage) {
        if (!_pollPostUserCommentLast) {
          _pollPostUserCommentSizeCount +=
              _pollPostUserCommentSnapShot!.docs.length;
        }
        if (_pollPostUserCommentSizeCount == userCommentSnap.count) {
          _pollPostUserCommentLast = true;
        }
      } else {
        _pollPostUserCommentLast = false;
        _pollPostUserCommentSizeCount +=
            _pollPostUserCommentSnapShot!.docs.length;

        if (_pollPostUserCommentSizeCount < _pageSize ||
            _pageSize == userCommentSnap.count) {
          _pollPostUserCommentLast = true;
        }
      }
    } catch (e) {
      //
    } finally {
      _postPollCommentPaginationLoader = false;
      _postPollCommentLoader = false;
      notifyListeners();
    }
  }

  getPollOrPostReplyList({
    bool isNext = false,
    required String postId,
    required String commentId,
    String? clickedReplyId,
    bool isFromProfile = false,
  }) async {
    try {
      bool _pollPostUserReplyLast = false;
      int _pollPostUserReplySizeCount = 0;

      if (isNext) {
        _pollPostUserReplyLast = _canRepliesLoadMore[commentId] ?? false;
        _pollPostRepliesPaginationLoading[commentId] = true;
        _pollPostUserReplySizeCount = _pollPostRepliesSizeCount[commentId] ?? 0;

        notifyListeners();
      }

      QuerySnapshot<Map<String, dynamic>>? postPollReplySnapshot;

      var commentQueryForReply = FirebaseFirestore.instance
          .collection('replies')
          .where('parentMessageId', isEqualTo: postId)
          .where('parentCommentId', isEqualTo: commentId)
          .where('reportRemoved', isEqualTo: false)
          .orderBy('datePublished', descending: false);

      var userRepliesSnap = await commentQueryForReply.count().get();

      if (isNext) {
        postPollReplySnapshot = _postPollRepliesSnapShotMap[commentId];
        postPollReplySnapshot = await commentQueryForReply
            .startAfterDocument(postPollReplySnapshot!.docs.last)
            .limit(_pageSize)
            .get();
        _postPollRepliesSnapShotMap[commentId] = postPollReplySnapshot;
      } else {
        postPollReplySnapshot =
            await commentQueryForReply.limit(_pageSize).get();
        _postPollRepliesSnapShotMap[commentId] = postPollReplySnapshot;
      }

      var foundIndex = -1;
      for (var index = 0;
          index < _postPollCommentAndRepliesList.length;
          index++) {
        Comment comment = _postPollCommentAndRepliesList[index].comment;
        if (commentId == comment.commentId) {
          foundIndex = index;
        }
      }

      bool doesClickedCommentExistInList = false;

      for (var element in (postPollReplySnapshot.docs)) {
        Reply reply = Reply.fromSnap(
          element,
        );

        if (isFromProfile) {
          if (reply.replyId == clickedReplyId) {
            doesClickedCommentExistInList = true;
          }
        }

        if (!checkIfAlreadyExistInPostPollList(
          id: reply.replyId,
          isComment: false,
          parentCommentId: commentId,
        )) {
          if (reply.replyId == clickedReplyId) {
            _postPollCommentAndRepliesList[foundIndex]
                .replyList
                .insert(0, reply);
          } else {
            _postPollCommentAndRepliesList[foundIndex].replyList.add(reply);
          }
        }
      }

      if (clickedReplyId != null && !doesClickedCommentExistInList) {
        Reply reply = await getCommentOrReplyViaId(
            commentOrReplyId: clickedReplyId, isReply: true);
        _postPollCommentAndRepliesList[foundIndex].replyList.insert(0, reply);
      }

      if (isNext) {
        if (!_pollPostUserReplyLast) {
          _pollPostUserReplySizeCount += postPollReplySnapshot.docs.length;
        }
        if (_pollPostUserReplySizeCount == userRepliesSnap.count) {
          _pollPostUserReplyLast = true;
        }
      } else {
        _pollPostUserReplyLast = false;
        _pollPostUserReplySizeCount += postPollReplySnapshot.docs.length;

        if (_pollPostUserReplySizeCount < _pageSize ||
            _pageSize == userRepliesSnap.count) {
          _pollPostUserReplyLast = true;
        }
      }

      _canRepliesLoadMore[commentId] = _pollPostUserReplyLast;
      _pollPostRepliesSizeCount[commentId] = _pollPostUserReplySizeCount;
    } catch (e) {
      //
    } finally {
      _pollPostRepliesPaginationLoading[commentId] = false;
      notifyListeners();
    }
  }

  //Update User Like Dislike
  updateUserLikeDislike({
    required String type,
    required String docId,
    required int likeCount,
    required int dislikeCount,
    required List<dynamic> likes,
    required List<dynamic> dislikes,
  }) {
    // debugPrint("Type : $type");
    if (type == "comment") {
      CommentsReplies? containsElement;
      try {
        containsElement = _userCommentList
            .firstWhere((element) => element.comment?.commentId == docId);
        if (containsElement != null) {
          _userCommentList
              .firstWhere((element) => element.comment?.commentId == docId)
              .comment
              ?.likeCount = likeCount;
          _userCommentList
              .firstWhere((element) => element.comment?.commentId == docId)
              .comment
              ?.dislikeCount = dislikeCount;
          _userCommentList
              .firstWhere((element) => element.comment?.commentId == docId)
              .comment
              ?.likes = likes;
          _userCommentList
              .firstWhere((element) => element.comment?.commentId == docId)
              .comment
              ?.dislikes = dislikes;
          // print(
          //     "Updated User Likes And Dislikes ::: ${_userCommentReplyList.firstWhere((element) => element.comment?.commentId == docId).comment?.toJson()}");
        }
      } catch (e) {
        //
      }
    } else {
      CommentsReplies? containsElement;
      try {
        containsElement = _userReplyList
            .firstWhere((element) => element.reply?.replyId == docId);
        // debugPrint("Inside Reply Element Found :::: $containsElement");
        if (containsElement != null) {
          _userReplyList
              .firstWhere((element) => element.reply?.replyId == docId)
              .reply
              ?.likeCount = likeCount;
          _userReplyList
              .firstWhere((element) => element.reply?.replyId == docId)
              .reply
              ?.dislikeCount = dislikeCount;
          _userReplyList
              .firstWhere((element) => element.reply?.replyId == docId)
              .reply
              ?.likes = likes;
          _userReplyList
              .firstWhere((element) => element.reply?.replyId == docId)
              .reply
              ?.dislikes = dislikes;
        }
        // debugPrint(
        //     "Updated User Likes And Dislikes ::: ${_userCommentReplyList.firstWhere((element) => element.reply?.replyId == docId).reply?.toJson()}");
      } catch (e) {
        //
      }
    }
    notifyListeners();
  }

  updatePostPollComment({
    required String type,
    required String docId,
    required int likeCount,
    required int dislikeCount,
    required List<dynamic> likes,
    required List<dynamic> dislikes,
    String? parentMessageId,
  }) {
    // debugPrint("Type : $type");
    if (type == "comment") {
      for (var index = 0;
          index < _postPollCommentAndRepliesList.length;
          index++) {
        Comment comment = _postPollCommentAndRepliesList[index].comment;
        if (comment.commentId == docId) {
          comment.likeCount = likeCount;
          comment.dislikeCount = dislikeCount;
          comment.likes = likes;
          comment.dislikes = dislikes;
          // print("Updated User Likes And Dislikes ::: ${comment.toJson()}");
        }
      }
    } else {
      for (var index = 0;
          index < _postPollCommentAndRepliesList.length;
          index++) {
        Comment comment = _postPollCommentAndRepliesList[index].comment;
        // List<Reply> replyList = _postPollCommentAndRepliesList[index].replyList;
        if (comment.commentId == parentMessageId) {
          for (var rIndex = 0;
              rIndex < _postPollCommentAndRepliesList[index].replyList.length;
              rIndex++) {
            Reply reply =
                _postPollCommentAndRepliesList[index].replyList[rIndex];
            if (reply.replyId == docId) {
              reply.likeCount = likeCount;
              reply.dislikeCount = dislikeCount;
              reply.likes = likes;
              reply.dislikes = dislikes;
              // print(
              //     "Updated User Likes And Dislikes ::: ${_postPollCommentAndRepliesList[index].replyList[rIndex].toJson()}");
            }
          }
        }
      }
    }
    notifyListeners();
  }

  deleteUserComment(String commentId) {
    _userCommentList
        .removeWhere((element) => element.comment?.commentId == commentId);
    for (var index = 0;
        index < _postPollCommentAndRepliesList.length;
        index++) {
      CommentsAndReplies commentsAndReplies =
          _postPollCommentAndRepliesList[index];
      if (commentsAndReplies.comment.commentId == commentId) {
        _postPollCommentAndRepliesList.removeAt(index);
      }
    }
    notifyListeners();
  }

  deleteUserReply(String parentCommentId, String replyId) {
    _userReplyList.removeWhere((element) => element.reply?.replyId == replyId);
    for (var index = 0;
        index < _postPollCommentAndRepliesList.length;
        index++) {
      CommentsAndReplies commentsAndReplies =
          _postPollCommentAndRepliesList[index];
      if (commentsAndReplies.comment.commentId == parentCommentId) {
        for (var rIndex = 0;
            rIndex < _postPollCommentAndRepliesList[index].replyList.length;
            rIndex++) {
          if (_postPollCommentAndRepliesList[index].replyList[rIndex].replyId ==
              replyId) {
            _postPollCommentAndRepliesList[index].replyList.removeAt(rIndex);
          }
        }
      }
    }
    notifyListeners();
  }

  addNewCommentInPostPoll({
    required String postId,
    required String text,
    required String uid,
    required String username,
    required String commentId,
    required int datePublished,
    required DateTime datePublishedNTP,
  }) {
    // String trimmedText = trimText(text: text);
    // var timeNow = dateEST;

    Comment comment = Comment(
      parentId: postId,
      username: username,
      UID: uid,
      text: text,
      commentId: commentId,
      datePublished: datePublished,
      datePublishedNTP: Timestamp.fromDate(datePublishedNTP),
      likes: [],
      likeCount: 0,
      dislikes: [],
      dislikeCount: 0,
      reportCounter: 0,
      reportChecked: false,
      reportRemoved: false,
    );

    _postPollCommentAndRepliesList.insert(
      0,
      CommentsAndReplies(comment: comment, replyList: []),
    );
  }

  addNewReplyInPostPoll({
    required String postId,
    required String text,
    required String uid,
    required String username,
    required String commentId,
    required String replyId,
    required int insertAt,
    required DateTime datePublishedNTP,
  }) {
    // String trimmedText = trimText(text: text);
    // var timeNow = await NTP.now();
    Reply reply = Reply(
      parentMessageId: postId,
      parentCommentId: commentId,
      username: username,
      UID: uid,
      text: text,
      replyId: replyId,
      datePublished: Timestamp.fromDate(datePublishedNTP),
      datePublishedNTP: Timestamp.fromDate(datePublishedNTP),
      likes: [],
      likeCount: 0,
      dislikes: [],
      dislikeCount: 0,
      reportCounter: 0,
      reportChecked: false,
      reportRemoved: false,
    );

    for (var index = 0;
        index < _postPollCommentAndRepliesList.length;
        index++) {
      CommentsAndReplies commentsAndReplies =
          _postPollCommentAndRepliesList[index];

      if (commentId == commentsAndReplies.comment.commentId) {
        commentsAndReplies.replyList.insert(insertAt, reply);
        // commentsAndReplies.replyList.insert(0, reply);
      }
    }
  }

  sendUserToPost(String parentId,
      {Function(Poll)? sendUserToPoll, Function(Post)? sendUserToPost}) async {
    try {
      var pollQuery = FirebaseFirestore.instance.collection('polls').where(
            'pollId',
            isEqualTo: parentId,
          );
      var postQuery = FirebaseFirestore.instance.collection('posts').where(
            'postId',
            isEqualTo: parentId,
          );

      var pollSnapShot = await pollQuery.get();
      var postSnapShot = await postQuery.get();

      if (pollSnapShot.docs.isNotEmpty) {
        Poll poll = Poll.fromSnap(pollSnapShot.docs[0]);
        (sendUserToPoll ?? () {})(poll);
      }

      if (postSnapShot.docs.isNotEmpty) {
        Post post = Post.fromSnap(postSnapShot.docs[0]);
        (sendUserToPost ?? () {})(post);
      }
    } catch (e) {
      //
    }
  }

  bool checkIfAlreadyExistInUserCommentList(
      {required String? id, required bool isComment}) {
    bool exist = false;
    if (isComment) {
      for (var i = 0; i < _userCommentList.length; i++) {
        CommentsReplies commentsReplies = _userCommentList[i];
        if (commentsReplies.comment?.commentId == id) {
          exist = true;
        }
      }
    } else {
      for (var i = 0; i < _userCommentList.length; i++) {
        CommentsReplies commentsReplies = _userCommentList[i];
        if (commentsReplies.reply?.replyId == id) {
          exist = true;
        }
      }
    }

    return exist;
  }

  bool checkIfAlreadyExistInPostPollList(
      {required String? id, required bool isComment, String? parentCommentId}) {
    bool exist = false;
    for (var i = 0; i < _postPollCommentAndRepliesList.length; i++) {
      CommentsAndReplies commentsAndReplies = _postPollCommentAndRepliesList[i];
      if (isComment) {
        if (commentsAndReplies.comment.commentId == id) {
          exist = true;
        }
      } else {
        if (commentsAndReplies.comment.commentId == parentCommentId) {
          for (var r = 0; r < commentsAndReplies.replyList.length; r++) {
            Reply reply = commentsAndReplies.replyList[r];
            if (reply.replyId == id) {
              exist = true;
            }
          }
        }
      }
    }
    return exist;
  }

  dynamic getCommentOrReplyViaId({
    required String commentOrReplyId,
    bool isReply = false,
  }) async {
    if (isReply) {
      var replySnap = await FirebaseFirestore.instance
          .collection('replies')
          .where("replyId", isEqualTo: commentOrReplyId)
          .get();
      if (replySnap.docs.isNotEmpty) {
        Reply reply = Reply.fromSnap(replySnap.docs[0]);
        return reply;
      }
    } else {
      var commentSnap = await FirebaseFirestore.instance
          .collection('comments')
          .where("commentId", isEqualTo: commentOrReplyId)
          .get();
      if (commentSnap.docs.isNotEmpty) {
        Comment comment = Comment.fromSnap(commentSnap.docs[0]);
        return comment;
      }
    }
  }

  List<CommentsAndReplies> rearrangeSnap(
      List<CommentsAndReplies> commentsList, String commentId) {
    var index = -1;
    for (var i = 0; i < commentsList.length; i++) {
      Comment comment = commentsList[i].comment;
      if (comment.commentId == commentId) {
        index = i;
      }
    }
    if (index != -1) {
      var temp = commentsList[index];
      commentsList.removeAt(index);
      commentsList.insert(0, temp);
    }
    return commentsList;
  }

  get userCommentList => _userCommentList;

  get userReplyList => _userReplyList;

  get pageLoading => _pageLoading;

  get postPollCommentLoader => _postPollCommentLoader;

  get commentPageScrollLoading => _commentPageScrollLoading;

  get replyPageScrollLoading => _replyPageScrollLoading;

  get commentLastCheck => _userCommentLast;

  get replyLastCheck => _userReplyLast;

  get postPollCommentAndReplyList => _postPollCommentAndRepliesList;

  get postPollPaginationLoader => _postPollCommentPaginationLoader;

  get canPostPollLoadMore => !(_pollPostUserCommentLast);

  get canPostPollRepliesLoadMoreMap => _canRepliesLoadMore;
  get canPostPollRepliesPaginationLoadingMap =>
      _pollPostRepliesPaginationLoading;
}

// Returns Combined List of Poll and posts done by user
// getCommentReplyResult(
//     String? userId, {
//       bool getNextPage = false,
//       bool requiredComment = true,
//     }) async {
//   try {
//     if (getNextPage) {
//       _pageScrollLoading = true;
//       notifyListeners();
//     } else {
//       _pageLoading = true;
//       notifyListeners();
//       _userCommentList = [];
//       _userReplyList = [];
//       _userCommentSizeCount = 0;
//       _userReplySizeCount = 0;
//     }
//
//     var commentQuery = FirebaseFirestore.instance
//         .collection('comments')
//         .where('UID', isEqualTo: userId ?? "")
//         .orderBy("datePublished", descending: true)
//         .where('reportRemoved', isEqualTo: false);
//     var replyQuery = FirebaseFirestore.instance
//         .collection('replies')
//         .where('UID', isEqualTo: userId ?? "")
//         .orderBy("datePublished", descending: true)
//         .where('reportRemoved', isEqualTo: false);
//
//     var commentSnap = await commentQuery.count().get();
//     var replySnap = await replyQuery.count().get();
//
//     Future.delayed(Duration.zero);
//
//     if (getNextPage) {
//       if (!_userCommentLast) {
//         _userCommentSnapShot = await commentQuery
//             .startAfterDocument(_userCommentSnapShot!.docs.last)
//             .limit(_pageSize)
//             .get();
//       }
//       if (!_userReplyLast) {
//         _userReplySnapShot = await replyQuery
//             .startAfterDocument(_userReplySnapShot!.docs.last)
//             .limit(_pageSize)
//             .get();
//       }
//     } else {
//       _userCommentSnapShot = await commentQuery.limit(_pageSize).get();
//       _userReplySnapShot = await replyQuery.limit(_pageSize).get();
//     }
//
//     // List<CommentsReplies> temporaryListing = [];
//
//     for (var element in _userCommentSnapShot!.docs) {
//       Comment comment = Comment.fromSnap(
//         element,
//       );
//
//       var pollQuery = FirebaseFirestore.instance.collection('polls').where(
//         'pollId',
//         isEqualTo: comment.parentId,
//       );
//
//       var postQuery = FirebaseFirestore.instance.collection('posts').where(
//         'postId',
//         isEqualTo: comment.parentId,
//       );
//
//       var pollQuerySnapShot = await pollQuery.get();
//       var postQuerySnapShot = await postQuery.get();
//
//       print(
//           "========================> ${element.data()} in _userCommentSnapShot!.docs");
//       print("Got Poll SnapShot ::::; ${pollQuerySnapShot.docs}");
//       print("Got Post SnapShot ::::; ${postQuerySnapShot.docs}");
//
//       if (!checkIfAlreadyExistInUserCommentList(
//           id: comment.commentId, isComment: true)) {
//         if (pollQuerySnapShot.docs.isNotEmpty) {
//           Poll poll = Poll.fromSnap(pollQuerySnapShot.docs[0]);
//           _userCommentList.add(
//             CommentsReplies(
//               datePublished: comment.datePublished,
//               commentReplyType: CommentReplyType.comment,
//               comment: comment,
//               postOrPollComment: PostOrPollComment.poll,
//               poll: poll,
//             ),
//           );
//         }
//
//         if (postQuerySnapShot.docs.isNotEmpty) {
//           Post post = Post.fromSnap(postQuerySnapShot.docs[0]);
//           _userCommentList.add(
//             CommentsReplies(
//               datePublished: comment.datePublished,
//               commentReplyType: CommentReplyType.comment,
//               comment: comment,
//               postOrPollComment: PostOrPollComment.post,
//               post: post,
//             ),
//           );
//         }
//       }
//     }
//
//     for (var element in _userReplySnapShot!.docs) {
//       Reply reply = Reply.fromSnap(
//         element,
//       );
//       var pollQuery = FirebaseFirestore.instance.collection('polls').where(
//         'pollId',
//         isEqualTo: reply.parentMessageId,
//       );
//       var postQuery = FirebaseFirestore.instance.collection('posts').where(
//         'postId',
//         isEqualTo: reply.parentMessageId,
//       );
//
//       var pollQuerySnapShot = await pollQuery.get();
//       var postQuerySnapShot = await postQuery.get();
//
//       print(
//           "========================> ${element.data()} in _userCommentSnapShot!.docs");
//       print("Got Poll SnapShot ::::; ${pollQuerySnapShot.docs}");
//       print("Got Post SnapShot ::::; ${postQuerySnapShot.docs}");
//
//       if (!checkIfAlreadyExistInUserCommentList(
//           id: reply.replyId, isComment: false)) {
//         if (pollQuerySnapShot.docs.isNotEmpty) {
//           Poll poll = Poll.fromSnap(pollQuerySnapShot.docs[0]);
//           _userReplyList.add(
//             CommentsReplies(
//               datePublished: reply.datePublished,
//               commentReplyType: CommentReplyType.reply,
//               reply: reply,
//               postOrPollComment: PostOrPollComment.poll,
//               poll: poll,
//             ),
//           );
//         }
//
//         if (postQuerySnapShot.docs.isNotEmpty) {
//           Post post = Post.fromSnap(postQuerySnapShot.docs[0]);
//           _userReplyList.add(
//             CommentsReplies(
//               datePublished: reply.datePublished,
//               commentReplyType: CommentReplyType.reply,
//               reply: reply,
//               postOrPollComment: PostOrPollComment.post,
//               post: post,
//             ),
//           );
//         }
//       }
//     }
//
//     // temporaryListing.sort((a, b) {
//     //   print("A Date :::  ${a.datePublished}");
//     //   print("B Date :::  ${b.datePublished}");
//     //   print(
//     //       "b.datePublished.compareTo(a.datePublished) :::  ${b.datePublished.compareTo(a.datePublished)}");
//     //   return b.datePublished.compareTo(a.datePublished);
//     // });
//     // _userCommentReplyList.addAll(temporaryListing);
//
//     if (getNextPage) {
//       _userCommentSizeCount += _userCommentSnapShot!.docs.length;
//       _userReplySizeCount += _userReplySnapShot!.docs.length;
//       if (_userCommentSizeCount == commentSnap.count) {
//         _userCommentLast = true;
//       }
//       if (_userReplySizeCount == replySnap.count) {
//         _userReplyLast = true;
//       }
//     } else {
//       _userCommentLast = false;
//       _userReplyLast = false;
//       _userCommentSizeCount = _userCommentSnapShot!.docs.length;
//       _userReplySizeCount = _userReplySnapShot!.docs.length;
//       if (_userCommentSizeCount < _pageSize ||
//           _pageSize == commentSnap.count) {
//         _userCommentLast = true;
//       }
//       if (_userReplySizeCount < _pageSize || _pageSize == replySnap.count) {
//         _userReplyLast = true;
//       }
//     }
//
//     debugPrint("User Comment Length  : ${_userCommentList.length}");
//     debugPrint("User Replies Length  : ${_userReplyList.length}");
//   } catch (e, st) {
//     debugPrint('PostProvider getUserPost error $e $st');
//   } finally {
//     if (getNextPage) {
//       _pageScrollLoading = false;
//     } else {
//       _pageLoading = false;
//     }
//     notifyListeners();
//   }
// }
