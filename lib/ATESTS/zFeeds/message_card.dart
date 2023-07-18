import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import '../../main.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../provider/post_provider.dart';
import '../provider/user_provider.dart';
import '../methods/auth_methods.dart';
import '../methods/firestore_methods.dart';
import '../screens/full_image_screen.dart';
import '../screens/full_message.dart';
import '../screens/profile_all_user.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../utils/like_animation.dart';
import 'package:video_player/video_player.dart';
import '../responsive/my_flutter_app_icons.dart';

class PostCardTest extends StatefulWidget {
  final Post post;
  final profileScreen;
  final archives;

  var durationInDay;

  PostCardTest({
    Key? key,
    required this.post,
    required this.profileScreen,
    required this.archives,
    required this.durationInDay,
  }) : super(key: key);

  @override
  State<PostCardTest> createState() => _PostCardTestState();
}

class _PostCardTestState extends State<PostCardTest> {
  final AuthMethods _authMethods = AuthMethods();
  User? _userProfile;
  late Post _post;
  bool _isPostEnded = false;
  late YoutubePlayerController controller;
  VideoPlayerController? videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool isLikeAnimating = false;
  bool tileClick = false;
  var key = GlobalKey();
  var chewieController;
  bool initialized = false;
  bool isSwapped = false;
  bool profileScreen = false;
  var snap;
  var testNumber = 24100;
  int fillContainerWidth = 85;
  bool isAdditionalTextTrue = false;

  bool _voteLoading = false;

  @override
  void initState() {
    super.initState();

    _post = widget.post;
    // plusCounter = widget.post.plusCount;

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
    // if (_post.selected == 2) {
    //   videoController = VideoPlayerController.network(_post.aPostUrl);
    //   _initializeVideoPlayerFuture = videoController!.initialize().then((_) {
    //     setState(() {});
    //   });
    //   chewieController = ChewieController(
    //     videoPlayerController: videoController!,
    //     autoPlay: false,
    //     looping: false,
    //   );
    // }

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

    // getComments();
  }

  void deleteMessage(Post post, User user) async {
    try {
      String res = await FirestoreMethods().deletePost(post, 'message', user);
      if (res == "success") {
        var provider = Provider.of<PostProvider>(navigatorKey.currentContext!,
            listen: false);
        provider.deleteUserPost(post.postId);
        if (!mounted) return;
        showSnackBar('Message successfully deleted.', context);
      } else {}
    } catch (e) {
      //
    }
  }

