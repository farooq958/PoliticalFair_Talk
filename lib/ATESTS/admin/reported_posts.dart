import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../methods/auth_methods.dart';
import '../screens/full_image_profile.dart';
import '../screens/full_image_screen.dart';
import '../utils/utils.dart';
import 'package:video_player/video_player.dart';

class ReportPosts extends StatefulWidget {
  final Post post;

  const ReportPosts({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<ReportPosts> createState() => _ReportPostsState();
}

class _ReportPostsState extends State<ReportPosts> {
  final AuthMethods _authMethods = AuthMethods();
  bool message = true;
  User? _userProfile;
  late Post _post;
  late YoutubePlayerController controller;
  VideoPlayerController? videoController;
  var chewieController;
  var snap;

  @override
  void initState() {
    super.initState();

    _post = widget.post;

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
  }

  getAllUserDetails() async {
    User userProfile = await _authMethods.getUserProfileDetails(_post.UID);
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    _post = widget.post;

    const player = YoutubePlayerIFrame(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(_post.postId)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          snap = snapshot.data != null ? Post.fromSnap(snapshot.data!) : snap;
          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          }
          return snap.reportChecked == true || snap.reportRemoved == true
              ? Row()
              : YoutubePlayerControllerProvider(
                  controller: controller,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: const Color.fromARGB(255, 204, 204, 204)),
                        color: Colors.white,
                      ),
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
                                        ? InkWell(
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 150),
                                                () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FullImageProfile(
                                                                photo: _userProfile
                                                                    ?.photoUrl)),
                                                  );
                                                },
                                              );
                                            },
                                            child: Material(
                                              color: Colors.grey,
                                              shape: const CircleBorder(),
                                              clipBehavior: Clip.hardEdge,
                                              child: Ink.image(
                                                image: NetworkImage(
                                                    _userProfile?.photoUrl ??
                                                        ''),
                                                fit: BoxFit.cover,
                                                width: 40,
                                                height: 40,
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
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(width: 10),
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
                                Expanded(
                                  child: Container(
                                    height: 30,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 219, 219, 219),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Report Counter',
                                          style: TextStyle(fontSize: 13)),
                                      Text('${_post.reportCounter}',
                                          style: const TextStyle(fontSize: 13))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  top: 4,
                                                  bottom: 8),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    24,
                                                child: Text(
                                                  '${_post.aTitle} ',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                                        height:
                                                            MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    2 -
                                                                2,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            2,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 245, 245, 245),
                                                        child: Stack(
                                                          children: [
                                                            Center(
                                                              child:
                                                                  CachedNetworkImage(
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(),
                                                                imageUrl: _post
                                                                    .aPostUrl,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  )
                                                : _post.aVideoUrl != ""
                                                    ? LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          return SizedBox(
                                                            width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >
                                                                    600
                                                                ? 500
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    1,
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
                                                                            ? CrossFadeState.showSecond
                                                                            : CrossFadeState.showFirst,
                                                                        duration:
                                                                            const Duration(milliseconds: 300),
                                                                        secondChild:
                                                                            const SizedBox(),
                                                                        firstChild:
                                                                            Material(
                                                                                child: Stack(
                                                                          children: [
                                                                            const Center(child: CircularProgressIndicator()),
                                                                            FadeInImage.memoryNetwork(
                                                                                // width: MediaQuery.of(context).size.width * 0.89,
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
                                            _post.aBody == ""
                                                ? Row()
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            bottom: 8,
                                                            right: 12,
                                                            left: 12),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            2,
                                                    child: Text(
                                                        '${_post.aBody} ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        removeProfPicDialog(
                                                          context: context,
                                                          uid: _post.UID,
                                                        );
                                                      },
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: const Icon(
                                                          Icons.person,
                                                          color: Color.fromARGB(
                                                              255, 236, 50, 37),
                                                          size: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        keepReportDialog(
                                                          context: context,
                                                          post: _post.postId,
                                                          type: 'message',
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              204, 204, 204),
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        width: 120,
                                                        child: const Center(
                                                          child: Text(
                                                            'KEEP',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        removeReportDialog(
                                                          context: context,
                                                          post: _post.postId,
                                                          uid: _post.UID,
                                                          type: 'message',
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              255, 133, 124),
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        width: 120,
                                                        child: const Center(
                                                          child: Text(
                                                            'REMOVE',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                  ),
                );
        });
  }
}
