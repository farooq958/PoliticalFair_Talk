import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/CommentsReplies.dart';
import '../models/comment.dart';
import '../models/poll.dart';
import '../models/reply.dart';
import '../models/user.dart';
import '../provider/comments_replies_provider.dart';
import '../provider/user_provider.dart';
import '../methods/auth_methods.dart';
import '../methods/firestore_methods.dart';
import '../screens/full_message.dart';
import '../screens/profile_all_user.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../utils/like_animation.dart';
import 'dart:ui' as ui;

class CommentCardPoll extends StatefulWidget {
  // Comment
  int? index;
  final pollId;
  final pollUId;
  final snap;
  final String? option1;
  final String? option2;
  final String? option3;
  final String? option4;
  final String? option5;
  final String? option6;
  final String? option7;
  final String? option8;
  final String? option9;
  final String? option10;
  final bool? vote1;
  final bool? vote2;
  final bool? vote3;
  final bool? vote4;
  final bool? vote5;
  final bool? vote6;
  final bool? vote7;
  final bool? vote8;
  final bool? vote9;
  final bool? vote10;
  final Function parentSetState;

  var durationInDay;

  // Reply
  final bool isReply;
  final Poll? parentPost;
  final String? parentCommentId;
  final String? parentReplyId;

  final CommentsReplies? commentsReplies;

  final GlobalKey? scrollKey;

  bool openUpReplySection;

  final bool useScrollKey;

  CommentCardPoll({
    Key? key,
    this.index,

    // Reply
    this.isReply = false,
    this.parentCommentId,
    this.parentPost,
    this.parentReplyId,

    // Comment
    // required this.durationInDay,
    // required this.durationForHours,
    // required this.durationForMinutes,
    required this.pollId,
    required this.snap,
    this.vote1,
    this.vote2,
    this.vote3,
    this.vote4,
    this.vote5,
    this.vote6,
    this.vote7,
    this.vote8,
    this.vote9,
    this.vote10,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.option5,
    this.option6,
    this.option7,
    this.option8,
    this.option9,
    this.option10,
    required this.parentSetState,
    required this.pollUId,
    required this.durationInDay,
    this.scrollKey,
    this.commentsReplies,
    this.openUpReplySection = false,
    this.useScrollKey = false,
  }) : super(key: key);

  @override
  State<CommentCardPoll> createState() => _CommentCardPollState();
}

class _CommentCardPollState extends State<CommentCardPoll> {
  User? user;
  final TextEditingController _replyController = TextEditingController();
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
  var snap;
  late CommentReplyProvider commentReplyProvider;

  // /***/
  // /***/
  // InterstitialAd? interstitialAd;
  // final String interstitialAdUnitIdIOS = 'ca-app-pub-1591305463797264/4735037493';
  // final String interstitialAdUnitIdAndroid =
  //     'ca-app-pub-1591305463797264/9016556769';
  // /***/
  // /***/

