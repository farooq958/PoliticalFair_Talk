import 'dart:async';
import 'package:aft/ATESTS/models/CommentsReplies.dart';
import 'package:aft/ATESTS/provider/most_liked_key_provider.dart';
import 'package:aft/ATESTS/provider/poll_provider.dart';
import 'package:aft/ATESTS/screens/full_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../models/comment.dart';
import '../provider/comments_replies_provider.dart';
import '../provider/filter_provider.dart';
import '../provider/left_time_provider.dart';
import '../provider/searchpage_provider.dart';
import '../provider/timer_provider.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../zFeeds/comment_card_poll.dart';
import '../models/poll.dart';
import '../models/user.dart';
import '../poll/poll_view.dart';
import '../methods/firestore_methods.dart';
import '../utils/utils.dart';
import 'profile_all_user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

String? currentReplyCommentId;

// class CommentSort {
//   final String label;
//   final String key;
//   final bool value;
//   final Icon icon;
//   final Icon iconSelected;
//
//   CommentSort({
//     required this.label,
//     required this.key,
//     required this.value,
//     required this.icon,
//     required this.iconSelected,
//   });
// }
//
// class CommentFilter {
//   final String label;
//   Icon? icon;
//   RotatedBox? rotatedBox;
//   final String key;
//   final String value;
//   final Icon prefixIcon;
//   final Icon prefixIconSelected;
//
//   CommentFilter({
//     required this.label,
//     this.icon,
//     this.rotatedBox,
//     required this.key,
//     required this.value,
//     required this.prefixIcon,
//     required this.prefixIconSelected,
//   });
// }

class FullMessagePoll extends StatefulWidget {
  final Poll poll;
  final String pollId;
  final CommentsReplies? commentsReplies;
  final bool? isReply;
  var durationInDay;

  FullMessagePoll(
      {Key? key,
      required this.poll,
      required this.pollId,
      this.commentsReplies,
      this.isReply,
      required this.durationInDay})
      : super(key: key);

  @override
  State<FullMessagePoll> createState() => _FullMessagePollState();
}

class _FullMessagePollState extends State<FullMessagePoll> {
  late Poll _poll;
  final AuthMethods _authMethods = AuthMethods();
  User? _userProfile;
  final TextEditingController _commentController = TextEditingController();
  bool isLikeAnimating = false;
  bool filter = false;
  bool _isPollEnded = false;
  // DateTime ntpTime = DateTime.now();
  GlobalKey? commentScrollKey = GlobalKey();
  var snap;

  var durationInDay = 0;
  FirebaseDatabase rdb = FirebaseDatabase.instance;

  // /***/
  // /***/
  // InterstitialAd? interstitialAd;

  // final String interstitialAdUnitIdIOS = 'ca-app-pub-1591305463797264/4735037493';
  // final String interstitialAdUnitIdAndroid =
  //     'ca-app-pub-1591305463797264/9016556769';
  // /***/
  // /***/

  List<CommentSort> commentSorts = [
    CommentSort(
        label: 'Most Popular',
        key: 'likeCount',
        value: true,
        icon: const Icon(Icons.trending_up, size: 17, color: Colors.grey),
        iconSelected:
            const Icon(Icons.trending_up, size: 17, color: Colors.black)),
    CommentSort(
        label: 'Most Recent',
        key: 'datePublished',
        value: true,
        icon: const Icon(Icons.stars, size: 17, color: Colors.grey),
        iconSelected: const Icon(Icons.stars, size: 17, color: Colors.black)),
  ];

  ScrollController _scrollController = ScrollController();

  reinitializeCommentFilter(Poll poll) {
    commentFilters.clear();
    commentFilters.add(CommentFilter(
      label: 'Show All',
      key: 'commentId',
      value: 'all',
      prefixIcon: const Icon(
        Icons.done_all,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done_all,
        color: Colors.black,
        size: 15,
      ),
    ));
    for (int i = 1; i < 11; i++) {
      String option = poll.toJson()["bOption$i"];
      if (option.isNotEmpty) {
        commentFilters.add(CommentFilter(
          label: '$option ',
          key: "vote$i",
          value: 'UID',
          prefixIcon: const Icon(
            Icons.done,
            color: Colors.grey,
            size: 15,
          ),
          prefixIconSelected: const Icon(
            Icons.done,
            color: Colors.black,
            size: 15,
          ),
        ));
      }
    }
    // ignore: avoid_function_literals_in_foreach_calls
    commentFilters.forEach((element) {
      // print(element.key);
    });
  }

