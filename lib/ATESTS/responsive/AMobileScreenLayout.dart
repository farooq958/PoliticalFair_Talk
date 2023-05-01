import 'package:aft/ATESTS/provider/block_list_provider.dart';
import 'package:aft/ATESTS/provider/filter_provider.dart';
import 'package:aft/ATESTS/provider/poll_provider.dart';
import 'package:aft/ATESTS/provider/post_provider.dart';
import 'package:aft/ATESTS/screens/most_liked_screen.dart';
import 'package:aft/ATESTS/services/firebase_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/country_change_provider.dart';
import '../provider/user_report_provider.dart';
import '../screens/add_post.dart';
import '../screens/home_screen.dart';
import '../screens/search.dart';
import '../screens/submissions.dart';
import '../utils/global_variables.dart';
import 'my_flutter_app_icons.dart';

// ignore: must_be_immutable
class MobileScreenLayout extends StatefulWidget {
  final int? pageIndex;

  // String s;

  const MobileScreenLayout( // this.s,
      {
    Key? key,
    this.pageIndex,
  }) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // Timer? timer;
  // int? midnightDuration;

  int _page = 0;
  late PageController pageController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  var durationInDay = 0;
  var oldDurationInDay = 0;
  // DateTime ntpTime = DateTime.now();
  FirebaseDatabase rdb = FirebaseDatabase.instance;

  final RateMyApp rateMyApp = RateMyApp(
    minDays: 7,
    minLaunches: 10,
    remindDays: 14,
    remindLaunches: 20,
    // minDays: 0,
    // minLaunches: 1,
    // remindDays: 0,
    // remindLaunches: 2,
    googlePlayIdentifier: 'net.fairtalk.fairtalk',
    appStoreIdentifier: '1665430482',
  );