  getAllUserDetails() async {
    User userProfile = await _authMethods.getUserProfileDetails(_post.UID);
    if (!mounted) return;
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // final postProvider = Provider.of<PostProvider>(context, listen: false);
    _post = widget.post;
    // int endTime = widget.post.endDate.toDate().millisecondsSinceEpoch;
    //  debugPrint('end time is ${widget.post.endDate.toDate()}');

    const player = YoutubePlayerIFrame(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );
    final User? user = Provider.of<UserProvider>(context).getUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.UID)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          /// Condition for checking both snapshot is not null and neither its data
          snap = snapshot.data != null && snapshot.data!.data() != null
              ? User.fromMap(snapshot.data!.data()!)
              : snap;
          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          } else if (user == null) {
            return buildMessageCard(context);
          } else {
            return !snap.blockList.contains(_post.UID)
                ? buildMessageCard(context)
                : Row();
          }
        });
  }

  Widget buildMessageCard(BuildContext context) {
    // final postProvider = Provider.of<PostProvider>(context, listen: false);
    _post = widget.post;
    // int endTime = widget.post.endDate.toDate().millisecondsSinceEpoch;
    //  debugPrint('end time is ${widget.post.endDate.toDate()}');

    const player = YoutubePlayerIFrame(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );
    final User? user = Provider.of<UserProvider>(context).getUser;

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
          ? showSnackBarAction(
              "Votes from unverified accounts don't count!",
              pending,
              context,
            )
          : null;
      // showSnackBar('+1', context);
    }

    // void verifiedPlusVote() async {
    //   await FirestoreMethods().plusMessage(
    //     _post.postId,
    //     user?.UID ?? '',
    //     _post.plus,
    //     _post.neutral,
    //     _post.minus,
    //     _post,
    //     _post.global,
    //     _post.country,
    //   );
    //   user?.maxDailyTime != widget.durationInDay
    //       ? await FirestoreMethods()
    //           .changeMaxDailyTime(user?.UID ?? '', widget.durationInDay)
    //       : null;
    //   user?.maxDailyTime != widget.durationInDay
    //       ? await FirestoreMethods().resetTokensCounter(user?.UID ?? '')
    //       : null;
    //   user?.maxDailyTime == widget.durationInDay &&
    //           user?.tokensCounter.clamp(1, 9) == user?.tokensCounter
    //       ? await FirestoreMethods().incrementTokensCounter(user?.UID ?? '')
    //       : null;
    // }

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
          ? showSnackBarAction(
              "Votes from unverified accounts don't count!",
              pending,
              context,
            )
          : null;
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
          ? showSnackBarAction(
              "Votes from unverified accounts don't count!",
              pending,
              context,
            )
          : null;
    }

    return YoutubePlayerControllerProvider(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 6,
        ),
        child: PhysicalModel(
          color: tileClick ? testing : whiteDialog,
          elevation: 2,
          child: Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: const Color.fromARGB(255, 245, 245, 245)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    tileClick = true;
                  });

                  Future.delayed(const Duration(milliseconds: 50), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullMessage(
                          post: _post,
                          postId: _post.postId,
                        ),
                      ),
                    );
                    setState(() {
                      tileClick = false;
                    });
                  });
                },
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Stack(
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
                                                widget.profileScreen
                                                    ? null
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileAllUser(
                                                            uid: _post.UID,
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
                                                widget.profileScreen
                                                    ? null
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileAllUser(
                                                                  uid:
                                                                      _post.UID,
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
                                                package: 'country_icons'),
                                          )
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
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userProfile?.username ?? '',
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat.yMMMd().format(
                                  _post.datePublishedNTP.toDate(),
                                ),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              height: 30,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                splashColor: Colors.grey.withOpacity(0.5),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 50), () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            children: [
                                              widget.profileScreen &&
                                                      _post.UID == user?.UID
                                                  ? SimpleDialogOption(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.delete),
                                                          Container(width: 10),
                                                          const Text(
                                                              'Delete Message',
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
                                                              deleteConfirmation(
                                                                  context:
                                                                      context,
                                                                  phrase:
                                                                      'Deleting this message is permanent and this action cannot be undone.',
                                                                  type:
                                                                      'Delete Message',
                                                                  action:
                                                                      () async {
                                                                    if (user !=
                                                                        null) {
                                                                      deleteMessage(
                                                                          _post,
                                                                          user!);

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      // showSnackBar(
                                                                      //     'Message successfully deleted.',
                                                                      //     context);
                                                                    }
                                                                  });
                                                            },
                                                          );
                                                        });
                                                      },
                                                    )
                                                  : Row(),
                                              _post.UID == user?.UID
                                                  ? Row()
                                                  : SimpleDialogOption(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.block),
                                                          Container(width: 10),
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
                                                              // !snap.blockList.contains(_post.UID)
                                                              //     ?
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
                                                                      .doc(_post
                                                                          .UID);
                                                                  var blockUserInfo = await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(_post
                                                                          .UID)
                                                                      .get();
                                                                  if (blockUserInfo
                                                                      .exists) {
                                                                    final batch =
                                                                        FirebaseFirestore
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
                                                                            _post.UID
                                                                          ])
                                                                        });
                                                                    batch.set(
                                                                      blockListRef,
                                                                      blockingUserData,
                                                                    );

                                                                    batch
                                                                        .commit();
                                                                  }
                                                                  if (!mounted) {
                                                                    return;
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
                                                                isSearch: false,
                                                              );
                                                              // : showSnackBar('User already blocked.', context);
                                                            },
                                                          );
                                                        });
                                                      },
                                                    ),
                                              _post.UID == user?.UID
                                                  ? Row()
                                                  : SimpleDialogOption(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons
                                                              .report_outlined),
                                                          Container(width: 10),
                                                          const Text(
                                                              'Report Message',
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
                                                                  150),
                                                          () {
                                                            performLoggedUserAction(
                                                                context:
                                                                    context,
                                                                action: () {
                                                                  // Future.delayed(
                                                                  //     const Duration(
                                                                  //         milliseconds:
                                                                  //             150),
                                                                  //     () {
                                                                  reportDialog(
                                                                    context:
                                                                        context,
                                                                    type:
                                                                        'message',
                                                                    typeCapital:
                                                                        'Message',
                                                                    user: false,
                                                                    action:
                                                                        () async {
                                                                      await FirestoreMethods().reportCounter(
                                                                          _post
                                                                              .postId,
                                                                          _post
                                                                              .reportChecked,
                                                                          'message');
                                                                      if (!mounted) {
                                                                        return;
                                                                      }
                                                                      showSnackBar(
                                                                          'Message successfully reported.',
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  );
                                                                  // });
                                                                });
                                                          },
                                                        );
                                                      },
                                                    ),
                                              _post.time == 1 &&
                                                      _post.UID != user?.UID
                                                  ? const SizedBox()
                                                  : SimpleDialogOption(
                                                      onPressed: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    150), () {
                                                          _post.time == 1 &&
                                                                  _post.UID ==
                                                                      user?.UID
                                                              ? null
                                                              : keywordsDialog(
                                                                  context:
                                                                      context);
                                                        });
                                                      },
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              _post.time == 1 &&
                                                                      _post.UID ==
                                                                          user?.UID
                                                                  ? SizedBox()
                                                                  : const SizedBox(
                                                                      width: 25,
                                                                      child: Icon(
                                                                          Icons
                                                                              .key,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                              Container(
                                                                  width: 10),
                                                              _post.time == 1 &&
                                                                      _post.UID ==
                                                                          user
                                                                              ?.UID
                                                                  ? const Text(
                                                                      'Nothing to see here.',
                                                                      style: TextStyle(
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    )
                                                                  : _post.tagsLowerCase
                                                                              ?.length ==
                                                                          0
                                                                      ? const Text(
                                                                          'No keywords used.',
                                                                          style: TextStyle(
                                                                              letterSpacing: 0.2,
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        )
                                                                      : const Text(
                                                                          'Keywords:',
                                                                          style: TextStyle(
                                                                              letterSpacing: 0.2,
                                                                              fontSize: 15),
                                                                        ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              _post.tagsLowerCase?.length == 1 ||
                                                                      _post.tagsLowerCase
                                                                              ?.length ==
                                                                          2 ||
                                                                      _post.tagsLowerCase
                                                                              ?.length ==
                                                                          3
                                                                  ? Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                            width:
                                                                                35),
                                                                        const Text(
                                                                          '•',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              6,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            '${_post.tagsLowerCase?[0]}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(),
                                                              _post.tagsLowerCase
                                                                              ?.length ==
                                                                          2 ||
                                                                      _post.tagsLowerCase
                                                                              ?.length ==
                                                                          3
                                                                  ? Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                            width:
                                                                                35),
                                                                        const Text(
                                                                          '•',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              6,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            '${_post.tagsLowerCase?[1]}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(),
                                                              _post.tagsLowerCase
                                                                          ?.length ==
                                                                      3
                                                                  ? Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                            width:
                                                                                35),
                                                                        const Text(
                                                                          '•',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              6,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            '${_post.tagsLowerCase?[2]}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(letterSpacing: 0.2, fontSize: 15),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          );
                                        });
                                  });
                                },
                                child: const Icon(Icons.more_vert),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 4,
                            bottom: isAdditionalTextTrue == false &&
                                        _post.aBody != "" &&
                                        _post.aVideoUrl != "" ||
                                    isAdditionalTextTrue == false &&
                                        _post.aBody != "" &&
                                        _post.aPostUrl != ""
                                ? 8
                                : isAdditionalTextTrue == false &&
                                        _post.aBody != ""
                                    ? 4
                                    : 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 14,
                                          left: 14,
                                          top: 4,
                                          bottom: _post.aVideoUrl != "" &&
                                                  _post.aBody != ""
                                              ? 0
                                              : _post.aPostUrl != "" &&
                                                      _post.aBody != ""
                                                  ? 0
                                                  : _post.aVideoUrl != "" ||
                                                          _post.aPostUrl != ""
                                                      ? 8
                                                      : 0),
                                      child: Text(
                                        '${_post.aTitle} ',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(height: 3),
                                    _post.aBody != ""
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    splashColor: Colors.blue
                                                        .withOpacity(0.3),
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
                                                          horizontal: 12),
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
                                                                    Colors.blue,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14.0),
                                            child: Text(
                                              '${_post.aBody}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),

                                    SizedBox(
                                        height: isAdditionalTextTrue &&
                                                    _post.aPostUrl != "" ||
                                                isAdditionalTextTrue &&
                                                    _post.aVideoUrl != ""
                                            ? 8
                                            : 0),

                                    // _post.selected == 1
                                    //     ?
                                    _post.aPostUrl != ""
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: PhysicalModel(
                                              elevation: 2,
                                              color: const Color.fromARGB(
                                                  255, 245, 245, 245),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: InkWell(
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
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            2,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              245,
                                                              245,
                                                              245,
                                                              245),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      // border: Border.all(
                                                      //     width: 0,
                                                      //     color: Colors.grey),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child:
                                                              CachedNetworkImage(
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Center(
                                                              child: Container(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      darkBlue,
                                                                ),
                                                                height: 25,
                                                                width: 25,
                                                              ),
                                                            ),
                                                            imageUrl:
                                                                _post.aPostUrl,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          )
                                        // : _post.selected == 2
                                        //     ? FutureBuilder(
                                        //         future:
                                        //             _initializeVideoPlayerFuture,
                                        //         builder: (context, snapshot) {
                                        //           if (snapshot
                                        //                   .connectionState ==
                                        //               ConnectionState.done) {
                                        //             return LayoutBuilder(
                                        //                 builder: (context,
                                        //                     constraints) {
                                        //               if (kIsWeb &&
                                        //                   constraints
                                        //                           .maxWidth >
                                        //                       800) {
                                        //                 return Row(
                                        //                   crossAxisAlignment:
                                        //                       CrossAxisAlignment
                                        //                           .start,
                                        //                   children: const [
                                        //                     Expanded(
                                        //                         child:
                                        //                             player),
                                        //                     SizedBox(
                                        //                       width: 500,
                                        //                     ),
                                        //                   ],
                                        //                 );
                                        //               }
                                        //               return SizedBox(
                                        //                 width: MediaQuery.of(
                                        //                                 context)
                                        //                             .size
                                        //                             .width >
                                        //                         600
                                        //                     ? 500
                                        //                     : MediaQuery.of(
                                        //                                 context)
                                        //                             .size
                                        //                             .width -
                                        //                         42,
                                        //                 child: Stack(
                                        //                   children: [
                                        //                     player,
                                        //                     Positioned.fill(
                                        //                         child: Chewie(
                                        //                       controller:
                                        //                           chewieController,
                                        //                     )),
                                        //                   ],
                                        //                 ),
                                        //               );
                                        //             });
                                        //           } else {
                                        //             return const Center(
                                        //                 child:
                                        //                     CircularProgressIndicator());
                                        //           }
                                        //         },
                                        //       )
                                        // : _post.selected == 3
                                        //     ?
                                        : _post.aVideoUrl != ""
                                            ? LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  // if (kIsWeb &&
                                                  //     constraints.maxWidth >
                                                  //         800) {
                                                  //   return Row(
                                                  //     crossAxisAlignment:
                                                  //         CrossAxisAlignment
                                                  //             .start,
                                                  //     children: const [
                                                  //       Expanded(
                                                  //           child: player),
                                                  //       SizedBox(
                                                  //         width: 500,
                                                  //       ),
                                                  //     ],
                                                  //   );
                                                  // }
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: SizedBox(
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
                                                            Positioned.fill(
                                                              child:
                                                                  YoutubeValueBuilder(
                                                                controller:
                                                                    controller,
                                                                builder:
                                                                    (context,
                                                                        value) {
                                                                  return AnimatedCrossFade(
                                                                    crossFadeState: value.isReady
                                                                        ? CrossFadeState
                                                                            .showSecond
                                                                        : CrossFadeState
                                                                            .showFirst,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    secondChild:
                                                                        const SizedBox(),
                                                                    firstChild:
                                                                        Material(
                                                                            color:
                                                                                Colors.black,
                                                                            child: Stack(
                                                                              children: [
                                                                                Center(
                                                                                  child: Container(
                                                                                    child: CircularProgressIndicator(
                                                                                      color: whiteDialog,
                                                                                    ),
                                                                                    height: 25,
                                                                                    width: 25,
                                                                                  ),
                                                                                ),
                                                                                // FadeInImage.memoryNetwork(
                                                                                //     width: MediaQuery.of(context).size.width,
                                                                                //     placeholder: kTransparentImage,
                                                                                //     fadeInDuration: const Duration(milliseconds: 200),
                                                                                //     image: YoutubePlayerController.getThumbnail(
                                                                                //       videoId:
                                                                                //           controller.initialVideoId,
                                                                                //       quality:
                                                                                //           ThumbnailQuality.high,
                                                                                //     )),
                                                                              ],
                                                                            )),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14, left: 14),
                          child: Container(
                            height: 0,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 0, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isSwapped
                              ? Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        // width: 70,
                                        height: 38,
                                        alignment: Alignment.center,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            splashColor:
                                                Colors.grey.withOpacity(0.3),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100), () {
                                                scoreDialogMessage(
                                                    context: context);
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  ' Score ',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                          255, 120, 120, 120),
                                                      letterSpacing: 0.5),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.check_box,
                                                      size: 12,
                                                      color: Color.fromARGB(
                                                          255, 139, 139, 139),
                                                    ),
                                                    Container(width: 4),
                                                    Text(
                                                      '${_post.score}',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              120,
                                                              120,
                                                              120),
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
                                      SizedBox(
                                        // width: 95,
                                        height: 38,
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: InkWell(
                                            splashColor:
                                                Colors.grey.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100), () {
                                                timerDialog(
                                                    context: context,
                                                    type: 'message');
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'Time Left',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Color.fromARGB(
                                                              255,
                                                              120,
                                                              120,
                                                              120),
                                                          letterSpacing: 0.5,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.timer,
                                                      size: 12,
                                                      color: Color.fromARGB(
                                                          255, 139, 139, 139),
                                                    ),
                                                    Container(width: 4),
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
                                                      _post.time == 1
                                                          ? 'Unlimited'
                                                          : widget.durationInDay ==
                                                                  (_post.time)
                                                              ? '7 Days'
                                                              : widget.durationInDay ==
                                                                      (_post.time +
                                                                          1)
                                                                  ? '6 Days'
                                                                  : widget.durationInDay ==
                                                                          (_post.time +
                                                                              2)
                                                                      ? '5 Days'
                                                                      : widget.durationInDay ==
                                                                              (_post.time + 3)
                                                                          ? '4 Days'
                                                                          : widget.durationInDay == (_post.time + 4)
                                                                              ? '3 Days'
                                                                              : widget.durationInDay == (_post.time + 5)
                                                                                  ? '2 Days'
                                                                                  : widget.durationInDay == (_post.time + 6)
                                                                                      ? '1 Day'
                                                                                      : 'None',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              120,
                                                              120,
                                                              120),
                                                          letterSpacing: 0.5,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    // }
                                                    // else if (widget
                                                    //         .durationInDay >
                                                    //     _post.time) {
                                                    //   return ChangeNotifierProvider(
                                                    //     create: (context) =>
                                                    //         TimerProvider(_post
                                                    //             .getEndDate()),
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
                                                    //                 12,
                                                    //             color: Color
                                                    //                 .fromARGB(
                                                    //                     255,
                                                    //                     120,
                                                    //                     120,
                                                    //                     120),
                                                    //             letterSpacing:
                                                    //                 0.5,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w500),
                                                    //       );
                                                    //     }),
                                                    //   );
                                                    // } else {
                                                    //   return const Text("");
                                                    // }
                                                    // }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        // width: 70,
                                        height: 38,
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: InkWell(
                                            splashColor:
                                                Colors.grey.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 50), () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullMessage(
                                                      post: _post,
                                                      postId: _post.postId,
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Comments',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Color.fromARGB(
                                                          255, 120, 120, 120),
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      MyFlutterApp.comments,
                                                      size: 12,
                                                      color: Color.fromARGB(
                                                          255, 139, 139, 139),
                                                    ),
                                                    Container(width: 6),
                                                    Center(
                                                      child: Text(
                                                        '${_post.commentCount}',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    120,
                                                                    120,
                                                                    120),
                                                            letterSpacing: 0.5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
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
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                fillContainerWidth,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: 70,
                                              child: Column(
                                                children: [
                                                  Stack(
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
                                                                        .center,
                                                                width: (MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        fillContainerWidth) /
                                                                    3,
                                                                child:
                                                                    LikeAnimation(
                                                                  isAnimating: _post
                                                                      .plus
                                                                      .contains(
                                                                          user?.UID),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    shape:
                                                                        const CircleBorder(),
                                                                    clipBehavior:
                                                                        Clip.hardEdge,
                                                                    child:
                                                                        InkWell(
                                                                      splashColor: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
                                                                      onTap:
                                                                          () async {
                                                                        // final leftTimeProvider = Provider.of<LeftTimeProvider>(
                                                                        //     context,
                                                                        //     listen: false);
                                                                        // await leftTimeProvider
                                                                        //     .getDate();

                                                                        // DateTime  now = await widget.post.getEndDate();

                                                                        if ((widget.durationInDay == (_post.time + 0)) ||
                                                                            (widget.durationInDay ==
                                                                                (_post.time + 1)) ||
                                                                            (widget.durationInDay == (_post.time + 2)) ||
                                                                            (widget.durationInDay == (_post.time + 3)) ||
                                                                            (widget.durationInDay == (_post.time + 4)) ||
                                                                            (widget.durationInDay == (_post.time + 5)) ||
                                                                            (widget.durationInDay == (_post.time + 6))) {
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
                                                                              snap?.pending == 'true'
                                                                                  ? unverifiedPlusVote(true)
                                                                                  : snap?.aaCountry == ""
                                                                                      ? unverifiedPlusVote(false)
                                                                                      : user?.admin == true && (_post.time == 0 || _post.time == 1)
                                                                                          ? await FirestoreMethods().messageScore(_post.postId, 'plus', _post)
                                                                                          : _post.time == 1 || _post.time == 0
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
                                                                                              : _isPostEnded
                                                                                                  ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                                  : _post.country != "" && _post.global == "false" && _post.country != snap.aaCountry
                                                                                                      ? showSnackBar("Action failed. Voting nationally is only available for your specific country.", context)
                                                                                                      : widget.archives == true
                                                                                                          ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                                          : user?.admin == true
                                                                                                              ? await FirestoreMethods().messageScore(_post.postId, 'plus', _post)
                                                                                                              : await FirestoreMethods().plusMessage(_post.postId, user?.UID ?? '', _post.plus, _post.neutral, _post.minus, _post, _post.global, _post.country);
                                                                              // FirestoreMethods()
                                                                              //     .scoreMessage(
                                                                              //   _post.postId,
                                                                              //   user?.UID ?? "",
                                                                              //   _post.plusCount -
                                                                              //       _post
                                                                              //           .minusCount,
                                                                              //   _post.UID,
                                                                              // );
                                                                              setState(() {});
                                                                            });
                                                                      },
                                                                      child: _post
                                                                              .plus
                                                                              .contains(user?.UID)
                                                                          ? const SizedBox(
                                                                              height: 45,
                                                                              width: 40,
                                                                              child: Icon(
                                                                                Icons.add_circle,
                                                                                color: Colors.green,
                                                                              ),
                                                                            )
                                                                          : const SizedBox(
                                                                              height: 45,
                                                                              width: 40,
                                                                              child: Icon(
                                                                                Icons.add_circle,
                                                                                color: Color.fromARGB(255, 206, 204, 204),
                                                                              ),
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
                                                                        .center,
                                                                width: (MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        fillContainerWidth) /
                                                                    3,
                                                                child:
                                                                    LikeAnimation(
                                                                  isAnimating: _post
                                                                      .neutral
                                                                      .contains(
                                                                          user?.UID),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    shape:
                                                                        const CircleBorder(),
                                                                    clipBehavior:
                                                                        Clip.hardEdge,
                                                                    child:
                                                                        InkWell(
                                                                      splashColor: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
                                                                      onTap:
                                                                          () async {
                                                                        // final leftTimeProvider = Provider.of<LeftTimeProvider>(
                                                                        //     context,
                                                                        //     listen: false);
                                                                        // await leftTimeProvider
                                                                        //     .getDate();

                                                                        // DateTime  now = await widget.post.getEndDate();

                                                                        if ((widget.durationInDay == (_post.time + 0)) ||
                                                                            (widget.durationInDay ==
                                                                                (_post.time + 1)) ||
                                                                            (widget.durationInDay == (_post.time + 2)) ||
                                                                            (widget.durationInDay == (_post.time + 3)) ||
                                                                            (widget.durationInDay == (_post.time + 4)) ||
                                                                            (widget.durationInDay == (_post.time + 5)) ||
                                                                            (widget.durationInDay == (_post.time + 6))) {
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
                                                                              snap?.pending == 'true'
                                                                                  ? unverifiedNeutralVote(true)
                                                                                  : snap?.aaCountry == ""
                                                                                      ? unverifiedNeutralVote(false)
                                                                                      : user?.admin == true && (_post.time == 0 || _post.time == 1)
                                                                                          ? await FirestoreMethods().messageScore(_post.postId, 'neutral', _post)
                                                                                          : _post.time == 0 || _post.time == 1
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
                                                                                              : _isPostEnded
                                                                                                  ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                                  : _post.country != "" && _post.global == "false" && _post.country != snap.aaCountry
                                                                                                      ? showSnackBar("Action failed. Voting nationally is only available for your specific country.", context)
                                                                                                      : widget.archives == true
                                                                                                          ? showSnackBarError("This message's voting cycle has already ended.", context)
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
                                                                      child: _post
                                                                              .neutral
                                                                              .contains(user?.UID)
                                                                          ? const SizedBox(
                                                                              height: 45,
                                                                              width: 40,
                                                                              child: RotatedBox(
                                                                                quarterTurns: 1,
                                                                                child: Icon(
                                                                                  Icons.pause_circle_filled,
                                                                                  color: Color.fromARGB(255, 111, 111, 111),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox(
                                                                              height: 45,
                                                                              width: 40,
                                                                              child: RotatedBox(
                                                                                quarterTurns: 1,
                                                                                child: Icon(
                                                                                  Icons.pause_circle_filled,
                                                                                  color: Color.fromARGB(255, 206, 204, 204),
                                                                                ),
                                                                              ),
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
                                                                        .center,
                                                                // width: MediaQuery.of(
                                                                //                 context)
                                                                //             .size
                                                                //             .width /
                                                                //         3 -
                                                                //     29,

                                                                width: (MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        fillContainerWidth) /
                                                                    3,

                                                                child:
                                                                    LikeAnimation(
                                                                  isAnimating: _post
                                                                      .minus
                                                                      .contains(
                                                                          user?.UID),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    shape:
                                                                        const CircleBorder(),
                                                                    clipBehavior:
                                                                        Clip.hardEdge,
                                                                    child:
                                                                        InkWell(
                                                                      splashColor: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
                                                                      onTap:
                                                                          () async {
                                                                        // final leftTimeProvider = Provider.of<LeftTimeProvider>(
                                                                        //     context,
                                                                        //     listen: false);
                                                                        // await leftTimeProvider
                                                                        //     .getDate();

                                                                        // DateTime  now = await widget.post.getEndDate();

                                                                        if ((widget.durationInDay == (_post.time + 0)) ||
                                                                            (widget.durationInDay ==
                                                                                (_post.time + 1)) ||
                                                                            (widget.durationInDay == (_post.time + 2)) ||
                                                                            (widget.durationInDay == (_post.time + 3)) ||
                                                                            (widget.durationInDay == (_post.time + 4)) ||
                                                                            (widget.durationInDay == (_post.time + 5)) ||
                                                                            (widget.durationInDay == (_post.time + 6))) {
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
                                                                              snap?.pending == 'true'
                                                                                  ? unverifiedMinusVote(true)
                                                                                  : snap?.aaCountry == ""
                                                                                      ? unverifiedMinusVote(false)
                                                                                      : user?.admin == true && (_post.time == 0 || _post.time == 1)
                                                                                          ? await FirestoreMethods().messageScore(_post.postId, 'minus', _post)
                                                                                          : _post.time == 0 || _post.time == 1
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
                                                                                              : _isPostEnded
                                                                                                  ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                                  : _post.country != "" && _post.global == "false" && _post.country != snap.aaCountry
                                                                                                      ? showSnackBar("Action failed. Voting nationally is only available for your specific country.", context)
                                                                                                      : widget.archives == true
                                                                                                          ? showSnackBarError("This message's voting cycle has already ended.", context)
                                                                                                          : user?.admin == true
                                                                                                              ? await FirestoreMethods().messageScore(_post.postId, 'minus', _post)
                                                                                                              : await FirestoreMethods().minusMessage(_post.postId, user?.UID ?? '', _post.plus, _post.neutral, _post.minus, _post, _post.global, _post.country);

                                                                              setState(() {});
                                                                            });
                                                                      },
                                                                      child: _post
                                                                              .minus
                                                                              .contains(user?.UID)
                                                                          ? const SizedBox(
                                                                              height: 45,
                                                                              width: 40,
                                                                              child: Icon(
                                                                                Icons.do_not_disturb_on,
                                                                                color: Colors.red,
                                                                              ),
                                                                            )
                                                                          : const SizedBox(
                                                                              height: 45,
                                                                              width: 40,
                                                                              child: Icon(
                                                                                Icons.do_not_disturb_on,
                                                                                color: Color.fromARGB(255, 206, 204, 204),
                                                                              ),
                                                                            ),
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

                                                  ////////////////////////////////////////////////////////////////***********////////////////////////////////////////////////////// */
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  fillContainerWidth,
                                              child: InkWell(
                                                onTap: () {
                                                  percentageBarDialog(
                                                    context: context,
                                                    plusCount: _post.plusCount,
                                                    neutralCount:
                                                        _post.neutralCount,
                                                    minusCount:
                                                        _post.minusCount,
                                                    // postEnded: _isPostEnded,
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
                                                          width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  fillContainerWidth) /
                                                              3,
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
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        SizedBox(
                                                          width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  fillContainerWidth) /
                                                              3,
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
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3 -
                                                              29,
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
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3.5),
                                                    Center(
                                                      child: PhysicalModel(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: Colors.white,
                                                        elevation: 2,
                                                        child: Container(
                                                          height: 5,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              fillContainerWidth,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          child: _post.plusCount +
                                                                      _post
                                                                          .minusCount +
                                                                      _post
                                                                          .neutralCount ==
                                                                  0
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(25),
                                                                          bottomLeft:
                                                                              Radius.circular(25),
                                                                        ),
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      width:
                                                                          (MediaQuery.of(context).size.width - fillContainerWidth) /
                                                                              3,
                                                                    ),
                                                                    Container(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          (MediaQuery.of(context).size.width - fillContainerWidth) /
                                                                              3,
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topRight:
                                                                              Radius.circular(25),
                                                                          bottomRight:
                                                                              Radius.circular(25),
                                                                        ),
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      width:
                                                                          (MediaQuery.of(context).size.width - fillContainerWidth) /
                                                                              3,
                                                                    ),
                                                                  ],
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child:
                                                                      SizedBox(
                                                                    width: 20,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.green,
                                                                              borderRadius: BorderRadius.circular(0)),
                                                                          width: _post.plusCount == 0
                                                                              ? 0
                                                                              : (MediaQuery.of(context).size.width - fillContainerWidth) * (_post.plusCount / (_post.plusCount + _post.minusCount + _post.neutralCount)),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                            // alignment:
                                                                            //     Alignment.center,
                                                                            // child: Text(
                                                                            //     (_post.plusCount / (_post.plusCount + _post.minusCount + _post.neutralCount)) <= 0.1
                                                                            //         ? ''
                                                                            //         : _post.plusCount <= 9999
                                                                            //             ? '${_post.plusCount}'
                                                                            //             : _post.plusCount >= 1000000
                                                                            //                 ? '${_post.plusCount.toString().substring(0, 1)}.${_post.plusCount.toString().substring(1, 2)}M'
                                                                            //                 : _post.plusCount >= 100000
                                                                            //                     ? '${_post.plusCount.toString().substring(0, 3)}K'
                                                                            //                     : _post.plusCount >= 10000
                                                                            //                         ? '${_post.plusCount.toString().substring(0, 2)}.${_post.plusCount.toString().substring(2, 3)}K'
                                                                            //                         : '${_post.plusCount.toString().substring(0, 1)}.${_post.plusCount.toString().substring(1, 2)}K',
                                                                            //     style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          color:
                                                                              Colors.grey,
                                                                          width: _post.neutralCount == 0
                                                                              ? 0
                                                                              : (MediaQuery.of(context).size.width - fillContainerWidth) * (_post.neutralCount / (_post.plusCount + _post.minusCount + _post.neutralCount)),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                            // alignment:
                                                                            //     Alignment.center,
                                                                            // child: Text(
                                                                            //     (_post.neutralCount / (_post.plusCount + _post.minusCount + _post.neutralCount)) <= 0.1
                                                                            //         ? ''
                                                                            //         : _post.neutralCount <= 9999
                                                                            //             ? '${_post.neutralCount}'
                                                                            //             : _post.neutralCount >= 1000000
                                                                            //                 ? '${_post.neutralCount.toString().substring(0, 1)}.${_post.neutralCount.toString().substring(1, 2)}M'
                                                                            //                 : _post.neutralCount >= 100000
                                                                            //                     ? '${_post.neutralCount.toString().substring(0, 3)}K'
                                                                            //                     : _post.neutralCount >= 10000
                                                                            //                         ? '${_post.neutralCount.toString().substring(0, 2)}.${_post.neutralCount.toString().substring(2, 3)}K'
                                                                            //                         : '${_post.neutralCount.toString().substring(0, 1)}.${_post.neutralCount.toString().substring(1, 2)}K',
                                                                            //     style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          color:
                                                                              Colors.red,
                                                                          width: _post.minusCount == 0
                                                                              ? 0
                                                                              : (MediaQuery.of(context).size.width - fillContainerWidth) * (_post.minusCount / (_post.plusCount + _post.minusCount + _post.neutralCount)),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                (MediaQuery.of(context).size.width - fillContainerWidth) / 3,
                                                                            // alignment:
                                                                            //     Alignment.center,
                                                                            // child: Text(
                                                                            //     (_post.minusCount / (_post.plusCount + _post.minusCount + _post.neutralCount)) <= 0.1
                                                                            //         ? ''
                                                                            //         : _post.minusCount <= 9999
                                                                            //             ? '${_post.minusCount}'
                                                                            //             : _post.minusCount >= 1000000
                                                                            //                 ? '${_post.minusCount.toString().substring(0, 1)}.${_post.minusCount.toString().substring(1, 2)}M'
                                                                            //                 : _post.minusCount >= 100000
                                                                            //                     ? '${_post.minusCount.toString().substring(0, 3)}K'
                                                                            //                     : _post.minusCount >= 10000
                                                                            //                         ? '${_post.minusCount.toString().substring(0, 2)}.${_post.minusCount.toString().substring(2, 3)}K'
                                                                            //                         : '${_post.minusCount.toString().substring(0, 1)}.${_post.minusCount.toString().substring(1, 2)}K',
                                                                            //     style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                width: 45,
                                alignment: Alignment.centerLeft,
                                child: Material(
                                  color: Colors.transparent,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  child: IconButton(
                                    splashColor: Colors.grey.withOpacity(0.5),
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
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
