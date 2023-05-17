import 'dart:async';

import 'package:aft/ATESTS/provider/filter_provider.dart';
import 'package:aft/ATESTS/provider/poll_provider.dart';
import 'package:aft/ATESTS/provider/post_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/poll.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../zFeeds/message_card.dart';
import '../zFeeds/poll_card.dart';
import 'filter_arrays.dart';
import 'filter_screen.dart';
import 'my_drawer_list.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    Key? key,
    this.durationInDay,
  }) : super(key: key);
  final durationInDay;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var messages = 'true';
  var global = 'true';
  bool loading = false;
  String oneValue = '';
  String twoValue = '';
  String threeValue = '';
  String countryCode = "";

  // User? user;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _logoutLoading = false;
  // DateTime ntpTime = DateTime.now();

  List<Post> postsList = [];
  StreamSubscription? loadDataStream;
  StreamController<Post> updatingStream = StreamController.broadcast();

  List<Poll> pollsList = [];
  StreamSubscription? loadDataStreamPoll;
  StreamController<Poll> updatingStreamPoll = StreamController.broadcast();
  final _postScrollController = ScrollController();
  final _pollsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    isLoading = true;
    // debugPrint('init work');
    // debugPrint(
    // 'two val: $twoValue\n global $global\n country $countryCode\n duration ${widget.durationInDay}\n one val $oneValue');
    loadCountryFilterValue();

    // getValueG().then(((value) => getValueM().then((value) => initList())));
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final pollsProvider = Provider.of<PollsProvider>(context, listen: false);
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    // leftTime();
    _getPosts(filterProvider: filterProvider);
  }

  // leftTime() async {
  //   final leftTimeProvider =
  //       Provider.of<LeftTimeProvider>(context, listen: false);

  //   await leftTimeProvider.getDate();

  //   //debugPrint("end value $endTime");
  // }

  @override
  void dispose() {
    super.dispose();
    _postScrollController.dispose();
    _pollsScrollController.dispose();
    if (loadDataStream != null) {
      loadDataStream!.cancel();
    }
    if (loadDataStreamPoll != null) {
      loadDataStreamPoll!.cancel();
    }
  }

  postNextScroll() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    // if (_postScrollController.position.extentAfter < 1) {
    //   debugPrint(
    //       'two val: $twoValue\n global $global\n country $countryCode\n duration ${widget.durationInDay}\n one val $oneValue');
    //
    //   postProvider.getNextPosts(twoValue, global, countryCode,
    //       widget.durationInDay, filterProvider.oneValue);
    // }
  }

  pollNextScroll() async {
    final pollsProvider = Provider.of<PollsProvider>(context, listen: false);
    // if (_postScrollController.position.extentAfter < 1) {
    //   debugPrint("polls Pagination working ");
    //   getValueG().then(((value) => getValueM().then((value) {
    //     debugPrint('getValue M for poll at init');
    //     pollsProvider.getNextPolls(twoValue, global, countryCode,widget.durationInDay, oneValue);})));
    // }
  }

  loadCountryFilterValue() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // debugPrint("loadCountry working");
    setState(() {
      int selectedCountryIndex = prefs.getInt('countryRadio') ?? 188;

      // debugPrint('number value ${short.indexOf(userProvider.getUser!.aaCountry)}');
      countryCode = short[userProvider.getUser != null
          ? userProvider.getUser!.aaCountry.isNotEmpty
              ? short.indexOf(userProvider.getUser!.aaCountry)
              : selectedCountryIndex
          : selectedCountryIndex];
      oneValue = prefs.getString('selected_radio') ?? '';
      twoValue = prefs.getString('selected_radio1') ?? '';
      threeValue = prefs.getString('selected_radio2') ?? '';
      debugPrint(
          "onle value ${oneValue} two value ${twoValue} threevalue ${threeValue}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    return SafeArea(
      child: Stack(
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
              toolbarHeight: 68,
              backgroundColor: Colors.white,
              actions: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, right: 8, left: 8),
                            child: Consumer<FilterProvider>(
                                builder: (context, filterProvider, child) {
                              // debugPrint(
                              // 'Feed Screen value of messages ${filterProvider.messages}');
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 36,
                                    height: 35,
                                    child: Material(
                                      shape: const CircleBorder(),
                                      color: Colors.white,
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        splashColor:
                                            Colors.grey.withOpacity(0.5),
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 50),
                                              () {
                                            _key.currentState?.openDrawer();
                                          });
                                        },
                                        child: const Icon(Icons.settings,
                                            color: Color.fromARGB(
                                                255, 80, 80, 80)),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 1.0),
                                            child: Text(
                                              filterProvider.global == "true"
                                                  ? 'Global'
                                                  : 'National',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 55, 55, 55),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.5,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: filterProvider.global ==
                                                      "true"
                                                  ? 0
                                                  : 4),
                                          filterProvider.global == "true"
                                              ? Row()
                                              : SizedBox(
                                                  width: 24,
                                                  height: 16,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2.0),
                                                    child: Image.asset(
                                                      'icons/flags/png/${filterProvider.countryCode}.png',
                                                      package: 'country_icons',
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                      PhysicalModel(
                                        color: Colors.transparent,
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                            width: 116,
                                            height: 32.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              // border: Border.all(
                                              //   width: .75,
                                              //   color: Colors.grey,
                                              // ),
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  child: InkWell(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25),
                                                      bottomLeft:
                                                          Radius.circular(25),
                                                    ),
                                                    onTap: () {
                                                      filterProvider.global ==
                                                              "true"
                                                          ? null
                                                          : Provider.of<
                                                                      FilterProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .setGlobal(
                                                                  'true');
                                                      if (filterProvider
                                                              .messages ==
                                                          'true') {
                                                        Provider.of<PostProvider>(
                                                                context,
                                                                listen: false)
                                                            .getPosts(
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                widget
                                                                    .durationInDay,
                                                                filterProvider
                                                                    .oneValue);
                                                      } else {
                                                        Provider.of<PollsProvider>(
                                                                context,
                                                                listen: false)
                                                            .getPolls(
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                widget
                                                                    .durationInDay,
                                                                filterProvider
                                                                    .oneValue);
                                                      }
                                                      // initList();
                                                      // initPollList();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  25),
                                                        ),
                                                        color: filterProvider
                                                                    .global ==
                                                                "true"
                                                            ? const Color
                                                                    .fromARGB(
                                                                255,
                                                                125,
                                                                125,
                                                                125)
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                228,
                                                                228,
                                                                228),
                                                      ),
                                                      height: 100,
                                                      width: 58,
                                                      child: Icon(
                                                          MyFlutterApp
                                                              .globe_americas,
                                                          color: Colors.white,
                                                          size: filterProvider
                                                                      .global ==
                                                                  "true"
                                                              ? 23
                                                              : 17),
                                                    ),
                                                  ),
                                                ),
                                                ClipRRect(
                                                  child: InkWell(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(25),
                                                      bottomRight:
                                                          Radius.circular(25),
                                                    ),
                                                    onTap: () {
                                                      filterProvider.global !=
                                                              "true"
                                                          ? null
                                                          : Provider.of<
                                                                      FilterProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .setGlobal(
                                                                  'false');
                                                      if (filterProvider
                                                              .messages ==
                                                          'true') {
                                                        Provider.of<PostProvider>(
                                                                context,
                                                                listen: false)
                                                            .getPosts(
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                widget
                                                                    .durationInDay,
                                                                filterProvider
                                                                    .oneValue);
                                                      } else {
                                                        Provider.of<PollsProvider>(
                                                                context,
                                                                listen: false)
                                                            .getPolls(
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                widget
                                                                    .durationInDay,
                                                                filterProvider
                                                                    .oneValue);
                                                      }
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    25),
                                                          ),
                                                          color: filterProvider
                                                                      .global !=
                                                                  "true"
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  125,
                                                                  125,
                                                                  125)
                                                              : const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  228,
                                                                  228,
                                                                  228),
                                                        ),
                                                        height: 100,
                                                        width: 58,
                                                        child: Icon(Icons.flag,
                                                            color: Colors.white,
                                                            size: filterProvider
                                                                        .global !=
                                                                    "true"
                                                                ? 23
                                                                : 17)),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 1.0),
                                        child: Text(
                                          filterProvider.messages == "true"
                                              ? 'Messages'
                                              : 'Polls',
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 55, 55, 55),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.5,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      PhysicalModel(
                                        color: Colors.transparent,
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          width: 116,
                                          height: 32.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                child: InkWell(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                  ),
                                                  onTap: () {
                                                    // debugPrint(
                                                    // 'filter value ${filterProvider.messages}');
                                                    filterProvider.messages ==
                                                            "true"
                                                        ? null
                                                        : Provider.of<
                                                                    FilterProvider>(
                                                                context,
                                                                listen: false)
                                                            .setMessage('true');

                                                    _getPosts(
                                                        filterProvider:
                                                            filterProvider);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(25),
                                                        bottomLeft:
                                                            Radius.circular(25),
                                                      ),
                                                      color: filterProvider
                                                                  .messages ==
                                                              "true"
                                                          ? const Color
                                                                  .fromARGB(255,
                                                              125, 125, 125)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              228, 228, 228),
                                                    ),
                                                    height: 100,
                                                    width: 58,
                                                    child: Icon(Icons.message,
                                                        color: Colors.white,
                                                        size: filterProvider
                                                                    .messages ==
                                                                "true"
                                                            ? 23
                                                            : 17),
                                                  ),
                                                ),
                                              ),
                                              ClipRRect(
                                                child: InkWell(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25),
                                                  ),
                                                  onTap: () {
                                                    // debugPrint(
                                                    // 'Feed Screen message value ${messages}');
                                                    filterProvider.messages !=
                                                            "true"
                                                        ? null
                                                        : Provider.of<
                                                                    FilterProvider>(
                                                                context,
                                                                listen: false)
                                                            .setMessage(
                                                                'false');
                                                    _getPosts(
                                                        filterProvider:
                                                            filterProvider);
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  25),
                                                        ),
                                                        color: filterProvider
                                                                    .messages !=
                                                                "true"
                                                            ? const Color
                                                                    .fromARGB(
                                                                255,
                                                                125,
                                                                125,
                                                                125)
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                228,
                                                                228,
                                                                228),
                                                      ),
                                                      height: 100,
                                                      width: 58,
                                                      child: RotatedBox(
                                                        quarterTurns: 1,
                                                        child: Icon(Icons.poll,
                                                            color: Colors.white,
                                                            size: filterProvider
                                                                        .messages !=
                                                                    "true"
                                                                ? 23
                                                                : 17),
                                                      )),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 36,
                                    height: 35,
                                    child: Material(
                                      shape: const CircleBorder(),
                                      color: Colors.white,
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        splashColor:
                                            Colors.grey.withOpacity(0.5),
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 50),
                                              () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Countries(
                                                  durationInDay:
                                                      widget.durationInDay,
                                                  removeFilterOptions: 0,
                                                  pageIndex: 0,
                                                ),
                                              ),
                                            ).then((value) async {
                                              await loadCountryFilterValue();
                                              //  initList();
                                              // initPollList();
                                            });
                                          });
                                        },
                                        child: const Icon(Icons.filter_list,
                                            color: Color.fromARGB(
                                                255, 80, 80, 80)),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Consumer<FilterProvider>(
                builder: (context, filterProvider, child) {
              return filterProvider.messages == "true"
                  ? Consumer<PostProvider>(
                      builder: (context, postProvider, child) {
                      if (postProvider.pLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (postProvider.posts.isEmpty) {
                          return const Center(
                            child: Text(
                              'No messages yet.',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 114, 114, 114),
                                  fontSize: 18),
                            ),
                          );
                        } else {
                          return ListView(
                            controller: _postScrollController,
                            children: [
                              postProvider.count <= 1 || postProvider.pLoading
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
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
                                                      postProvider
                                                          .getPreviousPosts(
                                                              filterProvider
                                                                  .twoValue,
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .durationInDay,
                                                              filterProvider
                                                                  .oneValue);
                                                      _postScrollController
                                                          .jumpTo(0);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
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
                                                          color: Color.fromARGB(
                                                              255, 81, 81, 81),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('View Previous',
                                                            // '${(postProvider.count - 2) * postProvider.pageSize + 1} - ${(postProvider.count - 1) * postProvider.pageSize}',
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
                                                            )),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ListView.builder(
                                itemCount: postProvider.posts.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return PostCardTest(
                                      key:
                                          Key(postProvider.posts[index].postId),
                                      post: postProvider.posts[index],
                                      profileScreen: false,
                                      archives: false,
                                      durationInDay: widget.durationInDay);
                                },
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
                                                        // print(
                                                        //     "filterProvider.twoValue: ${filterProvider.twoValue}");
                                                        // print(
                                                        //     "filterProvider.global: ${filterProvider.global}");
                                                        // print(
                                                        //     "filterProvider.countryCode: ${filterProvider.countryCode}");
                                                        // print(
                                                        //     "filterProvider.durationInDay: ${filterProvider.durationInDay}");
                                                        // print(
                                                        //     "filterProvider.oneValue: ${filterProvider.oneValue}");

                                                        postProvider
                                                            .getNextPosts(
                                                          filterProvider
                                                              .twoValue,
                                                          filterProvider.global,
                                                          filterProvider
                                                              .countryCode,
                                                          filterProvider
                                                              .durationInDay,
                                                          filterProvider
                                                              .oneValue,
                                                        );
                                                        _postScrollController
                                                            .jumpTo(0);
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
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
                                                          Icons.arrow_downward,
                                                          size: 16,
                                                          color: Color.fromARGB(
                                                              255, 81, 81, 81),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'View Next',
                                                          // 'View ${postProvider.count * postProvider.pageSize + 1} - ${(postProvider.count + 1) * postProvider.pageSize}',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    81,
                                                                    81,
                                                                    81),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13,
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
                                      ),
                                    ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }
                      }
                    })
                  : Consumer<PollsProvider>(
                      builder: (context, pollsProvider, child) {
                      if (pollsProvider.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (pollsProvider.polls.isEmpty) {
                        return const Center(
                          child: Text(
                            'No polls yet.',
                            style: TextStyle(
                                color: Color.fromARGB(255, 114, 114, 114),
                                fontSize: 18),
                          ),
                        );
                      } else {
                        return ListView(
                          controller: _pollsScrollController,
                          children: [
                            pollsProvider.count <= 1 || pollsProvider.loading
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
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
                                              splashColor: const Color.fromARGB(
                                                  255, 245, 245, 245),
                                              onTap: () {
                                                Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100),
                                                  () {
                                                    pollsProvider
                                                        .getPreviousPolls(
                                                            filterProvider
                                                                .twoValue,
                                                            filterProvider
                                                                .global,
                                                            filterProvider
                                                                .countryCode,
                                                            filterProvider
                                                                .durationInDay,
                                                            filterProvider
                                                                .oneValue);
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
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
                                                    Icon(
                                                      Icons.arrow_upward,
                                                      size: 16,
                                                      color: Color.fromARGB(
                                                          255, 81, 81, 81),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'View Previous',
                                                      // '${(pollsProvider.count - 2) * pollsProvider.pageSize + 1} - ${(pollsProvider.count - 1) * pollsProvider.pageSize}',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 81, 81, 81),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
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
                                  ),
                            Column(
                              children: [
                                ...List.generate(pollsProvider.polls.length,
                                    (index) {
                                  return PollCard(
                                      key: Key(
                                          pollsProvider.polls[index].pollId),
                                      poll: pollsProvider.polls[index],
                                      profileScreen: false,
                                      archives: false,
                                      durationInDay: widget.durationInDay);
                                })
                              ],
                            ),
                            pollsProvider.last || pollsProvider.loading
                                ? const SizedBox()
                                : Visibility(
                                    visible: pollsProvider.isButtonVisible,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
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
                                                  onTap: () async {
                                                    Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () {
                                                        pollsProvider.getNextPolls(
                                                            filterProvider
                                                                .twoValue,
                                                            filterProvider
                                                                .global,
                                                            filterProvider
                                                                .countryCode,
                                                            filterProvider
                                                                .durationInDay,
                                                            filterProvider
                                                                .oneValue);
                                                        _pollsScrollController
                                                            .jumpTo(0);
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
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
                                                          Icons.arrow_downward,
                                                          size: 16,
                                                          color: Color.fromARGB(
                                                              255, 81, 81, 81),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'View Next',
                                                          // '${pollsProvider.count * pollsProvider.pageSize + 1} - ${(pollsProvider.count + 1) * pollsProvider.pageSize}',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    81,
                                                                    81,
                                                                    81),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13,
                                                            letterSpacing: 0.3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }
                    });
            }),
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
      ),
    );
  }

  void _getPosts({
    required FilterProvider filterProvider,
  }) {
    debugPrint(
        "getPost method working one Value: ${filterProvider.oneValue} two value ${filterProvider.twoValue}");
    if (filterProvider.messages == 'true') {
      Provider.of<PostProvider>(context, listen: false).getPosts(
          filterProvider.twoValue,
          filterProvider.global,
          filterProvider.countryCode,
          widget.durationInDay,
          filterProvider.oneValue);
    } else {
      // debugPrint("Getting Polls");
      Provider.of<PollsProvider>(context, listen: false).getPolls(
          filterProvider.twoValue,
          filterProvider.global,
          filterProvider.countryCode,
          widget.durationInDay,
          filterProvider.oneValue);
    }
  }
}
