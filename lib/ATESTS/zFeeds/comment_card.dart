import 'dart:async';

import 'package:aft/ATESTS/models/CommentsReplies.dart';
import 'package:aft/ATESTS/models/comment.dart';
import 'package:aft/ATESTS/models/reply.dart';
import 'package:aft/ATESTS/provider/comments_replies_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/poll.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../methods/auth_methods.dart';
import '../methods/firestore_methods.dart';
import '../screens/full_message.dart';
import '../screens/full_message_poll.dart' as fullMessagePoll;
import '../screens/profile_all_user.dart';
import '../utils/utils.dart';
import '../utils/like_animation.dart';
import 'dart:ui' as ui;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class CommentCard extends StatefulWidget {
  // Comment
  int? index;
  final profileScreen;
  final postId;
  final postUId;
  final snap;
  final bool? plus;
  final bool? neutral;
  final bool? minus;
  final Function parentSetState;

  // final durationInDay;
  // final durationForHours;
  // final durationForMinutes;
  // Reply
  final bool isReply;
  final Post? parentPost;
  final String? parentCommentId;

  // final FocusNode? parentFocusNode;
  // final TextEditingController? parentReplyTextController;
  final String? parentReplyId;

  final bool isFromProfile;

  final CommentsReplies? commentsReplies;

  final GlobalKey? scrollKey;

  final bool openUpReplySection;

  final bool useScrollKey;

  final durationInDay;

  CommentCard({
    Key? key,

    // Reply
    this.isReply = false,
    this.parentCommentId,
    // this.parentFocusNode,
    // this.parentReplyTextController,
    this.parentPost,
    this.parentReplyId,

    // Comment
    // required this.durationInDay,
    // required this.durationForMinutes,
    // required this.durationForHours,
    required this.postId,
    this.index,
    required this.postUId,
    required this.snap,
    required this.profileScreen,
    this.plus,
    this.neutral,
    this.minus,
    required this.parentSetState,
    required this.durationInDay,
    this.isFromProfile = false,
    this.scrollKey,
    this.commentsReplies,
    this.openUpReplySection = false,
    this.useScrollKey = false,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  // late Post _post;
  User? user;
  final TextEditingController _replyController = TextEditingController();
  CommentReplyProvider? commentReplyProvider;
  FocusNode currentReplyFocusNode = FocusNode();
  bool isReadmore = false;
  bool showMoreButton = true;
  bool _replyingOnComment = false;
  bool _showCommentReplies = false;

  // int _likes = 0;
  // int _dislikes = 0;
  dynamic commentReplies;
  final AuthMethods _authMethods = AuthMethods();
  User? _userProfile;
  var postUID = "";
  var snap;
  bool isFromProfileScreen = false;
  CommentsReplies? commentsReplies;
  bool tileClick = false;

  // DateTime ntpTime = DateTime.now();
  // Timer? timer;

  // bool _isCommentTimerEnded = false;

  // /***/
  // /***/
  // InterstitialAd? interstitialAd;
  // final String interstitialAdUnitIdIOS =
  //     'ca-app-pub-1591305463797264/4735037493';
  // final String interstitialAdUnitIdAndroid =
  //     'ca-app-pub-1591305463797264/9016556769';
  // /***/
  // /***/

  @override
  void dispose() {
    super.dispose();
    // timer?.cancel();
    _replyController.dispose();
  }

  void messageReply(
    String postId,
    String commentId,
    String text,
    String uid,
    String name, {
    required int insertAt,
  }) async {
    try {
      String res = await FirestoreMethods().reply(
        postId,
        commentId,
        text,
        uid,
        name,
        widget.isReply,
        insertAt: insertAt,
      );
      if (res == "success") {
        // if (!mounted) return;
        // _showInterstitialAd();
        // showSnackBar('Reply successfully posted.', context);
        FocusScope.of(context).unfocus();
        // await AuthMethods().commentWaitTimer();
        await _stopReplying();
      } else {}
    } catch (e) {
      //
    }
  }

  void deleteComment(String commentId) async {
    try {
      String res = await FirestoreMethods().deleteComment(commentId);
      if (res == "success") {
        if (widget.commentsReplies != null) {
          if (widget.commentsReplies?.post != null) {
            await FirestoreMethods().commentCounter(
                widget.commentsReplies?.post?.postId ?? "-", 'message', false);
          } else if (widget.commentsReplies?.poll != null) {
            FirestoreMethods().commentCounter(
                widget.commentsReplies?.poll?.pollId ?? "-", 'poll', false);
          }
        } else {
          await FirestoreMethods()
              .commentCounter(widget.postId, 'message', false);
        }
        commentReplyProvider?.deleteUserComment(commentId);
      } else {}
    } catch (e) {
      //
    }
  }

  void deleteReply(String replyId, String parentCommentId) async {
    try {
      String res = await FirestoreMethods().deleteReply(replyId);
      if (res == "success") {
        commentReplyProvider?.deleteUserReply(
          parentCommentId,
          replyId,
        );
      } else {}
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    super.initState();
    // _post = widget.parentPost!;

    // timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
    //   if (this.mounted) {
    //     setState(() {
    //       ntpTime = DateTime.now();
    //       // debugPrint('DATE TIME: $ntpTime');
    //     });
    //   }
    // });
    getAllUserDetails();
    Future.delayed(Duration.zero, () async {
      commentReplyProvider =
          Provider.of<CommentReplyProvider>(context, listen: false);
    });
    commentsReplies = widget.commentsReplies;
    isFromProfileScreen = widget.isFromProfile;

    if (widget.openUpReplySection == true) {
      _showCommentReplies = true;
    }
    // _loadInterstitialAd();
    // postUID = widget.postUId ?? "";
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
  //         'Reply successfully posted.',
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

  getAllUserDetails() async {
    User userProfile =
        await _authMethods.getUserProfileDetails(widget.snap['UID']);
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;

    _replyingOnComment = widget.isReply
        ? widget.parentReplyId == currentReplyCommentId
        : widget.snap['commentId'] == currentReplyCommentId;

    return user == null
        ? buildComments(context)
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.UID)
                .snapshots(),
            builder: (content,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              snap =
                  snapshot.data != null ? User.fromSnap(snapshot.data!) : snap;
              if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox();
              }
              return !snap.blockList.contains(_userProfile?.UID)
                  ? buildComments(context)
                  : const SizedBox();
            });
  }

  Widget buildComments(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    _replyingOnComment = widget.isReply
        ? widget.parentReplyId == currentReplyCommentId
        : widget.snap['commentId'] == currentReplyCommentId;
    // _isCommentTimerEnded =
    //     (timerCommentEnd).toDate().difference(ntpTime).isNegative;

    // print("Use Scroll Key Inside Comment Card =====> ${widget.useScrollKey}");

    return Container(
      key: widget.useScrollKey ? widget.scrollKey : null,
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.isFromProfile ? 10 : 0,
        ),
        child: PhysicalModel(
          color: widget.isFromProfile
              ? Colors.white
              : !widget.isFromProfile && tileClick
                  ? const Color.fromARGB(255, 245, 245, 245)
                  : widget.useScrollKey
                      ? const Color.fromARGB(255, 227, 241, 255)
                      : Colors.white,
          elevation: !widget.isFromProfile ? 0 : 2,
          child: Container(
            decoration: BoxDecoration(
                border: !widget.isFromProfile
                    ? const Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 245, 245, 245),
                            width: 0.5),
                        // top: BorderSide(
                        //     color: const Color.fromARGB(255, 245, 245, 245),
                        //     width: 0.5),
                      )
                    : null),
            child: Theme(
              data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: const Color.fromARGB(255, 245, 245, 245)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isFromProfile
                      ? () {
                          if (commentsReplies?.postOrPollComment ==
                              PostOrPollComment.post) {
                            setState(() {
                              tileClick = true;
                            });
                            Post post = commentsReplies!.post!;
                            // print("Got Post ID ::: ${post.postId}");
                            Future.delayed(const Duration(milliseconds: 0), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullMessage(
                                    post: post,
                                    postId: post.postId,
                                    commentsReplies: commentsReplies,
                                    isReply: widget.isReply,
                                  ),
                                ),
                              );
                              setState(() {
                                tileClick = true;
                              });
                            });
                          } else {
                            setState(() {
                              tileClick = true;
                            });
                            Poll poll = commentsReplies!.poll!;
                            Future.delayed(const Duration(milliseconds: 0),
                                () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      fullMessagePoll.FullMessagePoll(
                                          poll: poll,
                                          pollId: poll.pollId,
                                          commentsReplies: commentsReplies,
                                          isReply: widget.isReply,
                                          durationInDay: widget.durationInDay),
                                ),
                              );
                              setState(() {
                                tileClick = true;
                              });
                            });
                          }
                        }
                      : null,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left:
                              widget.isReply && !widget.isFromProfile ? 42 : 0,
                          bottom: widget.isReply ? 6 : 0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width:
                                          widget.isReply || widget.isFromProfile
                                              ? 0
                                              : 1,
                                      color:
                                          widget.isReply || widget.isFromProfile
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 220, 220, 220)),
                                ),
                              ),
                              child: Container(
                                color: const Color.fromARGB(255, 236, 234, 234),
                              ),
                            ),
                            Padding(
                              padding: widget.isFromProfile
                                  ? const EdgeInsets.only(
                                      right: 10.0,
                                      left: 10,
                                      top: 8,
                                      bottom: 10,
                                    )
                                  : widget.isReply
                                      ? const EdgeInsets.only(
                                          right: 12.0,
                                          left: 18,
                                          top: 8,
                                          bottom: 10,
                                        )
                                      : const EdgeInsets.only(
                                          right: 12.0,
                                          left: 10,
                                          top: 16,
                                          bottom: 10,
                                        ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 200, 200, 200),
                                    ),
                                    child: Stack(
                                      children: [
                                        _userProfile?.photoUrl != null
                                            ? Material(
                                                color: Colors.grey,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: Ink.image(
                                                  image: NetworkImage(
                                                      '${_userProfile?.photoUrl}'),
                                                  fit: BoxFit.cover,
                                                  width: 40,
                                                  height: 40,
                                                  child: InkWell(
                                                    splashColor: Colors.white
                                                        .withOpacity(0.5),
                                                    onTap: () {
                                                      Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                          widget.profileScreen
                                                              ? null
                                                              : Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProfileAllUser(
                                                                      uid: _userProfile
                                                                              ?.UID ??
                                                                          '',
                                                                      initialTab:
                                                                          0,
                                                                    ),
                                                                  ),
                                                                );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Material(
                                                color: Colors.grey,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.hardEdge,
                                                child: Ink.image(
                                                  image: const AssetImage(
                                                      'assets/avatarFT.jpg'),
                                                  fit: BoxFit.cover,
                                                  width: 40,
                                                  height: 40,
                                                  // splashColor: Colors.blue,
                                                  child: InkWell(
                                                    splashColor: Colors.white
                                                        .withOpacity(0.5),
                                                    onTap: () {
                                                      Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                          widget.profileScreen
                                                              ? null
                                                              : Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProfileAllUser(
                                                                      uid: _userProfile
                                                                              ?.UID ??
                                                                          '',
                                                                      initialTab:
                                                                          0,
                                                                    ),
                                                                  ),
                                                                );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                        Positioned(
                                          bottom: 0,
                                          right: 2.8,
                                          child: Row(
                                            children: [
                                              _userProfile?.profileFlag == true
                                                  ? SizedBox(
                                                      width: 15.5,
                                                      height: 7.7,
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
                                              _userProfile?.profileBadge == true
                                                  ? Stack(
                                                      children: const [
                                                        Positioned(
                                                          right: 3,
                                                          top: 3,
                                                          child: CircleAvatar(
                                                            radius: 4,
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          child: Icon(
                                                              Icons.verified,
                                                              color: Color
                                                                  .fromARGB(
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Text(
                                                  _userProfile?.username ?? '',
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              // Visibility(
                                              //   visible: widget.minus ?? false,
                                              //   child: Padding(
                                              //     padding:
                                              //         const EdgeInsets.symmetric(
                                              //             vertical: 2.0),
                                              //     child: Row(
                                              //       children: [
                                              //         const Icon(Icons.done,
                                              //             size: 10,
                                              //             color: Colors.grey),
                                              //         const SizedBox(width: 3),
                                              //         Row(
                                              //           children: const [
                                              //             Text(
                                              //               'Voted: ',
                                              //               style: TextStyle(
                                              //                 fontSize: 10,
                                              //                 color:
                                              //                     Color.fromARGB(
                                              //                         255,
                                              //                         111,
                                              //                         111,
                                              //                         111),
                                              //               ),
                                              //             ),
                                              //             Icon(
                                              //               Icons
                                              //                   .do_not_disturb_on,
                                              //               color: Colors.red,
                                              //               size: 12,
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              // Visibility(
                                              //   visible: widget.plus ?? false,
                                              //   child: Padding(
                                              //     padding:
                                              //         const EdgeInsets.symmetric(
                                              //             vertical: 2.0),
                                              //     child: Row(
                                              //       children: [
                                              //         const Icon(Icons.done,
                                              //             size: 10,
                                              //             color: Colors.grey),
                                              //         const SizedBox(width: 3),
                                              //         Row(
                                              //           children: const [
                                              //             Text(
                                              //               'Voted: ',
                                              //               style: TextStyle(
                                              //                 fontSize: 10,
                                              //                 color:
                                              //                     Color.fromARGB(
                                              //                         255,
                                              //                         111,
                                              //                         111,
                                              //                         111),
                                              //               ),
                                              //             ),
                                              //             Icon(
                                              //               Icons.add_circle,
                                              //               color: Colors.green,
                                              //               size: 12,
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              // Visibility(
                                              //   visible: widget.neutral ?? false,
                                              //   child: Padding(
                                              //     padding:
                                              //         const EdgeInsets.symmetric(
                                              //             vertical: 2.0),
                                              //     child: Row(
                                              //       children: [
                                              //         const Icon(Icons.done,
                                              //             size: 10,
                                              //             color: Colors.grey),
                                              //         const SizedBox(width: 3),
                                              //         Row(
                                              //           children: const [
                                              //             Text(
                                              //               'Voted: ',
                                              //               style: TextStyle(
                                              //                 fontSize: 10,
                                              //                 color:
                                              //                     Color.fromARGB(
                                              //                         255,
                                              //                         111,
                                              //                         111,
                                              //                         111),
                                              //               ),
                                              //             ),
                                              //             RotatedBox(
                                              //               quarterTurns: 1,
                                              //               child: Icon(
                                              //                 Icons
                                              //                     .pause_circle_filled,
                                              //                 color:
                                              //                     Color.fromARGB(
                                              //                         255,
                                              //                         111,
                                              //                         111,
                                              //                         111),
                                              //                 size: 12,
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              Text(
                                                DateFormat.yMMMd().format(widget
                                                    .snap['datePublishedNTP']
                                                    .toDate()),
                                                style: const TextStyle(
                                                    fontSize: 11.5,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Expanded(child: Container()),
                                          Container(
                                            width: 37,
                                            height: 37,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
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
                                                    widget.snap['UID'] ==
                                                            user?.UID
                                                        ? showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SimpleDialog(
                                                                children: [
                                                                  SimpleDialogOption(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            20),
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons.delete),
                                                                        Container(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                            widget.isReply
                                                                                ? 'Delete Reply'
                                                                                : 'Delete Comment',
                                                                            style:
                                                                                const TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                      ],
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 150),
                                                                          () {
                                                                        deleteConfirmation(
                                                                            context:
                                                                                context,
                                                                            phrase: widget.isReply
                                                                                ? 'Deleting this reply is permanent and this action cannot be undone.'
                                                                                : 'Deleting this comment is permanent and this action cannot be undone.',
                                                                            type: widget.isReply
                                                                                ? 'Delete Reply'
                                                                                : 'Delete Comment',
                                                                            action:
                                                                                () async {
                                                                              widget.isReply
                                                                                  ? deleteReply(
                                                                                      // widget.postId, widget.parentCommentId!,
                                                                                      widget.snap['replyId'],
                                                                                      widget.snap['parentCommentId'])
                                                                                  : deleteComment(
                                                                                      // widget.postId,
                                                                                      widget.snap['commentId'],
                                                                                    );
                                                                              Navigator.of(context).pop();
                                                                              Navigator.of(context).pop();
                                                                              showSnackBar(widget.isReply ? 'Reply successfully deleted.' : 'Comment successfully deleted.', context);
                                                                            });
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            })
                                                        : showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SimpleDialog(
                                                                children: [
                                                                  SimpleDialogOption(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            20),
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons.block),
                                                                        Container(
                                                                            width:
                                                                                10),
                                                                        const Text(
                                                                            'Block User',
                                                                            style:
                                                                                TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                      ],
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 150),
                                                                          () {
                                                                        performLoggedUserAction(
                                                                          context:
                                                                              context,
                                                                          action:
                                                                              () {
                                                                            blockDialog(
                                                                              action: () async {
                                                                                var userRef = FirebaseFirestore.instance.collection("users").doc(user?.UID);
                                                                                var blockListRef = FirebaseFirestore.instance.collection("users").doc(user?.UID).collection('blockList').doc(widget.snap['UID']);
                                                                                var blockUserInfo = await FirebaseFirestore.instance.collection("users").doc(widget.snap['UID']).get();
                                                                                if (blockUserInfo.exists) {
                                                                                  final batch = FirebaseFirestore.instance.batch();
                                                                                  final blockingUserData = blockUserInfo.data();
                                                                                  blockingUserData?['creatorUID'] = user?.UID;
                                                                                  batch.update(userRef, {
                                                                                    'blockList': FieldValue.arrayUnion([
                                                                                      widget.snap['UID']
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
                                                                  SimpleDialogOption(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            20),
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons.report_outlined),
                                                                        Container(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                            widget.isReply
                                                                                ? 'Report Reply'
                                                                                : 'Report Comment',
                                                                            style:
                                                                                const TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                      ],
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Future
                                                                          .delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                150),
                                                                        () {
                                                                          performLoggedUserAction(
                                                                              context: context,
                                                                              action: () {
                                                                                widget.isReply
                                                                                    ? reportDialog(
                                                                                        context: context,
                                                                                        type: 'reply',
                                                                                        typeCapital: 'Reply',
                                                                                        user: false,
                                                                                        action: () async {
                                                                                          await FirestoreMethods().reportCounter(widget.snap['replyId'], widget.snap['reportChecked'], 'reply');
                                                                                          if (!mounted) return;
                                                                                          showSnackBar('Reply successfully reported.', context);
                                                                                          Navigator.pop(context);
                                                                                          Navigator.pop(context);
                                                                                        })
                                                                                    : reportDialog(
                                                                                        context: context,
                                                                                        type: 'comment',
                                                                                        typeCapital: 'Comment',
                                                                                        user: false,
                                                                                        action: () async {
                                                                                          await FirestoreMethods().reportCounter(widget.snap['commentId'], widget.snap['reportChecked'], 'comment');
                                                                                          if (!mounted) return;
                                                                                          showSnackBar('Comment successfully reported.', context);
                                                                                          Navigator.pop(context);
                                                                                          Navigator.pop(context);
                                                                                        });
                                                                              });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                  });
                                                },
                                                child: const Icon(
                                                    Icons.more_vert,
                                                    size: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: widget.isFromProfile && widget.isReply
                                      ? 62
                                      : widget.isReply
                                          ? 68
                                          : 62,
                                  right: 16),
                              child: buildText('${widget.snap['text']}'),
                            ),
                            Container(height: 8),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: widget.isFromProfile && widget.isReply
                                      ? 0.0
                                      : widget.isFromProfile
                                          ? 6
                                          : 0,
                                  right: 14,
                                  left: widget.isFromProfile && widget.isReply
                                      ? 62
                                      : widget.isReply
                                          ? 68
                                          : 62),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        LikeAnimation(
                                          isAnimating: widget.snap['likes']
                                                  ?.contains(user?.UID) ??
                                              false,
                                          child: InkWell(
                                            onTap: () async {
                                              performLoggedUserAction(
                                                  context: context,
                                                  action: () async {
                                                    widget.isReply
                                                        ? await FirestoreMethods()
                                                            .like(
                                                            widget.snap[
                                                                'replyId'],
                                                            user?.UID ?? '',
                                                            widget
                                                                .snap['likes'],
                                                            widget.snap[
                                                                'dislikes'],
                                                            widget.snap[
                                                                'likeCount'],
                                                            widget.snap[
                                                                'dislikeCount'],
                                                            'reply',
                                                            parentMessageId: widget
                                                                    .snap[
                                                                'parentCommentId'],
                                                          )
                                                        : await FirestoreMethods().like(
                                                            widget.snap[
                                                                'commentId'],
                                                            user?.UID ?? '',
                                                            widget
                                                                .snap['likes'],
                                                            widget.snap[
                                                                'dislikes'],
                                                            widget.snap[
                                                                'likeCount'],
                                                            widget.snap[
                                                                'dislikeCount'],
                                                            'comment');

                                                    if (mounted) {
                                                      setState(() {});
                                                    }
                                                  });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.thumb_up,
                                                    color: widget.snap['likes']
                                                                ?.contains(user
                                                                    ?.UID) ??
                                                            false
                                                        ? Colors.blueAccent
                                                        : const Color.fromARGB(
                                                            255, 206, 204, 204),
                                                    size: 16.0,
                                                  ),
                                                ),
                                                Container(width: 6),
                                                Text(
                                                    '${widget.snap['likeCount']}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(width: 24),
                                        LikeAnimation(
                                          isAnimating: widget.snap['dislikes']
                                                  ?.contains(user?.UID) ??
                                              false,
                                          child: InkWell(
                                            onTap: () async {
                                              performLoggedUserAction(
                                                  context: context,
                                                  action: () async {
                                                    widget.isReply
                                                        ? await FirestoreMethods().dislike(
                                                            widget.snap[
                                                                'replyId'],
                                                            user?.UID ?? '',
                                                            widget.snap[
                                                                'likes'],
                                                            widget.snap[
                                                                'dislikes'],
                                                            widget.snap[
                                                                'likeCount'],
                                                            widget.snap[
                                                                'dislikeCount'],
                                                            'reply',
                                                            parentMessageId: widget
                                                                    .snap[
                                                                'parentCommentId'])
                                                        : await FirestoreMethods()
                                                            .dislike(
                                                                widget.snap[
                                                                    'commentId'],
                                                                user?.UID ?? '',
                                                                widget.snap[
                                                                    'likes'],
                                                                widget
                                                                        .snap[
                                                                    'dislikes'],
                                                                widget.snap[
                                                                    'likeCount'],
                                                                widget.snap[
                                                                    'dislikeCount'],
                                                                'comment');
                                                    setState(() {});
                                                  });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.thumb_down,
                                                    size: 16,
                                                    color: widget.snap[
                                                                    'dislikes']
                                                                ?.contains(user
                                                                    ?.UID) ??
                                                            false
                                                        ? Colors.blueAccent
                                                        : const Color.fromARGB(
                                                            255, 206, 204, 204),
                                                  ),
                                                ),
                                                Container(width: 6),
                                                Text(
                                                    '${widget.snap['dislikeCount']}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: !_replyingOnComment &&
                                        widget.isFromProfile == false,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        splashColor:
                                            Colors.blue.withOpacity(0.5),
                                        onTap: () async {
                                          Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                            performLoggedUserAction(
                                                context: context,
                                                action: () async {
                                                  await _startReplying(
                                                    to: widget.snap['username'],
                                                    commentId: widget.isReply
                                                        ? widget.parentReplyId
                                                        : widget
                                                            .snap['commentId'],
                                                    replyFocusNode: widget
                                                            .isReply
                                                        ? currentReplyFocusNode
                                                        : currentReplyFocusNode,
                                                    replyTextController:
                                                        widget.isReply
                                                            ? _replyController
                                                            : _replyController,
                                                  );
                                                });
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          color: Colors.transparent,
                                          child: Row(
                                            children: const [
                                              Icon(Icons.reply,
                                                  color: Colors.blueAccent,
                                                  size: 14),
                                              SizedBox(width: 4),
                                              Text(
                                                  // _isCommentTimerEnded || guest
                                                  //     ?
                                                  "REPLY"
                                                  // : 'WAIT TIME'
                                                  ,
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _showCommentReplies,
                              child: _replyTextField(),
                            ),
                            Visibility(
                              visible: !widget.isReply,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    // .collection('posts')
                                    // .doc(widget.postId)
                                    // .collection('comments')
                                    // .doc(widget.snap['commentId'])
                                    .collection('replies')
                                    .where('parentMessageId',
                                        isEqualTo: widget.postId)
                                    .where('parentCommentId',
                                        isEqualTo: widget.snap['commentId'])
                                    .where('reportRemoved', isEqualTo: false)
                                    .orderBy('datePublished', descending: false)
                                    // .orderBy('likeCount', descending: true)
                                    .snapshots(),
                                builder: (content, snapshot) {
                                  int repliesCount =
                                      (snapshot.data as dynamic)?.docs.length ??
                                          0;
                                  return repliesCount > 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 58.0,
                                              ),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    splashColor: Colors.blue
                                                        .withOpacity(0.5),
                                                    onTap: () async {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds: 50),
                                                          () {
                                                        _showCommentReplies =
                                                            !_showCommentReplies;
                                                        _stopReplying();
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 2),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            _showCommentReplies
                                                                ? Icons
                                                                    .arrow_drop_up
                                                                : Icons
                                                                    .arrow_drop_down,
                                                            size: 18,
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                          Container(width: 2),
                                                          // Text(
                                                          //     "Replies (${widget.snap['replyCount']})",
                                                          //     style:
                                                          //         const TextStyle(
                                                          //       color: Colors
                                                          //           .blueAccent,
                                                          //       fontSize: 13,
                                                          //       letterSpacing: 0.5,
                                                          //     )),
                                                          Text(
                                                              _showCommentReplies
                                                                  ? "Hide Replies"
                                                                  : "Show Replies",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontSize: 13,
                                                                // fontWeight:
                                                                //     FontWeight
                                                                //         .w500,
                                                                letterSpacing:
                                                                    0.5,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox();
                                },
                              ),
                            ),
                            Visibility(
                              visible: !_showCommentReplies &&
                                  widget.isFromProfile == false,
                              child: _replyTextField(),
                            ),
                            Visibility(
                              visible: _showCommentReplies,
                              child: Consumer<CommentReplyProvider>(
                                builder:
                                    (context, commentReplyProvider, child) {
                                  CommentsAndReplies? commentAndReplies;
                                  for (var index = 0;
                                      index <
                                          commentReplyProvider
                                              .postPollCommentAndReplyList
                                              .length;
                                      index++) {
                                    Comment comment = commentReplyProvider
                                        .postPollCommentAndReplyList[index]
                                        .comment;
                                    if (comment.commentId ==
                                        widget.snap['commentId']) {
                                      commentAndReplies = commentReplyProvider
                                          .postPollCommentAndReplyList[index];
                                      // print(
                                      //     "Debugging Element ::: ${commentReplyProvider.postPollCommentAndReplyList[index]?.replyList}");
                                    }
                                  }

                                  return ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      ReplyList(
                                          replyList:
                                              commentAndReplies?.replyList ??
                                                  [],
                                          parentPost: widget.parentPost,
                                          scrollKey: widget.scrollKey,
                                          replyId:
                                              commentsReplies?.reply?.replyId,
                                          parentCommentId:
                                              widget.snap['commentId'],
                                          postId: widget.postId,
                                          postUId: postUID,
                                          parentSetState: widget.parentSetState,
                                          durationInDay: widget.durationInDay),
                                      Visibility(
                                        visible: !(commentReplyProvider
                                                        .canPostPollRepliesLoadMoreMap[
                                                    widget.snap['commentId']] ??
                                                true) &&
                                            !(commentReplyProvider
                                                        .canPostPollRepliesPaginationLoadingMap[
                                                    widget.snap['commentId']] ??
                                                true),
                                        child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
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
                                                              255,
                                                              245,
                                                              245,
                                                              245),
                                                      onTap: () {
                                                        commentReplyProvider
                                                            .getPollOrPostReplyList(
                                                          postId: widget.postId,
                                                          commentId: widget
                                                                      .snap[
                                                                  'commentId'] ??
                                                              "",
                                                          isNext: true,
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 6,
                                                                horizontal: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
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
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      81,
                                                                      81,
                                                                      81),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              'View More Replies',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        81,
                                                                        81,
                                                                        81),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
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
                                      ),
                                      Visibility(
                                        visible: (commentReplyProvider
                                                    .canPostPollRepliesPaginationLoadingMap[
                                                widget.snap['commentId']] ??
                                            false),
                                        child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _replyTextField() {
    return Padding(
      padding: EdgeInsets.only(bottom: _showCommentReplies ? 0 : 8),
      child: Visibility(
        visible: _replyingOnComment,
        child: Padding(
          padding: EdgeInsets.only(left: widget.isReply ? 12 : 8, right: 8),
          child: PhysicalModel(
            elevation: 2,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 242, 242, 242),
                  // border: Border.all(
                  //   width: 0,
                  //   color: const Color.fromARGB(255, 201, 201, 201),
                  // ),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      left: 8,
                      bottom: 4,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            left: 4,
                          ),
                          child: Stack(
                            children: [
                              user?.photoUrl != null
                                  ? Material(
                                      color: Colors.grey,
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      child: Ink.image(
                                        image:
                                            NetworkImage('${user?.photoUrl}'),
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                                widget.profileScreen
                                                    ? null
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileAllUser(
                                                                  uid:
                                                                      user?.UID ??
                                                                          '',
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
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      child: Ink.image(
                                        image: const AssetImage(
                                            'assets/avatarFT.jpg'),
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                        // splashColor: Colors.blue,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                                widget.profileScreen
                                                    ? null
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileAllUser(
                                                                  uid:
                                                                      user?.UID ??
                                                                          '',
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
                                right: 2.8,
                                child: Row(
                                  children: [
                                    _userProfile?.profileFlag == true
                                        ? SizedBox(
                                            width: 15.5,
                                            height: 7.7,
                                            child: Image.asset(
                                                'icons/flags/png/${_userProfile?.aaCountry}.png',
                                                package: 'country_icons'))
                                        : Row()
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 1,
                                child: Row(
                                  children: [
                                    _userProfile?.profileBadge == true
                                        ? Stack(
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
                                                child: Icon(Icons.verified,
                                                    color: Color.fromARGB(
                                                        255, 113, 191, 255),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 8,
                            ),
                            child: TextField(
                              style: const TextStyle(fontSize: 15),
                              controller: _replyController,
                              maxLines: null,
                              focusNode: currentReplyFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Write a reply',
                                contentPadding: EdgeInsets.only(top: 14),
                                hintStyle: TextStyle(color: Colors.grey),
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 11),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, right: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            splashColor: Colors.grey.withOpacity(0.3),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () async {
                                await _stopReplying();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: const Text("CANCEL",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 121, 121, 121),
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  )),
                            ),
                          ),
                        ),
                        Container(width: 15),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            splashColor: Colors.blue.withOpacity(0.5),
                            onTap: () async {
                              performLoggedUserAction(
                                  context: context,
                                  action: () {
                                    // postReply(
                                    //     widget.postId,
                                    //     widget.isReply
                                    //         ? widget.parentCommentId
                                    //         : widget.snap['commentId'],
                                    //     _replyController.text,
                                    //     user?.UID ?? '',
                                    //     user?.username ?? '',
                                    //     user?.photoUrl ?? '');
                                    messageReply(
                                      widget.postId,
                                      widget.isReply
                                          ? widget.parentCommentId
                                          : widget.snap['commentId'],
                                      _replyController.text,
                                      user?.UID ?? '',
                                      user?.username ?? '',
                                      insertAt: widget.isReply
                                          ? ((widget.index ?? 0) + 1)
                                          : 0,
                                    );
                                    setState(() {
                                      _replyController.text = "";
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 100),
                                        () async {
                                      await _stopReplying();
                                    });
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.send,
                                        color: Colors.blueAccent, size: 12),
                                    Container(width: 4),
                                    const Text(
                                      'SEND',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueAccent,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText(String text) {
    TextStyle yourStyle = const TextStyle(fontSize: 15);
    const maxLinesAfterEllipses = 10;
    final lines = isReadmore ? null : maxLinesAfterEllipses;
    Text t = Text(
      text,
      style: yourStyle,
      maxLines: lines,
      overflow: isReadmore ? TextOverflow.visible : TextOverflow.ellipsis,
    );

    return Column(
      children: [
        Container(alignment: Alignment.centerLeft, child: t),
        LayoutBuilder(builder: (context, constraints) {
          final span = TextSpan(text: text, style: yourStyle);
          final tp = TextPainter(
            text: span,
            textDirection: ui.TextDirection.ltr,
            textAlign: TextAlign.left,
          );
          tp.layout(maxWidth: constraints.maxWidth);
          final numLines = tp.computeLineMetrics().length;

          if (numLines > maxLinesAfterEllipses) {
            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                splashColor: Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  setState(() {
                    isReadmore = !isReadmore;
                  });
                },
                child: Text(
                  isReadmore ? 'Show Less' : 'Show More',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  // Widget buildText(String text) {
  //   final lines = isReadmore ? null : 15;
  //   Text t = Text(
  //     text,
  //     style: TextStyle(fontSize: 15),
  //     maxLines: lines,
  //     overflow: isReadmore ? TextOverflow.visible : TextOverflow.ellipsis,
  //   );
  //   return t;
  // }

  Future<void> _stopReplying() async {
    currentReplyCommentId = null;
    currentReplyFocusNode = FocusNode();
    widget.parentSetState();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Future<void> _startReplying({
    required String to,
    required String commentId,
    required TextEditingController replyTextController,
    required FocusNode replyFocusNode,
  }) async {
    currentReplyCommentId = commentId;
    currentReplyFocusNode = FocusNode();
    widget.parentSetState();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () {
        replyTextController.text = '@$to ';
        FocusScope.of(context).requestFocus(replyFocusNode);
      },
    );
  }
}

class ReplyList extends StatelessWidget {
  final List<Reply> replyList;
  final Post? parentPost;
  final String? parentCommentId;
  final postId;
  final Function parentSetState;
  final postUId;
  var durationInDay;
  // final durationForHours;
  // final durationForMinutes;
  GlobalKey? scrollKey;
  final String? replyId;

  ReplyList({
    Key? key,
    required this.replyList,
    this.parentPost,
    this.parentCommentId,
    this.postId,
    this.postUId,
    required this.durationInDay,
    // this.durationForHours,
    // this.durationForMinutes,
    required this.parentSetState,
    this.scrollKey,
    this.replyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(
            replyList.length,
            (index) {
              Reply reply = replyList[index];
              // debugPrint("");
              // debugPrint("===============================");
              // debugPrint("replySnap ${reply.toJson()}");
              // debugPrint("reply $replyId");
              // debugPrint(
              //     "================  replySnap['replyId'] == replyId ${reply.replyId == replyId}");
              bool userScrollKey = reply.replyId == replyId;

              if (index == replyList.length - 1) {
                _scrollToTop();
              }

              return CommentCard(
                key: Key(reply.replyId),
                index: index,
                isReply: true,
                parentCommentId: parentCommentId,
                parentReplyId: reply.replyId,
                snap: reply.toJson(),
                postId: postId,
                postUId: postUId,
                minus: parentPost?.minus.contains(reply.UID),
                neutral: parentPost?.neutral.contains(reply.UID),
                plus: parentPost?.plus.contains(reply.UID),
                parentSetState: parentSetState,
                scrollKey: scrollKey,
                useScrollKey: userScrollKey,
                profileScreen: false,
                durationInDay: durationInDay,
              );
            },
          )
        ],
      ),
    );
  }

  _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollKey?.currentContext != null) {
        Scrollable.ensureVisible(scrollKey!.currentContext!);
        scrollKey = null;
      }
    });
  }
}