  List<CommentFilter> commentFilters = [
    CommentFilter(
      label: 'Show All',
      key: 'commentId',
      value: 'all',
      prefixIcon: const Icon(
        Icons.done_all,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done_all,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 1',
      key: 'plus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 2',
      key: 'neutral',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 3',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done_all,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done_all,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 4',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 5',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 6',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 7',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 8',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 9',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
    CommentFilter(
      label: 'Option 10',
      key: 'minus',
      value: 'UID',
      prefixIcon: const Icon(
        Icons.done,
        color: Colors.grey,
        size: 15,
      ),
      prefixIconSelected: const Icon(
        Icons.done,
        color: Colors.black,
        size: 15,
      ),
    ),
  ];

  late CommentSort _selectedCommentSort;
  late CommentFilter _selectedCommentFilter;
  CommentReplyProvider? commentReplyProvider;

  final CollectionReference firestoreInstance =
      FirebaseFirestore.instance.collection('postCounter');

  int getCounterComment = 0;

  Future<String> _loadCommentCounter() async {
    String res1 = "Some error occurred.";
    try {
      await firestoreInstance.doc('commentCounter').get().then((event) {
        setState(() {
          getCounterComment = event['counter'];
        });
      });
      res1 = "success";
    } catch (e) {
      //
    }
    return res1;
  }

  void pollComment(
      String pollId, String text, String uid, String username) async {
    try {
      String res1 = await _loadCommentCounter();
      String res = await FirestoreMethods()
          .comment(pollId, text, uid, username, getCounterComment);
      if (res1 == "success" && res == "success") {
        FirestoreMethods().commentCounter(_poll.pollId, 'poll', true);
        // _showInterstitialAd();
        // await AuthMethods().commentWaitTimer();
        // setState(() {
        //   _selectedCommentSort = commentSorts.last;
        //   _selectedCommentFilter = commentFilters.first;
        // });
      } else {
        // showSnackBar(res, context);
      }
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    _getStartTime();
    Provider.of<FilterProvider>(context, listen: false)
        .setDurationInDay(durationInDay);

    // _loadInterstitialAd();

    _poll = widget.poll;

    if ((widget.durationInDay == (widget.poll.time + 0)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 1)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 2)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 3)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 4)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 5)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 6)) == true) {
      _isPollEnded = false;
    } else {
      _isPollEnded = true;
    }
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   if (commentScrollKey.currentContext != null) {
    //     Scrollable.ensureVisible(commentScrollKey.currentContext!);
    //   }
    // });
    reinitializeCommentFilter(_poll);
    // });
    _selectedCommentSort = commentSorts.first;
    _selectedCommentFilter = commentFilters.first;

    currentReplyCommentId = null;
    getAllUserDetails();
    Future.delayed(Duration.zero, () async {
      String? commentId;
      String? replyId;

      if (widget.commentsReplies != null) {
        if (widget.isReply ?? false) {
          commentId = widget.commentsReplies?.reply?.parentCommentId;
          replyId = widget.commentsReplies?.reply?.replyId;
        } else {
          commentId = widget.commentsReplies?.comment?.commentId;
        }
      }

      commentReplyProvider =
          Provider.of<CommentReplyProvider>(context, listen: false);
      commentReplyProvider?.getPollOrPostCommentList(
        postPollId: _poll.pollId,
        selectedCommentFilter: _selectedCommentFilter,
        selectedCommentSort: _selectedCommentSort,
        postPoll: _poll.toJson(),
        isFromProfile: (widget.commentsReplies != null),
        clickedCommentId: commentId,
        clickedReplyId: replyId,
      );
    });
    initScrollControllerListener();
  }

  // void _loadInterstitialAd() {
  //   if (Platform.isIOS) {
  //     InterstitialAd.load(
  //       adUnitId: interstitialAdUnitIdIOS,

  //       request: const AdRequest(),
  //       adLoadCallback:
  //           InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
  //         interstitialAd = ad;

  //         _setFullScreenContentCallback(ad);
  //       }, onAdFailedToLoad: (LoadAdError loadAdError) {
  //         debugPrint('$loadAdError');
  //       }),
  //       // orientation: AppOpenAd.orientationPortrait,
  //     );
  //   } else if (Platform.isAndroid) {
  //     InterstitialAd.load(
  //       adUnitId: interstitialAdUnitIdAndroid,
  //       request: const AdRequest(),
  //       adLoadCallback:
  //           InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
  //         interstitialAd = ad;

  //         _setFullScreenContentCallback(ad);
  //       }, onAdFailedToLoad: (LoadAdError loadAdError) {
  //         debugPrint('$loadAdError');
  //       }),
  //       // orientation: AppOpenAd.orientationPortrait,
  //     );
  //   }
  // }

  // void _setFullScreenContentCallback(InterstitialAd ad) {
  //   ad.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) => print('$ad'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       debugPrint('$ad');
  //       showSnackBar(
  //         'Comment successfully posted.',
  //         context,
  //       );
  //       ad.dispose();
  //       interstitialAd = null;
  //       _loadInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       debugPrint('$ad - error: $error');
  //       ad.dispose();
  //       interstitialAd = null;
  //       _loadInterstitialAd();
  //     },
  //     onAdImpression: (InterstitialAd ad) =>
  //         debugPrint('$ad Impression occurred'),
  //   );
  // }

  // void _showInterstitialAd() {
  //   interstitialAd?.show();
  // }

  void initScrollControllerListener() {
    // _scrollController.addListener(() {
    //   if (_scrollController.position.maxScrollExtent <=
    //       _scrollController.offset) {
    //     if (commentReplyProvider?.canPostPollLoadMore) {
    commentReplyProvider?.getPollOrPostCommentList(
      postPollId: _poll.pollId,
      selectedCommentFilter: _selectedCommentFilter,
      selectedCommentSort: _selectedCommentSort,
      postPoll: _poll.toJson(),
      isNextPage: true,
    );
    //     }
    //   }
    // });
  }

  getAllUserDetails() async {
    User userProfile = await _authMethods.getUserProfileDetails(_poll.UID);
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _poll = widget.poll;
    // final leftTimeProvider =
    //     Provider.of<LeftTimeProvider>(context, listen: false);

    final User? user = Provider.of<UserProvider>(context).getUser;
    // _isPollEnded =
    //     (_poll.endDate as Timestamp).toDate().difference(ntpTime).isNegative;
    final pollsProvider = Provider.of<PollsProvider>(context, listen: false);

    return user == null
        ? buildFullPoll(context)
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.UID)
                .snapshots(),
            builder: (content,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              snap =
                  snapshot.data != null ? User.fromSnap(snapshot.data!) : snap;
              if (!snapshot.hasData || snapshot.data == null) {
                return Row();
              }
              return buildFullPoll(context);
            });
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
      // debugPrint(
      //     "======> Re arranged Snaps :::: ${commentsList[0].comment.commentId}");
    }
    return commentsList;
  }

  Widget buildFullPoll(BuildContext context) {
    _poll = widget.poll;
    // final leftTimeProvider =
    //     Provider.of<LeftTimeProvider>(context, listen: false);

    final User? user = Provider.of<UserProvider>(context).getUser;
    // _isPollEnded =
    //     (_poll.endDate as Timestamp).toDate().difference(ntpTime).isNegative;
    final pollsProvider = Provider.of<PollsProvider>(context, listen: false);
    // _isCommentTimerEnded =
    //     (timerCommentEnd).toDate().difference(ntpTime).isNegative;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('polls')
            .doc(widget.pollId)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          _poll = snapshot.data != null ? Poll.fromSnap(snapshot.data!) : _poll;
          snapshot.data != null
              ? pollsProvider.updatePollRealTime(Poll.fromSnap(snapshot.data!))
              : null;
          snapshot.data != null
              ? Provider.of<SearchPageProvider>(context, listen: false)
                  .updatePollRealTime(Poll.fromSnap(snapshot.data!))
              : null;
          snapshot.data != null
              ? Provider.of<MostLikedKeyProvider>(context, listen: false)
                  .updatePollRealTime(Poll.fromSnap(snapshot.data!))
              : null;

          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black.withOpacity(0.05),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  elevation: 4,
                  actions: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Material(
                                  color: Colors.transparent,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                    splashColor: Colors.grey.withOpacity(0.5),
                                    onPressed: () {
                                      Future.delayed(
                                        const Duration(milliseconds: 50),
                                        () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_back,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Text(
                                //   _pollTimeLeftLabel(poll: _poll),
                                //   style: const TextStyle(
                                //     fontSize: 10,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                // Material(
                                //   color: Colors.transparent,
                                //   child: InkWell(
                                //     borderRadius:
                                //         BorderRadius.circular(5),
                                //     // customBorder: const CircleBorder(),
                                //     splashColor:
                                //         Colors.grey.withOpacity(0.3),
                                //     onTap: () {
                                //       Future.delayed(
                                //           const Duration(
                                //               milliseconds: 50), () {
                                //         scoreDialogPoll(context: context);
                                //       });
                                //     },
                                //     child: Text(placement,
                                //         style: const TextStyle(
                                //             color: Color.fromARGB(
                                //                 255, 143, 143, 143),
                                //             fontSize: 24,
                                //             fontStyle: FontStyle.italic,
                                //             fontWeight: FontWeight.w500)),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 38,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          scoreDialogPoll(context: context);
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            ' Score ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Container(height: 0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.check_box,
                                                size: 13,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                              ),
                                              Container(width: 4),
                                              Text(
                                                _poll.totalVotes == 1
                                                    ? '${_poll.totalVotes}'
                                                    : '${_poll.totalVotes}',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color.fromARGB(
                                                        255, 81, 81, 81),
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                SizedBox(
                                  // width: 95,
                                  height: 38,
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      splashColor: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          timerDialog(
                                              context: context, type: 'poll');
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Time Left',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Container(height: 0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.timer,
                                                size: 13,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                              ),
                                              Container(width: 4),
                                              // Consumer<LeftTimeProvider>(
                                              //     builder: (context,
                                              //         leftTimeProvider, child) {
                                              //   if (leftTimeProvider.loading) {
                                              //     return const SizedBox();
                                              //   } else if (_poll
                                              //       .getEndDate()
                                              //       .isBefore(leftTimeProvider
                                              //           .leftTime))
                                              //           {
                                              //     return
                                              Text(
                                                durationInDay ==
                                                        (widget.poll.time)
                                                    ? '7 Days'
                                                    : durationInDay ==
                                                            (widget.poll.time +
                                                                1)
                                                        ? '6 Days'
                                                        : durationInDay ==
                                                                (widget.poll
                                                                        .time +
                                                                    2)
                                                            ? '5 Days'
                                                            : durationInDay ==
                                                                    (widget.poll
                                                                            .time +
                                                                        3)
                                                                ? '4 Days'
                                                                : durationInDay ==
                                                                        (widget.poll.time +
                                                                            4)
                                                                    ? '3 Days'
                                                                    : durationInDay ==
                                                                            (widget.poll.time +
                                                                                5)
                                                                        ? '2 Days'
                                                                        : durationInDay ==
                                                                                (widget.poll.time + 6)
                                                                            ? '1 Day'
                                                                            : 'None',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color.fromARGB(
                                                        255, 81, 81, 81),
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              //   } else if (_poll
                                              //       .getEndDate()
                                              //       .isAfter(leftTimeProvider
                                              //           .leftTime)) {
                                              //     return ChangeNotifierProvider(
                                              //       create: (context) =>
                                              //           TimerProvider(
                                              //               _poll.getEndDate()),
                                              //       child:
                                              //           Consumer<TimerProvider>(
                                              //               builder: (context,
                                              //                   timerProvider,
                                              //                   child) {
                                              //         return Text(
                                              //           timerProvider
                                              //               .timeString,
                                              //           style: const TextStyle(
                                              //               fontSize: 13,
                                              //               color:
                                              //                   Color.fromARGB(
                                              //                       255,
                                              //                       81,
                                              //                       81,
                                              //                       81),
                                              //               letterSpacing: 0.5,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w500),
                                              //         );
                                              //       }),
                                              //     );
                                              //   } else {
                                              //     return const Text("");
                                              //   }
                                              // }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                SizedBox(
                                  // width: 85,
                                  height: 38,
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      splashColor: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Comments',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                MyFlutterApp.comments,
                                                size: 13,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                              ),
                                              Container(width: 8),
                                              Center(
                                                child: Text(
                                                  '${_poll.commentCount}',
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                          255, 81, 81, 81),
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                // StreamBuilder(
                                                //   stream: FirebaseFirestore
                                                //       .instance
                                                //       .collection('polls')
                                                //       .doc(_poll.pollId)
                                                //       .collection('comments')
                                                //       .snapshots(),
                                                //   builder: (content, snapshot) {
                                                //     print(
                                                //         'BEFORE SNAPSHOT _post.comments: ${widget.poll.comments}');

                                                //     return Text(
                                                //       '${(snapshot.data as dynamic)?.docs.length ?? 0}',
                                                //       style: const TextStyle(
                                                //           fontSize: 13,
                                                //           color: Color.fromARGB(
                                                //               255, 81, 81, 81),
                                                //           letterSpacing: 0.5,
                                                //           fontWeight:
                                                //               FontWeight.w500),
                                                //     );
                                                //   },
                                                // ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 0, left: 0, top: 10, bottom: 0),
                        child: Column(
                          children: [
                            PhysicalModel(
                              elevation: 2,
                              color: Colors.transparent,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  // border: Border(
                                  //     top: BorderSide(
                                  //         width: 1,
                                  //         color:
                                  //             Color.fromARGB(255, 220, 220, 220)),
                                  //     bottom: BorderSide(
                                  //         width: 1,
                                  //         color: Color.fromARGB(
                                  //             255, 220, 220, 220))),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                        top: 10.0,
                                        right: 10,
                                        left: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromARGB(
                                                  255, 200, 200, 200),
                                            ),
                                            child: Stack(
                                              children: [
                                                _userProfile?.photoUrl != null
                                                    ? Material(
                                                        color: Colors.grey,
                                                        shape:
                                                            const CircleBorder(),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Ink.image(
                                                          image: NetworkImage(
                                                              _userProfile
                                                                      ?.photoUrl ??
                                                                  ''),
                                                          fit: BoxFit.cover,
                                                          width: 40,
                                                          height: 40,
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.5),
                                                            onTap: () {
                                                              Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        100),
                                                                () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ProfileAllUser(
                                                                              uid: _poll.UID,
                                                                              initialTab: 0,
                                                                            )),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : Material(
                                                        color: Colors.grey,
                                                        shape:
                                                            const CircleBorder(),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Ink.image(
                                                          image: const AssetImage(
                                                              'assets/avatarFT.jpg'),
                                                          fit: BoxFit.cover,
                                                          width: 40,
                                                          height: 40,
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.5),
                                                            onTap: () {
                                                              Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        100),
                                                                () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ProfileAllUser(
                                                                              uid: _poll.UID,
                                                                              initialTab: 0,
                                                                            )),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 3,
                                                  child: Row(
                                                    children: [
                                                      _userProfile?.profileFlag ==
                                                              true
                                                          ? SizedBox(
                                                              width: 20,
                                                              height: 10,
                                                              child: Image.asset(
                                                                  'icons/flags/png/${_userProfile?.aaCountry}.png',
                                                                  package:
                                                                      'country_icons'))
                                                          : Row()
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 1,
                                                  child: Row(
                                                    children: [
                                                      _userProfile?.profileBadge ==
                                                              true
                                                          ? Stack(
                                                              children: const [
                                                                Positioned(
                                                                  right: 3,
                                                                  top: 3,
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 4,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  child: Icon(
                                                                      Icons
                                                                          .verified,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          113,
                                                                          191,
                                                                          255),
                                                                      size: 13),
                                                                ),
                                                              ],
                                                            )
                                                          : Row()
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileAllUser(
                                                                uid: _poll.UID,
                                                                initialTab: 0,
                                                              )),
                                                    );
                                                  },
                                                  child: Text(
                                                    _userProfile?.username ??
                                                        '',
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 15.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        letterSpacing: 0.5),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  DateFormat.yMMMd().format(
                                                    _poll.datePublishedNTP
                                                        .toDate(),
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 12.5,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Material(
                                              color: Colors.transparent,
                                              shape: const CircleBorder(),
                                              child: InkWell(
                                                customBorder:
                                                    const CircleBorder(),
                                                splashColor: Colors.grey
                                                    .withOpacity(0.5),
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 50),
                                                      () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return SimpleDialog(
                                                            children: [
                                                              _poll.UID ==
                                                                      user?.UID
                                                                  ? Row()
                                                                  : SimpleDialogOption(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.block),
                                                                          Container(
                                                                              width: 10),
                                                                          const Text(
                                                                              'Block User',
                                                                              style: TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                        ],
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Future.delayed(
                                                                            const Duration(milliseconds: 150),
                                                                            () {
                                                                          performLoggedUserAction(
                                                                            context:
                                                                                context,
                                                                            action:
                                                                                () {
                                                                              // blockDialog(
                                                                              //   context: context,
                                                                              //   isSearch: false,
                                                                              //   action: () async {
                                                                              //     var userRef = FirebaseFirestore.instance.collection("users").doc(user?.UID);
                                                                              //     var blockListRef = FirebaseFirestore.instance.collection("users").doc(user?.UID).collection('blockList').doc(_poll.UID);
                                                                              //     var blockUserInfo = await FirebaseFirestore.instance.collection("users").doc(_poll.UID).get();
                                                                              //     if (blockUserInfo.exists) {
                                                                              //       final batch = FirebaseFirestore.instance.batch();
                                                                              //       batch.update(userRef, {
                                                                              //         'blockList': FieldValue.arrayUnion([
                                                                              //           _poll.UID
                                                                              //         ])
                                                                              //       });
                                                                              //       batch.set(blockListRef, blockUserInfo.data());
                                                                              //       batch.commit();
                                                                              //     }

                                                                              //     showSnackBar('User successfully blocked.', context);
                                                                              //     Navigator.pop(context);
                                                                              //     Navigator.pop(context);
                                                                              //   },
                                                                              // );
                                                                              blockDialog(
                                                                                action: () async {
                                                                                  var userRef = FirebaseFirestore.instance.collection("users").doc(user?.UID);
                                                                                  var blockListRef = FirebaseFirestore.instance.collection("users").doc(user?.UID).collection('blockList').doc(_poll.UID);
                                                                                  var blockUserInfo = await FirebaseFirestore.instance.collection("users").doc(_poll.UID).get();
                                                                                  if (blockUserInfo.exists) {
                                                                                    final batch = FirebaseFirestore.instance.batch();
                                                                                    final blockingUserData = blockUserInfo.data();
                                                                                    blockingUserData?['creatorUID'] = user?.UID;
                                                                                    batch.update(userRef, {
                                                                                      'blockList': FieldValue.arrayUnion([
                                                                                        _poll.UID
                                                                                      ])
                                                                                    });
                                                                                    batch.set(
                                                                                      blockListRef,
                                                                                      blockingUserData,
                                                                                    );

                                                                                    batch.commit();
                                                                                  }
                                                                                  if (!mounted) return;
                                                                                  showSnackBar('User successfully blocked.', context);
                                                                                  Navigator.pop(context);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                context: context,
                                                                                isSearch: false,
                                                                              );
                                                                            },
                                                                          );
                                                                        });
                                                                      },
                                                                    ),
                                                              _poll.UID ==
                                                                      user?.UID
                                                                  ? Row()
                                                                  : SimpleDialogOption(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.report_outlined),
                                                                          Container(
                                                                              width: 10),
                                                                          const Text(
                                                                              'Report Message',
                                                                              style: TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                        ],
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Future
                                                                            .delayed(
                                                                          const Duration(
                                                                              milliseconds: 150),
                                                                          () {
                                                                            performLoggedUserAction(
                                                                                context: context,
                                                                                action: () {
                                                                                  // Future.delayed(
                                                                                  //     const Duration(
                                                                                  //         milliseconds:
                                                                                  //             150),
                                                                                  //     () {
                                                                                  reportDialog(
                                                                                    context: context,
                                                                                    type: 'poll',
                                                                                    typeCapital: 'Poll',
                                                                                    user: false,
                                                                                    action: () async {
                                                                                      await FirestoreMethods().reportCounter(_poll.pollId, _poll.reportChecked, 'poll');
                                                                                      if (!mounted) return;
                                                                                      showSnackBar('Poll successfully reported.', context);
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  );
                                                                                  // });
                                                                                });
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                              SimpleDialogOption(
                                                                onPressed: () {
                                                                  Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      () {
                                                                    keywordsDialog(
                                                                        context:
                                                                            context);
                                                                  });
                                                                },
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(20),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width:
                                                                              25,
                                                                          child: Icon(
                                                                              Icons.key,
                                                                              color: Colors.black),
                                                                        ),
                                                                        Container(
                                                                            width:
                                                                                10),
                                                                        // ignore: prefer_is_empty
                                                                        _poll.tagsLowerCase?.length ==
                                                                                0
                                                                            ? const Text(
                                                                                'No keywords used.',
                                                                                style: TextStyle(letterSpacing: 0.2, fontSize: 15, color: Colors.black),
                                                                              )
                                                                            : const Text(
                                                                                'Keywords:',
                                                                                style: TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          _poll.tagsLowerCase?.length == 1 || _poll.tagsLowerCase?.length == 2 || _poll.tagsLowerCase?.length == 3
                                                                              ? Row(
                                                                                  children: [
                                                                                    const SizedBox(width: 36),
                                                                                    const Text(
                                                                                      '•',
                                                                                      style: TextStyle(
                                                                                        fontSize: 20,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        '${_poll.tagsLowerCase?[0]}',
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              : Row(),
                                                                          _poll.tagsLowerCase?.length == 2 || _poll.tagsLowerCase?.length == 3
                                                                              ? Row(
                                                                                  children: [
                                                                                    const SizedBox(width: 36),
                                                                                    const Text(
                                                                                      '•',
                                                                                      style: TextStyle(
                                                                                        fontSize: 20,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        '${_poll.tagsLowerCase?[1]}',
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              : Row(),
                                                                          _poll.tagsLowerCase?.length == 3
                                                                              ? Row(
                                                                                  children: [
                                                                                    const SizedBox(width: 36),
                                                                                    const Text(
                                                                                      '•',
                                                                                      style: TextStyle(
                                                                                        fontSize: 20,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        '${_poll.tagsLowerCase?[2]}',
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              : Row(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  });
                                                },
                                                child:
                                                    const Icon(Icons.more_vert),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8.0, bottom: 4),
                                      child: Text('${_poll.aPollTitle} ',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          )),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8, bottom: 8),
                                      child: Stack(
                                        children: [
                                          PollView(
                                            poll: widget.poll,
                                            pollId: _poll.pollId,
                                            pollEnded: _isPollEnded,
                                            hasVoted: _poll.votesUIDs
                                                .contains(user?.UID),
                                            userVotedOptionId:
                                                _getUserPollOptionId(
                                                    user?.UID ?? ''),
                                            onVoted: (PollOption pollOption,
                                                int newTotalVotes) async {
                                              {
                                                // final leftTimeProvider =
                                                //     Provider.of<
                                                //             LeftTimeProvider>(
                                                //         context,
                                                //         listen: false);
                                                // await leftTimeProvider
                                                //     .getDate();

                                                // DateTime  now = await widget.post.getEndDate();

                                                if ((durationInDay ==
                                                        (_poll.time + 0)) ||
                                                    (durationInDay ==
                                                        (_poll.time + 1)) ||
                                                    (durationInDay ==
                                                        (_poll.time + 2)) ||
                                                    (durationInDay ==
                                                        (_poll.time + 3)) ||
                                                    (durationInDay ==
                                                        (_poll.time + 4)) ||
                                                    (durationInDay ==
                                                        (_poll.time + 5)) ||
                                                    (durationInDay ==
                                                        (_poll.time + 6))) {
                                                  setState(() {
                                                    _isPollEnded = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _isPollEnded = true;
                                                  });
                                                }

                                                void unverifiedPoll(
                                                    bool pending) async {
                                                  await FirestoreMethods()
                                                      .pollUnverified(
                                                    poll: widget.poll,
                                                    uid: user?.UID ?? '',
                                                    optionIndex: pollOption.id!,
                                                  );
                                                  showSnackBarAction(
                                                    "Votes from unverified accounts don't count!",
                                                    pending,
                                                    context,
                                                  );
                                                }

                                                performLoggedUserAction(
                                                    context: context,
                                                    action: () async {
                                                      _isPollEnded
                                                          ? showSnackBarError(
                                                              "This poll's voting cycle has already ended.",
                                                              context)
                                                          : snap?.pending ==
                                                                  'true'
                                                              ? unverifiedPoll(
                                                                  true)
                                                              : snap?.aaCountry ==
                                                                      ""
                                                                  ? unverifiedPoll(
                                                                      false)
                                                                  : widget.poll.country != "" &&
                                                                          widget.poll.global ==
                                                                              "false" &&
                                                                          widget.poll.country !=
                                                                              snap
                                                                                  .aaCountry
                                                                      ? showSnackBar(
                                                                          "Action failed. Voting nationally is only available for your specific country.",
                                                                          context)
                                                                      : user?.admin ==
                                                                              true
                                                                          ? await FirestoreMethods()
                                                                              .pollScore(
                                                                              poll: widget.poll,
                                                                              optionIndex: pollOption.id!,
                                                                            )
                                                                          : await FirestoreMethods()
                                                                              .poll(
                                                                              poll: widget.poll,
                                                                              uid: user?.UID ?? '',
                                                                              optionIndex: pollOption.id!,
                                                                            );
                                                    });
                                              }
                                            },
                                            leadingVotedProgessColor:
                                                Colors.blue.shade200,
                                            pollOptionsSplashColor:
                                                Colors.white,
                                            votedProgressColor: Colors.blueGrey
                                                .withOpacity(0.3),
                                            votedBackgroundColor:
                                                Colors.grey.withOpacity(0.2),
                                            votedCheckmark: const Icon(
                                              Icons.check_circle_outline,
                                              color: Color.fromARGB(
                                                  255, 17, 125, 21),
                                              size: 18,
                                            ),
                                            pollOptions: [
                                              PollOption(
                                                id: 1,
                                                title: Text(
                                                  _poll.bOption1,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                votes: _poll.voteCount1,
                                              ),
                                              PollOption(
                                                id: 2,
                                                title: Text(
                                                  _poll.bOption2,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                votes: _poll.voteCount2,
                                              ),
                                              if (_poll.bOption3 != '')
                                                PollOption(
                                                  id: 3,
                                                  title: Text(
                                                    _poll.bOption3,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount3,
                                                ),
                                              if (_poll.bOption4 != '')
                                                PollOption(
                                                  id: 4,
                                                  title: Text(
                                                    _poll.bOption4,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount4,
                                                ),
                                              if (_poll.bOption5 != '')
                                                PollOption(
                                                  id: 5,
                                                  title: Text(
                                                    _poll.bOption5,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount5,
                                                ),
                                              if (_poll.bOption6 != '')
                                                PollOption(
                                                  id: 6,
                                                  title: Text(
                                                    _poll.bOption6,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount6,
                                                ),
                                              if (_poll.bOption7 != '')
                                                PollOption(
                                                  id: 7,
                                                  title: Text(
                                                    _poll.bOption7,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount7,
                                                ),
                                              if (_poll.bOption8 != '')
                                                PollOption(
                                                  id: 8,
                                                  title: Text(
                                                    _poll.bOption8,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount8,
                                                ),
                                              if (_poll.bOption9 != '')
                                                PollOption(
                                                  id: 9,
                                                  title: Text(
                                                    _poll.bOption9,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount9,
                                                ),
                                              if (_poll.bOption10 != '')
                                                PollOption(
                                                  id: 10,
                                                  title: Text(
                                                    _poll.bOption10,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  votes: _poll.voteCount10,
                                                ),
                                            ],
                                            metaWidget: Row(
                                              children: [Row()],
                                            ),
                                          ),
                                          Positioned.fill(
                                              child: Visibility(
                                            visible: _isPollEnded,
                                            child: Container(
                                              color: Colors.cyanAccent
                                                  .withOpacity(0.0),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 0, right: 0, left: 0),
                              child: PhysicalModel(
                                elevation: 2,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    // border: Border(
                                    //     top: BorderSide(
                                    //         width: 1,
                                    //         color: Color.fromARGB(
                                    //             255, 220, 220, 220)),
                                    //     bottom: BorderSide(
                                    //         width: 1,
                                    //         color: Color.fromARGB(
                                    //             255, 220, 220, 220))),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 14,
                                              top: 16,
                                              bottom: 4,
                                            ),
                                            child: Text(
                                              'Comments (${_poll.commentCount})',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  letterSpacing: 0.8),
                                            ),
                                            // StreamBuilder(
                                            //   stream: _selectedCommentFilter
                                            //               .value ==
                                            //           'all'
                                            //       ? FirebaseFirestore.instance
                                            //           .collection('polls')
                                            //           .doc(_poll.pollId)
                                            //           .collection('comments')

                                            //           // Sort
                                            //           .orderBy(
                                            //               _selectedCommentSort
                                            //                   .key,
                                            //               descending:
                                            //                   _selectedCommentSort
                                            //                       .value)
                                            //           .snapshots()
                                            //       : FirebaseFirestore.instance
                                            //           .collection('polls')
                                            //           .doc(_poll.pollId)
                                            //           .collection('comments')
                                            //           .orderBy(
                                            //               _selectedCommentSort
                                            //                   .key,
                                            //               descending:
                                            //                   _selectedCommentSort
                                            //                       .value)
                                            //           // Filter
                                            //           .where(
                                            //               _selectedCommentFilter
                                            //                   .value,
                                            //               whereIn: (_poll
                                            //                       .toJson()[
                                            //                           _selectedCommentFilter
                                            //                               .key]
                                            //                       .isNotEmpty
                                            //                   ? _poll.toJson()[
                                            //                       _selectedCommentFilter
                                            //                           .key]
                                            //                   : [
                                            //                       'placeholder_uid'
                                            //                     ]))

                                            //           // Sort
                                            //           // .orderBy(_selectedCommentSort.key,
                                            //           //     descending:
                                            //           //         _selectedCommentSort
                                            //           //             .value)
                                            //           .snapshots(),
                                            //   builder: (content, snapshot) {
                                            //     return Text(
                                            //       'Comments (${(snapshot.data as dynamic)?.docs.length ?? 0})',
                                            //       style: const TextStyle(
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //           fontSize: 18,
                                            //           letterSpacing: 0.8),
                                            //     );
                                            //   },
                                            // ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                              top: 10,
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                splashColor: Colors.grey
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 50),
                                                      () {
                                                    setState(() {
                                                      filter = !filter;
                                                    });
                                                  });
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 25,
                                                  color: Colors.transparent,
                                                  child: Stack(
                                                    children: [
                                                      const Icon(
                                                        Icons.filter_list,
                                                        color: Colors.black,
                                                      ),
                                                      Positioned(
                                                        right: -3,
                                                        child: Icon(
                                                            filter == false
                                                                ? Icons
                                                                    .arrow_drop_down
                                                                : Icons
                                                                    .arrow_drop_up,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      filter == false
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0,
                                                  right: 6,
                                                  top: 10,
                                                  bottom: 1),
                                              child: Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    top: 6,
                                                    bottom: 6,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 43,
                                                            child: Text(
                                                              'Sort:   ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            2),
                                                                child: Row(
                                                                  children: [
                                                                    ...List.generate(
                                                                        commentSorts
                                                                            .length,
                                                                        (index) {
                                                                      CommentSort
                                                                          commentSort =
                                                                          commentSorts[
                                                                              index];
                                                                      return InkResponse(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              PhysicalModel(
                                                                                color: _selectedCommentSort == commentSort ? const Color.fromARGB(255, 187, 225, 255) : const Color.fromARGB(255, 245, 245, 245),
                                                                                elevation: 2,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      _selectedCommentSort == commentSort ? commentSort.iconSelected : commentSort.icon,
                                                                                      const SizedBox(width: 5),
                                                                                      Text(commentSort.label, style: TextStyle(color: _selectedCommentSort == commentSort ? Colors.black : Colors.grey)),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(width: 6),
                                                                            ],
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            setState(
                                                                              () {
                                                                                _selectedCommentSort = commentSort;
                                                                              },
                                                                            );
                                                                            commentReplyProvider?.getPollOrPostCommentList(
                                                                              postPollId: _poll.pollId,
                                                                              selectedCommentFilter: _selectedCommentFilter,
                                                                              selectedCommentSort: _selectedCommentSort,
                                                                              postPoll: _poll.toJson(),
                                                                            );
                                                                          });
                                                                    })
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(height: 6),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 43,
                                                            child: Text(
                                                                'Filter: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                )),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 2.0,
                                                                  bottom: 2,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    ...List.generate(
                                                                        commentFilters
                                                                            .length,
                                                                        (index) {
                                                                      CommentFilter
                                                                          commentFilter =
                                                                          commentFilters[
                                                                              index];
                                                                      return InkResponse(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              PhysicalModel(
                                                                                color: _selectedCommentFilter == commentFilter ? const Color.fromARGB(255, 187, 225, 255) : const Color.fromARGB(255, 245, 245, 245),
                                                                                elevation: 2,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      _selectedCommentFilter == commentFilter ? commentFilter.prefixIconSelected : commentFilter.prefixIcon,
                                                                                      const SizedBox(width: 5),
                                                                                      Text(
                                                                                        commentFilter.label == 'Show All' ? commentFilter.label : 'Voted: ${commentFilter.label}',
                                                                                        style: TextStyle(
                                                                                          color: _selectedCommentFilter == commentFilter ? Colors.black : Colors.grey,
                                                                                        ),
                                                                                      ),
                                                                                      commentFilter.icon ??
                                                                                          // Container(),
                                                                                          commentFilter.rotatedBox ??
                                                                                          Row(),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(width: 6),
                                                                            ],
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            setState(
                                                                              () {
                                                                                _selectedCommentFilter = commentFilter;
                                                                              },
                                                                            );
                                                                            commentReplyProvider?.getPollOrPostCommentList(
                                                                              postPollId: _poll.pollId,
                                                                              selectedCommentFilter: _selectedCommentFilter,
                                                                              selectedCommentSort: _selectedCommentSort,
                                                                              postPoll: _poll.toJson(),
                                                                            );
                                                                          });
                                                                    })
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 1.0,
                                          left: 1,
                                          bottom: 8,
                                        ),
                                        child: Container(
                                          color: Colors.white,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 9.0,
                                                  top: 14,
                                                ),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromARGB(
                                                        255, 200, 200, 200),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      user?.photoUrl != null
                                                          ? Material(
                                                              color:
                                                                  Colors.grey,
                                                              shape:
                                                                  const CircleBorder(),
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              child: Ink.image(
                                                                image: NetworkImage(
                                                                    '${user?.photoUrl}'),
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 40,
                                                                height: 40,
                                                                child: InkWell(
                                                                  splashColor: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5),
                                                                  onTap: () {
                                                                    Future
                                                                        .delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              100),
                                                                      () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ProfileAllUser(
                                                                                    uid: user?.UID ?? '',
                                                                                    initialTab: 0,
                                                                                  )),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : Material(
                                                              color:
                                                                  Colors.grey,
                                                              shape:
                                                                  const CircleBorder(),
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              child: Ink.image(
                                                                image: const AssetImage(
                                                                    'assets/avatarFT.jpg'),
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 40,
                                                                height: 40,
                                                                child: InkWell(
                                                                  splashColor: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5),
                                                                  onTap: () {
                                                                    Future
                                                                        .delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              100),
                                                                      () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ProfileAllUser(
                                                                                    uid: user?.UID ?? '',
                                                                                    initialTab: 0,
                                                                                  )),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                      user == null
                                                          ? Row()
                                                          : snap?.profileFlag &&
                                                                  snap?.aaCountry !=
                                                                      ""
                                                              ? Positioned(
                                                                  bottom: 0,
                                                                  right: 3,
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              10,
                                                                          child: Image.asset(
                                                                              'icons/flags/png/${user.aaCountry}.png',
                                                                              package: 'country_icons'))
                                                                    ],
                                                                  ),
                                                                )
                                                              : user == null
                                                                  ? Row()
                                                                  : snap?.profileBadge &&
                                                                          snap?.aaCountry !=
                                                                              ""
                                                                      ? Positioned(
                                                                          bottom:
                                                                              0,
                                                                          right:
                                                                              1,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Stack(
                                                                                children: const [
                                                                                  Positioned(
                                                                                    right: 3,
                                                                                    top: 3,
                                                                                    child: CircleAvatar(
                                                                                      radius: 4,
                                                                                      backgroundColor: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    child: Icon(Icons.verified, color: Color.fromARGB(255, 113, 191, 255), size: 13),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : Row()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 14.0),
                                                  child: TextField(
                                                    controller:
                                                        _commentController,
                                                    maxLines: null,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Write a comment',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      labelStyle: TextStyle(
                                                          color: Colors.black),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 8),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .blueAccent,
                                                            width: 2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0, bottom: 8),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                splashColor: Colors.blue
                                                    .withOpacity(0.5),
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 50),
                                                      () async {
                                                    performLoggedUserAction(
                                                        context: context,
                                                        action: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          pollComment(
                                                              _poll.pollId,
                                                              _commentController
                                                                  .text,
                                                              user?.UID ?? '',
                                                              user?.username ??
                                                                  '');
                                                          setState(() {
                                                            _commentController
                                                                .text = "";
                                                          });
                                                        });
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.send,
                                                          color:
                                                              Colors.blueAccent,
                                                          size: 12),
                                                      Container(width: 4),
                                                      const Text(
                                                        'SEND',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.blueAccent,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Consumer<CommentReplyProvider>(
                              builder: (context, commentReplyProvider, child) {
                                String? commentId;
                                if (widget.commentsReplies != null) {
                                  if (widget.isReply ?? false) {
                                    commentId = widget.commentsReplies?.reply
                                        ?.parentCommentId;
                                  } else {
                                    commentId = widget
                                        .commentsReplies?.comment?.commentId;
                                  }
                                }
                                if (commentScrollKey != null) {
                                  rearrangeSnap(
                                      commentReplyProvider
                                          .postPollCommentAndReplyList,
                                      commentId ?? "");
                                }
                                if (commentReplyProvider
                                    .postPollCommentLoader) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: PhysicalModel(
                                          elevation: 2,
                                          color: Colors.transparent,
                                          child: CommentList(
                                            commentList: commentReplyProvider
                                                .postPollCommentAndReplyList,
                                            poll: widget.poll,
                                            commentsReplies:
                                                widget.commentsReplies,
                                            isReply: widget.isReply,
                                            parentSetState: () {
                                              setState(() {});
                                            },
                                            scrollToComment: commentScrollKey,
                                            scrollToTop: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300), () {
                                                if (commentScrollKey
                                                        ?.currentContext !=
                                                    null) {
                                                  Scrollable.ensureVisible(
                                                      commentScrollKey!
                                                          .currentContext!);
                                                  commentScrollKey = null;
                                                }
                                              });
                                            },
                                            durationInDay: durationInDay,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: commentReplyProvider
                                                .canPostPollLoadMore &&
                                            !commentReplyProvider
                                                .postPollPaginationLoader,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              PhysicalModel(
                                                color: Colors.white,
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    splashColor:
                                                        const Color.fromARGB(
                                                            255, 245, 245, 245),
                                                    onTap: () {
                                                      initScrollControllerListener();
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8,
                                                          horizontal: 16),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                            Icons
                                                                .arrow_downward,
                                                            size: 16,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            'View More',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13.5,
                                                              letterSpacing:
                                                                  0.3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: commentReplyProvider
                                            .postPollPaginationLoader,
                                        child: const Center(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _getStartTime() {
    final durationRef = rdb.ref('duration/period');
    durationRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      debugPrint('duration from real time db ${data}');

      if (mounted) {
        setState(() {
          durationInDay = data['time'];
          Provider.of<FilterProvider>(context, listen: false)
              .setDurationInDay(durationInDay);
        });
      }
    });
  }

  int? _getUserPollOptionId(String uid) {
    int? optionId;
    for (int i = 1; i <= 10; i++) {
      switch (i) {
        case 1:
          if (_poll.vote1.contains(uid)) {
            optionId = i;
          }
          break;
        case 2:
          if (_poll.vote2.contains(uid)) {
            optionId = i;
          }
          break;
        case 3:
          if (_poll.vote3.contains(uid)) {
            optionId = i;
          }
          break;
        case 4:
          if (_poll.vote4.contains(uid)) {
            optionId = i;
          }
          break;
        case 5:
          if (_poll.vote5.contains(uid)) {
            optionId = i;
          }
          break;
        case 6:
          if (_poll.vote6.contains(uid)) {
            optionId = i;
          }
          break;
        case 7:
          if (_poll.vote7.contains(uid)) {
            optionId = i;
          }
          break;
        case 8:
          if (_poll.vote8.contains(uid)) {
            optionId = i;
          }
          break;
        case 9:
          if (_poll.vote9.contains(uid)) {
            optionId = i;
          }
          break;
        case 10:
          if (_poll.vote10.contains(uid)) {
            optionId = i;
          }
          break;
      }
    }
    return optionId;
  }
}

class CommentList extends StatelessWidget {
  final List<CommentsAndReplies> commentList;
  final Poll poll;
  final Function parentSetState;
  final CommentsReplies? commentsReplies;
  final bool? isReply;
  final GlobalKey? scrollToComment;
  final Function scrollToTop;
  var durationInDay;

  CommentList({
    super.key,
    required this.commentList,
    required this.poll,
    required this.parentSetState,
    this.commentsReplies,
    this.isReply,
    required this.scrollToComment,
    required this.scrollToTop,
    required this.durationInDay,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: commentList.length,
        itemBuilder: (context, index) {
          Comment comment = commentList[index].comment;
          String? commentId;
          if (commentsReplies != null) {
            commentId = commentsReplies?.comment?.commentId;
          }
          bool isMatched =
              (commentId != null && comment.commentId == commentId);

          if (index == commentList.length - 1) {
            scrollToTop();
          }

          return CommentCardPoll(
              key: Key(comment.commentId),
              snap: comment.toJson(),
              index: index,
              parentPost: poll,
              pollId: poll.pollId,
              pollUId: poll.UID,
              option1: poll.bOption1,
              option2: poll.bOption2,
              option3: poll.bOption3,
              option4: poll.bOption4,
              option5: poll.bOption5,
              option6: poll.bOption6,
              option7: poll.bOption7,
              option8: poll.bOption8,
              option9: poll.bOption9,
              option10: poll.bOption10,
              vote1: poll.vote1.contains(comment.UID),
              vote2: poll.vote2.contains(comment.UID),
              vote3: poll.vote3.contains(comment.UID),
              vote4: poll.vote4.contains(comment.UID),
              vote5: poll.vote5.contains(comment.UID),
              vote6: poll.vote6.contains(comment.UID),
              vote7: poll.vote7.contains(comment.UID),
              vote8: poll.vote8.contains(comment.UID),
              vote9: poll.vote9.contains(comment.UID),
              vote10: poll.vote10.contains(comment.UID),
              parentSetState: parentSetState,
              scrollKey: scrollToComment,
              useScrollKey: isMatched,
              commentsReplies: commentsReplies,
              openUpReplySection: (comment.commentId ==
                      commentsReplies?.reply?.parentCommentId &&
                  scrollToComment != null),
              isReply: false,
              durationInDay: durationInDay);
        },
      ),
    );
  }
}