  void pollReply(
    String pollId,
    String commentId,
    String text,
    String uid,
    String username,
  ) async {
    try {
      String res = await FirestoreMethods().reply(
          pollId, commentId, text, uid, username, widget.isReply,
          insertAt: widget.isReply ? ((widget.index ?? 0) + 1) : 0);
      if (res == "success") {
        // _showInterstitialAd();
        FocusScope.of(context).unfocus();
        await _stopReplying();
      } else {
        // showSnackBar(res, context);
      }
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  void deletePollComment(String commentId) async {
    try {
      String res = await FirestoreMethods().deleteComment(commentId);
      if (res == "success") {
        // FirestoreMethods().commentCounter(widget.pollId, 'poll', false);
        // commentReplyProvider.deleteUserComment(commentId);
      } else {}
    } catch (e) {
      //
    }
  }

  void deletePollReply(String commentId, String replyId) async {
    try {
      String res = await FirestoreMethods().deleteReply(replyId);
      if (res == "success") {
        commentReplyProvider.deleteUserReply(commentId, replyId);
        if (!mounted) return;
        showSnackBar('Reply successfully deleted.', context);
      } else {}
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    super.initState();

    // _loadInterstitialAd();

    // print("Got Open Up Comment Section ::: ${widget.openUpReplySection}");
    if (widget.openUpReplySection == true) {
      _showCommentReplies = true;
    }
    commentReplyProvider =
        Provider.of<CommentReplyProvider>(context, listen: false);

    getAllUserDetails();
  }

  getAllUserDetails() async {
    User userProfile =
        await _authMethods.getUserProfileDetails(widget.snap['UID']);
    setState(() {
      _userProfile = userProfile;
    });
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

  @override
  void dispose() {
    super.dispose();
    _replyController.dispose();
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
    return Container(
      key: widget.useScrollKey ? widget.scrollKey : null,
      color: widget.useScrollKey
          ? const Color.fromARGB(255, 227, 241, 255)
          : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: widget.isReply ? 42 : 0,
              bottom: widget.isReply ? 6 : 0,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: 1,
                          color: widget.isReply
                              ? Colors.white
                              : const Color.fromARGB(255, 220, 220, 220)),
                    ),
                  ),
                  child: Container(
                    color: const Color.fromARGB(255, 236, 234, 234),
                  ),
                ),
                Padding(
                  padding: widget.isReply
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
                                            _userProfile?.photoUrl ?? ''),
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileAllUser(
                                                      uid: _userProfile?.UID ??
                                                          '',
                                                      initialTab: 0,
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
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileAllUser(
                                                      uid: _userProfile?.UID ??
                                                          '',
                                                      initialTab: 0,
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
                                right: 3,
                                child: Row(
                                  children: [
                                    _userProfile?.profileFlag == true
                                        ? SizedBox(
                                            width: 20,
                                            height: 10,
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
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileAllUser(
                                            uid: _userProfile?.UID ?? '',
                                            initialTab: 0,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _userProfile?.username ?? '',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // Visibility(
                                  //   visible: widget.vote1 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option1}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote2 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option2}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote3 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option3}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote4 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option4}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote5 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option5}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote6 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option6}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote7 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option7}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote8 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option8}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote9 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option9}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // Visibility(
                                  //   visible: widget.vote10 ?? false,
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
                                  //         const Text(
                                  //           'Voted: ',
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //             color: Color.fromARGB(
                                  //                 255, 111, 111, 111),
                                  //           ),
                                  //         ),
                                  //         SizedBox(
                                  //           width: widget.isReply
                                  //               ? MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   214
                                  //               : MediaQuery.of(
                                  //                           context)
                                  //                       .size
                                  //                       .width -
                                  //                   164,
                                  //           child: Text(
                                  //             '${widget.option10}',
                                  //             maxLines: 1,
                                  //             style: const TextStyle(
                                  //                 color:
                                  //                     Color.fromARGB(
                                  //                         255,
                                  //                         111,
                                  //                         111,
                                  //                         111),
                                  //                 fontSize: 10,
                                  //                 overflow:
                                  //                     TextOverflow
                                  //                         .ellipsis,
                                  //                 fontWeight:
                                  //                     FontWeight
                                  //                         .w500),
                                  //           ),
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
                                        fontSize: 11.5, color: Colors.grey),
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
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.grey.withOpacity(0.5),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 50), () {
                                        widget.snap['UID'] == user?.UID
                                            ? showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return SimpleDialog(
                                                    children: [
                                                      SimpleDialogOption(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.delete),
                                                            Container(
                                                                width: 10),
                                                            Text(
                                                                widget.isReply
                                                                    ? 'Delete Reply'
                                                                    : 'Delete Comment',
                                                                style: const TextStyle(
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontSize:
                                                                        15)),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      150), () {
                                                            deleteConfirmation(
                                                                context:
                                                                    context,
                                                                phrase: widget
                                                                        .isReply
                                                                    ? 'Deleting this reply is permanent and this action cannot be undone.'
                                                                    : 'Deleting this comment is permanent and this action cannot be undone.',
                                                                type: widget
                                                                        .isReply
                                                                    ? 'Delete Reply'
                                                                    : 'Delete Comment',
                                                                action:
                                                                    () async {
                                                                  widget.isReply
                                                                      ? deletePollReply(
                                                                          widget.snap[
                                                                              'parentCommentId'],
                                                                          widget
                                                                              .snap['replyId'])
                                                                      : deletePollComment(
                                                                          widget
                                                                              .snap['commentId'],
                                                                        );
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  showSnackBar(
                                                                      widget.isReply
                                                                          ? 'Reply successfully deleted.'
                                                                          : 'Comment successfully deleted.',
                                                                      context);
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
                                                            const EdgeInsets
                                                                .all(20),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.block),
                                                            Container(
                                                                width: 10),
                                                            const Text(
                                                                'Block User',
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontSize:
                                                                        15)),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      150), () {
                                                            performLoggedUserAction(
                                                              context: context,
                                                              action: () {
                                                                blockDialog(
                                                                  action:
                                                                      () async {
                                                                    var userRef = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .doc(user
                                                                            ?.UID);
                                                                    var blockListRef = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .doc(user
                                                                            ?.UID)
                                                                        .collection(
                                                                            'blockList')
                                                                        .doc(widget
                                                                            .snap['UID']);
                                                                    var blockUserInfo = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .doc(widget
                                                                            .snap['UID'])
                                                                        .get();
                                                                    if (blockUserInfo
                                                                        .exists) {
                                                                      final batch = FirebaseFirestore
                                                                          .instance
                                                                          .batch();
                                                                      final blockingUserData =
                                                                          blockUserInfo
                                                                              .data();
                                                                      blockingUserData?[
                                                                              'creatorUID'] =
                                                                          user?.UID;
                                                                      batch.update(
                                                                          userRef,
                                                                          {
                                                                            'blockList':
                                                                                FieldValue.arrayUnion([
                                                                              widget.snap['UID']
                                                                            ])
                                                                          });
                                                                      batch.set(
                                                                        blockListRef,
                                                                        blockingUserData,
                                                                      );

                                                                      batch
                                                                          .commit();
                                                                    }

                                                                    showSnackBar(
                                                                        'User successfully blocked.',
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  context:
                                                                      context,
                                                                  isSearch:
                                                                      false,
                                                                );
                                                              },
                                                            );
                                                          });
                                                        },
                                                      ),
                                                      SimpleDialogOption(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        child: Row(
                                                          children: [
                                                            const Icon(Icons
                                                                .report_outlined),
                                                            Container(
                                                                width: 10),
                                                            Text(
                                                                widget.isReply
                                                                    ? 'Report Reply'
                                                                    : 'Report Comment',
                                                                style: const TextStyle(
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontSize:
                                                                        15)),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    150),
                                                            () {
                                                              performLoggedUserAction(
                                                                  context:
                                                                      context,
                                                                  action: () {
                                                                    widget
                                                                            .isReply
                                                                        ? reportDialog(
                                                                            context:
                                                                                context,
                                                                            type:
                                                                                'reply',
                                                                            typeCapital:
                                                                                'Reply',
                                                                            user:
                                                                                false,
                                                                            action:
                                                                                () async {
                                                                              await FirestoreMethods().reportCounter(widget.snap['replyId'], widget.snap['reportChecked'], 'reply');

                                                                              showSnackBar('Reply successfully reported.', context);
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            })
                                                                        : reportDialog(
                                                                            context:
                                                                                context,
                                                                            type:
                                                                                'comment',
                                                                            typeCapital:
                                                                                'Comment',
                                                                            user:
                                                                                false,
                                                                            action:
                                                                                () async {
                                                                              await FirestoreMethods().reportCounter(widget.snap['commentId'], widget.snap['reportChecked'], 'comment');

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
                                    child:
                                        const Icon(Icons.more_vert, size: 20),
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
                      left: widget.isReply ? 68 : 62, right: 16),
                  child: buildText('${widget.snap['text']}'),
                ),
                Container(height: 8),
                Padding(
                  padding: widget.isReply
                      ? const EdgeInsets.only(bottom: 4.0, right: 14, left: 68)
                      : const EdgeInsets.only(bottom: 4.0, right: 14, left: 62),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            LikeAnimation(
                              isAnimating:
                                  widget.snap['likes']?.contains(user?.UID) ??
                                      false,
                              child: InkWell(
                                onTap: () async {
                                  performLoggedUserAction(
                                      context: context,
                                      action: () async {
                                        widget.isReply
                                            ? await FirestoreMethods().like(
                                                widget.snap['replyId'],
                                                user?.UID ?? '',
                                                widget.snap['likes'],
                                                widget.snap['dislikes'],
                                                widget.snap['likeCount'],
                                                widget.snap['dislikeCount'],
                                                'reply',
                                                parentMessageId: widget
                                                    .snap['parentCommentId'],
                                              )
                                            : await FirestoreMethods().like(
                                                widget.snap['commentId'],
                                                user?.UID ?? '',
                                                widget.snap['likes'],
                                                widget.snap['dislikes'],
                                                widget.snap['likeCount'],
                                                widget.snap['dislikeCount'],
                                                'comment');
                                        setState(() {});
                                      });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.thumb_up,
                                        color: widget.snap['likes']
                                                    ?.contains(user?.UID) ??
                                                false
                                            ? Colors.blueAccent
                                            : const Color.fromARGB(
                                                255, 206, 204, 204),
                                        size: 16.0,
                                      ),
                                    ),
                                    Container(width: 6),
                                    Text('${widget.snap['likeCount']}',
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
                                                widget.snap['replyId'],
                                                user?.UID ?? '',
                                                widget.snap['likes'],
                                                widget.snap['dislikes'],
                                                widget.snap['likeCount'],
                                                widget.snap['dislikeCount'],
                                                'reply',
                                                parentMessageId: widget
                                                    .snap['parentCommentId'],
                                              )
                                            : await FirestoreMethods().dislike(
                                                widget.snap['commentId'],
                                                user?.UID ?? '',
                                                widget.snap['likes'],
                                                widget.snap['dislikes'],
                                                widget.snap['likeCount'],
                                                widget.snap['dislikeCount'],
                                                'comment');
                                        setState(() {});
                                      });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.thumb_down,
                                        size: 16,
                                        color: widget.snap['dislikes']
                                                    ?.contains(user?.UID) ??
                                                false
                                            ? Colors.blueAccent
                                            : const Color.fromARGB(
                                                255, 206, 204, 204),
                                      ),
                                    ),
                                    Container(width: 6),
                                    Text('${widget.snap['dislikeCount']}',
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
                        visible: !_replyingOnComment,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            splashColor: Colors.blue.withOpacity(0.5),
                            onTap: () async {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                performLoggedUserAction(
                                    context: context,
                                    action: () async {
                                      await _startReplying(
                                        to: widget.snap['username'],
                                        commentId: widget.isReply
                                            ? widget.parentReplyId
                                            : widget.snap['commentId'],
                                        replyFocusNode: widget.isReply
                                            ? currentReplyFocusNode
                                            : currentReplyFocusNode,
                                        replyTextController: widget.isReply
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
                                      color: Colors.blueAccent, size: 14),
                                  SizedBox(width: 4),
                                  Text("REPLY",
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
                        .collection('replies')
                        .where('parentMessageId', isEqualTo: widget.pollId)
                        .where('parentCommentId',
                            isEqualTo: widget.snap['commentId'])
                        .where('reportRemoved', isEqualTo: false)
                        .orderBy('datePublished', descending: false)
                        .snapshots(),
                    builder: (content, snapshot) {
                      int repliesCount =
                          (snapshot.data as dynamic)?.docs.length ?? 0;
                      return repliesCount > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(25),
                                        splashColor:
                                            Colors.blue.withOpacity(0.5),
                                        onTap: () async {
                                          Future.delayed(
                                              const Duration(milliseconds: 50),
                                              () {
                                            _showCommentReplies =
                                                !_showCommentReplies;
                                            _stopReplying();
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _showCommentReplies
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down,
                                                size: 18,
                                                color: Colors.blueAccent,
                                              ),
                                              Container(width: 2),
                                              Text(
                                                  // "Replies (${widget.snap['replyCount']})",
                                                  _showCommentReplies
                                                      ? "Hide Replies"
                                                      : "Show Replies",
                                                  style: const TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 13,
                                                    letterSpacing: 0.5,
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
                          : Container();
                    },
                  ),
                ),
                Visibility(
                  visible: !_showCommentReplies,
                  child: _replyTextField(),
                ),
                Visibility(
                  visible: _showCommentReplies,
                  child: Consumer<CommentReplyProvider>(
                    builder: (context, commentReplyProvider, child) {
                      CommentsAndReplies? commentAndReplies;
                      for (var index = 0;
                          index <
                              commentReplyProvider
                                  .postPollCommentAndReplyList.length;
                          index++) {
                        Comment comment = commentReplyProvider
                            .postPollCommentAndReplyList[index].comment;
                        if (comment.commentId == widget.snap['commentId']) {
                          commentAndReplies = commentReplyProvider
                              .postPollCommentAndReplyList[index];
                          // print(
                          //     "Debugging Element ::: ${commentReplyProvider.postPollCommentAndReplyList[index]?.replyList}");
                        }
                      }

                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ReplyList(
                            replyList: commentAndReplies?.replyList ?? [],
                            parentPost: widget.parentPost,
                            parentCommentId: widget.snap['commentId'],
                            pollId: widget.pollId,
                            parentSetState: widget.parentSetState,
                            replyId: widget.commentsReplies?.reply?.replyId,
                            scrollKey: widget.scrollKey,
                            durationInDay: widget.durationInDay,
                          ),
                          Visibility(
                            visible: !(commentReplyProvider
                                            .canPostPollRepliesLoadMoreMap[
                                        widget.snap['commentId']] ??
                                    true) &&
                                !(commentReplyProvider
                                            .canPostPollRepliesPaginationLoadingMap[
                                        widget.snap['commentId']] ??
                                    true),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 12, left: 12),
                              child: PhysicalModel(
                                color: testing,
                                elevation: 2,
                                borderRadius: BorderRadius.circular(25),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    splashColor: whiteDialog,
                                    onTap: () {
                                      commentReplyProvider
                                          .getPollOrPostReplyList(
                                        postId: widget.pollId,
                                        commentId:
                                            widget.snap['commentId'] ?? "",
                                        isNext: true,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'View More Replies',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileAllUser(
                                                            uid:
                                                                user?.UID ?? '',
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
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileAllUser(
                                                            uid:
                                                                user?.UID ?? '',
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
                                    _userProfile?.profileFlag == true
                                        ? SizedBox(
                                            width: 20,
                                            height: 10,
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
                                    pollReply(
                                      widget.pollId,
                                      widget.isReply
                                          ? widget.parentCommentId
                                          : widget.snap['commentId'],
                                      _replyController.text,
                                      user?.UID ?? '',
                                      user?.username ?? '',
                                    );
                                    setState(() {
                                      _replyController.text = "";
                                      // print(widget.snap['commentId']);
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
  final Poll? parentPost;
  final String? parentCommentId;
  final pollId;
  final pollUId;
  final Function parentSetState;
  var durationInDay;

  GlobalKey? scrollKey;
  final String? replyId;

  ReplyList({
    Key? key,
    required this.replyList,
    this.parentPost,
    this.parentCommentId,
    this.pollId,
    this.pollUId,
    required this.durationInDay,
    required this.parentSetState,
    this.scrollKey,
    this.replyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(replyList.length, (index) {
            Reply reply = replyList[index];
            // debugPrint("");
            // debugPrint("===============================");
            // debugPrint("replySnap ${reply.toJson()}");
            // debugPrint("reply $replyId");
            // debugPrint(
            //     "================  replySnap['replyId'] == replyId ${reply.replyId == replyId}");

            bool useScrollKey = reply.replyId == replyId;

            if (index == replyList.length - 1) {
              _scrollToTop();
            }

            return CommentCardPoll(
              key: Key(reply.replyId),
              isReply: true,
              index: index,
              parentCommentId: parentCommentId,
              parentReplyId: reply.replyId,
              snap: reply.toJson(),
              pollId: pollId,
              pollUId: pollUId,
              option1: parentPost?.bOption1,
              option2: parentPost?.bOption2,
              option3: parentPost?.bOption3,
              option4: parentPost?.bOption4,
              option5: parentPost?.bOption5,
              option6: parentPost?.bOption6,
              option7: parentPost?.bOption7,
              option8: parentPost?.bOption8,
              option9: parentPost?.bOption9,
              option10: parentPost?.bOption10,
              vote1: parentPost?.vote1.contains(reply.UID),
              vote2: parentPost?.vote2.contains(reply.UID),
              vote3: parentPost?.vote3.contains(reply.UID),
              vote4: parentPost?.vote4.contains(reply.UID),
              vote5: parentPost?.vote5.contains(reply.UID),
              vote6: parentPost?.vote6.contains(reply.UID),
              vote7: parentPost?.vote7.contains(reply.UID),
              vote8: parentPost?.vote8.contains(reply.UID),
              vote9: parentPost?.vote9.contains(reply.UID),
              vote10: parentPost?.vote10.contains(reply.UID),
              parentSetState: parentSetState,
              scrollKey: scrollKey,
              useScrollKey: useScrollKey,
              durationInDay: durationInDay,
            );
          })
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
