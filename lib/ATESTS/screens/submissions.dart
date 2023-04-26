import 'dart:async';
import 'package:aft/ATESTS/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/post_provider.dart';
import '../provider/user_provider.dart';
import '../utils/utils.dart';
import '../zFeeds/message_card.dart';
import '../models/user.dart';
import 'my_drawer_list.dart';

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
  bool posts = true;
  bool comment = false;
  bool profileScreen = true;
  bool filter = false;

  User? _userProfile;
  User? _userAdmin;
  User? _userP;
  final ScrollController _scrollController = ScrollController();

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

  @override
  void initState() {
    super.initState();
    initScrollControllerListener();
    Future.delayed(Duration.zero, () async {
      postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider?.getSubmissionPosts();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initScrollControllerListener() {
    if (!(postProvider?.isLastUserPost ?? true) &&
        !(postProvider?.pageLoading ?? true)) {
      postProvider?.getNextUserPosts('1');
    }
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
    return buildProfileScreen(context);
  }

  Widget buildProfileScreen(BuildContext context) {
    _userAdmin = Provider.of<UserProvider>(context).getUser;
    _userProfile = Provider.of<UserProvider>(context).getAllUser;
    String data = _userAdmin?.UID ?? "";
    String userProfiledata = _userProfile?.UID ?? "";
    User? user =
        userProfiledata == data ? _userAdmin ?? _userP : _userProfile ?? _userP;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                Scaffold(
                  key: _key,
                  backgroundColor: Colors.black.withOpacity(0.05),
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
                    elevation: 4,
                    toolbarHeight: 56,
                    backgroundColor: Colors.white,
                    actions: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: Material(
                                  shape: const CircleBorder(),
                                  color: Colors.white,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.grey.withOpacity(0.5),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 50), () {
                                        _key.currentState?.openDrawer();
                                      });
                                    },
                                    child: const Icon(Icons.settings,
                                        color: Color.fromARGB(255, 80, 80, 80)),
                                  ),
                                ),
                              ),
                              const Text('Submissions',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 30, 30, 30),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3)),
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: Material(
                                  shape: const CircleBorder(),
                                  color: Colors.white,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.grey.withOpacity(0.5),
                                    onTap: () {
                                      showSnackBar(
                                          'Creating a submission is currently unavailable. Read "What are submissions?" for more info.',
                                          context);
                                    },
                                    child: const Icon(Icons.create,
                                        color: Color.fromARGB(255, 80, 80, 80)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  body: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              children: [
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: PhysicalModel(
                                    color: Colors.white,
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        // border: Border.all(
                                        //     width: 2,
                                        //     color: const Color.fromARGB(255, 36, 64, 101)),
                                      ),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isHowSubWork = !isHowSubWork;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "What are submissions?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 30, 30, 30),
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Icon(
                                                      isHowSubWork
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 30, 30, 30),
                                                      size: 28)
                                                ],
                                              ),
                                            ),
                                          ),
                                          isHowSubWork
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 4),
                                                      Text(
                                                        "Summary",
                                                        // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        "On other platforms, most decisions are taken by a few individuals sitting around a table during a board meeting. On Fairtalk, we let our users vote and decide everything. When you create a submission, other users will be given a total of 30 days to vote on it. Once the 30 days have passed, the submission that received the highest score will become the new feature that will be developed and implemented into our platform.",
                                                        // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          letterSpacing: 0.3,
                                                        ),
                                                      ),
                                                      // const SizedBox(
                                                      //     height: 15),
                                                      // const Text(
                                                      //   "When you create a submission, you're deciding which features should be implemented or removed from our platform.",
                                                      //   // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                                                      //   textAlign:
                                                      //       TextAlign.left,
                                                      //   style: TextStyle(
                                                      //     letterSpacing: 0.3,
                                                      //   ),
                                                      // ),
                                                      // SizedBox(height: 15),
                                                      // Text(
                                                      //   "How do submissions work?",
                                                      //   // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                                                      //   textAlign:
                                                      //       TextAlign.left,
                                                      //   style: TextStyle(
                                                      //     letterSpacing: 0.3,
                                                      //     fontWeight:
                                                      //         FontWeight.w500,
                                                      //   ),
                                                      // ),
                                                      // const SizedBox(height: 2),
                                                      // const Text(
                                                      //   "The moment you successfully create a submission, it'll immediately get listed on this screen for 30 days. During that time, other verified users will be able to cast votes on your submission. Once the 30 days have passed, the submission that received the highest score will become the newest feature that will be developed/implemented into our platform.",
                                                      //   // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                                                      //   textAlign:
                                                      //       TextAlign.left,
                                                      //   style: TextStyle(
                                                      //     letterSpacing: 0.3,
                                                      //   ),
                                                      // ),

                                                      SizedBox(height: 15),
                                                      Text(
                                                        "When will I be able to create a submission?",
                                                        // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          letterSpacing: 0.3,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        "Since Fairtalk is completely new, submissions will only be made available once the platform reaches 500 verified users. We want to make sure there's enough people to participate and vote before releasing a critical feature like this. You can always track the current amount of verified users by clicking on the button below.",
                                                        // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          letterSpacing: 0.3,
                                                        ),
                                                      ),
                                                      SizedBox(height: 15),
                                                      PhysicalModel(
                                                        elevation: 2.5,
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Material(
                                                          color:
                                                              Colors.blueAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            splashColor: Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.3),
                                                            onTap: () {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          150),
                                                                  () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const Statistics()),
                                                                );
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          9),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // height: 40,
                                                              // width: 100,
                                                              child: Center(
                                                                child: Text(
                                                                  'Track Users',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15,
                                                                      letterSpacing:
                                                                          0.5),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 15),
                                                    ],
                                                  ),
                                                )
                                              : Row(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                _PostTabScreen(
                                    filter: filter,
                                    onLoadMore: initScrollControllerListener,
                                    durationInDay: durationInDay)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                )
              ],
            );
          },
        ),
        // }),
      ),
    );
  }

  Widget animatedTabContainer({required String label, required Color color}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 80, 80, 80))),
    );
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
        return Column(
          children: const [
            SizedBox(height: 12),
            SizedBox(
              // height: MediaQuery.of(context).size.width < screenWidth
              //     ? (filter
              //         ? MediaQuery.of(context).size.height - 200
              //         : MediaQuery.of(context).size.height - 200)
              //     : MediaQuery.of(context).size.height - 245,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      } else {
        if (postProvider.userProfilePost.isEmpty) {
          return Column(
            children: const [
              SizedBox(height: 12),
              SizedBox(
                // height: MediaQuery.of(context).size.width < screenWidth
                //     ? (filter
                //         ? MediaQuery.of(context).size.height - 454
                //         : MediaQuery.of(context).size.height - 404)
                //     : MediaQuery.of(context).size.height - 259,
                child: Center(
                  child: Text(
                    'No submissions yet.',
                    style: TextStyle(
                        color: Color.fromARGB(255, 114, 114, 114),
                        fontSize: 18),
                  ),
                ),
              ),
            ],
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
                          profileScreen: false,
                          archives: false,
                          durationInDay: durationInDay),

                      // Visibility(
                      //   visible: postProvider.pageLoading &&
                      //       (postProvider.userProfilePost.length - 1) == index,
                      //   child: const Padding(
                      //     padding: EdgeInsets.all(8.0),
                      //     child: Center(
                      //       child: SizedBox(
                      //         height: 30,
                      //         width: 30,
                      //         child: CircularProgressIndicator(),
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
