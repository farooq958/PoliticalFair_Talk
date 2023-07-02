import 'dart:async';
import 'dart:developer';
import 'package:aft/ATESTS/models/CommentsReplies.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../main.dart';
import '../methods/auth_methods.dart';
import '../models/comment.dart';
import '../provider/comments_replies_provider.dart';
import '../provider/filter_provider.dart';
import '../provider/left_time_provider.dart';
import '../provider/post_provider.dart';
import '../provider/timer_provider.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../zFeeds/comment_card.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../methods/firestore_methods.dart';
import '../utils/utils.dart';
import '../utils/like_animation.dart';
import 'full_image_screen.dart';
import 'profile_all_user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

String? currentReplyCommentId;

class CommentSort {
  final String label;
  final String key;
  final bool value;
  final Icon icon;
  final Icon iconSelected;

  CommentSort({
    required this.label,
    required this.key,
    required this.value,
    required this.icon,
    required this.iconSelected,
  });
}

class CommentFilter {
  final String label;
  Icon? icon;
  RotatedBox? rotatedBox;
  final String key;
  final String value;
  final Icon prefixIcon;
  final Icon prefixIconSelected;

  CommentFilter({
    required this.label,
    this.icon,
    this.rotatedBox,
    required this.key,
    required this.value,
    required this.prefixIcon,
    required this.prefixIconSelected,
  });
}

class FullMessage extends StatefulWidget {
  final Post post;
  final String postId;
  final CommentsReplies? commentsReplies;
  final bool? isReply;
  // var durationInDay;

  FullMessage({
    Key? key,
    required this.postId,
    required this.post,
    this.commentsReplies,
    this.isReply,
    // required this.durationInDay,
  }) : super(key: key);

  @override
  State<FullMessage> createState() => _FullMessageState();
}

class _FullMessageState extends State<FullMessage> {
  late Post _post;
  final AuthMethods _authMethods = AuthMethods();
  bool _isPostEnded = false;
  User? _userProfile;
  final TextEditingController _commentController = TextEditingController();
  late YoutubePlayerController controller;
  bool isLikeAnimating = false;
  int commentLen = 0;
  String placement = '';
  bool filter = false;
  bool isSwapped = true;
  late ScrollController _scrollController;
  bool isAdditionalTextTrue = false;

  // DateTime ntpTime = DateTime.now();
  var snap;

  var durationInDay = 0;
  FirebaseDatabase rdb = FirebaseDatabase.instance;

  // Timer? timer;
  // bool _isCommentTimerEnded = false;

  int fillContainerWidth = 90;

  CommentReplyProvider? commentReplyProvider;

  // /***/
  // /***/
  // InterstitialAd? interstitialAd;

  // final String interstitialAdUnitIdIOS =
  //     'ca-app-pub-1591305463797264/4735037493';
  // final String interstitialAdUnitIdAndroid =
  //     'ca-app-pub-1591305463797264/9016556769';
  // /***/
  // /***/

  // List<dynamic> commentList = [];
  // StreamSubscription? loadDataStream;

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

