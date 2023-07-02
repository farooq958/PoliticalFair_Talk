import 'dart:async';
import 'package:aft/ATESTS/models/CommentsReplies.dart';
import 'package:aft/ATESTS/models/comment.dart';
import 'package:aft/ATESTS/models/reply.dart';
import 'package:aft/ATESTS/provider/comments_replies_provider.dart';
import 'package:aft/ATESTS/provider/postPoll_provider.dart';
import 'package:aft/ATESTS/screens/profile_full_bio.dart';
import 'package:aft/ATESTS/zFeeds/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/filter_provider.dart';
import '../provider/poll_provider.dart';
import '../provider/post_provider.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../zFeeds/message_card.dart';
import '../zFeeds/poll_card.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'full_image_profile.dart';
import 'profile_screen_edit.dart';

class ProfileAllUser extends StatefulWidget {
  ProfileAllUser({
    Key? key,
    required this.uid,
    required this.initialTab,
  }) : super(key: key);
  final String uid;
  final int initialTab;

  @override
  State<ProfileAllUser> createState() => ProfileAllUserState();
}

class ProfileAllUserState extends State<ProfileAllUser>
    with SingleTickerProviderStateMixin {
  bool posts = true;
  bool comment = false;
  bool profileScreen = true;
  bool filter = false;
  int currentTab = 0;
  int commentLen = 0;
  int _selectedIndex = 0;
  final StreamController<int> _commentRepliesIndexController =
      StreamController<int>.broadcast();
  static const Duration animationDuration = Duration(milliseconds: 300);
  User? _userProfile;
  User? _userAdmin;
  User? _userP;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerBio = ScrollController();
  TabController? _tabController;
  var snap;
  late Post _post;
  int screenWidth = 650;

  List<dynamic> postList = [];
  List<dynamic> pollList = [];

  var durationInDay = 0;
  FirebaseDatabase rdb = FirebaseDatabase.instance;

  PostProvider? postProvider;
  PollsProvider? pollsProvider;
  PostPollProvider? postPollProvider;
  CommentReplyProvider? commentReplyProvider;

  double scrollOffset = 0.0;

  List<Widget> list = [
    const Tab(
        child: Icon(
      Icons.message_outlined,
    )),
    const Tab(
        child: RotatedBox(
            quarterTurns: 1,
            child: Icon(
              Icons.poll_outlined,
            ))),
    // Tab(child: Icon(Icons.check_box_outlined)),
    //new tab for comments and replies by the user
    // if (_userAdmin?.UID == _userProfile?.UID)
    const Padding(
        padding: EdgeInsets.only(top: 2),
        child: Tab(child: Icon(MyFlutterApp.comment_discussion, size: 23))),
  ];

  @override
  void initState() {
    super.initState();
    _getStartTime();
    Provider.of<FilterProvider>(context, listen: false)
        .setDurationInDay(durationInDay);
    initScrollControllerListener();
    // loadEditProfileValues();
    // initTabController();
    _tabController = TabController(vsync: this, length: list.length);

    _tabController?.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
    Provider.of<UserProvider>(context, listen: false)
        .refreshAllUser(widget.uid);

    Provider.of<UserProvider>(context, listen: false).refreshUser();

    Future.delayed(Duration.zero, () async {
      postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider?.getUserPosts(widget.uid);
    });
    Future.delayed(Duration.zero, () async {
      pollsProvider = Provider.of<PollsProvider>(context, listen: false);
      pollsProvider?.getUserPolls(widget.uid);
    });
    // Future.delayed(Duration.zero, () async {
    //   postPollProvider = Provider.of<PostPollProvider>(context, listen: false);
    //       postPollProvider?.getPostPollResult(widget.uid);
    // });
    Future.delayed(Duration.zero, () async {
      commentReplyProvider =
          Provider.of<CommentReplyProvider>(context, listen: false);
      commentReplyProvider?.getCommentResult(widget.uid);
      commentReplyProvider?.getReplyResult(widget.uid);
    });
  }

  @override
  void dispose() {
    _commentRepliesIndexController.close();
    super.dispose();
  }

  void initScrollControllerListener() {
    // _scrollController.addListener(() {
    //   scrollOffset = _scrollController.offset;
    //   if (_scrollController.position.maxScrollExtent <=
    //       _scrollController.offset) {
    if (_tabController?.index == 0) {
      if (!(postProvider?.isLastUserPost ?? true) &&
          !(postProvider?.pageLoading ?? true)) {
        postProvider?.getNextUserPosts(widget.uid);
      }
    } else if (_tabController?.index == 1) {
      if (!(pollsProvider?.userPollsLast ?? true) &&
          !(pollsProvider?.scrollLoading ?? true)) {
        pollsProvider?.getNextUserPolls(widget.uid);
      }
    }
    // else if (_tabController?.index == 3) {
    //   if (!(postPollProvider?.pollLastCheck && postPollProvider?.postLastCheck) &&
    //       !postPollProvider?.pageScrollLoading) {
    //     postPollProvider?.getUserNextPostPollPageLoading(widget.uid);
    //   }
    // }
    // else if (_tabController?.index == 2) {
    //   if (!(commentReplyProvider?.commentLastCheck &&
    //           commentReplyProvider?.replyLastCheck) &&
    //       !commentReplyProvider?.pageScrollLoading) {
    //     debugPrint("=========== Inside If");
    //     commentReplyProvider?.getCommentReplyResult(widget.uid,
    //         getNextPage: true);
    //   }
    // }
    // }
    // });
  }

  get getTabBar {
    return TabBar(
      onTap: (index) {
        setState(() {
          currentTab = index;
        });
      },
      // isScrollable: true,
      // _userAdmin?.UID == _userProfile?.UID,
      tabs: list,
      // const [],
      indicatorColor: Colors.black,
      indicatorWeight: 4,
      labelColor: Colors.black,
      controller: _tabController,
    );
  }

  @override
  Widget build(BuildContext context) {
    _userAdmin = Provider.of<UserProvider>(context).getUser;
    _userProfile = Provider.of<UserProvider>(context).getAllUser;
    String data = _userAdmin?.UID ?? "";
    String userProfiledata = _userProfile?.UID ?? "";
    User? user =
        userProfiledata == data ? _userAdmin ?? _userP : _userProfile ?? _userP;
    // return buildProfileScreen(context);
    return _userAdmin == null
        ? buildProfileScreen(context)
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_userAdmin?.UID)
                .snapshots(),
            builder: (content,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              snap =
                  snapshot.data != null ? User.fromSnap(snapshot.data!) : snap;
              if (!snapshot.hasData || snapshot.data == null) {
                return Row();
              }
              return buildProfileScreen(context);
            });
  }

  Widget buildProfileScreen(BuildContext context) {
    _userAdmin = Provider.of<UserProvider>(context).getUser;
    _userProfile = Provider.of<UserProvider>(context).getAllUser;
    String data = _userAdmin?.UID ?? "";
    String userProfiledata = _userProfile?.UID ?? "";
    User? user =
        userProfiledata == data ? _userAdmin ?? _userP : _userProfile ?? _userP;

    // double halfScreenHeight = MediaQuery.of(context).size.height * 0.4;

    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTab,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: testing,
                // backgroundColor: Colors.black.withOpacity(0.05),
                body: CustomScrollView(
                  // physics: const ClampingScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: whiteDialog,
                      expandedHeight: 200,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Material(
                                          shape: const CircleBorder(),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            splashColor:
                                                Colors.grey.withOpacity(0.5),
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 50),
                                                () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                            child: const Icon(Icons.arrow_back,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      user?.username ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                        color: Colors.black,
                                      ),
                                    ),
                                    _userAdmin?.UID == _userProfile?.UID
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Material(
                                                shape: const CircleBorder(),
                                                color: Colors.transparent,
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
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const EditProfile(),
                                                            ));
                                                      },
                                                    );
                                                  },
                                                  child: Icon(
                                                      _userAdmin?.UID ==
                                                              _userProfile?.UID
                                                          ? Icons
                                                              .create_outlined
                                                          : Icons.more_vert,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Material(
                                                shape: const CircleBorder(),
                                                color: Colors.transparent,
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
                                                                                var userRef = FirebaseFirestore.instance.collection("users").doc(_userAdmin?.UID);
                                                                                var blockListRef = FirebaseFirestore.instance.collection("users").doc(_userAdmin?.UID).collection('blockList').doc(_userProfile?.UID);
                                                                                var blockUserInfo = await FirebaseFirestore.instance.collection("users").doc(_userProfile?.UID).get();
                                                                                if (blockUserInfo.exists) {
                                                                                  final batch = FirebaseFirestore.instance.batch();
                                                                                  final blockingUserData = blockUserInfo.data();
                                                                                  blockingUserData?['creatorUID'] = _userAdmin?.UID;
                                                                                  batch.update(userRef, {
                                                                                    'blockList': FieldValue.arrayUnion([
                                                                                      _userProfile?.UID
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
                                                                        const Text(
                                                                            'Report User',
                                                                            style:
                                                                                TextStyle(letterSpacing: 0.2, fontSize: 15)),
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
                                                                                reportDialog(
                                                                                  context: context,
                                                                                  type: 'user',
                                                                                  typeCapital: 'User',
                                                                                  user: true,
                                                                                  action: () {
                                                                                    showSnackBar('User successfully reported.', context);
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                );
                                                                              });
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    );
                                                  },
                                                  child: Icon(
                                                      _userAdmin?.UID ==
                                                              _userProfile?.UID
                                                          ? Icons
                                                              .create_outlined
                                                          : Icons.more_vert,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: SizedBox(
                                        height: 92,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // width: 310,
                                        child: PhysicalModel(
                                          color: testing,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          elevation: 4,
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: InkWell(
                                              splashColor: Colors.black
                                                  .withOpacity(0.25),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileBio(
                                                              bio: user?.bio,
                                                              username: user
                                                                  ?.username),
                                                    ),
                                                  );
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8,
                                                    right: 10,
                                                    left: 10,
                                                    top: 8),
                                                alignment: Alignment.topCenter,
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    user != null &&
                                                            user.bio != ""
                                                        ? user.bio
                                                        : 'Empty Bio',
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 13,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, right: 0, left: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 60.0),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              splashColor:
                                                  Colors.grey.withOpacity(0.5),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 100), () {
                                                  scoreDialogProfile(
                                                      context: context);
                                                });
                                              },
                                              child: Container(
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 6),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          MyFlutterApp.medal,
                                                          color: Color.fromARGB(
                                                              255,
                                                              150,
                                                              150,
                                                              150),
                                                          size: 12,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text('Score',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      150,
                                                                      150,
                                                                      150),
                                                            )),
                                                        // const SizedBox(width: 4),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Container(
                                                      width: 55,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          top: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    _userAdmin?.UID == user?.UID
                                                        ? Text(
                                                            snap?.profileScore ==
                                                                    true
                                                                ? '${_userAdmin?.profileScoreValue}'
                                                                : 'Private',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                        : Text(
                                                            user?.profileScore ==
                                                                    true
                                                                ? '${user?.profileScoreValue}'
                                                                : 'Private',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Stack(
                                          children: [
                                            user?.photoUrl != null
                                                ? Material(
                                                    color: Colors.grey,
                                                    elevation: 4.0,
                                                    shape: const CircleBorder(),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: Ink.image(
                                                      image: NetworkImage(
                                                        '${user?.photoUrl}',
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: 100.0,
                                                      height: 100.0,
                                                      child: InkWell(
                                                        splashColor: Colors
                                                            .black
                                                            .withOpacity(0.5),
                                                        onTap: () {
                                                          Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    150),
                                                            () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        FullImageProfile(
                                                                            photo:
                                                                                user?.photoUrl)),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : Material(
                                                    color: Colors.grey,
                                                    elevation: 4.0,
                                                    shape: const CircleBorder(),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: Ink.image(
                                                      image: const AssetImage(
                                                          'assets/avatarFT.jpg'),
                                                      fit: BoxFit.cover,
                                                      width: 100.0,
                                                      height: 100.0,
                                                      child: InkWell(
                                                        splashColor: Colors
                                                            .black
                                                            .withOpacity(0.5),
                                                        onTap: () {
                                                          Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    150),
                                                            () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        FullImageProfile(
                                                                            photo:
                                                                                user?.photoUrl)),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                            Positioned(
                                              bottom: 0,
                                              right: 11,
                                              child: Row(
                                                children: [
                                                  _userAdmin?.UID !=
                                                              user?.UID &&
                                                          user?.profileFlag ==
                                                              true
                                                      ? SizedBox(
                                                          width: 36,
                                                          height: 18,
                                                          child: Image.asset(
                                                              'icons/flags/png/${user?.aaCountry}.png',
                                                              package:
                                                                  'country_icons'))
                                                      : _userAdmin?.UID ==
                                                                  user?.UID &&
                                                              snap?.profileFlag ==
                                                                  true
                                                          ? SizedBox(
                                                              width: 36,
                                                              height: 18,
                                                              child: Image.asset(
                                                                  'icons/flags/png/${snap?.aaCountry}.png',
                                                                  package:
                                                                      'country_icons'))
                                                          : Row()
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 2,
                                                right: 4,
                                                child: _userAdmin?.UID !=
                                                                user?.UID &&
                                                            user?.profileBadge ==
                                                                true ||
                                                        _userAdmin?.UID ==
                                                                user?.UID &&
                                                            snap?.profileBadge ==
                                                                true
                                                    ? Stack(
                                                        children: const [
                                                          Positioned(
                                                            left: 5,
                                                            bottom: 4,
                                                            child: CircleAvatar(
                                                              radius: 10,
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
                                                                size: 28),
                                                          ),
                                                        ],
                                                      )
                                                    : Row()),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 60.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: testing,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 4),
                                          width: 110,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.perm_contact_calendar,
                                                    color: Color.fromARGB(
                                                        255, 150, 150, 150),
                                                    size: 13,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text('Joined',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                            255, 150, 150, 150),
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Container(
                                                width: 55,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                  user != null
                                                      ? DateFormat.yMMMd()
                                                          .format(
                                                          user.dateCreated
                                                              .toDate(),
                                                        )
                                                      : '',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      elevation: 0,
                      pinned: true,
                      floating: true,
                      bottom: MediaQuery.of(context).size.width > screenWidth
                          ? PreferredSize(
                              preferredSize:
                                  Size(MediaQuery.of(context).size.width, 0),
                              child: const SizedBox(),
                            )
                          : PreferredSize(
                              preferredSize:
                                  Size(MediaQuery.of(context).size.height, 0),
                              child: const SizedBox()),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        PreferredSize(
                          preferredSize: Size(
                            MediaQuery.of(context).size.width,
                            _tabController?.index == 2
                                ? 90.6
                                : getTabBar.preferredSize.height + 3,
                          ),
                          child: Column(children: [
                            Visibility(
                              visible: _tabController?.index == 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  // width: 310,
                                  child: Column(
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        elevation: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: testing,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.only(),
                                          child: StreamBuilder<int>(
                                              initialData: 0,
                                              stream:
                                                  _commentRepliesIndexController
                                                      .stream,
                                              builder: (context, snapshot) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            _commentRepliesIndexController
                                                                .add(0);
                                                          },
                                                          child:
                                                              AnimatedCrossFade(
                                                            duration:
                                                                animationDuration,
                                                            crossFadeState: (snapshot
                                                                        .data ==
                                                                    0)
                                                                ? CrossFadeState
                                                                    .showFirst
                                                                : CrossFadeState
                                                                    .showSecond,
                                                            secondChild:
                                                                animatedTabContainer(
                                                                    label:
                                                                        'Comments',
                                                                    color: Colors
                                                                        .transparent),
                                                            firstChild:
                                                                animatedTabContainer(
                                                              label: 'Comments',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      210,
                                                                      210,
                                                                      210),
                                                            ),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          _commentRepliesIndexController
                                                              .add(1);
                                                        },
                                                        child:
                                                            AnimatedCrossFade(
                                                          duration:
                                                              animationDuration,
                                                          crossFadeState:
                                                              snapshot.data == 1
                                                                  ? CrossFadeState
                                                                      .showFirst
                                                                  : CrossFadeState
                                                                      .showSecond,
                                                          secondChild:
                                                              animatedTabContainer(
                                                                  label:
                                                                      'Replies',
                                                                  color: Colors
                                                                      .transparent),
                                                          firstChild:
                                                              animatedTabContainer(
                                                            label: 'Replies',
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    210,
                                                                    210,
                                                                    210),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            getTabBar,
                          ]),
                        ),
                      ),
                      pinned: true,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                            children: [
                              _tabController?.index == 0
                                  ? _PostTabScreen(
                                      filter: filter,
                                      onLoadMore: initScrollControllerListener,
                                      durationInDay: durationInDay)
                                  : _tabController?.index == 1
                                      ? _PollTabScreen(
                                          filter: filter,
                                          onLoadMore:
                                              initScrollControllerListener,
                                          durationInDay: durationInDay)
                                      : StreamBuilder<int>(
                                          initialData: 0,
                                          stream: _commentRepliesIndexController
                                              .stream,
                                          builder: (context, snapshot) {
                                            return _CommentRepliesTabScreen(
                                              selectedIndex: snapshot.data ?? 0,
                                              filter: filter,
                                              uId: widget.uid,
                                              commentReplyProvider:
                                                  commentReplyProvider,
                                              durationInDay: durationInDay,
                                            );
                                          },
                                        ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // }),
        ),
      ),
    );
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

  Widget animatedTabContainer({required String label, required Color color}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 80, 80, 80))),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final PreferredSizeWidget _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: whiteDialog,
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          _tabBar.preferredSize.height == 90.6 && maxExtent == 0
              ? Container(
                  color: Colors.blue,
                  height: 60,
                )
              : SizedBox(),
          _tabBar,
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _PostTabScreen extends StatelessWidget {
  final bool filter;
  final Function() onLoadMore;
  var durationInDay;

  _PostTabScreen(
      {Key? key,
      required this.filter,
      required this.onLoadMore,
      required this.durationInDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int screenWidth = 650;
    return Consumer<PostProvider>(builder: (context, postProvider, child) {
      if (postProvider.pLoading) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 280,
          child: const Center(child: CircularProgressIndicator()),
        );
      } else {
        if (postProvider.userProfilePost.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 280,
            child: const Center(
              child: Text(
                'No messages yet.',
                style: TextStyle(
                    color: Color.fromARGB(255, 114, 114, 114), fontSize: 18),
              ),
            ),
          );
        } else {
          return Column(
            children: [
              ListView.builder(
                // key: UniqueKey(),
                itemCount: postProvider.userProfilePost.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      PostCardTest(
                          post: postProvider.userProfilePost[index],
                          profileScreen: true,
                          archives: false,
                          durationInDay: durationInDay),
                      Visibility(
                        visible: postProvider.canUserPostLoadMore &&
                            !postProvider.pageLoading &&
                            (postProvider.userProfilePost.length - 1) == index,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PhysicalModel(
                                  color: Colors.white,
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(25),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      splashColor: const Color.fromARGB(
                                          255, 245, 245, 245),
                                      onTap: onLoadMore,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.arrow_downward,
                                                size: 16, color: Colors.black),
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
                          ],
                        ),
                      ),
                      Visibility(
                        visible: postProvider.pageLoading &&
                            (postProvider.userProfilePost.length - 1) == index,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          );
        }
      }
    });
  }
}

class _PollTabScreen extends StatelessWidget {
  final bool filter;
  final Function() onLoadMore;
  final durationInDay;

  _PollTabScreen(
      {Key? key,
      required this.filter,
      required this.onLoadMore,
      required this.durationInDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int screenWidth = 650;
    return Consumer<PollsProvider>(builder: (context, pollsProvider, child) {
      if (pollsProvider.loading) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 280,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (pollsProvider.userPolls.isEmpty) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 280,
          child: const Center(
            child: Text(
              'No polls yet.',
              style: TextStyle(
                  color: Color.fromARGB(255, 114, 114, 114), fontSize: 18),
            ),
          ),
        );
      } else {
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: pollsProvider.userPolls.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    PollCard(
                        poll: pollsProvider.userPolls[index],
                        profileScreen: true,
                        archives: false,
                        durationInDay: durationInDay),
                    Visibility(
                      visible: !pollsProvider.userPollsLast &&
                          !pollsProvider.scrollLoading &&
                          (pollsProvider.userPolls.length - 1) == index,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PhysicalModel(
                                color: Colors.white,
                                elevation: 2,
                                borderRadius: BorderRadius.circular(25),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    splashColor: const Color.fromARGB(
                                        255, 245, 245, 245),
                                    onTap: onLoadMore,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                        ],
                      ),
                    ),
                    Visibility(
                      visible: pollsProvider.scrollLoading &&
                          (pollsProvider.userPolls.length - 1) == index,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      }
    });
  }
}

class _CommentRepliesTabScreen extends StatelessWidget {
  final bool filter;
  final String uId;
  final int selectedIndex;
  final CommentReplyProvider? commentReplyProvider;
  var durationInDay;

  _CommentRepliesTabScreen(
      {Key? key,
      required this.filter,
      required this.uId,
      required this.selectedIndex,
      this.commentReplyProvider,
      required this.durationInDay})
      : super(key: key);

  static const Duration animationDuration = Duration(milliseconds: 300);

  onLoadMore() {
    if (selectedIndex == 0) {
      if (!commentReplyProvider?.commentLastCheck &&
          !commentReplyProvider?.commentPageScrollLoading) {
        commentReplyProvider?.getCommentResult(uId, getNextPage: true);
      }
    } else {
      if (!(commentReplyProvider?.commentLastCheck &&
              commentReplyProvider?.replyLastCheck) &&
          !commentReplyProvider?.replyPageScrollLoading) {
        commentReplyProvider?.getReplyResult(uId, getNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<CommentReplyProvider>(
            builder: (context, commentReplyProvider, child) {
          List<CommentsReplies> commentRepliesList = [];
          Widget commentsListView = Container();
          Widget repliesListView = Container();

          if (selectedIndex == 0) {
            commentRepliesList = commentReplyProvider.userCommentList;
            commentsListView = commentOrReplyListView(
                commentRepliesList: commentRepliesList,
                commentReplyProvider: commentReplyProvider,
                durationInDay: durationInDay);
          } else {
            commentRepliesList = commentReplyProvider.userReplyList;
            repliesListView = commentOrReplyListView(
                commentRepliesList: commentRepliesList,
                commentReplyProvider: commentReplyProvider,
                durationInDay: durationInDay);
          }

          if (commentReplyProvider.pageLoading) {
            int screenWidth = 650;
            return SizedBox(
              height: MediaQuery.of(context).size.height - 315,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (commentRepliesList.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 315,
              child: Center(
                child: Text(
                  (selectedIndex == 0) ? 'No comments yet.' : 'No replies yet.',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 114, 114, 114), fontSize: 18),
                ),
              ),
            );
          } else {
            return AnimatedCrossFade(
              crossFadeState: selectedIndex == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: commentsListView,
              secondChild: repliesListView,
              duration: animationDuration,
            );
          }
        }),
      ],
    );
  }

  Widget animatedTabContainer({required String label, required Color color}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget commentOrReplyListView(
      {required List<CommentsReplies> commentRepliesList,
      required CommentReplyProvider commentReplyProvider,
      required durationInDay}) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: commentRepliesList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            CommentsReplies commentsReply = commentRepliesList[index];
            Key? key;
            String? postId;
            String? postUId;
            Map<String, dynamic>? snap;
            if (CommentReplyType.comment == commentsReply.commentReplyType) {
              Comment? comment = commentsReply.comment;
              key = Key(comment?.commentId ?? "-");
              postId = comment?.commentId;
              postUId = comment?.UID;
              snap = comment?.toJson();
            } else {
              Reply? reply = commentsReply.reply;
              key = Key(reply?.replyId ?? "-");
              postId = reply?.replyId;
              postUId = reply?.UID;
              snap = reply?.toJson();
            }
            return Column(
              children: [
                CommentCard(
                  key: key,
                  postId: postId,
                  postUId: postUId,
                  snap: snap,
                  commentsReplies: commentsReply,
                  isFromProfile: true,
                  isReply:
                      CommentReplyType.reply == commentsReply.commentReplyType,
                  parentSetState: () {
                    // setState(() {});
                  },
                  profileScreen: true,
                  durationInDay: durationInDay,
                ),
                Visibility(
                  visible: (selectedIndex == 0)
                      ? ((!commentReplyProvider.commentLastCheck &&
                              !commentReplyProvider.commentPageScrollLoading) &&
                          (commentRepliesList.length - 1) == index)
                      : ((!commentReplyProvider.replyLastCheck &&
                              !commentReplyProvider.replyPageScrollLoading) &&
                          (commentRepliesList.length - 1) == index),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhysicalModel(
                            color: Colors.white,
                            elevation: 2,
                            borderRadius: BorderRadius.circular(25),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                splashColor:
                                    const Color.fromARGB(255, 245, 245, 245),
                                onTap: onLoadMore,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                    ],
                  ),
                ),
                Visibility(
                  visible: selectedIndex == 0
                      ? commentReplyProvider.commentPageScrollLoading &&
                          (commentRepliesList.length - 1) == index
                      : commentReplyProvider.replyPageScrollLoading &&
                          (commentRepliesList.length - 1) == index,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
