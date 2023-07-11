import 'dart:async';
import 'package:aft/ATESTS/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../info screens/submissions_info.dart';
import '../provider/post_provider.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../zFeeds/message_card.dart';
import '../models/user.dart';
import 'my_drawer_list.dart';
import 'submissions_create.dart';

class Submissions extends StatefulWidget {
  Submissions({
    Key? key,
    // required this.uid,
    this.durationInDay,
    // required this.initialTab,
  }) : super(key: key);
  // final String uid;
  final durationInDay;
  // final int initialTab;

  @override
  State<Submissions> createState() => SubmissionsState();
}

class SubmissionsState extends State<Submissions>
    with SingleTickerProviderStateMixin {
  bool isMostPopular = true;
  bool isMostRecent = false;
  bool isFilter = false;
  bool isLoading = false;
  bool isDetailed = false;
  bool isPoster = true;
  int _selectedIndex = 0;
  int currentTab = 0;
  User? _userProfile;
  User? _userAdmin;
  User? _userP;
  final ScrollController _scrollController = ScrollController();
  final _postScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _logoutLoading = false;
  bool isHowSubWork = false;

  TabController? _tabController;
  var snap;
  int screenWidth = 650;

  List<dynamic> postList = [];
  List<dynamic> pollList = [];

  var durationInDay = 0;

  PostProvider? postProvider;

  List<Widget> list = [
    Tab(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle_outline,
              size: 14,
            ),
            SizedBox(width: 6),
            Text('BALLOTS', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ),
    Tab(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.check_circle,
              size: 14,
            ),
            SizedBox(width: 6),
            Text(
              'WINNING BALLOTS',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _tabController = TabController(vsync: this, length: list.length);

    _tabController?.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
    _getPosts();

    // initScrollControllerListener();
    // Future.delayed(Duration.zero, () async {
    //   postProvider = Provider.of<PostProvider>(context, listen: false);
    //   postProvider?.getSubmissionsScore();
    //   // postProvider?.getSubmissionsDate();
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _postScrollController.dispose();
  }

  // void initScrollControllerListener() {
  //   if (!(postProvider?.isLastUserPostScore ?? true) &&
  //       !(postProvider?.pageLoading ?? true)) {
  //     postProvider?.getSubmissionsScoreNext();
  //   }

  //   // else if (isMostRecent == true) {
  //   //   if (!(postProvider?.isLastUserPost ?? true) &&
  //   //       !(postProvider?.pageLoading ?? true)) {
  //   //     postProvider?.getSubmissionsNext();
  //   //   }
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    _userAdmin = Provider.of<UserProvider>(context).getUser;
    _userProfile = Provider.of<UserProvider>(context).getAllUser;
    String data = _userAdmin?.UID ?? "";
    String userProfiledata = _userProfile?.UID ?? "";
    User? user =
        userProfiledata == data ? _userAdmin ?? _userP : _userProfile ?? _userP;
    // return buildProfileScreen(context);
    return buildProfileScreen(context);
  }

  Widget buildProfileScreen(BuildContext context) {
    _userAdmin = Provider.of<UserProvider>(context).getUser;
    _userProfile = Provider.of<UserProvider>(context).getAllUser;
    String data = _userAdmin?.UID ?? "";
    String userProfiledata = _userProfile?.UID ?? "";
    User? user =
        userProfiledata == data ? _userAdmin ?? _userP : _userProfile ?? _userP;

    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Builder(builder: (BuildContext context) {
            return Stack(
              children: [
                Scaffold(
                  key: _key,
                  backgroundColor: testing,
                  drawer: Drawer(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SettingsScreen(
                            durationInDay: widget.durationInDay,
                            onLoading: (isLoading) {
                              setState(() {
                                _logoutLoading = isLoading;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 4,
                    toolbarHeight:
                        // isFilter ? 96 :
                        50,
                    backgroundColor: darkBlue,
                    bottom: PreferredSize(
                      preferredSize: Size(40, 37),
                      child: SizedBox(
                        height:
                            // isFilter ? 96 :
                            42,
                        // color: Color.fromARGB(255, 245, 245, 245),
                        child: TabBar(
                          onTap: (index) {
                            setState(() {
                              currentTab = index;
                              _getPosts();
                            });
                          },
                          // isScrollable: true,
                          tabs: list,
                          indicatorColor: Colors.white,
                          indicatorWeight: 2,
                          labelColor: Colors.white,
                          controller: _tabController,
                        ),
                      ),
                    ),
                    actions: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 8, top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: SizedBox(
                                  width: 36,
                                  height: 35,
                                  child: Material(
                                    shape: const CircleBorder(),
                                    color: darkBlue,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      splashColor: Colors.grey.withOpacity(0.5),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 50),
                                            () {
                                          _key.currentState?.openDrawer();
                                          isFilter = false;
                                        });
                                      },
                                      child: const Icon(Icons.settings,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(0),
                                    onTap: () {
                                      Future.delayed(
                                        const Duration(milliseconds: 50),
                                        () {
                                          Navigator.of(context)
                                              .push(PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            duration:
                                                Duration(milliseconds: 600),
                                            child: SubmissionCreate(
                                              durationInDay:
                                                  widget.durationInDay,
                                            ),
                                          ));
                                        },
                                      );
                                    },
                                    child: Container(
                                      // width: 220,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 4),
                                      child: const Center(
                                        child: Text(
                                          "FAIRTALK'S DEMOCRACY",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // height: 1,
                                    width: 215,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      border: Border(
                                        top: BorderSide(
                                            width: 1, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: SizedBox(
                                  width: 36,
                                  height: 35,
                                  child: Material(
                                    shape: const CircleBorder(),
                                    color: darkBlue,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      splashColor: Colors.grey.withOpacity(0.5),
                                      onTap: () {
                                        setState(() {
                                          isFilter = !isFilter;
                                        });
                                      },
                                      child: const Icon(Icons.filter_list,
                                          color: whiteDialog),
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 5.0),
                              //   child: Material(
                              //     shape: const CircleBorder(),
                              //     color: darkBlue,
                              //     child: InkWell(
                              //       customBorder: const CircleBorder(),
                              //       splashColor: Colors.grey.withOpacity(0.5),
                              //       onTap: () {
                              //         Future.delayed(
                              //           const Duration(milliseconds: 50),
                              //           () {
                              //             Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       SubmissionCreate(
                              //                         durationInDay: widget
                              //                             .durationInDay,
                              //                       )),
                              //             );
                              //           },
                              //         );
                              //       },
                              //       child: SizedBox(
                              //         width: 40,
                              //         height: 40,
                              //         child: Stack(
                              //           children: const [
                              //             Positioned(
                              //               left: 7,
                              //               top: 7,
                              //               child: Icon(Icons.create,
                              //                   color: Colors.white,
                              //                   size: 26),
                              //             ),
                              //             Positioned(
                              //               top: 20,
                              //               left: 20,
                              //               child: Icon(
                              //                 Icons.add,
                              //                 size: 13,
                              //                 color: Colors.white,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: Consumer<PostProvider>(
                    builder: (context, postProvider, child) {
                      if (postProvider.pLoading) {
                        return const SizedBox(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        // if (postProvider.posts.isEmpty) {
                        //   return Center(
                        //     child: Text(
                        //       _tabController?.index == 0
                        //           ? 'No ballots yet.'
                        //           : 'No winning ballots yet.',
                        //       style: const TextStyle(
                        //           color:
                        //               Color.fromARGB(255, 114, 114, 114),
                        //           fontSize: 18),
                        //     ),
                        //   );
                        // } else
                        {
                          return ListView(
                            controller: _postScrollController,
                            children: [
                              postProvider.count <= 1 || postProvider.pLoading
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 4,
                                      ),
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
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                      isMostPopular == true &&
                                                              _tabController
                                                                      ?.index ==
                                                                  0
                                                          ? postProvider
                                                              .getPreviousSubmissions()
                                                          : isMostRecent ==
                                                                      true &&
                                                                  _tabController
                                                                          ?.index ==
                                                                      0
                                                              ? postProvider
                                                                  .getPreviousSubmissionsDate()
                                                              : isMostPopular ==
                                                                          true &&
                                                                      _tabController
                                                                              ?.index ==
                                                                          1
                                                                  ? postProvider
                                                                      .getPreviousUpdates()
                                                                  : postProvider
                                                                      .getPreviousUpdatesDate();

                                                      _postScrollController
                                                          .jumpTo(0);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
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
                                                          Icons.arrow_upward,
                                                          size: 16,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('View Previous',
                                                            // '${(postProvider.count - 2) * postProvider.pageSize + 1} - ${(postProvider.count - 1) * postProvider.pageSize}',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13.5,
                                                              letterSpacing:
                                                                  0.3,
                                                            )),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              Column(
                                children: [
                                  isPoster
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                            left: 12,
                                            top: 12,
                                            bottom: 2,
                                          ),
                                          child: Column(
                                            children: [
                                              PhysicalModel(
                                                color: darkBlue,
                                                elevation: 3,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6,
                                                              right: 12,
                                                              left: 12),
                                                      decoration: BoxDecoration(
                                                        color: whiteDialog,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        25),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25)),
                                                        border: Border.all(
                                                            width: 5,
                                                            color: darkBlue),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                            'Tired of these guys dictating the direction of social media?',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: darkBlue,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Image.asset(
                                                              'assets/musk-zuck.png',
                                                              opacity:
                                                                  const AlwaysStoppedAnimation(
                                                                      .9),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: isDetailed
                                                              ? 15
                                                              : 0),
                                                      child: Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                isDetailed =
                                                                    !isDetailed;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          12,
                                                                      top: 8,
                                                                      right: 12,
                                                                      left: 12),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                      isDetailed
                                                                          ? Icons
                                                                              .keyboard_arrow_up
                                                                          : Icons
                                                                              .keyboard_arrow_down,
                                                                      color:
                                                                          whiteDialog,
                                                                      size: 28),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Flexible(
                                                                    child:
                                                                        const Text(
                                                                      "Learn how Fairtalk is replacing CEO's with a democratic system.",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            whiteDialog,
                                                                        letterSpacing:
                                                                            0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          isDetailed
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            top:
                                                                                BorderSide(color: whiteDialog, width: 0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Text(
                                                                        "Creating Ballots",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: whiteDialog.withOpacity(0.8),
                                                                            fontSize: 16),
                                                                      ),
                                                                      Text(
                                                                        "When you create a ballot, you're deciding which new features you want us to add, remove or modify from our platform. The ballot that receives the highest score every month will be added to the \"Winning Ballots\" list & will also become the newest feature that we will develop.",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              whiteDialog.withOpacity(0.8),
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      Text(
                                                                        "Rules",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: whiteDialog.withOpacity(0.8),
                                                                            fontSize: 16),
                                                                      ),
                                                                      Text(
                                                                        "We want to give as much power & freedom as possible to our users. And for this reason, there are no rules. As long as your feature complies with both major App Stores, we'll do our very best to implement it.",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              whiteDialog.withOpacity(0.8),
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isPoster = false;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 2,
                                                      horizontal: 8),
                                                  child: const Text(
                                                    'Hide',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  ListView.builder(
                                    itemCount: postProvider.posts.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          PostCardTest(
                                              key: Key(postProvider
                                                  .posts[index].postId),
                                              post: postProvider.posts[index],
                                              profileScreen: false,
                                              archives: false,
                                              durationInDay: durationInDay),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              postProvider.last || postProvider.pLoading
                                  ? const SizedBox()
                                  : Visibility(
                                      visible: postProvider.isButtonVisible,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
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
                                                    Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () {
                                                        isMostPopular == true &&
                                                                _tabController
                                                                        ?.index ==
                                                                    0
                                                            ? postProvider
                                                                .getNextSubmissions()
                                                            : isMostRecent ==
                                                                        true &&
                                                                    _tabController
                                                                            ?.index ==
                                                                        0
                                                                ? postProvider
                                                                    .getNextSubmissionsDate()
                                                                : isMostPopular ==
                                                                            true &&
                                                                        _tabController?.index ==
                                                                            1
                                                                    ? postProvider
                                                                        .getNextUpdates()
                                                                    : isMostRecent ==
                                                                                true &&
                                                                            _tabController?.index ==
                                                                                1
                                                                        ? postProvider
                                                                            .getNextUpdatesDate()
                                                                        : null;
                                                        _postScrollController
                                                            .jumpTo(0);
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      // border: Border.all(
                                                      //   width: 1,
                                                      //   color: Colors.black,
                                                      // ),
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
                                                            color:
                                                                Colors.black),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'View Next',
                                                          // 'View ${postProvider.count * postProvider.pageSize + 1} - ${(postProvider.count + 1) * postProvider.pageSize}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            // fontWeight:
                                                            //     FontWeight.w500,
                                                            fontSize: 13.5,
                                                            letterSpacing: 0,
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
                              const SizedBox(height: 10),
                            ],
                          );
                        }
                      }
                    },
                  ),

                  // CustomScrollView(
                  //   controller: _scrollController,
                  //   slivers: [
                  //     SliverList(
                  //       delegate: SliverChildListDelegate(
                  //         [
                  //           _PostTabScreen(
                  //               filter: filter,
                  //               onLoadMore: initScrollControllerListener,
                  //               durationInDay: durationInDay)
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
                Visibility(
                  visible: _logoutLoading,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: SizedBox(
                        height: 19,
                        width: 19,
                        child: CircularProgressIndicator(
                          // color: Color.fromARGB(255, 231, 104, 104),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 47.5,
                  right: 0,
                  child: isFilter
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              PhysicalModel(
                                color: whiteDialog,
                                borderRadius: BorderRadius.circular(5),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: SizedBox(
                                      width: 190,
                                      // height: 50,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'SORT BY:',
                                                style: TextStyle(
                                                    color: darkBlue,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Container(
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: darkBlue,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    onTap: () {
                                                      setState(() {
                                                        isMostPopular = true;
                                                        isMostRecent = false;
                                                        _getPosts();
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          color: isMostPopular
                                                              ? darkBlue
                                                              : whiteDialog,
                                                          // border: isMostPopular ? Border.all(
                                                          //   width: 2,
                                                          //   color: isMostPopular
                                                          //       ? whiteDialog
                                                          //       : darkBlue
                                                          //           .withOpacity(
                                                          //               0.5),
                                                          // ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .trending_up,
                                                                color: isMostPopular
                                                                    ? whiteDialog
                                                                    : darkBlue,
                                                                size: 16),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Most Popular',
                                                              style: TextStyle(
                                                                  color: isMostPopular
                                                                      ? whiteDialog
                                                                      : darkBlue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    onTap: () {
                                                      setState(() {
                                                        isMostPopular = false;
                                                        isMostRecent = true;
                                                        _getPosts();
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isMostRecent
                                                              ? darkBlue
                                                              : whiteDialog,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          // border: Border.all(
                                                          //   width: 2,
                                                          //   color: isMostRecent
                                                          //       ? whiteDialog
                                                          //       : darkBlue
                                                          //           .withOpacity(
                                                          //               0.8),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons.stars,
                                                                color: isMostRecent
                                                                    ? whiteDialog
                                                                    : darkBlue,
                                                                size: 15),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Most Recent',
                                                              style: TextStyle(
                                                                  color: isMostRecent
                                                                      ? whiteDialog
                                                                      : darkBlue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ]),
                                        ],
                                      )),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 36,
                                  height: 35,
                                  child: Material(
                                    shape: const CircleBorder(),
                                    color: Colors.transparent,
                                    child: InkWell(
                                        customBorder: const CircleBorder(),
                                        splashColor:
                                            Colors.grey.withOpacity(0.5),
                                        onTap: () {
                                          setState(
                                            () {
                                              isFilter = false;
                                            },
                                          );
                                        },
                                        child: const Icon(Icons.close,
                                            color: darkBlue, size: 26)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
                Positioned(
                  bottom: 7,
                  right: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: PhysicalModel(
                      elevation: 4,
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        shape: const CircleBorder(),
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            Future.delayed(
                              const Duration(milliseconds: 50),
                              () {
                                // Navigator.push(
                                //   context,

                                //   MaterialPageRoute(
                                //       builder: (context) => SubmissionCreate(
                                //             durationInDay: widget.durationInDay,
                                //           )),
                                // );
                                Navigator.of(context).push(PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  duration: Duration(milliseconds: 600),
                                  child: SubmissionCreate(
                                    durationInDay: widget.durationInDay,
                                  ),
                                ));
                              },
                            );
                          },
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Stack(
                              children: const [
                                Positioned(
                                  left: 17,
                                  top: 16,
                                  child: Icon(Icons.create,
                                      color: Colors.white, size: 26),
                                ),
                                Positioned(
                                  top: 29,
                                  left: 29,
                                  child: Icon(
                                    Icons.add,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _getPosts() async {
    await Future.delayed(Duration.zero);
    if (isMostPopular == true && _tabController?.index == 0) {
      Provider.of<PostProvider>(context, listen: false).getSubmissionsScore();
    } else if (isMostRecent == true && _tabController?.index == 0) {
      Provider.of<PostProvider>(context, listen: false).getSubmissionsDate();
    } else if (isMostPopular == true && _tabController?.index == 1) {
      Provider.of<PostProvider>(context, listen: false).getUpdatesScore();
    } else {
      Provider.of<PostProvider>(context, listen: false).getUpdatesDate();
    }
    ;
  }
}

// Widget animatedTabContainer({required String label, required Color color}) {
//   return Container(
//     alignment: Alignment.center,
//     decoration: BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.circular(25),
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     child: Text(label,
//         style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 80, 80, 80))),
//   );
// }

// class _PostTabScreen extends StatelessWidget {
//   final bool filter;
//   final Function() onLoadMore;
//   var durationInDay;

//   _PostTabScreen(
//       {Key? key,
//       required this.filter,
//       required this.onLoadMore,
//       required this.durationInDay})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PostProvider>(builder: (context, postProvider, child) {
//       if (postProvider.pLoading) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             SizedBox(height: 12),
//             SizedBox(
//               // height: MediaQuery.of(context).size.width < screenWidth
//               //     ? (filter
//               //         ? MediaQuery.of(context).size.height - 200
//               //         : MediaQuery.of(context).size.height - 200)
//               //     : MediaQuery.of(context).size.height - 245,
//               child: Center(child: CircularProgressIndicator()),
//             ),
//           ],
//         );
//       } else {
//         if (postProvider.submissionPostScore.isEmpty) {
//           return const Center(
//             child: Text(
//               'No submissions yet.',
//               style: TextStyle(
//                   color: Color.fromARGB(255, 114, 114, 114), fontSize: 18),
//             ),
//           );
//         } else {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ListView.builder(
//                 itemCount: postProvider.submissionPostScore.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       PostCardTest(
//                           post: postProvider.submissionPostScore[index],
//                           profileScreen: false,
//                           archives: false,
//                           durationInDay: durationInDay),
//                       Visibility(
//                         visible: postProvider.canUserPostLoadMore &&
//                             !postProvider.pageLoading &&
//                             (postProvider.submissionPostScore.length - 1) ==
//                                 index,
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 PhysicalModel(
//                                   color: Colors.white,
//                                   elevation: 2,
//                                   borderRadius: BorderRadius.circular(25),
//                                   child: Material(
//                                     color: Colors.transparent,
//                                     child: InkWell(
//                                       borderRadius: BorderRadius.circular(25),
//                                       splashColor: const Color.fromARGB(
//                                           255, 245, 245, 245),
//                                       onTap: onLoadMore,
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                           vertical: 8,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.transparent,
//                                           borderRadius:
//                                               BorderRadius.circular(25),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: const [
//                                             Icon(Icons.arrow_downward,
//                                                 size: 16, color: Colors.black),
//                                             SizedBox(width: 8),
//                                             Text(
//                                               'View More',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 13.5,
//                                                 letterSpacing: 0,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Visibility(
//                         visible: postProvider.pageLoading &&
//                             (postProvider.submissionPostScore.length - 1) ==
//                                 index,
//                         child: const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Center(
//                             child: SizedBox(
//                               height: 30,
//                               width: 30,
//                               child: CircularProgressIndicator(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//             ],
//           );
//         }
//       }
//     });
//   }
// }
