import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/post_provider.dart';
import '../provider/poll_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/global_variables.dart';
import '../zFeeds/message_card.dart';
import '../zFeeds/poll_card.dart';

class Organic extends StatefulWidget {
  Organic({
    Key? key,
    // required this.uid,
    this.durationInDay,
    // required this.initialTab,
  }) : super(key: key);
  // final String uid;
  final durationInDay;
  // final int initialTab;

  @override
  State<Organic> createState() => OrganicState();
}

class OrganicState extends State<Organic> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int _selectedIndex = 0;
  int currentTab = 0;

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
  PollsProvider? pollsProvider;

  List<Widget> list = [
    Tab(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.message_outlined,
              size: 14,
            ),
            SizedBox(width: 6),
            Text('Messages', style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
    ),
    Tab(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.poll_outlined,
              size: 14,
            ),
            SizedBox(width: 6),
            Text('Polls', style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
    ),
    Tab(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              MyFlutterApp.comment_discussion,
              size: 14,
            ),
            SizedBox(width: 6),
            Text('Comments', style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
    ),
    Tab(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              MyFlutterApp.comment_discussion,
              size: 14,
            ),
            SizedBox(width: 6),
            Text(
              'Replies',
              style: TextStyle(fontSize: 11),
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
  }

  @override
  void dispose() {
    super.dispose();
    _postScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return buildProfileScreen(context);
    return buildProfileScreen(context);
  }

  Widget buildProfileScreen(BuildContext context) {
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
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 4,
                    toolbarHeight:
                        // isFilter ? 96 :
                        52,
                    backgroundColor: darkBlue,
                    bottom: PreferredSize(
                      preferredSize: const Size(40, 37),
                      child: SizedBox(
                        height:
                            // isFilter ? 96 :
                            44,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 36,
                                height: 35,
                                child: Material(
                                  shape: const CircleBorder(),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    splashColor: Colors.grey.withOpacity(0.5),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 50), () {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Icon(Icons.arrow_back,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                "Organic Content",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: _tabController?.index == 0
                      ? Consumer<PostProvider>(
                          builder: (context, postProvider, child) {
                            if (postProvider.pLoading) {
                              return const SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else {
                              {
                                return ListView(
                                  controller: _postScrollController,
                                  children: [
                                    postProvider.count <= 1 ||
                                            postProvider.pLoading
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 4,
                                                right: 12,
                                                left: 12),
                                            child: PhysicalModel(
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
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100), () {
                                                        postProvider
                                                            .getPreviousOrganicMessages(
                                                                widget
                                                                    .durationInDay);

                                                        _postScrollController
                                                            .jumpTo(0);
                                                      });
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Center(
                                                        child: Text(
                                                            'View Previous',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            )),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
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
                                    postProvider.last || postProvider.pLoading
                                        ? const SizedBox()
                                        : Visibility(
                                            visible:
                                                postProvider.isButtonVisible,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                right: 12,
                                                left: 12,
                                              ),
                                              child: PhysicalModel(
                                                color: whiteDialog,
                                                elevation: 2,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    splashColor: testing,
                                                    onTap: () {
                                                      Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                          postProvider
                                                              .getNextOrganicMessages(
                                                                  widget
                                                                      .durationInDay);

                                                          _postScrollController
                                                              .jumpTo(0);
                                                        },
                                                      );
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Center(
                                                        child: Text(
                                                          'View More',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                    const SizedBox(height: 10),
                                  ],
                                );
                              }
                            }
                          },
                        )
                      : _tabController?.index == 1
                          ? Consumer<PollsProvider>(
                              builder: (context, pollsProvider, child) {
                                if (pollsProvider.loading) {
                                  return const SizedBox(
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else {
                                  {
                                    return ListView(
                                      controller: _postScrollController,
                                      children: [
                                        pollsProvider.count <= 1 ||
                                                pollsProvider.loading
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 4,
                                                    right: 12,
                                                    left: 12),
                                                child: PhysicalModel(
                                                  color: Colors.white,
                                                  elevation: 2,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        splashColor: const Color
                                                                .fromARGB(
                                                            255, 245, 245, 245),
                                                        onTap: () {
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      100), () {
                                                            _tabController
                                                                        ?.index ==
                                                                    1
                                                                ? pollsProvider
                                                                    .getPreviousOrganicPolls(
                                                                        widget
                                                                            .durationInDay)
                                                                : null;

                                                            _postScrollController
                                                                .jumpTo(0);
                                                          });
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child: Center(
                                                            child: Text(
                                                                'View Previous',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                )),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                        ListView.builder(
                                          itemCount: pollsProvider.polls.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                PollCard(
                                                    key: Key(pollsProvider
                                                        .polls[index].pollId),
                                                    poll: pollsProvider
                                                        .polls[index],
                                                    profileScreen: false,
                                                    archives: false,
                                                    durationInDay:
                                                        widget.durationInDay),
                                              ],
                                            );
                                          },
                                        ),
                                        pollsProvider.last ||
                                                pollsProvider.loading
                                            ? const SizedBox()
                                            : Visibility(
                                                visible: pollsProvider
                                                    .isButtonVisible,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10.0,
                                                    right: 12,
                                                    left: 12,
                                                  ),
                                                  child: PhysicalModel(
                                                    color: whiteDialog,
                                                    elevation: 2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        splashColor: testing,
                                                        onTap: () {
                                                          Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                            () {
                                                              _tabController
                                                                          ?.index ==
                                                                      1
                                                                  ? pollsProvider
                                                                      .getNextOrganicPolls(
                                                                          widget
                                                                              .durationInDay)
                                                                  : null;
                                                              _postScrollController
                                                                  .jumpTo(0);
                                                            },
                                                          );
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child: Center(
                                                            child: Text(
                                                              'View More',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                        const SizedBox(height: 10),
                                      ],
                                    );
                                  }
                                }
                              },
                            )
                          : null,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _getPosts() async {
    await Future.delayed(Duration.zero);
    _tabController?.index == 0
        ? Provider.of<PostProvider>(context, listen: false)
            .getOrganicMessages(widget.durationInDay)
        : _tabController?.index == 1
            ? Provider.of<PollsProvider>(context, listen: false)
                .getOrganicPolls(widget.durationInDay)
            : null;
    // if (isMostPopular == true && _tabController?.index == 0) {
    //   Provider.of<PostProvider>(context, listen: false).getSubmissionsScore();
    // } else if (isMostRecent == true && _tabController?.index == 0) {
    //   Provider.of<PostProvider>(context, listen: false).getSubmissionsDate();
    // } else if (isMostPopular == true && _tabController?.index == 1) {
    //   Provider.of<PostProvider>(context, listen: false).getUpdatesScore();
    // } else {
    //   Provider.of<PostProvider>(context, listen: false).getUpdatesDate();
    // }
    // ;
  }
}
