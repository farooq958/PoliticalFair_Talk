import 'dart:async';
import 'package:aft/ATESTS/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../info screens/submissions_info.dart';
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
                                width: 36,
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
                              Padding(
                                padding: const EdgeInsets.only(top: 11.0),
                                child: Column(
                                  children: const [
                                    Text('SUBMISSIONS',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 55, 55, 55),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          // letterSpacing: -0.2,
                                          // fontFamily: 'Capitalis',
                                        )),
                                    Expanded(
                                      child: Text(
                                          'YOU DECIDE THE DIRECTION OF THE PLATFORM.',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 55, 55, 55),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            // letterSpacing: -0.2,
                                            // fontFamily: 'Capitalis',
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 36,
                                height: 35,
                                // color: Colors.blue,
                                child: Material(
                                  shape: const CircleBorder(),
                                  color: Colors.white,
                                  child: InkWell(
                                      customBorder: const CircleBorder(),
                                      splashColor: Colors.grey.withOpacity(0.5),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 50),
                                            () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SubmissionInfo()),
                                          );
                                        });
                                      },
                                      child: const Icon(Icons.help_outline,
                                          color:
                                              Color.fromARGB(255, 80, 80, 80))),
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
                                _PostTabScreen(
                                    filter: filter,
                                    onLoadMore: initScrollControllerListener,
                                    durationInDay: durationInDay),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PhysicalModel(
                                      color: Colors.blueAccent,
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(50),
                                      child: Material(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(50),
                                        child: InkWell(
                                          splashColor:
                                              Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: () {
                                            showSnackBar(
                                                'Action failed. Click on the "Question Mark" icon to find out why.',
                                                context);
                                          },
                                          child: SizedBox(
                                            height: 40,
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  left: 25, right: 25),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.create,
                                                      color: Colors.white,
                                                      size: 19),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Create a Submission",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        letterSpacing: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10)
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
