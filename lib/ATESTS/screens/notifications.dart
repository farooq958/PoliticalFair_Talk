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
import 'notifications_pref.dart';
import 'submissions_create.dart';

class NotificationsTab extends StatefulWidget {
  NotificationsTab({
    Key? key,
    // required this.uid,
    this.durationInDay,
    // required this.initialTab,
  }) : super(key: key);
  // final String uid;
  final durationInDay;
  // final int initialTab;

  @override
  State<NotificationsTab> createState() => NotificationsTabState();
}

class NotificationsTabState extends State<NotificationsTab>
    with SingleTickerProviderStateMixin {
  bool isMostPopular = true;
  bool isMostRecent = false;
  bool isFilter = false;
  bool isLoading = false;
  bool isDetailed = false;
  bool isPoster = true;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _userAdmin = Provider.of<UserProvider>(context).getUser;
    // _userProfile = Provider.of<UserProvider>(context).getAllUser;
    // String data = _userAdmin?.UID ?? "";
    // String userProfiledata = _userProfile?.UID ?? "";
    // User? user =
    //     userProfiledata == data ? _userAdmin ?? _userP : _userProfile ?? _userP;
    // // return buildProfileScreen(context);
    return buildProfileScreen(context);
  }

  Widget buildProfileScreen(BuildContext context) {
    // _userAdmin = Provider.of<UserProvider>(context).getUser;
    // _userProfile = Provider.of<UserProvider>(context).getAllUser;
    // String data = _userAdmin?.UID ?? "";
    // String userProfiledata = _userProfile?.UID ?? "";
    // User? user =
    //     userProfiledata == data ? _userAdmin ?? _userP : _userProfile ?? _userP;

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
                      toolbarHeight: 56,
                      backgroundColor: darkBlue,
                      actions: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, left: 8, top: 0),
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
                                        splashColor:
                                            Colors.grey.withOpacity(0.5),
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
                                Container(
                                  // width: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "NOTIFICATIONS",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: SizedBox(
                                    width: 36,
                                    height: 35,
                                    child: Material(
                                      shape: const CircleBorder(),
                                      color: darkBlue,
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        splashColor:
                                            Colors.grey.withOpacity(0.5),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Notifications(),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                            Icons.notifications_active_outlined,
                                            color: whiteDialog),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: Center(child: Text('List of Notifications')))
              ],
            );
          }),
        ),
      ),
    );
  }
}