  void messageComment(
    String postId,
    String text,
    String uid,
    String name,
  ) async {
    try {
      String res1 = await _loadCommentCounter();
      String res = await FirestoreMethods().comment(
        postId,
        text,
        uid,
        name,
        getCounterComment,
      );
      if (res1 == "success" && res == "success") {
        // _showInterstitialAd();
        FirestoreMethods().commentCounter(_post.postId, 'message', true);

        // AuthMethods().commentWaitTimer();

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
      label: 'Voted: ',
      icon: const Icon(
        Icons.add_circle,
        color: Colors.green,
        size: 15,
      ),
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
      label: 'Voted: ',
      rotatedBox: const RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.pause_circle_filled,
          color: Color.fromARGB(255, 104, 104, 104),
          size: 15,
        ),
      ),
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
      label: 'Voted: ',
      icon: const Icon(
        Icons.do_not_disturb_on,
        color: Colors.red,
        size: 15,
      ),
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

  bool isPaginationLoading = false;

  GlobalKey? postCommentScrollKey = GlobalKey();

  @override
  void initState() {
    _getStartTime();
    Provider.of<FilterProvider>(context, listen: false)
        .setDurationInDay(durationInDay);
    // timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
    //   if (this.mounted) {
    //     setState(() {
    //       ntpTime = DateTime.now();
    //       // debugPrint('DATE TIME: $ntpTime');
    //     });
    //   }
    // });
    // _loadInterstitialAd();
    _post = widget.post;

    _selectedCommentSort = commentSorts.first;
    _selectedCommentFilter = commentFilters.first;
    currentReplyCommentId = null;
    super.initState();
    _scrollController = ScrollController();
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
        postPollId: _post.postId,
        selectedCommentFilter: _selectedCommentFilter,
        selectedCommentSort: _selectedCommentSort,
        postPoll: _post.toJson(),
        isFromProfile: (widget.commentsReplies != null),
        clickedCommentId: commentId,
        clickedReplyId: replyId,
      );
    });
    controller = YoutubePlayerController(
      initialVideoId: _post.aVideoUrl,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    getAllUserDetails();

    controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    controller.onExitFullscreen = () {
      log('Exited Fullscreen');
    };
    // initScrollControllerListener();
    // Future.delayed(Duration(seconds: 2), () {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });

    // if ((_userProfile?.timerCommentEnd).isAfter(timeNow)) {
    //   setState(() {
    //     _isCommentTimerEnded = true;
    //   });
    // } else {
    //   setState(() {
    //     _isCommentTimerEnded = false;
    //   });
    // }
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

  Future<void> initScrollControllerListener() async {
    // _scrollController.addListener(() async {
    //   if (_scrollController.position.maxScrollExtent <=
    //       _scrollController.offset) {
    //     if (commentReplyProvider?.canPostPollLoadMore && !isPaginationLoading) {
    //       print(
    //           "commentReplyProvider?.canPostPollLoadMore ${commentReplyProvider?.canPostPollLoadMore}");
    //       isPaginationLoading = true;
    await commentReplyProvider?.getPollOrPostCommentList(
      postPollId: _post.postId,
      selectedCommentFilter: _selectedCommentFilter,
      selectedCommentSort: _selectedCommentSort,
      postPoll: _post.toJson(),
      isNextPage: true,
      isFromProfile: (widget.commentsReplies != null),
    );
    //       isPaginationLoading = false;
    //     }
    //   }
    // });
  }

  getAllUserDetails() async {
    User userProfile = await _authMethods.getUserProfileDetails(_post.UID);
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
    _commentController.dispose();
    // timer?.cancel();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _post = widget.post;
    // final postProvider = Provider.of<PostProvider>(context, listen: false);
    // const player = YoutubePlayerIFrame(
    //   gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    // );
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null
        ? buildFullMessage(context)
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
                return const SizedBox();
              }
              return buildFullMessage(context);
            });
  }

  Widget buildFullMessage(BuildContext context) {
    _post = widget.post;
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    const player = YoutubePlayerIFrame(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );
    final User? user = Provider.of<UserProvider>(context).getUser;

    // timer = Timer.periodic(
    //   Duration(seconds: 15),
    //   (Timer t) => setState(() {
    //     ntpTime = DateTime.now();
    //     debugPrint('DATE TIME: $ntpTime');
    //   }),
    // );

    // _isCommentTimerEnded = (snap?.timerCommentEnd as Timestamp)
    //     .toDate()
    //     .difference(ntpTime)
    //     .isNegative;
    // _isCommentTimerEnded =
    //     (timerCommentEnd).toDate().difference(ntpTime).isNegative;

    void unverifiedPlusVote(bool pending) async {
      await FirestoreMethods().plusMessageUnverified(
        _post.postId,
        user?.UID ?? '',
        _post.plus,
        _post.neutral,
        _post.minus,
        _post,
        _post.global,
        _post.country,
      );
      _post.plus.contains(user?.UID)
          ? null
          : showSnackBarAction(
              "Votes from unverified accounts don't count!",
              pending,
              context,
            );
    }

    void unverifiedNeutralVote(bool pending) async {
      await FirestoreMethods().neutralMessageUnverified(
        _post.postId,
        user?.UID ?? '',
        _post.plus,
        _post.neutral,
        _post.minus,
        _post,
        _post.global,
        _post.country,
      );
      _post.neutral.contains(user?.UID)
          ? null
          : showSnackBarAction(
              "Votes from unverified accounts don't count!",
              pending,
              context,
            );
    }

    void unverifiedMinusVote(bool pending) async {
      await FirestoreMethods().minusMessageUnverified(
        _post.postId,
        user?.UID ?? '',
        _post.plus,
        _post.neutral,
        _post.minus,
        _post,
        _post.global,
        _post.country,
      );
      _post.minus.contains(user?.UID)
          ? null
          : showSnackBarAction(
              "Votes from unverified accounts don't count!",
              pending,
              context,
            );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(
            // _post.postId
            widget.postId).snapshots(),
        builder: (context,
            AsyncSnapshot
                // <DocumentSnapshot<Map<String, dynamic>>>
                snapshot) {
          _post = snapshot.data != null
              ? Post.fromSnap(
                  snapshot.data!,
                  // 0
                )
              : _post;
          snapshot.data != null
              ? postProvider.updatePost(Post.fromSnap(snapshot.data!))
              : null;
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  elevation: 4,
                  toolbarHeight: isSwapped ? 68 : 68,
                  actions: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: isSwapped ? 0 : 10),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 45,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: isSwapped ? 6 : 3),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Material(
                                          color: Colors.transparent,
                                          shape: const CircleBorder(),
                                          clipBehavior: Clip.hardEdge,
                                          child: IconButton(
                                            splashColor:
                                                Colors.grey.withOpacity(0.5),
                                            onPressed: () {
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 50),
                                                () {
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.arrow_back,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: isSwapped
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SizedBox(
                                              height: 68,
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 70,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  height: 45,
                                                                  width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          3 -
                                                                      30,
                                                                  child:
                                                                      LikeAnimation(
                                                                    isAnimating: _post
                                                                        .plus
                                                                        .contains(
                                                                            user?.UID),
                                                                    child:
                                                                        IconButton(
                                                                      iconSize:
                                                                          25,
                                                                      onPressed:
                                                                          () async {
                                                                        // final leftTimeProvider = Provider.of<LeftTimeProvider>(
                                                                        //     context,
                                                                        //     listen:
                                                                        //         false);
                                                                        // await leftTimeProvider
                                                                        //     .getDate();

                                                                        // DateTime  now = await widget.post.getEndDate();

                                                                        if ((durationInDay == (_post.time + 0)) ||
                                                                            (durationInDay ==
                                                                                (_post.time + 1)) ||
                                                                            (durationInDay == (_post.time + 2)) ||
                                                                            (durationInDay == (_post.time + 3)) ||
                                                                            (durationInDay == (_post.time + 4)) ||
                                                                            (durationInDay == (_post.time + 5)) ||
                                                                            (durationInDay == (_post.time + 6))) {
                                                                          // debugPrint(
                                                                          // "working condition fine ");
                                                                          setState(
                                                                              () {
                                                                            _isPostEnded =
                                                                                false;
                                                                            // debugPrint(
                                                                            // "message is  false show$_isPostEnded ");
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            _isPostEnded =
                                                                                true;
                                                                            // debugPrint(
                                                                            // "message is  true show$_isPostEnded ");
                                                                          });
                                                                        }

                                                                        performLoggedUserAction(
                                                                            context:
                                                                                context,
                                                                            action:
                                                                                () async {
                                                                              _isPostEnded
                                                                                  ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                  : snap?.pending == 'true'
                                                                                      ? unverifiedPlusVote(true)
                                                                                      : snap?.aaCountry == ""
                                                                                          ? unverifiedPlusVote(false)
                                                                                          : _post.time == 0
                                                                                              ? await FirestoreMethods().plusMessage(
                                                                                                  _post.postId,
                                                                                                  user?.UID ?? '',
                                                                                                  _post.plus,
                                                                                                  _post.neutral,
                                                                                                  _post.minus,
                                                                                                  _post,
                                                                                                  _post.global,
                                                                                                  _post.country,
                                                                                                )
                                                                                              : _post.country != "" && _post.global == "false" && _post.country != snap.aaCountry
                                                                                                  ? showSnackBar("Action failed. Voting nationally is only available for your specific country.", context)
                                                                                                  : user?.admin == true
                                                                                                      ? await FirestoreMethods().messageScore(_post.postId, 'plus', _post)
                                                                                                      : await FirestoreMethods().plusMessage(
                                                                                                          _post.postId,
                                                                                                          user?.UID ?? '',
                                                                                                          _post.plus,
                                                                                                          _post.neutral,
                                                                                                          _post.minus,
                                                                                                          _post,
                                                                                                          _post.global,
                                                                                                          _post.country,
                                                                                                        );
                                                                              // FirestoreMethods()
                                                                              //     .scoreMessage(
                                                                              //   _post
                                                                              //       .postId,
                                                                              //   user?.UID ??
                                                                              //       "",
                                                                              //   _post.plusCount -
                                                                              //       _post.minusCount,
                                                                              //   _post
                                                                              //       .UID,
                                                                              // );

                                                                              setState(() {});
                                                                            });
                                                                      },
                                                                      icon: _post
                                                                              .plus
                                                                              .contains(user?.UID)
                                                                          ? const Icon(
                                                                              Icons.add_circle,
                                                                              color: Colors.green,
                                                                            )
                                                                          : const Icon(
                                                                              Icons.add_circle,
                                                                              color: Color.fromARGB(255, 206, 204, 204),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  height: 45,
                                                                  width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          3 -
                                                                      30,
                                                                  child:
                                                                      LikeAnimation(
                                                                    isAnimating: _post
                                                                        .neutral
                                                                        .contains(
                                                                            user?.UID),
                                                                    child:
                                                                        IconButton(
                                                                      iconSize:
                                                                          25,
                                                                      onPressed:
                                                                          () async {
                                                                        // final leftTimeProvider = Provider.of<LeftTimeProvider>(
                                                                        //     context,
                                                                        //     listen:
                                                                        //         false);
                                                                        // await leftTimeProvider
                                                                        //     .getDate();

                                                                        // DateTime  now = await widget.post.getEndDate();

                                                                        if ((durationInDay == (_post.time + 0)) ||
                                                                            (durationInDay ==
                                                                                (_post.time + 1)) ||
                                                                            (durationInDay == (_post.time + 2)) ||
                                                                            (durationInDay == (_post.time + 3)) ||
                                                                            (durationInDay == (_post.time + 4)) ||
                                                                            (durationInDay == (_post.time + 5)) ||
                                                                            (durationInDay == (_post.time + 6))) {
                                                                          setState(
                                                                              () {
                                                                            _isPostEnded =
                                                                                false;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            _isPostEnded =
                                                                                true;
                                                                          });
                                                                        }

                                                                        performLoggedUserAction(
                                                                            context:
                                                                                context,
                                                                            action:
                                                                                () async {
                                                                              _isPostEnded
                                                                                  ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                  : snap?.pending == 'true'
                                                                                      ? unverifiedNeutralVote(true)
                                                                                      : snap?.aaCountry == ""
                                                                                          ? unverifiedNeutralVote(false)
                                                                                          : _post.time == 0
                                                                                              ? await FirestoreMethods().neutralMessage(
                                                                                                  _post.postId,
                                                                                                  user?.UID ?? '',
                                                                                                  _post.plus,
                                                                                                  _post.neutral,
                                                                                                  _post.minus,
                                                                                                  _post,
                                                                                                  _post.global,
                                                                                                  _post.country,
                                                                                                )
                                                                                              : _post.country != "" && _post.global == "false" && _post.country != snap.aaCountry
                                                                                                  ? showSnackBar("Action failed. Voting nationally is only available for your specific country.", context)
                                                                                                  : user?.admin == true
                                                                                                      ? await FirestoreMethods().messageScore(_post.postId, 'neutral', _post)
                                                                                                      : await FirestoreMethods().neutralMessage(
                                                                                                          _post.postId,
                                                                                                          user?.UID ?? '',
                                                                                                          _post.plus,
                                                                                                          _post.neutral,
                                                                                                          _post.minus,
                                                                                                          _post,
                                                                                                          _post.global,
                                                                                                          _post.country,
                                                                                                        );

                                                                              setState(() {});
                                                                            });
                                                                      },
                                                                      icon: _post
                                                                              .neutral
                                                                              .contains(user?.UID)
                                                                          ? const RotatedBox(
                                                                              quarterTurns: 1,
                                                                              child: Icon(
                                                                                Icons.pause_circle_filled,
                                                                                color: Color.fromARGB(255, 111, 111, 111),
                                                                              ),
                                                                            )
                                                                          : const RotatedBox(
                                                                              quarterTurns: 1,
                                                                              child: Icon(
                                                                                Icons.pause_circle_filled,
                                                                                color: Color.fromARGB(255, 206, 204, 204),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  height: 45,
                                                                  width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          3 -
                                                                      30,
                                                                  child:
                                                                      LikeAnimation(
                                                                    isAnimating: _post
                                                                        .minus
                                                                        .contains(
                                                                            user?.UID),
                                                                    child:
                                                                        IconButton(
                                                                      iconSize:
                                                                          25,
                                                                      onPressed:
                                                                          () async {
                                                                        // final leftTimeProvider = Provider.of<LeftTimeProvider>(
                                                                        //     context,
                                                                        //     listen:
                                                                        //         false);
                                                                        // await leftTimeProvider
                                                                        //     .getDate();

                                                                        // DateTime  now = await widget.post.getEndDate();

                                                                        if ((durationInDay == (_post.time + 0)) ||
                                                                            (durationInDay ==
                                                                                (_post.time + 1)) ||
                                                                            (durationInDay == (_post.time + 2)) ||
                                                                            (durationInDay == (_post.time + 3)) ||
                                                                            (durationInDay == (_post.time + 4)) ||
                                                                            (durationInDay == (_post.time + 5)) ||
                                                                            (durationInDay == (_post.time + 6))) {
                                                                          setState(
                                                                              () {
                                                                            _isPostEnded =
                                                                                false;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            _isPostEnded =
                                                                                true;
                                                                          });
                                                                        }

                                                                        performLoggedUserAction(
                                                                            context:
                                                                                context,
                                                                            action:
                                                                                () async {
                                                                              _isPostEnded
                                                                                  ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                  : snap?.pending == 'true'
                                                                                      ? unverifiedMinusVote(true)
                                                                                      : snap?.aaCountry == ""
                                                                                          ? unverifiedMinusVote(false)
                                                                                          : _post.country != "" && _post.global == "false" && _post.country != snap.aaCountry
                                                                                              ? showSnackBar("Action failed. Voting nationally is only available for your specific country.", context)
                                                                                              : _post.time == 0
                                                                                                  ? await FirestoreMethods().minusMessage(
                                                                                                      _post.postId,
                                                                                                      user?.UID ?? '',
                                                                                                      _post.plus,
                                                                                                      _post.neutral,
                                                                                                      _post.minus,
                                                                                                      _post,
                                                                                                      _post.global,
                                                                                                      _post.country,
                                                                                                    )
                                                                                                  : user?.admin == true
                                                                                                      ? await FirestoreMethods().messageScore(_post.postId, 'minus', _post)
                                                                                                      : await FirestoreMethods().minusMessage(_post.postId, user?.UID ?? '', _post.plus, _post.neutral, _post.minus, _post, _post.global, _post.country);

                                                                              setState(() {});
                                                                            });
                                                                      },
                                                                      icon: _post
                                                                              .minus
                                                                              .contains(user?.UID)
                                                                          ? const Icon(
                                                                              Icons.do_not_disturb_on,
                                                                              color: Colors.red,
                                                                            )
                                                                          : const Icon(
                                                                              Icons.do_not_disturb_on,
                                                                              color: Color.fromARGB(255, 206, 204, 204),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            90,
                                                    bottom: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        percentageBarDialog(
                                                          context: context,
                                                          plusCount:
                                                              _post.plusCount,
                                                          neutralCount: _post
                                                              .neutralCount,
                                                          minusCount:
                                                              _post.minusCount,
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3 -
                                                                    30,
                                                                child: Text(
                                                                    _post.plusCount <=
                                                                            9999
                                                                        ? '${_post.plusCount}'
                                                                        : _post.plusCount >=
                                                                                1000000
                                                                            ? '${_post.plusCount.toString().substring(0, 1)}.${_post.plusCount.toString().substring(1, 2)}M'
                                                                            : _post.plusCount >=
                                                                                    100000
                                                                                ? '${_post.plusCount.toString().substring(0, 3)}K'
                                                                                : _post.plusCount >=
                                                                                        10000
                                                                                    ? '${_post.plusCount.toString().substring(0, 2)}.${_post.plusCount.toString().substring(2, 3)}K'
                                                                                    : '${_post.plusCount.toString().substring(0, 1)}.${_post.plusCount.toString().substring(1, 2)}K',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            11.5,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              SizedBox(
                                                                // color:
                                                                //     Colors.red,
                                                                width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3 -
                                                                    30,
                                                                child: Text(
                                                                    _post.neutralCount <=
                                                                            9999
                                                                        ? '${_post.neutralCount}'
                                                                        : _post.neutralCount >=
                                                                                1000000
                                                                            ? '${_post.neutralCount.toString().substring(0, 1)}.${_post.neutralCount.toString().substring(1, 2)}M'
                                                                            : _post.neutralCount >=
                                                                                    100000
                                                                                ? '${_post.neutralCount.toString().substring(0, 3)}K'
                                                                                : _post.neutralCount >=
                                                                                        10000
                                                                                    ? '${_post.neutralCount.toString().substring(0, 2)}.${_post.neutralCount.toString().substring(2, 3)}K'
                                                                                    : '${_post.neutralCount.toString().substring(0, 1)}.${_post.neutralCount.toString().substring(1, 2)}K',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            11.5,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3 -
                                                                    30,
                                                                child: Text(
                                                                    _post.minusCount <=
                                                                            9999
                                                                        ? '${_post.minusCount}'
                                                                        : _post.minusCount >=
                                                                                1000000
                                                                            ? '${_post.minusCount.toString().substring(0, 1)}.${_post.minusCount.toString().substring(1, 2)}M'
                                                                            : _post.minusCount >=
                                                                                    100000
                                                                                ? '${_post.minusCount.toString().substring(0, 3)}K'
                                                                                : _post.minusCount >=
                                                                                        10000
                                                                                    ? '${_post.minusCount.toString().substring(0, 2)}.${_post.minusCount.toString().substring(2, 3)}K'
                                                                                    : '${_post.minusCount.toString().substring(0, 1)}.${_post.minusCount.toString().substring(1, 2)}K',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            11.5,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 3.5),
                                                          Center(
                                                            child:
                                                                PhysicalModel(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                              color:
                                                                  Colors.white,
                                                              elevation: 2,
                                                              child: Container(
                                                                height: 5,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    fillContainerWidth,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0)),
                                                                child: _post.plusCount +
                                                                            _post.minusCount +
                                                                            _post.neutralCount ==
                                                                        0
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.green,
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(25),
                                                                                bottomLeft: Radius.circular(25),
                                                                              ),
                                                                            ),
                                                                            width:
                                                                                (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                          ),
                                                                          Container(
                                                                            color:
                                                                                Colors.grey,
                                                                            width:
                                                                                (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Colors.red,
                                                                              borderRadius: BorderRadius.only(
                                                                                topRight: Radius.circular(25),
                                                                                bottomRight: Radius.circular(25),
                                                                              ),
                                                                            ),
                                                                            width:
                                                                                (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              (MediaQuery.of(context).size.width - fillContainerWidth),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(0)),
                                                                                width: _post.plusCount == 0 ? 0 : (MediaQuery.of(context).size.width - fillContainerWidth) * (_post.plusCount / (_post.plusCount + _post.minusCount + _post.neutralCount)),
                                                                                child: Container(
                                                                                  width: (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                color: Colors.grey,
                                                                                width: _post.neutralCount == 0 ? 0 : (MediaQuery.of(context).size.width - fillContainerWidth) * (_post.neutralCount / (_post.plusCount + _post.minusCount + _post.neutralCount)),
                                                                                child: Container(
                                                                                  width: (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                color: Colors.red,
                                                                                width: _post.minusCount == 0 ? 0 : (MediaQuery.of(context).size.width - fillContainerWidth) * (_post.minusCount / (_post.plusCount + _post.minusCount + _post.neutralCount)),
                                                                                child: Container(
                                                                                  width: (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                91,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  // width: 65,
                                                  height: 38,
                                                  alignment: Alignment.center,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      splashColor: Colors.grey
                                                          .withOpacity(0.3),
                                                      onTap: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    100), () {
                                                          scoreDialogMessage(
                                                              context: context);
                                                        });
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            ' Score ',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        81,
                                                                        81,
                                                                        81),
                                                                letterSpacing:
                                                                    0.5),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons.check_box,
                                                                size: 13,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        81,
                                                                        81,
                                                                        81),
                                                              ),
                                                              Container(
                                                                  width: 4),
                                                              Text(
                                                                '${_post.score}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            81,
                                                                            81,
                                                                            81),
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(),
                                                SizedBox(
                                                  // width: 95,
                                                  height: 38,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: InkWell(
                                                      splashColor: Colors.grey
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      onTap: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    100), () {
                                                          timerDialog(
                                                              context: context,
                                                              type: 'message');
                                                        });
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Text(
                                                                'Time Left',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            81,
                                                                            81,
                                                                            81),
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons.timer,
                                                                size: 13,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        81,
                                                                        81,
                                                                        81),
                                                              ),
                                                              Container(
                                                                  width: 4),
                                                              // Consumer<
                                                              //         LeftTimeProvider>(
                                                              //     builder: (context,
                                                              //         leftTimeProvider,
                                                              //         child) {
                                                              //   if (leftTimeProvider
                                                              //       .loading) {
                                                              //     return const SizedBox();
                                                              //   } else {
                                                              //     return
                                                              Text(
                                                                _post.time == 0
                                                                    ? 'Unlimited'
                                                                    : durationInDay ==
                                                                            (_post
                                                                                .time)
                                                                        ? '7 Days'
                                                                        : durationInDay ==
                                                                                (_post.time + 1)
                                                                            ? '6 Days'
                                                                            : durationInDay == (_post.time + 2)
                                                                                ? '5 Days'
                                                                                : durationInDay == (_post.time + 3)
                                                                                    ? '4 Days'
                                                                                    : durationInDay == (_post.time + 4)
                                                                                        ? '3 Days'
                                                                                        : durationInDay == (_post.time + 5)
                                                                                            ? '2 Days'
                                                                                            : durationInDay == (_post.time + 6)
                                                                                                ? '1 Day'
                                                                                                : 'None',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            81,
                                                                            81,
                                                                            81),
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              // }
                                                              // } else if (_post
                                                              //     .getEndDate()
                                                              //     .isAfter(
                                                              //         leftTimeProvider
                                                              //             .leftTime)) {
                                                              //   return ChangeNotifierProvider(
                                                              //     create: (context) =>
                                                              //         TimerProvider(
                                                              //             _post.getEndDate()),
                                                              //     child: Consumer<
                                                              //             TimerProvider>(
                                                              //         builder: (context,
                                                              //             timerProvider,
                                                              //             child) {
                                                              //       return Text(
                                                              //         timerProvider
                                                              //             .timeString,
                                                              //         style: const TextStyle(
                                                              //             fontSize:
                                                              //                 13,
                                                              //             color: Color.fromARGB(
                                                              //                 255,
                                                              //                 81,
                                                              //                 81,
                                                              //                 81),
                                                              //             letterSpacing:
                                                              //                 0.5,
                                                              //             fontWeight:
                                                              //                 FontWeight.w500),
                                                              //       );
                                                              //     }),
                                                              //   );
                                                              // } else {
                                                              //   return const Text(
                                                              //       "");
                                                              // }
                                                              // }),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(),
                                                SizedBox(
                                                  // width: 65,
                                                  height: 38,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: InkWell(
                                                      splashColor: Colors.grey
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      onTap: () {},
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            'Comments',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        81,
                                                                        81,
                                                                        81),
                                                                letterSpacing:
                                                                    0.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                MyFlutterApp
                                                                    .comments,
                                                                size: 13,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        81,
                                                                        81,
                                                                        81),
                                                              ),
                                                              Container(
                                                                  width: 6),
                                                              Text(
                                                                '${_post.commentCount}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            81,
                                                                            81,
                                                                            81),
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
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
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: isSwapped ? 6 : 3.0),
                                      child: SizedBox(
                                        width: 45,
                                        child: Material(
                                          color: Colors.transparent,
                                          shape: const CircleBorder(),
                                          clipBehavior: Clip.hardEdge,
                                          child: IconButton(
                                            splashColor:
                                                Colors.grey.withOpacity(0.5),
                                            onPressed: () {
                                              setState(
                                                () {
                                                  isSwapped = !isSwapped;
                                                },
                                              );
                                            },
                                            iconSize: 28,
                                            icon: const Icon(
                                              Icons.swap_horiz,
                                            ),
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(_post.postId)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot
                          // <DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    _post = snapshot.data != null
                        ? Post.fromSnap(
                            snapshot.data!,
                            // 0
                          )
                        : _post;

                    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          YoutubePlayerControllerProvider(
                            controller: controller,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Column(
                                children: [
                                  PhysicalModel(
                                    elevation: 2,
                                    color: Colors.transparent,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        // border: Border(
                                        //   top: BorderSide(
                                        //       width: 1,
                                        //       color: Color.fromARGB(
                                        //           255, 220, 220, 220)),
                                        //   bottom: BorderSide(
                                        //     width: 1,
                                        //     color: Color.fromARGB(
                                        //         255, 220, 220, 220),
                                        //   ),
                                        // ),
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromARGB(
                                                        255, 200, 200, 200),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      _userProfile?.photoUrl !=
                                                              null
                                                          ? Material(
                                                              color:
                                                                  Colors.grey,
                                                              shape:
                                                                  const CircleBorder(),
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              child: Ink.image(
                                                                image: NetworkImage(
                                                                    _userProfile
                                                                            ?.photoUrl ??
                                                                        ''),
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
                                                                                    uid: _post.UID,
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
                                                                                    uid: _post.UID,
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
                                                                        right:
                                                                            3,
                                                                        top: 3,
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              4,
                                                                          backgroundColor:
                                                                              Colors.white,
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
                                                                            size:
                                                                                13),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfileAllUser(
                                                                          uid: _post
                                                                              .UID,
                                                                          initialTab:
                                                                              0,
                                                                        )),
                                                          );
                                                        },
                                                        child: Text(
                                                          _userProfile
                                                                  ?.username ??
                                                              '',
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 15.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        DateFormat.yMMMd()
                                                            .format(
                                                          _post.datePublishedNTP
                                                              .toDate(),
                                                        ),
                                                        style: const TextStyle(
                                                            fontSize: 12.5,
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: Container(
                                                //     height: 30,
                                                //   ),
                                                // ),
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
                                                                milliseconds:
                                                                    50), () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return SimpleDialog(
                                                                  children: [
                                                                    _post.UID ==
                                                                            user?.UID
                                                                        ? Row()
                                                                        : SimpleDialogOption(
                                                                            padding:
                                                                                const EdgeInsets.all(20),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                const Icon(Icons.block),
                                                                                Container(width: 10),
                                                                                const Text('Block User', style: TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                              ],
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Future.delayed(const Duration(milliseconds: 150), () {
                                                                                performLoggedUserAction(
                                                                                  context: context,
                                                                                  action: () {
                                                                                    blockDialog(
                                                                                      action: () async {
                                                                                        var userRef = FirebaseFirestore.instance.collection("users").doc(user?.UID);
                                                                                        var blockListRef = FirebaseFirestore.instance.collection("users").doc(user?.UID).collection('blockList').doc(_post.UID);
                                                                                        var blockUserInfo = await FirebaseFirestore.instance.collection("users").doc(_post.UID).get();
                                                                                        if (blockUserInfo.exists) {
                                                                                          final batch = FirebaseFirestore.instance.batch();
                                                                                          final blockingUserData = blockUserInfo.data();
                                                                                          blockingUserData?['creatorUID'] = user?.UID;
                                                                                          batch.update(userRef, {
                                                                                            'blockList': FieldValue.arrayUnion([_post.UID])
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
                                                                    _post.UID ==
                                                                            user?.UID
                                                                        ? Row()
                                                                        : SimpleDialogOption(
                                                                            padding:
                                                                                const EdgeInsets.all(20),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                const Icon(Icons.report_outlined),
                                                                                Container(width: 10),
                                                                                const Text('Report Message', style: TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                              ],
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Future.delayed(
                                                                                const Duration(milliseconds: 150),
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
                                                                                          type: 'message',
                                                                                          typeCapital: 'Message',
                                                                                          user: false,
                                                                                          action: () async {
                                                                                            await FirestoreMethods().reportCounter(_post.postId, _post.reportChecked, 'message');
                                                                                            if (!mounted) return;
                                                                                            showSnackBar('Message successfully reported.', context);
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
                                                                      onPressed:
                                                                          () {
                                                                        Future.delayed(
                                                                            const Duration(milliseconds: 150),
                                                                            () {
                                                                          keywordsDialog(
                                                                              context: context);
                                                                        });
                                                                      },
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              const SizedBox(
                                                                                width: 25,
                                                                                child: Icon(Icons.key, color: Colors.black),
                                                                              ),
                                                                              Container(width: 10),
                                                                              _post.tagsLowerCase?.length == 0
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
                                                                            padding:
                                                                                const EdgeInsets.only(left: 0.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                _post.tagsLowerCase?.length == 1 || _post.tagsLowerCase?.length == 2 || _post.tagsLowerCase?.length == 3
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
                                                                                              '${_post.tagsLowerCase?[0]}',
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    : Row(),
                                                                                _post.tagsLowerCase?.length == 2 || _post.tagsLowerCase?.length == 3
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
                                                                                              '${_post.tagsLowerCase?[1]}',
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    : Row(),
                                                                                _post.tagsLowerCase?.length == 3
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
                                                                                              '${_post.tagsLowerCase?[2]}',
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
                                                      child: const Icon(
                                                          Icons.more_vert),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 14,
                                                    left: 14,
                                                    top: 4,
                                                    bottom: _post.aVideoUrl !=
                                                                "" &&
                                                            _post.aBody != ""
                                                        ? 0
                                                        : _post.aPostUrl !=
                                                                    "" &&
                                                                _post.aBody !=
                                                                    ""
                                                            ? 0
                                                            : _post.aVideoUrl !=
                                                                        "" ||
                                                                    _post.aPostUrl !=
                                                                        ""
                                                                ? 8
                                                                : 0),
                                                child: Text('${_post.aTitle} ',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    )),
                                              ),
                                              _post.aBody != ""
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      25),
                                                              splashColor: Colors
                                                                  .blue
                                                                  .withOpacity(
                                                                      0.3),
                                                              onTap: () {
                                                                setState(() {
                                                                  isAdditionalTextTrue =
                                                                      !isAdditionalTextTrue;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        12),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        isAdditionalTextTrue
                                                                            ? ' Hide Additional Text'
                                                                            : ' View Additional Text',
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.blueAccent,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        )),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              // const SizedBox(height: 3),

                                              isAdditionalTextTrue
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 14.0),
                                                      child: Text(
                                                        '${_post.aBody}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),

                                              SizedBox(
                                                  height: isAdditionalTextTrue ==
                                                                  false &&
                                                              _post.aBody !=
                                                                  "" &&
                                                              _post.aVideoUrl !=
                                                                  "" ||
                                                          isAdditionalTextTrue ==
                                                                  false &&
                                                              _post.aBody !=
                                                                  "" &&
                                                              _post.aPostUrl !=
                                                                  ""
                                                      ? 4
                                                      : 8),
                                              // _post.selected == 1
                                              //     ?

                                              _post.aPostUrl != ""
                                                  ? InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullImageScreen(
                                                                    post: _post,
                                                                  )),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >=
                                                                600
                                                            ? 298
                                                            : MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    2 -
                                                                2,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >=
                                                                600
                                                            ? 598
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                2,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 245, 245, 245),
                                                        child:
                                                            CachedNetworkImage(
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(),
                                                          imageUrl:
                                                              _post.aPostUrl,
                                                        ),
                                                      ),
                                                    )
                                                  // : _post.selected == 3
                                                  //     ?
                                                  : _post.aVideoUrl != ""
                                                      ? LayoutBuilder(
                                                          builder: (context,
                                                              constraints) {
                                                            // if (kIsWeb &&
                                                            //     constraints
                                                            //             .maxWidth >
                                                            //         800) {
                                                            //   return Row(
                                                            //     crossAxisAlignment:
                                                            //         CrossAxisAlignment
                                                            //             .start,
                                                            //     children: const [
                                                            //       Expanded(
                                                            //           child:
                                                            //               player),
                                                            //       SizedBox(
                                                            //         width: 500,
                                                            //       ),
                                                            //     ],
                                                            //   );
                                                            // }
                                                            return SizedBox(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >
                                                                      600
                                                                  ? 598
                                                                  : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Stack(
                                                                children: [
                                                                  player,
                                                                  Positioned
                                                                      .fill(
                                                                    child:
                                                                        YoutubeValueBuilder(
                                                                      controller:
                                                                          controller,
                                                                      builder:
                                                                          (context,
                                                                              value) {
                                                                        return AnimatedCrossFade(
                                                                          crossFadeState: value.isReady
                                                                              ? CrossFadeState.showSecond
                                                                              : CrossFadeState.showFirst,
                                                                          duration:
                                                                              const Duration(milliseconds: 300),
                                                                          secondChild:
                                                                              const SizedBox(),
                                                                          firstChild: Material(
                                                                              child: Stack(
                                                                            children: [
                                                                              const Center(
                                                                                  child: CircularProgressIndicator(
                                                                                color: Colors.black,
                                                                              )),
                                                                              FadeInImage.memoryNetwork(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  // height: MediaQuery.of(context).size.width * 0.5,
                                                                                  placeholder: kTransparentImage,
                                                                                  fadeInDuration: const Duration(milliseconds: 200),
                                                                                  image: YoutubePlayerController.getThumbnail(
                                                                                    videoId: controller.initialVideoId,
                                                                                    quality: ThumbnailQuality.medium,
                                                                                  )),
                                                                            ],
                                                                          )),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : Row(),

                                              SizedBox(
                                                  height: _post.aVideoUrl !=
                                                              "" ||
                                                          _post.aPostUrl != ""
                                                      ? 12
                                                      : isAdditionalTextTrue
                                                          ? 4
                                                          : 0),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 0, left: 0, top: 10, bottom: 0),
                            child: PhysicalModel(
                              color: Colors.transparent,
                              elevation: 2,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
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
                                            'Comments (${_post.commentCount})',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                letterSpacing: 0.8),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                            top: 10,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor:
                                                  Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 50), () {
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
                                                          color: Colors.black),
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
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
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
                                                            'Sort:',
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
                                                                          2.0),
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
                                                                                    Text(commentSort.label,
                                                                                        style: TextStyle(
                                                                                          color: _selectedCommentSort == commentSort ? Colors.black : Colors.grey,
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(width: 6),
                                                                          ],
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          _selectedCommentSort =
                                                                              commentSort;
                                                                          setState(
                                                                              () {});
                                                                          commentReplyProvider
                                                                              ?.getPollOrPostCommentList(
                                                                            postPollId:
                                                                                _post.postId,
                                                                            selectedCommentFilter:
                                                                                _selectedCommentFilter,
                                                                            selectedCommentSort:
                                                                                _selectedCommentSort,
                                                                            postPoll:
                                                                                _post.toJson(),
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
                                                          child: Text('Filter:',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                  letterSpacing:
                                                                      0)),
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
                                                                                      commentFilter.label,
                                                                                      style: TextStyle(
                                                                                        color: _selectedCommentFilter == commentFilter ? Colors.black : Colors.grey,
                                                                                      ),
                                                                                    ),
                                                                                    commentFilter.icon ?? commentFilter.rotatedBox ?? Row(),
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
                                                                          commentReplyProvider
                                                                              ?.getPollOrPostCommentList(
                                                                            postPollId:
                                                                                _post.postId,
                                                                            selectedCommentFilter:
                                                                                _selectedCommentFilter,
                                                                            selectedCommentSort:
                                                                                _selectedCommentSort,
                                                                            postPoll:
                                                                                _post.toJson(),
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
                                        right: 1,
                                        left: 1,
                                        bottom: 8,
                                      ),
                                      child: Container(
                                        color: Colors.white,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Padding(
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
                                                                              'icons/flags/png/${snap?.aaCountry}.png',
                                                                              package: 'country_icons'))
                                                                    ],
                                                                  ),
                                                                )
                                                              :
                                                              // : _userProfile
                                                              //             ?.profileBadge ==
                                                              //         "true"
                                                              //     ?
                                                              user == null
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
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 14.0),
                                                child: TextField(
                                                  controller:
                                                      _commentController,
                                                  maxLines: null,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Write a comment',
                                                    hintStyle: TextStyle(
                                                        // fontStyle: FontStyle
                                                        //     .italic,
                                                        color: Colors.grey),
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    contentPadding:
                                                        EdgeInsets.only(top: 8),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.blueAccent,
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
                                    // _isCommentTimerEnded || guest
                                    //     ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0, bottom: 8),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              splashColor:
                                                  Colors.blue.withOpacity(0.5),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 50),
                                                    () async {
                                                  performLoggedUserAction(
                                                      context: context,
                                                      action: () async {
                                                        // _commentController
                                                        //         .text.isEmpty
                                                        //     ? null
                                                        //     : showSnackBar(
                                                        //         'Comment successfully posted.',
                                                        //         context);
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        messageComment(
                                                          _post.postId,
                                                          _commentController
                                                              .text,
                                                          user?.UID ?? '',
                                                          user?.username ?? '',
                                                        );

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
                                    // : Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     children: [
                                    //       Padding(
                                    //         padding: const EdgeInsets.only(
                                    //             right: 12.0, bottom: 8),
                                    //         child: Material(
                                    //           color: Colors.transparent,
                                    //           child: InkWell(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(
                                    //                     25),
                                    //             splashColor: Colors.grey
                                    //                 .withOpacity(0.3),
                                    //             onTap: () {
                                    //               Future.delayed(
                                    //                   const Duration(
                                    //                       milliseconds: 50),
                                    //                   () async {
                                    //                 performLoggedUserAction(
                                    //                     context: context,
                                    //                     action: () async {
                                    //                       showSnackBarErrorLonger(
                                    //                           'To avoid spam, each user is only allowed to send one comment or reply every 2 minutes.',
                                    //                           context);
                                    //                     });
                                    //               });
                                    //             },
                                    //             child: Container(
                                    //               padding:
                                    //                   const EdgeInsets.all(
                                    //                       4),
                                    //               color: Colors.transparent,
                                    //               child: Row(
                                    //                 children: const [
                                    //                   Icon(Icons.timer,
                                    //                       color:
                                    //                           Colors.grey,
                                    //                       size: 12),
                                    //                   SizedBox(width: 4),
                                    //                   Text(
                                    //                     'WAIT TIME',
                                    //                     style: TextStyle(
                                    //                       fontSize: 13,
                                    //                       fontWeight:
                                    //                           FontWeight
                                    //                               .w500,
                                    //                       color:
                                    //                           Colors.grey,
                                    //                       letterSpacing:
                                    //                           0.5,
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
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
                                  commentId = widget
                                      .commentsReplies?.reply?.parentCommentId;
                                } else {
                                  commentId = widget
                                      .commentsReplies?.comment?.commentId;
                                }
                              }
                              if (postCommentScrollKey != null) {
                                commentReplyProvider.rearrangeSnap(
                                    commentReplyProvider
                                        .postPollCommentAndReplyList,
                                    commentId ?? "");
                              }

                              if (commentReplyProvider.postPollCommentLoader) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
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
                                            post: _post,
                                            isReply: widget.isReply,
                                            commentsReplies:
                                                widget.commentsReplies,
                                            parentSetState: () {
                                              setState(() {});
                                            },
                                            scrollToComment:
                                                postCommentScrollKey,
                                            scrollToTop: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300), () {
                                                if (postCommentScrollKey
                                                        ?.currentContext !=
                                                    null) {
                                                  Scrollable.ensureVisible(
                                                      postCommentScrollKey!
                                                          .currentContext!);
                                                  postCommentScrollKey = null;
                                                }
                                              });
                                            },
                                            durationInDay: durationInDay),
                                      ),
                                    ),
                                    Visibility(
                                      visible: commentReplyProvider
                                              .canPostPollLoadMore &&
                                          !commentReplyProvider
                                              .postPollPaginationLoader,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
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
                                                      BorderRadius.circular(25),
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
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.arrow_downward,
                                                          size: 16,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'View More',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.5,
                                                            letterSpacing: 0.3,
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
                    );
                  },
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
}

class CommentList extends StatelessWidget {
  final List<CommentsAndReplies> commentList;
  final Post post;
  final Function parentSetState;
  final CommentsReplies? commentsReplies;
  final bool? isReply;
  final GlobalKey? scrollToComment;
  final Function scrollToTop;
  var durationInDay;

  CommentList({
    super.key,
    required this.commentList,
    required this.post,
    required this.parentSetState,
    this.commentsReplies,
    this.isReply,
    required this.scrollToComment,
    required this.scrollToTop,
    required this.durationInDay,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      // physics: ScrollPhysics(),
      itemCount: commentList.length,
      itemBuilder: (context, index) {
        Comment comment = commentList[index].comment;
        String? commentId;
        if (commentsReplies != null) {
          commentId = commentsReplies?.comment?.commentId;
        }
        bool isMatched = (commentId != null && comment.commentId == commentId);
        if (index == commentList.length - 1) {
          scrollToTop();
        }

        return CommentCard(
          key: Key(comment.commentId),
          snap: comment.toJson(),
          parentPost: post,
          postId: post.postId,
          postUId: post.UID,
          scrollKey: scrollToComment,
          useScrollKey: isMatched,
          commentsReplies: commentsReplies,
          openUpReplySection:
              (comment.commentId == commentsReplies?.reply?.parentCommentId &&
                  scrollToComment != null),
          isReply: false,
          isFromProfile: false,
          minus: post.minus.contains(comment.UID),
          neutral: post.neutral.contains(comment.UID),
          plus: post.plus.contains(comment.UID),
          parentSetState: parentSetState,
          profileScreen: false,
          durationInDay: durationInDay,
        );
      },
    );
  }
}

// class CommentList extends StatelessWidget {
//   final commentSnaps;
//   final Post post;
//   final Function parentSetState;
//   final CommentsReplies? commentsReplies;
//   final bool? isReply;
//
//   CommentList({
//     super.key,
//     required this.commentSnaps,
//     required this.post,
//     required this.parentSetState,
//     this.commentsReplies,
//     this.isReply,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         // physics: ScrollPhysics(),
//         itemCount: commentSnaps.length,
//         itemBuilder: (context, index) {
//           var commentSnap = commentSnaps[index].data();
//           String? commentId;
//           if (commentsReplies != null) {
//             commentId = commentsReplies?.comment?.commentId;
//           }
//           bool isMatched = (commentId != null &&
//               commentSnaps[index]['commentId'] == commentId);
//           print("Is Matched ====> $isMatched");
//           return CommentCard(
//             snap: commentSnaps[index],
//             parentPost: post,
//             postId: post.postId,
//             postUId: post.UID,
//             scrollKey: postCommentScrollKey,
//             useScrollKey: isMatched,
//             commentsReplies: commentsReplies,
//             openUpReplySection: (commentSnaps[index]['commentId'] ==
//                 commentsReplies?.reply?.parentCommentId),
//             isReply: false,
//             isFromProfile: false,
//             minus: post.minus.contains(commentSnap['uid']),
//             neutral: post.neutral.contains(commentSnap['uid']),
//             plus: post.plus.contains(commentSnap['uid']),
//             parentSetState: parentSetState,
//           );
//         },
//       ),
//     );
//   }
// }

//Old stream builder code

// StreamBuilder(
// stream: _selectedCommentFilter.value ==
// 'all'
// ? FirebaseFirestore.instance
//     .collection('comments')
// .where("parentId",
// isEqualTo: _post.postId)
// .where('reportRemoved',
// isEqualTo: false)
// .where("UID",
// isEqualTo: user == null
// ? 'null'
// : user.UID)
//
// // Sort
// .orderBy(_selectedCommentSort.key,
// descending: _selectedCommentSort
//     .value)
// .snapshots()
//     : FirebaseFirestore.instance
//     .collection('comments')
// .where("parentId",
// isEqualTo: _post.postId)
// .where('reportRemoved',
// isEqualTo: false)
// .where("UID",
// isEqualTo: user == null
// ? 'null'
// : user.UID)
//
// // Filter
// .where(_selectedCommentFilter.value,
// whereIn: (_post
//     .toJson()[
// _selectedCommentFilter
//     .key]
// .isNotEmpty
// ? _post.toJson()[
// _selectedCommentFilter
//     .key]
// : ['placeholder_uid']))
//
// // Sort
// .orderBy(_selectedCommentSort.key,
// descending:
// _selectedCommentSort.value)
// .snapshots(),
// builder: (content, snapshot) {
// String? commentId;
// if (widget.commentsReplies != null) {
// if (widget.isReply ?? false) {
// commentId = widget.commentsReplies
//     ?.reply?.parentCommentId;
// } else {
// commentId = widget.commentsReplies
//     ?.comment?.commentId;
// }
// }
// var arrangedData = rearrangeSnap(
// (snapshot.data as dynamic)?.docs ??
// [],
// commentId ?? "");
// if (snapshot.connectionState ==
// ConnectionState.waiting) {
// return snapshot.data == null
// ? Row()
// // const Padding(
// //     padding:
// //         EdgeInsets.all(8.0),
// //     child: Center(
// //       child:
// //           CircularProgressIndicator(),
// //     ),
// //   )
//     : CommentList(
// commentSnaps: arrangedData,
// post: widget.post,
// commentsReplies:
// widget.commentsReplies,
// isReply: widget.isReply,
// parentSetState: () {
// setState(() {});
// },
// );
// }
//
// return CommentList(
// commentSnaps: arrangedData,
// post: _post,
// isReply: widget.isReply,
// commentsReplies:
// widget.commentsReplies,
// parentSetState: () {
// setState(() {});
// },
// );
// },
// ),
// StreamBuilder(
// stream: _selectedCommentFilter.value ==
// 'all'
// ? FirebaseFirestore.instance
//     .collection('comments')
// .where("parentId",
// isEqualTo: _post.postId)
// .where('reportRemoved',
// isEqualTo: false)
// .where("UID",
// isNotEqualTo: user == null
// ? 'null'
// : user.UID)
// .orderBy("UID", descending: false)
// // Sort
// .orderBy(_selectedCommentSort.key,
// descending: _selectedCommentSort
//     .value)
// .snapshots()
//     : FirebaseFirestore.instance
//     .collection('comments')
// .where("parentId",
// isEqualTo: _post.postId)
// .where('reportRemoved',
// isEqualTo: false)
// .where("UID",
// isNotEqualTo: user == null
// ? 'null'
// : user.UID)
// .orderBy("UID", descending: false)
//
// // Filter
// .where(
// _selectedCommentFilter.value,
// whereIn: (_post
//     .toJson()[
// _selectedCommentFilter
//     .key]
// .isNotEmpty
// ? _post.toJson()[
// _selectedCommentFilter
//     .key]
// : ['placeholder_uid']))
//
// // Sort
// .orderBy(_selectedCommentSort.key,
// descending:
// _selectedCommentSort.value)
// .snapshots(),
// builder: (content, snapshot1) {
// String? commentId;
// if (widget.commentsReplies != null) {
// if (widget.isReply ?? false) {
// commentId = widget.commentsReplies
//     ?.reply?.parentCommentId;
// } else {
// commentId = widget.commentsReplies
//     ?.comment?.commentId;
// }
// }
// var arrangedData = rearrangeSnap(
// (snapshot1.data as dynamic)?.docs ??
// [],
// commentId ?? "");
// if (snapshot1.connectionState ==
// ConnectionState.waiting) {
// return snapshot1.data == null
// ? Row()
//     : CommentList(
// commentSnaps: arrangedData,
// isReply: widget.isReply,
// post: widget.post,
// commentsReplies:
// widget.commentsReplies,
// // durationInDay:
// //     widget.durationInDay,
// // durationForHours:
// //     widget.durationForHours,
// // durationForMinutes: widget
// //     .durationForMinutes,
// parentSetState: () {
// setState(() {});
// },
// );
// }
//
// return CommentList(
// commentSnaps: arrangedData,
// post: _post,
// commentsReplies:
// widget.commentsReplies,
// isReply: widget.isReply,
// // durationInDay: widget.durationInDay,
// // durationForHours:
// //     widget.durationForHours,
// // durationForMinutes:
// //     widget.durationForMinutes,
// parentSetState: () {
// setState(() {});
// },
// );
// },
// ),

// Comment List With Snap
// Consumer<CommentReplyProvider>(
// builder: (context, commentReplyProvider,
// child) {
// String? commentId;
// if (widget.commentsReplies != null) {
// if (widget.isReply ?? false) {
// commentId = widget.commentsReplies
//     ?.reply?.parentCommentId;
// } else {
// commentId = widget.commentsReplies
//     ?.comment?.commentId;
// }
// }
// var arrangedData = rearrangeSnap(
// (commentReplyProvider
//     .postPollUserCommentSnapShot
// as dynamic)
//     ?.docs ??
// [],
// commentId ?? "");
//
// return CommentList(
// commentSnaps: arrangedData,
// post: _post,
// isReply: widget.isReply,
// commentsReplies:
// widget.commentsReplies,
// parentSetState: () {
// setState(() {});
// },
// );
// },
// ),
// Consumer<CommentReplyProvider>(
// builder: (context, commentReplyProvider,
// child) {
// String? commentId;
// if (widget.commentsReplies != null) {
// if (widget.isReply ?? false) {
// commentId = widget.commentsReplies
//     ?.reply?.parentCommentId;
// } else {
// commentId = widget.commentsReplies
//     ?.comment?.commentId;
// }
// }
// var arrangedData = rearrangeSnap(
// (commentReplyProvider
//     .postPollOtherUsersCommentSnapShot
// as dynamic)
//     ?.docs ??
// [],
// commentId ?? "");
//
// return CommentList(
// commentSnaps: arrangedData,
// post: _post,
// isReply: widget.isReply,
// commentsReplies:
// widget.commentsReplies,
// parentSetState: () {
// setState(() {});
// },
// );
// },
// ),

// dynamic rearrangeSnap(var commentSnaps, String commentId) {
//   var index = -1;
//   for (var i = 0; i < commentSnaps.length; i++) {
//     if (commentSnaps[i]['commentId'] == commentId) {
//       index = i;
//       debugPrint("Found Element At Index ::: $index");
//     }
//   }
//   if (index != -1) {
//     var temp = commentSnaps[index];
//     commentSnaps.removeAt(index);
//     commentSnaps.insert(0, temp);
//     debugPrint(
//         "======> Re arranged Snaps :::: ${commentSnaps[0]['commentId']}");
//   }
//   return commentSnaps;
// }
