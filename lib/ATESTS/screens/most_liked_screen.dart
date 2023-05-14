import 'package:aft/ATESTS/provider/filter_provider.dart';
import 'package:aft/ATESTS/provider/most_liked_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/poll_provider.dart';
import '../provider/post_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../zFeeds/message_card.dart';
import '../zFeeds/poll_card.dart';
import 'filter_screen.dart';
import 'my_drawer_list.dart';

class MostLikedScreen extends StatefulWidget {
  const MostLikedScreen({
    Key? key,
    required this.durationInDay,
  }) : super(key: key);
  final durationInDay;

  @override
  State<MostLikedScreen> createState() => _MostLikedScreenState();
}

class _MostLikedScreenState extends State<MostLikedScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _postScrollController = ScrollController();
  final ScrollController _pollsScrollController = ScrollController();

  bool _logoutLoading = false;

  @override
  void initState() {
    super.initState();
    final mostLikeProvider =
        Provider.of<MostLikedProvider>(context, listen: false);
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    if (filterProvider.messages == 'true') {
      mostLikeProvider.getMostLikedPosts(filterProvider.global,
          filterProvider.countryCode, filterProvider.oneValue);
    } else {
      // debugPrint('messages are false');
      mostLikeProvider.getMostLikedPolls(filterProvider.global,
          filterProvider.countryCode, filterProvider.oneValue);
    }
    // _postScrollController.addListener(postNextScroll);
    // _pollsScrollController.addListener(pollsNextScroll);
  }

  postNextScroll() {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    if (_postScrollController.position.extentAfter < 1) {
      Provider.of<MostLikedProvider>(context, listen: false)
          .getNextMostLikedPosts(filterProvider.global,
              filterProvider.countryCode, filterProvider.oneValue);
    }
  }

  pollsNextScroll() {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    if (_postScrollController.position.extentAfter < 1) {
      Provider.of<MostLikedProvider>(context, listen: false)
          .getNextMostLikedPosts(filterProvider.global,
              filterProvider.countryCode, filterProvider.oneValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mostLikedProvider =
        Provider.of<MostLikedProvider>(context, listen: false);
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
                          padding:
                              const EdgeInsets.only(top: 8, right: 8, left: 8),
                          child: Consumer<FilterProvider>(
                              builder: (context, filterProvider, child) {
                            // debugPrint(
                            // 'value of messages ${filterProvider.messages}');
                            return Row(
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
                                            const Duration(milliseconds: 50),
                                            () {
                                          _key.currentState?.openDrawer();
                                        });
                                      },
                                      child: const Icon(Icons.settings,
                                          color:
                                              Color.fromARGB(255, 80, 80, 80)),
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
                                            width:
                                                filterProvider.global == "true"
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
                                    Material(
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
                                                            .setGlobal('true');
                                                    if (filterProvider
                                                            .messages ==
                                                        'true') {
                                                      mostLikedProvider
                                                          .getMostLikedPosts(
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .oneValue);
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
                                                      mostLikedProvider
                                                          .getMostLikedPolls(
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .oneValue);
                                                    }
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
                                                                  .global ==
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
                                                            .setGlobal('false');
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
                                                      mostLikedProvider
                                                          .getMostLikedPosts(
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
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

                                                      mostLikedProvider
                                                          .getMostLikedPolls(
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .oneValue);
                                                    }
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
                                    Material(
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
                                                  topLeft: Radius.circular(25),
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
                                                  if (filterProvider.messages ==
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

                                                    mostLikedProvider
                                                        .getMostLikedPosts(
                                                            filterProvider
                                                                .global,
                                                            filterProvider
                                                                .countryCode,
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

                                                    mostLikedProvider
                                                        .getMostLikedPolls(
                                                            filterProvider
                                                                .global,
                                                            filterProvider
                                                                .countryCode,
                                                            filterProvider
                                                                .oneValue);
                                                  }
                                                  //  filterProvider.setValueM(messages);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25),
                                                      bottomLeft:
                                                          Radius.circular(25),
                                                    ),
                                                    color: filterProvider
                                                                .messages ==
                                                            "true"
                                                        ? const Color.fromARGB(
                                                            255, 125, 125, 125)
                                                        : const Color.fromARGB(
                                                            255, 228, 228, 228),
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
                                                  topRight: Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25),
                                                ),
                                                onTap: () {
                                                  filterProvider.messages !=
                                                          "true"
                                                      ? null
                                                      : Provider.of<
                                                                  FilterProvider>(
                                                              context,
                                                              listen: false)
                                                          .setMessage('false');
                                                  if (filterProvider.messages ==
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

                                                    mostLikedProvider
                                                        .getMostLikedPosts(
                                                            filterProvider
                                                                .global,
                                                            filterProvider
                                                                .countryCode,
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
                                                    mostLikedProvider
                                                        .getMostLikedPolls(
                                                            filterProvider
                                                                .global,
                                                            filterProvider
                                                                .countryCode,
                                                            filterProvider
                                                                .oneValue);
                                                  }

                                                  //   filterProvider.setValueM(messages);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(25),
                                                        bottomRight:
                                                            Radius.circular(25),
                                                      ),
                                                      color: filterProvider
                                                                  .messages !=
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
                                      splashColor: Colors.grey.withOpacity(0.5),
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
                                                removeFilterOptions: 2,
                                              ),
                                            ),
                                          ).then((value) async {
                                            //await loadCountryFilterValue();
                                            //  initList();
                                            // initPollList();
                                          });
                                        });
                                      },
                                      child: const Icon(Icons.filter_list,
                                          color:
                                              Color.fromARGB(255, 80, 80, 80)),
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
          body: Consumer2<MostLikedProvider, FilterProvider>(
              builder: (context, mostLikedProvider, filterProvider, child) {
            if (mostLikedProvider.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (filterProvider.messages == 'true') {
              if (mostLikedProvider.mostLikedPosts.isEmpty) {
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
                  controller: _pollsScrollController,
                  children: [
                    mostLikedProvider.postPageCount <= 1 ||
                            mostLikedProvider.loading
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Row(
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
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                            mostLikedProvider
                                                .getPreviousMostLikedPosts(
                                                    filterProvider.global,
                                                    filterProvider.countryCode,
                                                    filterProvider.oneValue);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
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
                                              Text('View Previous',
                                                  // '${(mostLikedProvider.postPageCount - 2) * mostLikedProvider.pageSize + 1} - ${(mostLikedProvider.postPageCount - 1) * mostLikedProvider.pageSize}',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 81, 81, 81),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    letterSpacing: 0.3,
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
                      itemCount: mostLikedProvider.mostLikedPosts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PostCardTest(
                            post: mostLikedProvider.mostLikedPosts[index],
                            profileScreen: false,
                            archives: true,
                            durationInDay: widget.durationInDay);
                      },
                    ),
                    mostLikedProvider.lastPostPage || mostLikedProvider.loading
                        ? const SizedBox()
                        : Visibility(
                            visible: mostLikedProvider.isButtonVisible,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
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
                                        onTap: () {
                                          Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                              mostLikedProvider
                                                  .getNextMostLikedPosts(
                                                filterProvider.global,
                                                filterProvider.countryCode,
                                                filterProvider.oneValue,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
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
                                                Icons.arrow_downward,
                                                size: 16,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'View Next',
                                                // '${mostLikedProvider.postPageCount * mostLikedProvider.pageSize + 1} - ${(mostLikedProvider.postPageCount + 1) * mostLikedProvider.pageSize}',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 81, 81, 81),
                                                  fontWeight: FontWeight.w500,
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
                    const SizedBox(height: 10),
                  ],
                );
              }
            } else {
              if (mostLikedProvider.mostLikedPolls.isEmpty) {
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
                  children: [
                    mostLikedProvider.pollPageCount <= 1 ||
                            mostLikedProvider.loading
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Row(
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
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                            mostLikedProvider
                                                .getPreviousMostLikedPolls(
                                                    filterProvider.global,
                                                    filterProvider.countryCode,
                                                    filterProvider.oneValue);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
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
                                              Text('View Previous',
                                                  // '${(mostLikedProvider.pollPageCount - 2) * mostLikedProvider.pageSize + 1} - ${(mostLikedProvider.pollPageCount - 1) * mostLikedProvider.pageSize}',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 81, 81, 81),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    letterSpacing: 0.3,
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
                      itemCount: mostLikedProvider.mostLikedPolls.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PollCard(
                            poll: mostLikedProvider.mostLikedPolls[index],
                            profileScreen: false,
                            archives: true,
                            durationInDay: widget.durationInDay);
                      },
                    ),
                    mostLikedProvider.lastPollPage || mostLikedProvider.loading
                        ? const SizedBox()
                        : Visibility(
                            visible: mostLikedProvider.isPollButtonVisible,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
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
                                        onTap: () {
                                          Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                              mostLikedProvider
                                                  .getNextMostLikedPolls(
                                                filterProvider.global,
                                                filterProvider.countryCode,
                                                filterProvider.oneValue,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
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
                                                Icons.arrow_downward,
                                                size: 16,
                                                color: Color.fromARGB(
                                                    255, 81, 81, 81),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'View Next',
                                                // '${mostLikedProvider.pollPageCount * mostLikedProvider.pageSize + 1} - ${(mostLikedProvider.pollPageCount + 1) * mostLikedProvider.pageSize}',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 81, 81, 81),
                                                  fontWeight: FontWeight.w500,
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
                    const SizedBox(height: 10),
                  ],
                );
              }
            }
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
    );
  }
}