  @override
  void initState() {
    super.initState();

    setInitialSharedPreferrences();
    Provider.of<FilterProvider>(context, listen: false)
        .setDurationInDay(durationInDay);
    Provider.of<PostProvider>(context, listen: false).startScrollListener();
    Provider.of<PollsProvider>(context, listen: false).startScrollListener();
    Provider.of<BlockListProvider>(context, listen: false);
    isLoading = true;
    // _page = int.parse(widget.s);
    if (widget.pageIndex != null) {
      _page = widget.pageIndex!;
    }
    if (FirebaseNotification.mostLikedNav &&
        FirebaseNotification.mostLikedPageType.isNotEmpty) {
      switch (FirebaseNotification.mostLikedPageType) {
        case 'gm':
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            _page = 1;
          }
          break;
        case 'gp':
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setMessage('false');
            _page = 1;
          }
          break;
        case 'np':
          String countryCode = FirebaseNotification.mostLikedCountry;
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setMessage('false');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setCountryByString(countryCode);
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setGlobal('false');
            _page = 1;
          }
          break;
        case 'nm':
          String countryCode = FirebaseNotification.mostLikedCountry;
          if (navigatorKey.currentContext != null) {
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setOneValue('Most Recent');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setMessage('true');
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setCountryByString(countryCode);
            Provider.of<FilterProvider>(navigatorKey.currentContext!,
                    listen: false)
                .setGlobal('false');

            _page = 1;
          }
          break;
        default:
          // debugPrint("error");
          break;
      }
    }

    pageController = PageController(initialPage: _page);
    _getStartTime();
    // _initTimer();
    // _startTimer();
    // _loadNTPTime();
    // getDate();
    // _page = int.parse(widget.s);
    //  _page = int.parse(widget.s);
    // pageController = PageController(initialPage: _page);

    /////////////////////rate-my-app////////////////////////////////////

    //   if (rateMyApp.shouldOpenDialog) {
    //     rateMyApp.showRateDialog(
    //       context,
    //       title: 'rate this app',
    //       message: 'hi',
    //       rateButton: 'rate',
    //       noButton: 'no thanks',
    //       laterButton: 'maybe later',
    //       onDismissed: () =>
    //           rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    //     );
    //   }
    // });

    rateMyApp.init().then((_) {
      rateMyApp.conditions.forEach((condition) {
        if (condition is DebuggableCondition) {
          debugPrint(condition.valuesAsString);
        }
      });
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Feel free to share your experience!',
          message:
              'If you enjoy using Fairtalk, feel free to give us some feedback by either rating our app and/or writing us a review!',
          rateButton: 'GIVE FEEDBACK',
          laterButton: 'MAYBE LATER',
          noButton: "NO THANKS",
          dialogStyle: const DialogStyle(
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
          ),
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });

    //////////////////////////////////////////////////////////////////////
    // midnightTimer();
  }

  // midnightTimer() async {
  //   debugPrint('dateis $dateEST');
  //   // var date = await NTP.now();
  //   debugPrint('what is duration $durationInDay');
  //   // debugPrint(
  //   //     'original duration is ${await DurationProvider.getDurationInDays()}');
  //   var date = DateTime.now();
  //   midnightDuration = DateTime(date.year, date.month, date.day + 1, 0)
  //           .difference(dateEST)
  //           .inSeconds +
  //       2;
  //   debugPrint('duration in midnight $midnightDuration');
  //   timer = Timer.periodic(
  //       const Duration(seconds: 1), (Timer t) => checkDuration());
  // }

  // checkDuration() async {
  //   if (midnightDuration != null) {
  //     midnightDuration = midnightDuration! - 1;
  //     // debugPrint('midnight duration $midnightDuration');
  //     if (midnightDuration! <= 0) {
  //       debugPrint('yes timer executed');
  //       // debugPrint(
  //       //     'duration that come in ${await DurationProvider.getDurationInDays()}');
  //       await getDate();
  //       setState(() {
  //         _getStartTime();
  //         debugPrint('date is $dateEST');

  //         midnightDuration =
  //             DateTime(dateEST.year, dateEST.month, dateEST.day + 1, 0)
  //                     .difference(dateEST)
  //                     .inSeconds +
  //                 2;
  //       });
  //     }
  //   }
  //   // debugPrint('Midnight Duration: $midnightDuration');
  //   // debugPrint('durationInDay: $durationInDay');

  //   /// uncomment this section to check the time effect on all screens
  //   // setState(() {
  //   //   durationInDay++;
  //   // });
  // }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    // timer?.cancel();
    // Provider.of<PostProvider>(context, listen: false).stopListener();
    // Provider.of<PollsProvider>(context, listen: false).stopListener();
  }

  void navigationTapped(int page) async {
    FocusScope.of(context).unfocus();
    pageController.jumpToPage(page);
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final pollProvider = Provider.of<PollsProvider>(context, listen: false);

    filterProvider.setDurationInDay(durationInDay);
    // final leftTimeProvider =
    //     Provider.of<LeftTimeProvider>(context, listen: false);

    if (page == 0) {
      // debugPrint('page is ${page}');
      //  await filterProvider.loadFilters();
      // debugPrint('messages value outsice ${filterProvider.messages}');
      if (filterProvider.messages == 'true') {
        // debugPrint(
        //     'Filter Values at page change two val: ${filterProvider.twoValue}\n global: ${filterProvider.global} \n country ${filterProvider.countryCode}\n duration ${filterProvider.durationInDay}\n one val ${filterProvider.oneValue}');
        postProvider.getPosts(filterProvider.twoValue, filterProvider.global,
            filterProvider.countryCode, durationInDay, filterProvider.oneValue);
      } else {
        // debugPrint('messages value ${filterProvider.messages}');
        pollProvider.getPolls(filterProvider.twoValue, filterProvider.global,
            filterProvider.countryCode, durationInDay, filterProvider.oneValue);
      }
    } else if (page == 3) {
      filterProvider.setAllValue();
      // filterProvider.setTwoValue("All Days");
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Stack(
            children: [
              Container(
                color: Colors.white,
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                    appBar: AppBar(
                      elevation: 4,
                      toolbarHeight: 68,
                      backgroundColor: Colors.white,
                      actions: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 8, left: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Material(
                                          shape: CircleBorder(),
                                          color: Colors.white,
                                          child: Icon(Icons.settings,
                                              color: Color.fromARGB(
                                                  255, 80, 80, 80)),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 1.0),
                                                child: Text(
                                                  'Global',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 55, 55, 55),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.5,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          PhysicalModel(
                                            color: Colors.transparent,
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          25),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          25),
                                                                ),
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        125,
                                                                        125,
                                                                        125)),
                                                        height: 100,
                                                        width: 58,
                                                        child: const Icon(
                                                            MyFlutterApp
                                                                .globe_americas,
                                                            color: Colors.white,
                                                            size: 23),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(25),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    228,
                                                                    228,
                                                                    228),
                                                          ),
                                                          height: 100,
                                                          width: 58,
                                                          child: const Icon(
                                                              Icons.flag,
                                                              color:
                                                                  Colors.white,
                                                              size: 17)),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 1.0),
                                            child: Text(
                                              'Messages',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 55, 55, 55),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.5,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          PhysicalModel(
                                            color: Colors.transparent,
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        25),
                                                              ),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      125,
                                                                      125,
                                                                      125)),
                                                      height: 100,
                                                      width: 58,
                                                      child: const Icon(
                                                          Icons.message,
                                                          color: Colors.white,
                                                          size: 23),
                                                    ),
                                                  ),
                                                  ClipRRect(
                                                    child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    25),
                                                          ),
                                                          color: Color.fromARGB(
                                                              255,
                                                              228,
                                                              228,
                                                              228),
                                                        ),
                                                        height: 100,
                                                        width: 58,
                                                        child: const RotatedBox(
                                                          quarterTurns: 1,
                                                          child: Icon(
                                                              Icons.poll,
                                                              color:
                                                                  Colors.white,
                                                              size: 17),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Icon(Icons.filter_list,
                                            color: Color.fromARGB(
                                                255, 80, 80, 80)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: CupertinoTabBar(
                        inactiveColor: Colors.grey,
                        activeColor: Colors.black,
                        height: 50,
                        backgroundColor: Colors.white,
                        items: [
                          const BottomNavigationBarItem(
                            icon: Padding(
                                padding: EdgeInsets.only(top: 3.0, right: 0),
                                child: Icon(
                                  Icons.home,
                                )),
                            label: 'Home',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Icon(MyFlutterApp.university, size: 25),
                            ),
                            label: 'Archives',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Icon(
                                Icons.search,
                              ),
                            ),
                            label: 'Search',
                          ),
                          BottomNavigationBarItem(
                            icon: Stack(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 3.0),
                                  child: Icon(
                                    Icons.create,
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  left: 13,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 3.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            label: 'Create',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Icon(
                                Icons.phone_iphone,
                              ),
                            ),
                            label: 'Submissions',
                          ),
                        ],
                        currentIndex: _page,
                        onTap: navigationTapped),
                  ),
                ),
              ),
              Positioned.fill(
                child: Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : ChangeNotifierProvider<ChangeCountryProvider>(
            create: (context) => ChangeCountryProvider(),
            lazy: false,
            child: ChangeNotifierProvider<UserReportProvider>(
              create: (context) => UserReportProvider(),
              lazy: false,
              child: Container(
                color: Colors.white,
                child: SafeArea(
                  child: Scaffold(
                    body: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        onPageChanged: onPageChanged,
                        children: [
                          FeedScreen(
                            durationInDay: durationInDay,
                          ),
                          MostLikedScreen(durationInDay: durationInDay),
                          Search(
                            durationInDay: durationInDay,
                          ),
                          AddPost(
                            durationInDay: durationInDay,
                          ),
                          Submissions(
                            durationInDay: durationInDay,
                          ),
                        ]),
                    bottomNavigationBar: CupertinoTabBar(
                        inactiveColor: Colors.grey,
                        activeColor: Colors.black,
                        height: 50,
                        backgroundColor: Colors.white,
                        items: [
                          const BottomNavigationBarItem(
                            icon: Padding(
                                padding: EdgeInsets.only(top: 3.0, right: 0),
                                child: Icon(
                                  Icons.home,
                                )),
                            label: 'Home',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Icon(MyFlutterApp.university, size: 25),
                            ),
                            label: 'Archives',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Icon(
                                Icons.search,
                              ),
                            ),
                            label: 'Search',
                          ),
                          BottomNavigationBarItem(
                            icon: Stack(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 3.0),
                                  child: Icon(
                                    Icons.create,
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  left: 13,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 3.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            label: 'Create',
                          ),
                          const BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Icon(
                                Icons.phone_iphone,
                              ),
                            ),
                            label: 'Submissions',
                          ),
                          // BottomNavigationBarItem(
                          //   icon: Padding(
                          //     padding: const EdgeInsets.only(top: 3.0),
                          //     child: Icon(
                          //       Icons.notifications,
                          //     ),
                          //   ),
                          //   label: 'Notifications',
                          // ),
                        ],
                        currentIndex: _page,
                        onTap: navigationTapped),
                  ),
                ),
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
          oldDurationInDay = data['time'];
          durationInDay = data['time'];
          Provider.of<FilterProvider>(context, listen: false)
              .setDurationInDay(durationInDay);
          isLoading = false;
        });
      }
    });
    // var timeStr = doc["time"];
    // var timeStr = "15/09/2022 01:00:000Z";
    // // var timeStr = "14/09/2022 11:32:000Z";
    // // var timeStr = "09/09/2022 01:00:000Z";
    // var dateTime = DateFormat('dd/MM/yy HH:mm:ss').parse(timeStr);
    // var dateNow = dateEST;
    // // debugPrint('est date is $dateNow');
    // // var dateNow = ntpTime.toUtc();
    // var duration = dateNow.difference(dateTime);
    // var _dd = duration.inDays;
    // //set old duration

    // durationInDay = _dd;
    // if (_dd < 60) {
    //   setState(() {
    //     // durationForMinutes = _dd;
    //     isLoading = false;
    //   });
    // } else {
    //   // var _fd = _dd % 60;
    //   var _hd = _dd / 60;
    //   var _hhd = _hd.toInt();

    //   // check hours cycle getter 24
    //   if (_hhd < 24) {
    //     setState(() {
    //       // durationForMinutes = _fd;
    //       // durationForHours = _hhd;
    //       isLoading = false;
    //     });
    //   } else {
    //     var _hhhd = _hhd % 24;

    //     setState(() {
    //       // durationForMinutes = _fd;
    //       // durationForHours = _hhhd;
    //       isLoading = false;
    //     });
    //   }
    // }
    // oldDurationInDay = durationInDay;

    // setState(() {
    //   isLoading = false;
    // });

    // Provider.of<FilterProvider>(context, listen: false)
    //     .setDurationInDay(durationInDay);
  }

  void setInitialSharedPreferrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('selected_radio', 'Highest Score');
    prefs.setString('selected_radio1', 'All Days');
    prefs.setString('selected_radio3', 'true');
    prefs.setString('selected_radio4', 'true');
    prefs.setInt('countryRadio', 188);
  }
}
