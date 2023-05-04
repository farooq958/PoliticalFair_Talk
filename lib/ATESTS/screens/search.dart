import 'package:aft/ATESTS/provider/searchpage_provider.dart';
import 'package:aft/ATESTS/screens/filter_arrays.dart';
import 'package:aft/ATESTS/screens/filter_screen.dart';
import 'package:aft/ATESTS/screens/my_drawer_list.dart';
import 'package:aft/ATESTS/screens/profile_all_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../provider/filter_provider.dart';
import '../provider/most_liked_key_provider.dart';
import '../provider/search_userList.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/utils.dart';
import '../zFeeds/message_card.dart';
import '../zFeeds/poll_card.dart';

class Search extends StatefulWidget {
  const Search({
    Key? key,
    this.durationInDay,
  }) : super(key: key);
  final durationInDay;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final _scrollController = ScrollController();
  // var messages = 'true';
  // var global = 'true';
  bool loading = false;
  String oneValue = '';
  String twoValue = '';
  String threeValue = '';
  String countryCode = "";

  bool _logoutLoading = false;
  // bool _loading = false;
  int _currentMax = 10;
  void initState() {
    super.initState();
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    _getList(filterProvider: filterProvider);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _getMoreData(filterProvider);
      }
    });
  }

  Future _getMoreData(FilterProvider filterProvider) async {
    final userList = Provider.of<UserListProvider>(context, listen: false);
    userList.userListingLast == false
        ? userList.getUserListing(filterProvider.searchController.text,
            getNextList: true)
        : null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getList({
    required FilterProvider filterProvider,
  }) {
    if (filterProvider.messages == 'true') {
      Provider.of<SearchPageProvider>(context, listen: false).getkeywordList(
        filterProvider.global,
        filterProvider.countryCode,
        filterProvider.durationInDay,
        filterProvider.twoValue,
      );
    } else {
      // debugPrint("Getting Polls");
      Provider.of<SearchPageProvider>(context, listen: false)
          .getpollKeywordList(
        filterProvider.global,
        filterProvider.countryCode,
        filterProvider.durationInDay,
        filterProvider.twoValue,
      );
    }
  }

  loadCountryFilterValue(FilterProvider filterProvider) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (filterProvider.messages == "true" &&
        filterProvider.searchController.text.isEmpty &&
        filterProvider.isHome) {
      Provider.of<SearchPageProvider>(context, listen: false).getkeywordList(
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.durationInDay,
          filterProvider.twoValue);
      if (filterProvider.showMessages && filterProvider.isHome) {
        Provider.of<SearchPageProvider>(context, listen: false).initList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
          filterProvider.twoValue,
          filterProvider.durationInDay,
        );
      }
    } else if (filterProvider.messages != "true" &&
        filterProvider.searchController.text.isEmpty &&
        filterProvider.isHome) {
      Provider.of<SearchPageProvider>(context, listen: false)
          .getpollKeywordList(filterProvider.global, filterProvider.countryCode,
              filterProvider.durationInDay, filterProvider.twoValue);

      if (filterProvider.showMessages && filterProvider.isHome) {
        Provider.of<SearchPageProvider>(context, listen: false).initPollList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
          filterProvider.twoValue,
          filterProvider.durationInDay,
        );
      }
    } else if (filterProvider.messages == "true" &&
        filterProvider.searchController.text.isNotEmpty &&
        filterProvider.isHome) {
      Provider.of<SearchPageProvider>(context, listen: false).getsearchData(
        filterProvider.searchController.text,
        filterProvider.global,
        filterProvider.countryCode,
        filterProvider.twoValue,
        filterProvider.durationInDay,
      );
      if (filterProvider.showMessages && filterProvider.isHome) {
        Provider.of<SearchPageProvider>(context, listen: false).initList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
          filterProvider.twoValue,
          filterProvider.durationInDay,
        );
      }
    } else if (filterProvider.messages != "true" &&
        filterProvider.searchController.text.isNotEmpty &&
        filterProvider.isHome) {
      Provider.of<SearchPageProvider>(context, listen: false).getsearchDataPoll(
        filterProvider.searchController.text,
        filterProvider.global,
        filterProvider.countryCode,
        filterProvider.twoValue,
        filterProvider.durationInDay,
      );
      if (filterProvider.showMessages && filterProvider.isHome) {
        Provider.of<SearchPageProvider>(context, listen: false).initPollList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
          filterProvider.twoValue,
          filterProvider.durationInDay,
        );
      }
    }

    if (filterProvider.messages == "true" &&
        filterProvider.searchController.text.isEmpty &&
        filterProvider.isMostLiked) {
      Provider.of<MostLikedKeyProvider>(context, listen: false).getkeywordList(
        filterProvider.global,
        filterProvider.countryCode,
      );
      if (filterProvider.showMessages && filterProvider.isMostLiked) {
        Provider.of<MostLikedKeyProvider>(context, listen: false).initList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
        );
      }
    } else if (filterProvider.messages != "true" &&
        filterProvider.searchController.text.isEmpty &&
        filterProvider.isMostLiked) {
      Provider.of<MostLikedKeyProvider>(context, listen: false)
          .getpollKeywordList(
        filterProvider.global,
        filterProvider.countryCode,
      );

      if (filterProvider.showMessages && filterProvider.isMostLiked) {
        Provider.of<MostLikedKeyProvider>(context, listen: false).initPollList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
        );
      }
    } else if (filterProvider.messages == "true" &&
        filterProvider.searchController.text.isNotEmpty &&
        filterProvider.isMostLiked) {
      Provider.of<MostLikedKeyProvider>(context, listen: false).getsearchData(
        filterProvider.searchController.text,
        filterProvider.global,
        filterProvider.countryCode,
      );
      if (filterProvider.showMessages && filterProvider.isMostLiked) {
        Provider.of<MostLikedKeyProvider>(context, listen: false).initList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
        );
      }
    } else if (filterProvider.messages != "true" &&
        filterProvider.searchController.text.isNotEmpty &&
        filterProvider.isMostLiked) {
      Provider.of<MostLikedKeyProvider>(context, listen: false)
          .getsearchDataPoll(
        filterProvider.searchController.text,
        filterProvider.global,
        filterProvider.countryCode,
      );
      if (filterProvider.showMessages && filterProvider.isMostLiked) {
        Provider.of<MostLikedKeyProvider>(context, listen: false).initPollList(
          filterProvider.trendkeystore ?? "",
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue,
        );
      }
    }

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

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
              toolbarHeight: 145,
              backgroundColor: Colors.white,
              actions: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 8, left: 8),
                                  child: Consumer<FilterProvider>(builder:
                                      (context, filterProvider, child) {
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
                                              customBorder:
                                                  const CircleBorder(),
                                              splashColor:
                                                  Colors.grey.withOpacity(0.5),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 50), () {
                                                  _key.currentState
                                                      ?.openDrawer();
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 1.0),
                                                  child: Text(
                                                    filterProvider.global ==
                                                            "true"
                                                        ? 'Global'
                                                        : 'National',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 55, 55, 55),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.5,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        filterProvider.global ==
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
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 2.0),
                                                          child: Image.asset(
                                                            'icons/flags/png/${filterProvider.countryCode}.png',
                                                            package:
                                                                'country_icons',
                                                          ),
                                                        ),
                                                      )
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
                                                        BorderRadius.circular(
                                                            25),
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
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    25),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    25),
                                                          ),
                                                          onTap: () async {
                                                            filterProvider
                                                                        .global ==
                                                                    "true"
                                                                ? null
                                                                : Provider.of<
                                                                            FilterProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setGlobal(
                                                                        'true');
                                                            if (filterProvider
                                                                        .messages ==
                                                                    'true' &&
                                                                filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isHome) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getkeywordList(
                                                                      filterProvider
                                                                          .global,
                                                                      filterProvider
                                                                          .countryCode,
                                                                      filterProvider
                                                                          .durationInDay,
                                                                      filterProvider
                                                                          .twoValue);
                                                              // Provider.of<PostProvider>(
                                                              //         context,
                                                              //         listen: false)
                                                              //     .getPosts(
                                                              //         filterProvider.twoValue,
                                                              //         filterProvider.global,
                                                              //         filterProvider
                                                              //             .countryCode,
                                                              //         widget.durationInDay,
                                                              //         filterProvider
                                                              //             .oneValue);
                                                            } else if (filterProvider
                                                                        .messages !=
                                                                    'true' &&
                                                                filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isHome) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initPollList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getpollKeywordList(
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .durationInDay,
                                                                filterProvider
                                                                    .twoValue,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                    .isHome &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchDataPoll(
                                                                filterProvider
                                                                    .searchController
                                                                    .text,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                    .isHome &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchData(
                                                                filterProvider
                                                                    .searchController
                                                                    .text,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchDataPoll(
                                                                      filterProvider
                                                                          .searchController
                                                                          .text,
                                                                      filterProvider
                                                                          .global,
                                                                      filterProvider
                                                                          .countryCode);
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getpollKeywordList(
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchData(
                                                                filterProvider
                                                                    .searchController
                                                                    .text,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getkeywordList(
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                              );
                                                            }
                                                            if (filterProvider.isMostLiked &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                        .trendkeystore !=
                                                                    null &&
                                                                filterProvider
                                                                        .showMessages ==
                                                                    true) {
                                                              // await Provider.of<
                                                              //             MostLikedKeyProvider>(
                                                              //         context,
                                                              //         listen: false)
                                                              //     .getPostKeyData(
                                                              //   filterProvider
                                                              //           .trendkeystore ??
                                                              //       "",
                                                              //   filterProvider.global,
                                                              //   filterProvider
                                                              //       .countryCode,
                                                              // );
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypostList
                                                              //             .length >
                                                              //         0
                                                              //     ? await filterProvider.setListPostPollId(Provider.of<
                                                              //                     MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypostList[
                                                              //                 0]
                                                              //             .post_id ??
                                                              //         [])
                                                              //     : null;
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypostList
                                                              //             .length >
                                                              //         0
                                                              //     ?
                                                              await Provider.of<
                                                                          MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                              );
                                                              // : null;
                                                            }
                                                            if (filterProvider.isMostLiked &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                        .trendkeystore !=
                                                                    null &&
                                                                filterProvider
                                                                        .showMessages ==
                                                                    true) {
                                                              // await Provider.of<
                                                              //             MostLikedKeyProvider>(
                                                              //         context,
                                                              //         listen: false)
                                                              //     .getPollKeyData(
                                                              //   filterProvider
                                                              //           .trendkeystore ??
                                                              //       "",
                                                              //   filterProvider.global,
                                                              //   filterProvider
                                                              //       .countryCode,
                                                              // );
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypollList
                                                              //             .length >
                                                              //         0
                                                              //     ? await filterProvider.setListPostPollId(Provider.of<
                                                              //                     MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypollList[
                                                              //                 0]
                                                              //             .pollId ??
                                                              //         [])
                                                              //     : null;
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypollList
                                                              //             .length >
                                                              //         0
                                                              //     ?

                                                              await Provider.of<
                                                                          MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initPollList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                              );
                                                              // : null;
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25),
                                                                bottomLeft: Radius
                                                                    .circular(
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
                                                                color: Colors
                                                                    .white,
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
                                                              const BorderRadius
                                                                  .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    25),
                                                          ),
                                                          onTap: () async {
                                                            filterProvider
                                                                        .global !=
                                                                    "true"
                                                                ? null
                                                                : Provider.of<
                                                                            FilterProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setGlobal(
                                                                        'false');
                                                            if (filterProvider
                                                                        .messages ==
                                                                    'true' &&
                                                                filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isHome) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getkeywordList(
                                                                      filterProvider
                                                                          .global,
                                                                      filterProvider
                                                                          .countryCode,
                                                                      filterProvider
                                                                          .durationInDay,
                                                                      filterProvider
                                                                          .twoValue);
                                                              // Provider.of<PostProvider>(
                                                              //         context,
                                                              //         listen: false)
                                                              //     .getPosts(
                                                              //         filterProvider.twoValue,
                                                              //         filterProvider.global,
                                                              //         filterProvider
                                                              //             .countryCode,
                                                              //         widget.durationInDay,
                                                              //         filterProvider
                                                              //             .oneValue);
                                                            } else if (filterProvider
                                                                        .messages !=
                                                                    'true' &&
                                                                filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isHome) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initPollList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getpollKeywordList(
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .durationInDay,
                                                                filterProvider
                                                                    .twoValue,
                                                              );
                                                              // Provider.of<PollsProvider>(
                                                              //         context,
                                                              //         listen: false)
                                                              //     .getPolls(
                                                              //         filterProvider.twoValue,
                                                              //         filterProvider.global,
                                                              //         filterProvider
                                                              //             .countryCode,
                                                              //         widget.durationInDay,
                                                              //         filterProvider
                                                              //             .oneValue);
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                    .isHome) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchDataPoll(
                                                                filterProvider
                                                                    .searchController
                                                                    .text,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true &&
                                                                filterProvider
                                                                    .isHome) {
                                                              Provider.of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchData(
                                                                filterProvider
                                                                    .searchController
                                                                    .text,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .twoValue,
                                                                filterProvider
                                                                    .durationInDay,
                                                              );
                                                            }

                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchDataPoll(
                                                                      filterProvider
                                                                          .searchController
                                                                          .text,
                                                                      filterProvider
                                                                          .global,
                                                                      filterProvider
                                                                          .countryCode);
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getpollKeywordList(
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getsearchData(
                                                                filterProvider
                                                                    .searchController
                                                                    .text,
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                              );
                                                            }
                                                            if (filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider
                                                                    .isMostLiked &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                        .showMessages !=
                                                                    true) {
                                                              Provider.of<MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getkeywordList(
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                              );
                                                            }
                                                            if (filterProvider.isMostLiked &&
                                                                filterProvider
                                                                        .messages ==
                                                                    "true" &&
                                                                filterProvider
                                                                        .trendkeystore !=
                                                                    null &&
                                                                filterProvider
                                                                        .showMessages ==
                                                                    true) {
                                                              // await Provider.of<
                                                              //             MostLikedKeyProvider>(
                                                              //         context,
                                                              //         listen: false)
                                                              //     .getPostKeyData(
                                                              //   filterProvider
                                                              //           .trendkeystore ??
                                                              //       "",
                                                              //   filterProvider.global,
                                                              //   filterProvider
                                                              //       .countryCode,
                                                              // );
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypostList
                                                              //             .length >
                                                              //         0
                                                              //     ? filterProvider.setListPostPollId(Provider.of<
                                                              //                     MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypostList[
                                                              //                 0]
                                                              //             .post_id ??
                                                              //         [])
                                                              //     : null;
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypostList
                                                              //             .length >
                                                              //         0
                                                              //     ?
                                                              await Provider.of<
                                                                          MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                              );
                                                              // : null;
                                                            }
                                                            if (filterProvider.isMostLiked &&
                                                                filterProvider
                                                                        .messages !=
                                                                    "true" &&
                                                                filterProvider
                                                                        .trendkeystore !=
                                                                    null &&
                                                                filterProvider
                                                                        .showMessages ==
                                                                    true) {
                                                              // await Provider.of<
                                                              //             MostLikedKeyProvider>(
                                                              //         context,
                                                              //         listen: false)
                                                              //     .getPollKeyData(
                                                              //   filterProvider
                                                              //           .trendkeystore ??
                                                              //       "",
                                                              //   filterProvider.global,
                                                              //   filterProvider
                                                              //       .countryCode,
                                                              // );
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypollList
                                                              //             .length >
                                                              //         0
                                                              //     ?
                                                              //  filterProvider.setListPostPollId(Provider.of<
                                                              //                 MostLikedKeyProvider>(
                                                              //             context,
                                                              //             listen:
                                                              //                 false)
                                                              //         .keypollList[
                                                              //             0]
                                                              //         .post_id ??
                                                              //     [])
                                                              // : null;
                                                              // Provider.of<MostLikedKeyProvider>(
                                                              //                 context,
                                                              //                 listen:
                                                              //                     false)
                                                              //             .keypollList
                                                              //             .length >
                                                              //         0
                                                              //     ?
                                                              await Provider.of<
                                                                          MostLikedKeyProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .initPollList(
                                                                filterProvider
                                                                        .trendkeystore ??
                                                                    "",
                                                                filterProvider
                                                                    .global,
                                                                filterProvider
                                                                    .countryCode,
                                                                filterProvider
                                                                    .oneValue,
                                                              );
                                                              // : null;
                                                            }
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          25),
                                                                  bottomRight: Radius
                                                                      .circular(
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
                                                              child: Icon(
                                                                  Icons.flag,
                                                                  color: Colors
                                                                      .white,
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
                                              padding: const EdgeInsets.only(
                                                  bottom: 1.0),
                                              child: Text(
                                                filterProvider.messages ==
                                                        "true"
                                                    ? 'Messages'
                                                    : 'Polls',
                                                style: const TextStyle(
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
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  25),
                                                        ),
                                                        onTap: () async {
                                                          // debugPrint(
                                                          // 'filter value ${filterProvider.messages}');
                                                          filterProvider
                                                                      .messages ==
                                                                  "true"
                                                              ? null
                                                              : Provider.of<
                                                                          FilterProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setMessage(
                                                                      'true');
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isEmpty &&
                                                              filterProvider
                                                                  .isHome) {
                                                            Provider.of<SearchPageProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getkeywordList(
                                                                    filterProvider
                                                                        .global,
                                                                    filterProvider
                                                                        .countryCode,
                                                                    filterProvider
                                                                        .durationInDay,
                                                                    filterProvider
                                                                        .twoValue);
                                                          }
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              filterProvider
                                                                  .isHome) {
                                                            Provider.of<SearchPageProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getsearchData(
                                                                    filterProvider
                                                                        .searchController
                                                                        .text,
                                                                    filterProvider
                                                                        .global,
                                                                    filterProvider
                                                                        .countryCode,
                                                                    filterProvider
                                                                        .twoValue,
                                                                    filterProvider
                                                                        .durationInDay);
                                                          }
                                                          if (filterProvider
                                                                      .showMessages ==
                                                                  true &&
                                                              filterProvider
                                                                  .isHome) {
                                                            Provider.of<SearchPageProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .initList(
                                                              filterProvider
                                                                      .trendkeystore ??
                                                                  "",
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .oneValue,
                                                              filterProvider
                                                                  .twoValue,
                                                              filterProvider
                                                                  .durationInDay,
                                                            );
                                                          }
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              filterProvider
                                                                  .isMostLiked &&
                                                              filterProvider
                                                                      .showMessages ==
                                                                  false) {
                                                            Provider.of<MostLikedKeyProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getsearchData(
                                                              filterProvider
                                                                  .searchController
                                                                  .text,
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                            );
                                                          }
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isEmpty &&
                                                              filterProvider
                                                                  .isMostLiked &&
                                                              filterProvider
                                                                      .showMessages ==
                                                                  false) {
                                                            Provider.of<MostLikedKeyProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getkeywordList(
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                            );
                                                          }
                                                          if (filterProvider
                                                                  .isMostLiked &&
                                                              filterProvider
                                                                      .showMessages ==
                                                                  true &&
                                                              filterProvider
                                                                      .trendkeystore !=
                                                                  null) {
                                                            // await Provider.of<
                                                            //             MostLikedKeyProvider>(
                                                            //         context,
                                                            //         listen: false)
                                                            //     .getsearchData(
                                                            //   filterProvider
                                                            //           .trendkeystore ??
                                                            //       "",
                                                            //   filterProvider.global,
                                                            //   filterProvider
                                                            //       .countryCode,
                                                            // );
                                                            await Provider.of<
                                                                        MostLikedKeyProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .initList(
                                                              filterProvider
                                                                      .trendkeystore ??
                                                                  "",
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .oneValue,
                                                            );
                                                          }
                                                          // _getPosts(
                                                          //     filterProvider: filterProvider);
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(25),
                                                              bottomLeft: Radius
                                                                  .circular(25),
                                                            ),
                                                            color: filterProvider
                                                                        .messages ==
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
                                                              Icons.message,
                                                              color:
                                                                  Colors.white,
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
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  25),
                                                        ),
                                                        onTap: () async {
                                                          // debugPrint(
                                                          //     'Feed Screen message value ${messages}');
                                                          filterProvider
                                                                      .messages !=
                                                                  "true"
                                                              ? null
                                                              : Provider.of<
                                                                          FilterProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setMessage(
                                                                      'false');
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isEmpty &&
                                                              filterProvider
                                                                  .isHome) {
                                                            Provider.of<SearchPageProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getpollKeywordList(
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .durationInDay,
                                                              filterProvider
                                                                  .twoValue,
                                                            );
                                                          }
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              filterProvider
                                                                  .isHome) {
                                                            Provider.of<SearchPageProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getsearchDataPoll(
                                                                    filterProvider
                                                                        .searchController
                                                                        .text,
                                                                    filterProvider
                                                                        .global,
                                                                    filterProvider
                                                                        .countryCode,
                                                                    filterProvider
                                                                        .twoValue,
                                                                    filterProvider
                                                                        .durationInDay);
                                                          }
                                                          if (filterProvider
                                                                      .showMessages ==
                                                                  true &&
                                                              filterProvider
                                                                      .messages !=
                                                                  "true" &&
                                                              filterProvider
                                                                  .isHome) {
                                                            Provider.of<SearchPageProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .initPollList(
                                                              filterProvider
                                                                      .trendkeystore ??
                                                                  "",
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .oneValue,
                                                              filterProvider
                                                                  .twoValue,
                                                              filterProvider
                                                                  .durationInDay,
                                                            );
                                                          }
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              filterProvider
                                                                  .isMostLiked) {
                                                            Provider.of<MostLikedKeyProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getsearchDataPoll(
                                                                    filterProvider
                                                                        .searchController
                                                                        .text,
                                                                    filterProvider
                                                                        .global,
                                                                    filterProvider
                                                                        .countryCode);
                                                          }
                                                          if (filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isEmpty &&
                                                              filterProvider
                                                                  .isMostLiked &&
                                                              filterProvider
                                                                      .showMessages ==
                                                                  false) {
                                                            Provider.of<MostLikedKeyProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getpollKeywordList(
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                            );
                                                          }

                                                          if (filterProvider
                                                                  .isMostLiked &&
                                                              filterProvider
                                                                      .showMessages ==
                                                                  true &&
                                                              filterProvider
                                                                      .trendkeystore !=
                                                                  null) {
                                                            // await Provider.of<
                                                            //             MostLikedKeyProvider>(
                                                            //         context,
                                                            //         listen: false)
                                                            //     .getsearchDataPoll(
                                                            //   filterProvider
                                                            //           .trendkeystore ??
                                                            //       "",
                                                            //   filterProvider.global,
                                                            //   filterProvider
                                                            //       .countryCode,
                                                            // );
                                                            await Provider.of<
                                                                        MostLikedKeyProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .initPollList(
                                                              filterProvider
                                                                      .trendkeystore ??
                                                                  "",
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .oneValue,
                                                            );
                                                          }
                                                          // _getPosts(
                                                          //     filterProvider: filterProvider);
                                                        },
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        25),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
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
                                                              child: Icon(
                                                                  Icons.poll,
                                                                  color: Colors
                                                                      .white,
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
                                              customBorder:
                                                  const CircleBorder(),
                                              splashColor:
                                                  Colors.grey.withOpacity(0.5),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 50), () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Countries(
                                                              durationInDay: widget
                                                                  .durationInDay,
                                                              removeFilterOptions: filterProvider
                                                                      .isMostLiked
                                                                  ? 2
                                                                  : filterProvider.isUser ==
                                                                              false &&
                                                                          filterProvider.showMessages ==
                                                                              true
                                                                      ? 0
                                                                      : filterProvider.isAllKey == true && filterProvider.isUser == false ||
                                                                              filterProvider.isAllKey == true && filterProvider.searchController.text.isNotEmpty && filterProvider.isUser == false
                                                                          ? 1
                                                                          : filterProvider.isUser == true
                                                                              ? 3
                                                                              : 0),
                                                    ),
                                                  ).then((value) async {
                                                    await loadCountryFilterValue(
                                                        filterProvider);
                                                    //  initList();
                                                    // initPollList();
                                                  });
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.filter_list,
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
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5.0, right: 8, left: 8, top: 10),
                          child: Consumer<FilterProvider>(
                              builder: (context, filterProvider, child) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 16,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: PhysicalModel(
                                            color: Colors.transparent,
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                              height: 45,
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65 -
                                                  16,
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 245, 245, 245),
                                                // border: Border.all(
                                                //     width: 0.75, color: Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                              ),
                                              child: Theme(
                                                data: ThemeData(
                                                  colorScheme: ThemeData()
                                                      .colorScheme
                                                      .copyWith(
                                                        primary: const Color
                                                                .fromARGB(
                                                            255, 131, 135, 138),
                                                      ),
                                                ),
                                                child: TextField(
                                                  onChanged: (val) {
                                                    // if (val == "") {
                                                    //   getNextList1 = null;
                                                    //   getNextListPoll = null;
                                                    //   getNextListSearchPoll = null;
                                                    //   getNextListSearchMeassage =
                                                    //       null;
                                                    // }
                                                    if (filterProvider.isUser) {
                                                      Provider.of<UserListProvider>(
                                                              context,
                                                              listen: false)
                                                          .getUserListing(
                                                              filterProvider
                                                                  .searchController
                                                                  .text);
                                                    }
                                                    if (filterProvider
                                                                .isAllKey ==
                                                            true &&
                                                        filterProvider
                                                            .searchController
                                                            .text
                                                            .isEmpty) {
                                                      _getList(
                                                          filterProvider:
                                                              filterProvider);
                                                    }
                                                    filterProvider
                                                        .setShowMessage(false);

                                                    filterProvider.isAllKey ==
                                                                false &&
                                                            filterProvider
                                                                .searchController
                                                                .text
                                                                .isEmpty
                                                        ? filterProvider
                                                            .setisAllKey(true)
                                                        : null;
                                                    // if (filterProvider.messages !=
                                                    //         "true" &&
                                                    //     filterProvider.searchController
                                                    //         .text.isNotEmpty &&
                                                    //     filterProvider.isHome) {
                                                    //   Provider.of<SearchPageProvider>(
                                                    //           context,
                                                    //           listen: false)
                                                    //       .getsearchDataPoll(
                                                    //     filterProvider
                                                    //         .searchController.text,
                                                    //     filterProvider.global,
                                                    //     filterProvider.countryCode,
                                                    //     filterProvider.twoValue,
                                                    //     filterProvider.durationInDay,
                                                    //   );
                                                    // }
                                                    if (filterProvider
                                                                .isAllKey ==
                                                            true &&
                                                        filterProvider
                                                            .searchController
                                                            .text
                                                            .isNotEmpty &&
                                                        filterProvider.isHome) {
                                                      filterProvider.messages ==
                                                              "true"
                                                          ? Provider
                                                                  .of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .getsearchData(
                                                              filterProvider
                                                                  .searchController
                                                                  .text,
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode,
                                                              filterProvider
                                                                  .twoValue,
                                                              filterProvider
                                                                  .durationInDay,
                                                            )
                                                          : Provider
                                                                  .of<SearchPageProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .getsearchDataPoll(
                                                                  filterProvider
                                                                      .searchController
                                                                      .text,
                                                                  filterProvider
                                                                      .global,
                                                                  filterProvider
                                                                      .countryCode,
                                                                  filterProvider
                                                                      .twoValue,
                                                                  filterProvider
                                                                      .durationInDay);
                                                    }
                                                    if (filterProvider
                                                            .isMostLiked &&
                                                        filterProvider
                                                                .messages ==
                                                            "true" &&
                                                        filterProvider
                                                            .searchController
                                                            .text
                                                            .isNotEmpty) {
                                                      Provider.of<MostLikedKeyProvider>(
                                                              context,
                                                              listen: false)
                                                          .getsearchData(
                                                              filterProvider
                                                                  .searchController
                                                                  .text,
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode);
                                                    }
                                                    if (filterProvider
                                                            .isMostLiked &&
                                                        filterProvider
                                                                .messages !=
                                                            "true" &&
                                                        filterProvider
                                                            .searchController
                                                            .text
                                                            .isNotEmpty) {
                                                      Provider.of<MostLikedKeyProvider>(
                                                              context,
                                                              listen: false)
                                                          .getsearchDataPoll(
                                                              filterProvider
                                                                  .searchController
                                                                  .text,
                                                              filterProvider
                                                                  .global,
                                                              filterProvider
                                                                  .countryCode);
                                                    }
                                                    if (filterProvider
                                                            .isMostLiked &&
                                                        filterProvider
                                                            .searchController
                                                            .text
                                                            .isEmpty) {
                                                      filterProvider.messages ==
                                                              "true"
                                                          ? Provider.of<
                                                                      MostLikedKeyProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .getkeywordList(
                                                                  filterProvider
                                                                      .global,
                                                                  filterProvider
                                                                      .countryCode)
                                                          : Provider.of<
                                                                      MostLikedKeyProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .getpollKeywordList(
                                                                  filterProvider
                                                                      .global,
                                                                  filterProvider
                                                                      .countryCode);
                                                    }
                                                  },
                                                  onTap: () {
                                                    filterProvider
                                                        .setsearchFieldSelected(
                                                            true);
                                                    filterProvider
                                                        .setShowMessage(false);
                                                    // setState(() {
                                                    //   searchFieldSelected = true;
                                                    //   showMessages = false;
                                                    // });
                                                    filterProvider.isAllKey ==
                                                                false &&
                                                            filterProvider
                                                                .searchController
                                                                .text
                                                                .isEmpty
                                                        ? filterProvider
                                                            .setisAllKey(true)
                                                        : null;
                                                  },
                                                  maxLines: 1,
                                                  controller: filterProvider
                                                      .searchController,
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                        Icons.search,
                                                        color: Colors.grey,
                                                        size: 25),
                                                    hintText: filterProvider
                                                            .isHome
                                                        ? "Search Home"
                                                        : filterProvider
                                                                .isMostLiked
                                                            ? "Search Archives"
                                                            : "Search User",
                                                    labelStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                      top: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: InkWell(
                                            onTap: () async {
                                              filterProvider.setisHome(true);
                                              filterProvider.setisUser(false);
                                              filterProvider
                                                  .setIsMostLiked(false);
                                              if (filterProvider.messages ==
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isEmpty) {
                                                Provider.of<SearchPageProvider>(
                                                        context,
                                                        listen: false)
                                                    .getkeywordList(
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.durationInDay,
                                                  filterProvider.twoValue,
                                                );
                                              }
                                              if (filterProvider.messages !=
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isEmpty) {
                                                Provider.of<SearchPageProvider>(
                                                        context,
                                                        listen: false)
                                                    .getpollKeywordList(
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.durationInDay,
                                                  filterProvider.twoValue,
                                                );
                                              }
                                              if (filterProvider.messages !=
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isNotEmpty) {
                                                Provider.of<SearchPageProvider>(
                                                        context,
                                                        listen: false)
                                                    .getsearchDataPoll(
                                                  filterProvider
                                                      .searchController.text,
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.twoValue,
                                                  filterProvider.durationInDay,
                                                );
                                              }
                                              if (filterProvider.messages ==
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isNotEmpty) {
                                                Provider.of<SearchPageProvider>(
                                                        context,
                                                        listen: false)
                                                    .getsearchData(
                                                  filterProvider
                                                      .searchController.text,
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.twoValue,
                                                  filterProvider.durationInDay,
                                                );
                                              }
                                              if (filterProvider.showMessages ==
                                                      true &&
                                                  filterProvider.messages !=
                                                      "true") {
                                                await Provider.of<
                                                            SearchPageProvider>(
                                                        context,
                                                        listen: false)
                                                    .initPollList(
                                                  filterProvider
                                                          .trendkeystore ??
                                                      "",
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.oneValue,
                                                  filterProvider.twoValue,
                                                  filterProvider.durationInDay,
                                                );
                                                // : null;
                                              }
                                              if (filterProvider.showMessages ==
                                                      true &&
                                                  filterProvider.messages ==
                                                      "true") {
                                                await Provider.of<
                                                            SearchPageProvider>(
                                                        context,
                                                        listen: false)
                                                    .initList(
                                                  filterProvider
                                                          .trendkeystore ??
                                                      "",
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.oneValue,
                                                  filterProvider.twoValue,
                                                  filterProvider.durationInDay,
                                                );
                                                // : null;
                                              }
                                            },
                                            child: PhysicalModel(
                                              color: filterProvider.isHome
                                                  ? const Color.fromARGB(
                                                      255, 187, 225, 255)
                                                  : const Color.fromARGB(
                                                      255, 245, 245, 245),
                                              elevation: 3,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  height: 45,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 6,
                                                    bottom: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Icon(Icons.home,
                                                          color: filterProvider
                                                                  .isHome
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  75,
                                                                  75,
                                                                  75)
                                                              : Colors.grey,
                                                          size: 27),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: InkWell(
                                            onTap: () async {
                                              filterProvider.setisHome(false);
                                              filterProvider.setisUser(false);
                                              filterProvider
                                                  .setIsMostLiked(true);

                                              if (filterProvider.messages ==
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isEmpty) {
                                                Provider.of<MostLikedKeyProvider>(
                                                        context,
                                                        listen: false)
                                                    .getkeywordList(
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                );
                                              }
                                              if (filterProvider.messages !=
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isEmpty) {
                                                Provider.of<MostLikedKeyProvider>(
                                                        context,
                                                        listen: false)
                                                    .getpollKeywordList(
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                );
                                              }
                                              if (filterProvider.messages !=
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isNotEmpty) {
                                                Provider.of<MostLikedKeyProvider>(
                                                        context,
                                                        listen: false)
                                                    .getsearchDataPoll(
                                                  filterProvider
                                                      .searchController.text,
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                );
                                              }
                                              if (filterProvider.messages ==
                                                      "true" &&
                                                  filterProvider.showMessages !=
                                                      true &&
                                                  filterProvider
                                                      .searchController
                                                      .text
                                                      .isNotEmpty) {
                                                Provider.of<MostLikedKeyProvider>(
                                                        context,
                                                        listen: false)
                                                    .getsearchData(
                                                  filterProvider
                                                      .searchController.text,
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                );
                                              }
                                              if (filterProvider.showMessages ==
                                                      true &&
                                                  filterProvider.messages !=
                                                      "true") {
                                                // await Provider.of<MostLikedKeyProvider>(
                                                //         context,
                                                //         listen: false)
                                                //     .getPollKeyData(
                                                //   filterProvider.trendkeystore ?? "",
                                                //   filterProvider.global,
                                                //   filterProvider.countryCode,
                                                // );
                                                // print(
                                                //     "list.length----> ${filterProvider.trendkeystore}");
                                                // print(
                                                //     "list.length---->   ${Provider.of<MostLikedKeyProvider>(context, listen: false).keypollList[0].pollId}");
                                                // Provider.of<MostLikedKeyProvider>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .keypollList
                                                //             .length >
                                                //         0
                                                //     ? filterProvider.setListPostPollId(
                                                //         Provider.of<MostLikedKeyProvider>(
                                                //                     context,
                                                //                     listen: false)
                                                //                 .keypollList[0]
                                                //                 .pollId ??
                                                //             [])
                                                //     : null;
                                                // Provider.of<MostLikedKeyProvider>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .keypollList
                                                //             .length >
                                                //         0
                                                //     ?
                                                await Provider.of<
                                                            MostLikedKeyProvider>(
                                                        context,
                                                        listen: false)
                                                    .initPollList(
                                                  filterProvider
                                                          .trendkeystore ??
                                                      "",
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.oneValue,
                                                );
                                                // : null;
                                              }
                                              if (filterProvider.showMessages ==
                                                      true &&
                                                  filterProvider.messages ==
                                                      "true") {
                                                // await Provider.of<MostLikedKeyProvider>(
                                                //         context,
                                                //         listen: false)
                                                //     .getPostKeyData(
                                                //   filterProvider.trendkeystore ?? "",
                                                //   filterProvider.global,
                                                //   filterProvider.countryCode,
                                                // );
                                                // print(
                                                //     "list.length----> ${filterProvider.trendkeystore}");
                                                // print(
                                                //     "list.length---->   ${Provider.of<MostLikedKeyProvider>(context, listen: false).keypostList[0].post_id}");
                                                // Provider.of<MostLikedKeyProvider>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .keypostList
                                                //             .length >
                                                //         0
                                                //     ? filterProvider.setListPostPollId(
                                                //         Provider.of<MostLikedKeyProvider>(
                                                //                     context,
                                                //                     listen: false)
                                                //                 .keypostList[0]
                                                //                 .post_id ??
                                                //             [])
                                                //     : null;
                                                // Provider.of<MostLikedKeyProvider>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .keypostList
                                                //             .length >
                                                //         0
                                                //     ?
                                                await Provider.of<
                                                            MostLikedKeyProvider>(
                                                        context,
                                                        listen: false)
                                                    .initList(
                                                  filterProvider
                                                          .trendkeystore ??
                                                      "",
                                                  filterProvider.global,
                                                  filterProvider.countryCode,
                                                  filterProvider.oneValue,
                                                );
                                                // : null;
                                              }
                                            },
                                            child: PhysicalModel(
                                              color: filterProvider.isMostLiked
                                                  ? const Color.fromARGB(
                                                      255, 187, 225, 255)
                                                  : const Color.fromARGB(
                                                      255, 245, 245, 245),
                                              elevation: 3,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  height: 45,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 6,
                                                    bottom: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Icon(
                                                          MyFlutterApp
                                                              .university,
                                                          color: filterProvider
                                                                  .isMostLiked
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  75,
                                                                  75,
                                                                  75)
                                                              : Colors.grey,
                                                          size: 25),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: InkWell(
                                            onTap: () {
                                              filterProvider.setisHome(false);
                                              filterProvider.setisUser(true);
                                              filterProvider
                                                  .setIsMostLiked(false);
                                              Provider.of<UserListProvider>(
                                                      context,
                                                      listen: false)
                                                  .getUserListing(filterProvider
                                                      .searchController.text);
                                            },
                                            child: PhysicalModel(
                                              color: filterProvider.isUser
                                                  ? const Color.fromARGB(
                                                      255, 187, 225, 255)
                                                  : const Color.fromARGB(
                                                      255, 245, 245, 245),
                                              elevation: 3,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                height: 45,
                                                padding: const EdgeInsets.only(
                                                    top: 6,
                                                    bottom: 6,
                                                    left: 0,
                                                    right: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(Icons.person,
                                                        color: filterProvider
                                                                .isUser
                                                            ? const Color
                                                                    .fromARGB(
                                                                255, 75, 75, 75)
                                                            : Colors.grey,
                                                        size: 27),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        Consumer<FilterProvider>(
                            builder: (context, filterProvider, child) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: filterProvider.isUser == false &&
                                        filterProvider.showMessages == true
                                    ? 8
                                    : 12,
                                top: 2),
                            child: filterProvider.isUser &&
                                    filterProvider.searchController.text.isEmpty
                                ? Row()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      filterProvider.isUser == false &&
                                              filterProvider.showMessages ==
                                                  true
                                          ? Container(height: 20)
                                          : Icon(
                                              filterProvider.searchController
                                                          .text.isEmpty &&
                                                      filterProvider.isAllKey &&
                                                      filterProvider.isUser ==
                                                          false
                                                  ? Icons.trending_up
                                                  : filterProvider.isUser &&
                                                          filterProvider
                                                              .searchController
                                                              .text
                                                              .isEmpty
                                                      ? null
                                                      : filterProvider.isUser
                                                          ? Icons.group
                                                          : Icons.search,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          filterProvider.searchController.text
                                                      .isEmpty &&
                                                  filterProvider.isAllKey &&
                                                  filterProvider.isUser == false
                                              ? 'Trending Keywords'
                                              : filterProvider
                                                              .isUser ==
                                                          false &&
                                                      filterProvider
                                                              .showMessages ==
                                                          true &&
                                                      filterProvider
                                                              .messages ==
                                                          'true'
                                                  ? 'Messages with keyword: "${filterProvider.trendkeystore}"'
                                                  : filterProvider
                                                                  .isUser ==
                                                              false &&
                                                          filterProvider
                                                                  .showMessages ==
                                                              true &&
                                                          filterProvider
                                                                  .messages ==
                                                              'false'
                                                      ? 'Polls with keyword: "${filterProvider.trendkeystore}"'
                                                      // : isUser == false &&
                                                      //         showMessages == true &&
                                                      //         messages != "true"
                                                      //     ? 'Showing results: ${trendkeystore ?? ''}'
                                                      : filterProvider
                                                                      .isAllKey ==
                                                                  true &&
                                                              filterProvider
                                                                  .searchController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              filterProvider
                                                                      .isUser ==
                                                                  false
                                                          ? 'Searching for keywords: "${filterProvider.searchController.text}"'
                                                          : filterProvider.isAllKey ==
                                                                      false &&
                                                                  filterProvider
                                                                      .searchController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  filterProvider
                                                                          .isUser ==
                                                                      false
                                                              ? 'Searching for keywords: "${filterProvider.searchController.text}"'
                                                              : filterProvider
                                                                          .isUser &&
                                                                      filterProvider
                                                                          .searchController
                                                                          .text
                                                                          .isNotEmpty
                                                                  ? 'Searching for users: "${filterProvider.searchController.text}"'
                                                                  : '',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11.5,
                                              letterSpacing: 0.3,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Consumer<FilterProvider>(
              builder: (context, filterProvider, child) {
                return filterProvider.isUser &&
                        filterProvider.searchController.text.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'No users found.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                            Text('Search text field is empty.',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16)),
                          ],
                        ),
                      )
                    : filterProvider.isUser
                        ? Consumer<UserListProvider>(
                            builder: (context, userListProvider, child) {
                            return userListProvider.Loading == true
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : FutureBuilder(
                                    // future: userListProvider
                                    //     .getUserListing(searchController.text),
                                    builder: (context, snapshot) {
                                      // if (!snapshot.hasData || snapshot.data == null) {
                                      //   return Row();
                                      // }
                                      return userListProvider
                                              .searchUserList.isEmpty
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'No users found.',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child:
                                                  //  SingleChildScrollView(
                                                  //   child:
                                                  Column(
                                                children: [
                                                  // userListProvider.userListingListCount <=
                                                  //         1
                                                  //     ? const SizedBox()
                                                  //     : Padding(
                                                  //         padding: const EdgeInsets.only(
                                                  //             top: 10.0),
                                                  //         child: Align(
                                                  //           child: PhysicalModel(
                                                  //             color: Colors.transparent,
                                                  //             elevation: 2,
                                                  //             borderRadius:
                                                  //                 BorderRadius.circular(
                                                  //                     25),
                                                  //             child: Container(
                                                  //               decoration: BoxDecoration(
                                                  //                 color: Colors.white,
                                                  //                 borderRadius:
                                                  //                     BorderRadius
                                                  //                         .circular(25),
                                                  //               ),
                                                  //               height: 32,
                                                  //               width: 145,
                                                  //               child: Material(
                                                  //                 color:
                                                  //                     Colors.transparent,
                                                  //                 child: InkWell(
                                                  //                   borderRadius:
                                                  //                       BorderRadius
                                                  //                           .circular(25),
                                                  //                   splashColor:
                                                  //                       const Color
                                                  //                               .fromARGB(
                                                  //                           255,
                                                  //                           245,
                                                  //                           245,
                                                  //                           245),
                                                  //                   onTap: () {
                                                  //                     Future.delayed(
                                                  //                       const Duration(
                                                  //                           milliseconds:
                                                  //                               100),
                                                  //                       () {
                                                  //                         userListProvider.getUserListing(
                                                  //                             searchController
                                                  //                                 .text,
                                                  //                             getNextList:
                                                  //                                 false);
                                                  //                       },
                                                  //                     );
                                                  //                   },
                                                  //                   child: Center(
                                                  //                     child: Text(
                                                  //                       'Load ${(userListProvider.userListingListCount - 2) * 6 + 1} - ${(userListProvider.userListingListCount - 1) * 6}',
                                                  //                       style:
                                                  //                           const TextStyle(
                                                  //                         color: Colors
                                                  //                             .black,
                                                  //                         fontWeight:
                                                  //                             FontWeight
                                                  //                                 .w500,
                                                  //                         fontSize: 14,
                                                  //                         letterSpacing:
                                                  //                             0.3,
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //       ),

                                                  Flexible(
                                                    child: ListView.builder(
                                                      controller:
                                                          _scrollController,
                                                      // physics:
                                                      //     const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: false,
                                                      itemCount: userListProvider
                                                              .searchUserList
                                                              .length +
                                                          1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (index <
                                                            userListProvider
                                                                .searchUserList
                                                                .length) {
                                                          String? uid =
                                                              userListProvider
                                                                  .searchUserList[
                                                                      index]
                                                                  .UID;
                                                          return Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 0,
                                                                  vertical:
                                                                      3.5),
                                                              child:
                                                                  PhysicalModel(
                                                                elevation: 2,
                                                                color: Colors
                                                                    .transparent,
                                                                child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  child:
                                                                      InkWell(
                                                                    splashColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.25),
                                                                    onTap: () {
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 150),
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ProfileAllUser(
                                                                              uid: uid ?? "",
                                                                              initialTab: 0,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Stack(
                                                                                children: [
                                                                                  userListProvider.searchUserList[index].photoUrl != null
                                                                                      ? CircleAvatar(
                                                                                          backgroundColor: Colors.grey,
                                                                                          backgroundImage: NetworkImage(
                                                                                            userListProvider.searchUserList[index].photoUrl ?? "",
                                                                                          ))
                                                                                      : const CircleAvatar(backgroundColor: Colors.grey, backgroundImage: AssetImage('assets/avatarFT.jpg')),
                                                                                  Positioned(
                                                                                    bottom: 0,
                                                                                    right: 4,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        userListProvider.searchUserList[index].profileFlag == true
                                                                                            ? SizedBox(
                                                                                                width: 15.5,
                                                                                                height: 7.7,
                                                                                                child: Image.asset('icons/flags/png/${userListProvider.searchUserList[index].aaCountry}.png', package: 'country_icons'),
                                                                                              )
                                                                                            : Row()
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    bottom: 0,
                                                                                    right: 1,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        userListProvider.searchUserList[index].profileBadge == true
                                                                                            ? Stack(
                                                                                                children: const [
                                                                                                  Positioned(
                                                                                                    right: 3,
                                                                                                    top: 3,
                                                                                                    child: CircleAvatar(
                                                                                                      radius: 4,
                                                                                                      backgroundColor: Colors.white,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Positioned(
                                                                                                    child: Icon(Icons.verified, color: Color.fromARGB(255, 113, 191, 255), size: 13),
                                                                                                  ),
                                                                                                ],
                                                                                              )
                                                                                            : Row()
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(width: 12),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(userListProvider.searchUserList[index].username,
                                                                                      style: const TextStyle(
                                                                                        fontSize: 16.5,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      )),
                                                                                  const SizedBox(height: 2),
                                                                                  Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: MediaQuery.of(context).size.width - 108,
                                                                                        child: Text(userListProvider.searchUserList[index].bio == "" ? 'Empty Bio' : userListProvider.searchUserList[index].bio, maxLines: 10, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(height: 2),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          userListProvider.searchUserList[index].UID != user?.UID
                                                                              ? SizedBox(
                                                                                  width: 36,
                                                                                  height: 35,
                                                                                  child: Material(
                                                                                    color: Colors.transparent,
                                                                                    shape: const CircleBorder(),
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        Future.delayed(const Duration(milliseconds: 150), () {
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return SimpleDialog(
                                                                                                  children: [
                                                                                                    SimpleDialogOption(
                                                                                                      padding: const EdgeInsets.all(20),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          const Icon(Icons.block),
                                                                                                          Container(width: 10),
                                                                                                          const Text('Block User', style: TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                                                        ],
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        Future.delayed(const Duration(milliseconds: 150), () {
                                                                                                          performLoggedUserAction(
                                                                                                              context: context,
                                                                                                              action: () {
                                                                                                                blockDialog(
                                                                                                                  action: () async {
                                                                                                                    var userRef = FirebaseFirestore.instance.collection("users").doc(user?.UID);
                                                                                                                    var blockListRef = FirebaseFirestore.instance.collection("users").doc(user?.UID).collection('blockList').doc(userListProvider.searchUserList[index].UID);
                                                                                                                    var blockUserInfo = await FirebaseFirestore.instance.collection("users").doc(userListProvider.searchUserList[index].UID).get();
                                                                                                                    if (blockUserInfo.exists) {
                                                                                                                      final batch = FirebaseFirestore.instance.batch();
                                                                                                                      final blockingUserData = blockUserInfo.data();
                                                                                                                      blockingUserData?['creatorUID'] = user?.UID;
                                                                                                                      batch.update(userRef, {
                                                                                                                        'blockList': FieldValue.arrayUnion([
                                                                                                                          userListProvider.searchUserList[index].UID
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
                                                                                                              });
                                                                                                        });
                                                                                                      },
                                                                                                    ),
                                                                                                    SimpleDialogOption(
                                                                                                      padding: const EdgeInsets.all(20),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          const Icon(Icons.report_outlined),
                                                                                                          Container(width: 10),
                                                                                                          const Text('Report User', style: TextStyle(letterSpacing: 0.2, fontSize: 15)),
                                                                                                        ],
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        Future.delayed(
                                                                                                          const Duration(milliseconds: 150),
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
                                                                                        });
                                                                                      },
                                                                                      customBorder: const CircleBorder(),
                                                                                      splashColor: Colors.grey.withOpacity(0.5),
                                                                                      child: const Icon(
                                                                                        Icons.more_vert,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Row()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          16),
                                                              child: userListProvider
                                                                          .userListingLast ==
                                                                      false
                                                                  ? const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    )
                                                                  : const Center(
                                                                      child: Text(
                                                                          "No more users to load.",
                                                                          style: TextStyle(
                                                                              letterSpacing: 0.2,
                                                                              fontSize: 16,
                                                                              color: Colors.grey)),
                                                                    ));
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // ),
                                            );
                                    },
                                  );
                          })
                        : filterProvider.searchController.text.isEmpty &&
                                filterProvider.isAllKey &&
                                filterProvider.isHome
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, bottom: 3.5),
                                child: Consumer<SearchPageProvider>(builder:
                                    (context, searchPageProvider, child) {
                                  return FutureBuilder(
                                    // future: filterProvider.messages == "true"
                                    //     ? searchPageProvider.getkeywordList(
                                    //         filterProvider.global,
                                    //         filterProvider.countryCode)
                                    //     : searchPageProvider.getpollKeywordList(
                                    //         filterProvider.global,
                                    //         filterProvider.countryCode),
                                    builder: (BuildContext context, snapshot) {
                                      return searchPageProvider.Loading == true
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : searchPageProvider
                                                          .list.isNotEmpty &&
                                                      filterProvider.messages ==
                                                          "true" ||
                                                  searchPageProvider.listPoll
                                                          .isNotEmpty &&
                                                      filterProvider.messages !=
                                                          "true"
                                              ? SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      filterProvider.messages ==
                                                              "true"
                                                          ? searchPageProvider
                                                                      .postKeywordListCount >
                                                                  1
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3.5,
                                                                      bottom:
                                                                          3.5),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      PhysicalModel(
                                                                        color: Colors
                                                                            .white,
                                                                        elevation:
                                                                            2,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          child: InkWell(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                              onTap: () {
                                                                                searchPageProvider.getkeywordList(filterProvider.global, filterProvider.countryCode, filterProvider.durationInDay, filterProvider.twoValue, getNextList1: false);
                                                                              },
                                                                              child: Container(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.transparent,
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.arrow_upward,
                                                                                      size: 16,
                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                    ),
                                                                                    const SizedBox(width: 8),
                                                                                    Text('View ${((searchPageProvider.postKeywordListCount - 2) * 10) + 1} - ${(searchPageProvider.postKeywordListCount - 1) * 10}',
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                )
                                                              : Container()
                                                          : searchPageProvider
                                                                      .pollKeywordListCount >
                                                                  1
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3.5,
                                                                      bottom:
                                                                          3.5),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      PhysicalModel(
                                                                        color: Colors
                                                                            .white,
                                                                        elevation:
                                                                            2,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          child: InkWell(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                              onTap: () {
                                                                                // setState(
                                                                                //     () {
                                                                                //   print("poll----");
                                                                                //   getNextListPoll =
                                                                                //       false;
                                                                                // });
                                                                                searchPageProvider.getpollKeywordList(filterProvider.global, filterProvider.countryCode, filterProvider.durationInDay, filterProvider.twoValue, getNextListPoll: false);
                                                                              },
                                                                              child: Container(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.transparent,
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.arrow_upward,
                                                                                      size: 16,
                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                    ),
                                                                                    const SizedBox(width: 8),
                                                                                    Text('View ${((searchPageProvider.pollKeywordListCount - 2) * 10) + 1} - ${(searchPageProvider.pollKeywordListCount - 1) * 10}',
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                )
                                                              : Container(),
                                                      ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: filterProvider
                                                                      .messages ==
                                                                  "true"
                                                              ? searchPageProvider
                                                                  .list.length
                                                              : searchPageProvider
                                                                  .listPoll
                                                                  .length,
                                                          // ? keywordCount ==
                                                          //         lastPagekeyword
                                                          //     ? list.length % 10
                                                          //     : 10
                                                          // : pollKeywordCount ==
                                                          //         lastPollKewword
                                                          //     ? listPoll.length % 10
                                                          //     : 10,
                                                          itemBuilder: (context,
                                                              indexValue) {
                                                            // int indexValue = messages ==
                                                            //         "true"
                                                            //     ? index +
                                                            //         ((keywordCount - 1) *
                                                            //             10)
                                                            //     : index +
                                                            //         ((pollKeywordCount -
                                                            //                 1) *
                                                            //             10);

                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          3.5),
                                                              child:
                                                                  PhysicalModel(
                                                                elevation: 2,
                                                                color: Colors
                                                                    .transparent,
                                                                child: Material(
                                                                  color: Colors
                                                                      .white,
                                                                  child:
                                                                      InkWell(
                                                                    splashColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.25),
                                                                    onTap:
                                                                        () async {
                                                                      await filterProvider.messages ==
                                                                              "true"
                                                                          ? searchPageProvider
                                                                              .initList(
                                                                              searchPageProvider.list[indexValue].keyName ?? "",
                                                                              filterProvider.global,
                                                                              filterProvider.countryCode,
                                                                              filterProvider.oneValue,
                                                                              filterProvider.twoValue,
                                                                              filterProvider.durationInDay,
                                                                            )
                                                                          : searchPageProvider
                                                                              .initPollList(
                                                                              searchPageProvider.listPoll[indexValue].keyName ?? "",
                                                                              filterProvider.global,
                                                                              filterProvider.countryCode,
                                                                              filterProvider.oneValue,
                                                                              filterProvider.twoValue,
                                                                              filterProvider.durationInDay,
                                                                            );
                                                                      filterProvider
                                                                          .setisAllKey(
                                                                              false);
                                                                      filterProvider
                                                                          .setShowMessage(
                                                                              true);
                                                                      filterProvider.messages ==
                                                                              "true"
                                                                          ? filterProvider.setTrendKeyStore(searchPageProvider.list[indexValue].keyName ??
                                                                              "")
                                                                          : filterProvider.setTrendKeyStore(searchPageProvider.listPoll[indexValue].keyName ??
                                                                              "");
                                                                      // setState(() {
                                                                      // isAllKey =
                                                                      //     false;
                                                                      // showMessages =
                                                                      //     true;
                                                                      // });
                                                                    },
                                                                    child: NoRadioListTile<
                                                                            String>(
                                                                        start: filterProvider.messages ==
                                                                                "true"
                                                                            ? ((((searchPageProvider.postKeywordListCount - 1) * 10) + 1) + indexValue)
                                                                                .toString()
                                                                            : ((((searchPageProvider.pollKeywordListCount - 1) * 10) + 1) + indexValue)
                                                                                .toString(),
                                                                        center: filterProvider.messages ==
                                                                                "true"
                                                                            ? searchPageProvider.list[indexValue].keyName ??
                                                                                ""
                                                                            : searchPageProvider.listPoll[indexValue].keyName ??
                                                                                "",
                                                                        end: filterProvider.messages ==
                                                                                "true"
                                                                            ? searchPageProvider.list[indexValue].length.toString()
                                                                            : searchPageProvider.listPoll[indexValue].length.toString()),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                      filterProvider.messages ==
                                                              "true"
                                                          ? searchPageProvider
                                                                      .postKeywordLast ==
                                                                  false
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3.5,
                                                                      bottom:
                                                                          3.5),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      PhysicalModel(
                                                                        color: Colors
                                                                            .white,
                                                                        elevation:
                                                                            2,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          child: InkWell(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                              onTap: () {
                                                                                // Future.delayed(
                                                                                //     const Duration(
                                                                                //         milliseconds:
                                                                                //             100),
                                                                                //     () {});
                                                                                // setState(
                                                                                //     () {
                                                                                //   getNextList1 =
                                                                                //       true;
                                                                                // });
                                                                                searchPageProvider.getkeywordList(filterProvider.global, filterProvider.countryCode, filterProvider.durationInDay, filterProvider.twoValue, getNextList1: true);
                                                                              },
                                                                              child: Container(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.transparent,
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.arrow_downward,
                                                                                      size: 16,
                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                    ),
                                                                                    const SizedBox(width: 8),
                                                                                    Text("View ${(searchPageProvider.postKeywordListCount * 10) + 1} - ${(searchPageProvider.postKeywordListCount + 1) * 10}",
                                                                                        // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                )
                                                              : Container()
                                                          : searchPageProvider
                                                                      .pollKeywordLast ==
                                                                  false
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          3.5),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      PhysicalModel(
                                                                        color: Colors
                                                                            .white,
                                                                        elevation:
                                                                            2,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          child: InkWell(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                              onTap: () {
                                                                                // Future.delayed(
                                                                                //     const Duration(
                                                                                //         milliseconds:
                                                                                //             100),
                                                                                //     () {});
                                                                                // setState(
                                                                                //     () {
                                                                                //   getNextListPoll =
                                                                                //       true;
                                                                                // });
                                                                                searchPageProvider.getpollKeywordList(filterProvider.global, filterProvider.countryCode, filterProvider.durationInDay, filterProvider.twoValue, getNextListPoll: true);
                                                                              },
                                                                              child: Container(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.transparent,
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.arrow_downward,
                                                                                      size: 16,
                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                    ),
                                                                                    const SizedBox(width: 8),
                                                                                    Text("View ${(searchPageProvider.pollKeywordListCount * 10) + 1} - ${(searchPageProvider.pollKeywordListCount + 1) * 10}",
                                                                                        // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                        style: const TextStyle(
                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                )
                                                              : Container()
                                                    ],
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        'No trending keywords yet.',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                    },
                                  );
                                }),
                              )
                            : Consumer<SearchPageProvider>(
                                builder: (context, searchPageProvider, child) {
                                return searchPageProvider.Loading == true
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : filterProvider.showMessages == true &&
                                                filterProvider.isUser ==
                                                    false &&
                                                searchPageProvider
                                                    .postsList.isNotEmpty &&
                                                filterProvider.messages ==
                                                    "true" &&
                                                filterProvider.isHome ||
                                            filterProvider.showMessages == true &&
                                                filterProvider.isUser ==
                                                    false &&
                                                searchPageProvider
                                                    .pollsList.isNotEmpty &&
                                                filterProvider.messages !=
                                                    "true" &&
                                                filterProvider.isHome
                                        ? SingleChildScrollView(
                                            controller: searchPageProvider
                                                .scrollController,
                                            child: Column(
                                              children: [
                                                filterProvider.messages ==
                                                        "true"
                                                    ? Visibility(
                                                        visible: searchPageProvider
                                                            .previousButtonVisible,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PhysicalModel(
                                                                color: Colors
                                                                    .white,
                                                                elevation: 2,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    splashColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            245,
                                                                            245,
                                                                            245),
                                                                    onTap: () {
                                                                      Future
                                                                          .delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                100),
                                                                        () {
                                                                          if (filterProvider.messages ==
                                                                              "true") {
                                                                            searchPageProvider.initList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: false);
                                                                          } else {
                                                                            searchPageProvider.initPollList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: false);
                                                                          }
                                                                          // initList(
                                                                          //     trendkeystore!,
                                                                          //     getNextList:
                                                                          //         false);
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.arrow_upward,
                                                                              size: 16,
                                                                              color: Color.fromARGB(255, 81, 81, 81)),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'View ${(searchPageProvider.postPageCount - 2) * 6 + 1} - ${(searchPageProvider.postPageCount - 1) * 6}',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color.fromARGB(255, 81, 81, 81),
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
                                                      )
                                                    : Visibility(
                                                        visible: searchPageProvider
                                                            .previousButtonVisible,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PhysicalModel(
                                                                color: Colors
                                                                    .white,
                                                                elevation: 2,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    splashColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            245,
                                                                            245,
                                                                            245),
                                                                    onTap: () {
                                                                      Future
                                                                          .delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                100),
                                                                        () {
                                                                          if (filterProvider.messages ==
                                                                              "true") {
                                                                            searchPageProvider.initList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: false);
                                                                          } else {
                                                                            searchPageProvider.initPollList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: false);
                                                                          }
                                                                          // initPollList(
                                                                          //     trendkeystore!,
                                                                          //     getNextList:
                                                                          //         false);
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.arrow_upward,
                                                                              size: 16,
                                                                              color: Color.fromARGB(255, 81, 81, 81)),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'View ${(searchPageProvider.pollPageCount - 2) * 6 + 1} - ${(searchPageProvider.pollPageCount - 1) * 6}',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color.fromARGB(255, 81, 81, 81),
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
                                                // Consumer2<PostProvider, PollsProvider>(
                                                //     builder: (context, postProvider,
                                                //         pollProvider, child) {
                                                //   forsetInitState(
                                                //       postProvider, pollProvider);
                                                //   return
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: filterProvider
                                                              .messages ==
                                                          "true"
                                                      ? searchPageProvider
                                                          .postsList.length
                                                      : searchPageProvider
                                                          .pollsList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final User? user = Provider
                                                            .of<UserProvider>(
                                                                context)
                                                        .getUser;
                                                    return filterProvider
                                                                .messages ==
                                                            "true"
                                                        ? PostCardTest(
                                                            post: searchPageProvider
                                                                    .postsList[
                                                                index],
                                                            archives: false,
                                                            profileScreen:
                                                                false,
                                                            durationInDay: widget
                                                                .durationInDay
                                                            // currentUserId: null,
                                                            )
                                                        : PollCard(
                                                            poll: searchPageProvider
                                                                    .pollsList[
                                                                index],
                                                            archives: false,
                                                            profileScreen:
                                                                false,
                                                            durationInDay: widget
                                                                .durationInDay
                                                            // currentUserId: null,
                                                            );
                                                  },
                                                ),
                                                // }),
                                                filterProvider.messages ==
                                                        "true"
                                                    ? Visibility(
                                                        visible: searchPageProvider
                                                            .nextButtonVisible,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PhysicalModel(
                                                                color: Colors
                                                                    .white,
                                                                elevation: 2,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    splashColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            245,
                                                                            245,
                                                                            245),
                                                                    onTap: () {
                                                                      Future
                                                                          .delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                100),
                                                                        () {
                                                                          if (filterProvider.messages ==
                                                                              "true") {
                                                                            searchPageProvider.initList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: true);
                                                                          } else {
                                                                            searchPageProvider.initPollList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: true);
                                                                          }
                                                                          // initList(
                                                                          //     trendkeystore!,
                                                                          //     getNextList:
                                                                          //         true);
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.arrow_downward,
                                                                              size: 16,
                                                                              color: Color.fromARGB(255, 81, 81, 81)),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'View ${searchPageProvider.postPageCount * 6 + 1} - ${(searchPageProvider.postPageCount + 1) * 6}',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color.fromARGB(255, 81, 81, 81),
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
                                                      )
                                                    : Visibility(
                                                        visible: searchPageProvider
                                                            .nextButtonVisible,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PhysicalModel(
                                                                color: Colors
                                                                    .white,
                                                                elevation: 2,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    splashColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            245,
                                                                            245,
                                                                            245),
                                                                    onTap: () {
                                                                      Future
                                                                          .delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                100),
                                                                        () {
                                                                          if (filterProvider.messages ==
                                                                              "true") {
                                                                            searchPageProvider.initList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: true);
                                                                          } else {
                                                                            searchPageProvider.initPollList(
                                                                                filterProvider.trendkeystore ?? "",
                                                                                filterProvider.global,
                                                                                filterProvider.countryCode,
                                                                                filterProvider.oneValue,
                                                                                filterProvider.twoValue,
                                                                                filterProvider.durationInDay,
                                                                                getNextList: true);
                                                                          }
                                                                          // initPollList(
                                                                          //     trendkeystore!,
                                                                          //     getNextList:
                                                                          //         true);
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              6),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.arrow_downward,
                                                                              size: 16,
                                                                              color: Color.fromARGB(255, 81, 81, 81)),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'View ${searchPageProvider.pollPageCount * 6 + 1} - ${(searchPageProvider.pollPageCount + 1) * 6}',
                                                                            // '${(postPageCount - 2) * 10 + 1} - ${(postPageCount - 1) * 10}',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color.fromARGB(255, 81, 81, 81),
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
                                                      )
                                              ],
                                            ),
                                          )
                                        : filterProvider.showMessages == true &&
                                                filterProvider.isUser ==
                                                    false &&
                                                searchPageProvider
                                                    .postsList.isEmpty &&
                                                filterProvider.messages ==
                                                    "true" &&
                                                filterProvider.isHome
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'No messages found.',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : filterProvider.showMessages == true &&
                                                    filterProvider.isUser ==
                                                        false &&
                                                    searchPageProvider
                                                        .pollsList.isEmpty &&
                                                    filterProvider.messages !=
                                                        "true" &&
                                                    filterProvider.isHome
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          children: const [
                                                            Text(
                                                              'No polls found.',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : filterProvider.isAllKey == true &&
                                                        filterProvider
                                                            .searchController
                                                            .text
                                                            .isNotEmpty &&
                                                        filterProvider.isHome
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 6,
                                                                bottom: 3.5),
                                                        child: FutureBuilder(
                                                            // future: filterProvider
                                                            //             .messages ==
                                                            //         "true"
                                                            //     ? searchPageProvider
                                                            //         .getsearchData(
                                                            //         searchController
                                                            //             .text,
                                                            //         filterProvider
                                                            //             .global,
                                                            //         filterProvider
                                                            //             .countryCode,
                                                            //       )
                                                            //     : searchPageProvider
                                                            //         .getsearchData(
                                                            //         searchController
                                                            //             .text,
                                                            //         filterProvider
                                                            //             .global,
                                                            //         filterProvider
                                                            //             .countryCode,
                                                            //       ),
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    snapshot) {
                                                          return searchPageProvider
                                                                      .Loading ==
                                                                  true
                                                              ? const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                )
                                                              : searchPageProvider
                                                                              .searchResult
                                                                              .isEmpty &&
                                                                          filterProvider.messages ==
                                                                              "true" ||
                                                                      searchPageProvider
                                                                              .searchResultPoll
                                                                              .isEmpty &&
                                                                          filterProvider.messages !=
                                                                              "true"
                                                                  ? Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: const [
                                                                          Text(
                                                                            'No keywords found.',
                                                                            style:
                                                                                TextStyle(color: Colors.grey, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          filterProvider.messages == "true"
                                                                              ? searchPageProvider.postKeywordListCount > 1
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                  splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                  onTap: () {
                                                                                                    // setState(() {
                                                                                                    //   getNextListSearchMeassage = false;
                                                                                                    // });
                                                                                                    searchPageProvider.getsearchData(
                                                                                                      filterProvider.searchController.text,
                                                                                                      filterProvider.global,
                                                                                                      filterProvider.countryCode,
                                                                                                      filterProvider.twoValue,
                                                                                                      filterProvider.durationInDay,
                                                                                                      getnextPage: false,
                                                                                                    );
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.transparent,
                                                                                                      borderRadius: BorderRadius.circular(25),
                                                                                                    ),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        const Icon(
                                                                                                          Icons.arrow_upward,
                                                                                                          size: 16,
                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
                                                                                                        ),
                                                                                                        const SizedBox(width: 8),
                                                                                                        Text('View ${((searchPageProvider.postKeywordListCount - 2) * 10) + 1} - ${(searchPageProvider.postKeywordListCount - 1) * 10}',
                                                                                                            style: const TextStyle(
                                                                                                              color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                    )
                                                                                  : Container()
                                                                              : searchPageProvider.pollKeywordListCount > 1
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                  splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                  onTap: () {
                                                                                                    searchPageProvider.getsearchDataPoll(filterProvider.searchController.text, filterProvider.global, filterProvider.countryCode, filterProvider.twoValue, filterProvider.durationInDay, getnextPage: false);
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.transparent,
                                                                                                      borderRadius: BorderRadius.circular(25),
                                                                                                    ),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        const Icon(
                                                                                                          Icons.arrow_upward,
                                                                                                          size: 16,
                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
                                                                                                        ),
                                                                                                        const SizedBox(width: 8),
                                                                                                        Text('View ${((searchPageProvider.pollKeywordListCount - 2) * 10) + 1} - ${(searchPageProvider.pollKeywordListCount - 1) * 10}',
                                                                                                            style: const TextStyle(
                                                                                                              color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                    )
                                                                                  : Container(),
                                                                          ListView
                                                                              .builder(
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount: filterProvider.messages == "true"
                                                                                ? searchPageProvider.searchResult.length
                                                                                : searchPageProvider.searchResultPoll.length,
                                                                            itemBuilder: (context, index) =>
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.5),
                                                                              child: PhysicalModel(
                                                                                elevation: 2,
                                                                                color: Colors.transparent,
                                                                                child: Material(
                                                                                  color: Colors.white,
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.grey.withOpacity(0.25),
                                                                                    onTap: () async {
                                                                                      Future.delayed(const Duration(milliseconds: 250), () async {
                                                                                        filterProvider.setShowMessage(true);
                                                                                        filterProvider.messages == "true"
                                                                                            ? searchPageProvider.initList(
                                                                                                searchPageProvider.searchResult[index].keyName ?? "",
                                                                                                filterProvider.global,
                                                                                                filterProvider.countryCode,
                                                                                                filterProvider.oneValue,
                                                                                                filterProvider.twoValue,
                                                                                                filterProvider.durationInDay,
                                                                                              )
                                                                                            : searchPageProvider.initPollList(
                                                                                                searchPageProvider.searchResultPoll[index].keyName ?? "",
                                                                                                filterProvider.global,
                                                                                                filterProvider.countryCode,
                                                                                                filterProvider.oneValue,
                                                                                                filterProvider.twoValue,
                                                                                                filterProvider.durationInDay,
                                                                                              );
                                                                                        // filterProvider.messages == "true" ? initList(_searchResult[index].keyName ?? "") : initPollList(_searchResultPoll[index].keyName ?? "");
                                                                                        filterProvider.messages == "true" ? filterProvider.setTrendKeyStore(searchPageProvider.searchResult[index].keyName ?? "") : filterProvider.setTrendKeyStore(searchPageProvider.searchResultPoll[index].keyName ?? "");
                                                                                      });
                                                                                    },
                                                                                    child: SearchRadioListTile<String>(
                                                                                      center: filterProvider.messages == "true" ? searchPageProvider.searchResult[index].keyName ?? "" : searchPageProvider.searchResultPoll[index].keyName ?? "",
                                                                                      end: filterProvider.messages == "true" ? searchPageProvider.searchResult[index].length.toString() : searchPageProvider.searchResultPoll[index].length.toString(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          filterProvider.messages == "true"
                                                                              ? searchPageProvider.postKeywordLast == false
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                  splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                  onTap: () {
                                                                                                    // Future.delayed(
                                                                                                    //     const Duration(
                                                                                                    //         milliseconds:
                                                                                                    //             100),
                                                                                                    //     () {});
                                                                                                    // setState(() {
                                                                                                    //   getNextListSearchMeassage = true;
                                                                                                    // });
                                                                                                    searchPageProvider.getsearchData(
                                                                                                      filterProvider.searchController.text,
                                                                                                      filterProvider.global,
                                                                                                      filterProvider.countryCode,
                                                                                                      filterProvider.twoValue,
                                                                                                      filterProvider.durationInDay,
                                                                                                      getnextPage: true,
                                                                                                    );
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.transparent,
                                                                                                      borderRadius: BorderRadius.circular(25),
                                                                                                    ),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        const Icon(
                                                                                                          Icons.arrow_downward,
                                                                                                          size: 16,
                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
                                                                                                        ),
                                                                                                        const SizedBox(width: 8),
                                                                                                        Text("View ${(searchPageProvider.postKeywordListCount * 10) + 1} - ${(searchPageProvider.postKeywordListCount + 1) * 10}",
                                                                                                            // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                            style: const TextStyle(
                                                                                                              color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                    )
                                                                                  : Container()
                                                                              : searchPageProvider.pollKeywordLast == false
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                onTap: () {
                                                                                                  // Future.delayed(
                                                                                                  //     const Duration(
                                                                                                  //         milliseconds:
                                                                                                  //             100),
                                                                                                  //     () {});
                                                                                                  // setState(() {
                                                                                                  //   getNextListSearchPoll = true;
                                                                                                  // });
                                                                                                  searchPageProvider.getsearchDataPoll(filterProvider.searchController.text, filterProvider.global, filterProvider.countryCode, filterProvider.twoValue, filterProvider.durationInDay, getnextPage: true);
                                                                                                },
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.transparent,
                                                                                                    borderRadius: BorderRadius.circular(25),
                                                                                                  ),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      const Icon(
                                                                                                        Icons.arrow_downward,
                                                                                                        size: 16,
                                                                                                        color: Color.fromARGB(255, 81, 81, 81),
                                                                                                      ),
                                                                                                      const SizedBox(width: 8),
                                                                                                      Text(
                                                                                                        "View ${(searchPageProvider.pollKeywordListCount * 10) + 1} - ${(searchPageProvider.pollKeywordListCount + 1) * 10}",
                                                                                                        // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                        style: const TextStyle(
                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                    )
                                                                                  : Container()
                                                                        ],
                                                                      ),
                                                                    );
                                                        }),
                                                      )
                                                    : filterProvider.isAllKey == false &&
                                                            filterProvider
                                                                .searchController
                                                                .text
                                                                .isNotEmpty
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 6),
                                                            child: FutureBuilder(
                                                                // future: filterProvider
                                                                //             .messages ==
                                                                //         "true"
                                                                //     ? searchPageProvider
                                                                //         .getsearchData(
                                                                //         searchController
                                                                //             .text,
                                                                //         filterProvider
                                                                //             .global,
                                                                //         filterProvider
                                                                //             .countryCode,
                                                                //       )
                                                                //     : searchPageProvider
                                                                //         .getsearchDataPoll(
                                                                //         searchController
                                                                //             .text,
                                                                //         filterProvider
                                                                //             .global,
                                                                //         filterProvider
                                                                //             .countryCode,
                                                                //       ),
                                                                builder: (BuildContext context, snapshot) {
                                                              return searchPageProvider
                                                                          .Loading ==
                                                                      true
                                                                  ? const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    )
                                                                  : searchPageProvider.searchResult.isEmpty &&
                                                                              filterProvider.messages ==
                                                                                  "true" ||
                                                                          searchPageProvider.searchResultPoll.isEmpty &&
                                                                              filterProvider.messages != "true"
                                                                      ? Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: const [
                                                                              Text(
                                                                                'No keywords found.',
                                                                                style: TextStyle(color: Colors.grey, fontSize: 18),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              filterProvider.messages == "true"
                                                                                  ? searchPageProvider.postKeywordListCount > 1
                                                                                      ? Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                      splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                      onTap: () {
                                                                                                        // setState(() {
                                                                                                        //   searchPageProvider.getNextListSearchMeassage = false;
                                                                                                        // });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                        ),
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            const Icon(
                                                                                                              Icons.arrow_upward,
                                                                                                              size: 16,
                                                                                                              color: Color.fromARGB(255, 81, 81, 81),
                                                                                                            ),
                                                                                                            const SizedBox(width: 8),
                                                                                                            Text('View ${((searchPageProvider.postKeywordListCount - 2) * 10) + 1} - ${(searchPageProvider.postKeywordListCount - 1) * 10}',
                                                                                                                style: const TextStyle(
                                                                                                                  color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                        )
                                                                                      : Container()
                                                                                  : searchPageProvider.pollKeywordListCount > 1
                                                                                      ? Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                      splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                      onTap: () {
                                                                                                        // setState(() {
                                                                                                        //   getNextListSearchPoll = false;
                                                                                                        // });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                        ),
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            const Icon(
                                                                                                              Icons.arrow_upward,
                                                                                                              size: 16,
                                                                                                              color: Color.fromARGB(255, 81, 81, 81),
                                                                                                            ),
                                                                                                            const SizedBox(width: 8),
                                                                                                            Text('View ${((searchPageProvider.pollKeywordListCount - 2) * 10) + 1} - ${(searchPageProvider.pollKeywordListCount - 1) * 10}',
                                                                                                                style: const TextStyle(
                                                                                                                  color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                        )
                                                                                      : Container(),
                                                                              ListView.builder(
                                                                                physics: const NeverScrollableScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                itemCount: filterProvider.messages == "true" ? searchPageProvider.searchResult.length : searchPageProvider.searchResultPoll.length,
                                                                                itemBuilder: (context, index) => Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 3.5),
                                                                                  child: PhysicalModel(
                                                                                    elevation: 2,
                                                                                    color: Colors.transparent,
                                                                                    child: Material(
                                                                                      color: Colors.white,
                                                                                      child: InkWell(
                                                                                        splashColor: Colors.grey.withOpacity(0.25),
                                                                                        onTap: () async {
                                                                                          Future.delayed(const Duration(milliseconds: 250), () async {
                                                                                            filterProvider.setShowMessage(true);
                                                                                            filterProvider.messages == "true"
                                                                                                ? searchPageProvider.initList(
                                                                                                    searchPageProvider.searchResult[index].keyName ?? "",
                                                                                                    filterProvider.global,
                                                                                                    filterProvider.countryCode,
                                                                                                    filterProvider.oneValue,
                                                                                                    filterProvider.twoValue,
                                                                                                    filterProvider.durationInDay,
                                                                                                  )
                                                                                                : searchPageProvider.initPollList(
                                                                                                    searchPageProvider.searchResultPoll[index].keyName ?? "",
                                                                                                    filterProvider.global,
                                                                                                    filterProvider.countryCode,
                                                                                                    filterProvider.oneValue,
                                                                                                    filterProvider.twoValue,
                                                                                                    filterProvider.durationInDay,
                                                                                                  );
                                                                                            // filterProvider.messages == "true" ? initList(_searchResult[index].keyName ?? "") : initPollList(_searchResultPoll[index].keyName ?? "");
                                                                                            filterProvider.messages == "true" ? filterProvider.setTrendKeyStore(searchPageProvider.searchResult[index].keyName ?? "") : filterProvider.setTrendKeyStore(searchPageProvider.searchResultPoll[index].keyName ?? "");
                                                                                          });
                                                                                        },
                                                                                        child: SearchRadioListTile<String>(
                                                                                          center: filterProvider.messages == "true" ? searchPageProvider.searchResult[index].keyName ?? "" : searchPageProvider.searchResultPoll[index].keyName ?? "",
                                                                                          end: filterProvider.messages == "true" ? searchPageProvider.searchResult[index].length.toString() : searchPageProvider.searchResultPoll[index].length.toString(),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              filterProvider.messages == "true"
                                                                                  ? searchPageProvider.postKeywordLast == false
                                                                                      ? Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                      splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                      onTap: () {
                                                                                                        // Future.delayed(
                                                                                                        //     const Duration(
                                                                                                        //         milliseconds:
                                                                                                        //             100),
                                                                                                        //     () {});
                                                                                                        // setState(() {
                                                                                                        //   getNextListSearchMeassage = true;
                                                                                                        // });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                        ),
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            const Icon(
                                                                                                              Icons.arrow_downward,
                                                                                                              size: 16,
                                                                                                              color: Color.fromARGB(255, 81, 81, 81),
                                                                                                            ),
                                                                                                            const SizedBox(width: 8),
                                                                                                            Text("View ${(searchPageProvider.postKeywordListCount * 10) + 1} - ${(searchPageProvider.postKeywordListCount + 1) * 10}",
                                                                                                                // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                                style: const TextStyle(
                                                                                                                  color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                        )
                                                                                      : Container()
                                                                                  : searchPageProvider.pollKeywordLast == false
                                                                                      ? Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                      splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                      onTap: () {
                                                                                                        // Future.delayed(
                                                                                                        //     const Duration(
                                                                                                        //         milliseconds:
                                                                                                        //             100),
                                                                                                        //     () {});
                                                                                                        // setState(() {
                                                                                                        //   getNextListSearchPoll = true;
                                                                                                        // });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                        ),
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            const Icon(
                                                                                                              Icons.arrow_downward,
                                                                                                              size: 16,
                                                                                                              color: Color.fromARGB(255, 81, 81, 81),
                                                                                                            ),
                                                                                                            const SizedBox(width: 8),
                                                                                                            Text("View ${(searchPageProvider.pollKeywordListCount * 10) + 1} - ${(searchPageProvider.pollKeywordListCount + 1) * 10}",
                                                                                                                // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                                style: const TextStyle(
                                                                                                                  color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                        )
                                                                                      : Container()
                                                                            ],
                                                                          ),
                                                                        );
                                                            }),
                                                          )
                                                        : filterProvider.isMostLiked &&
                                                                filterProvider
                                                                    .searchController
                                                                    .text
                                                                    .isEmpty &&
                                                                filterProvider.showMessages ==
                                                                    false
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 6,
                                                                        bottom:
                                                                            3.5),
                                                                child: Consumer<
                                                                        MostLikedKeyProvider>(
                                                                    builder: (context,
                                                                        mostLikedKeyProvider,
                                                                        child) {
                                                                  return FutureBuilder(
                                                                    builder: (BuildContext
                                                                            context,
                                                                        snapshot) {
                                                                      return mostLikedKeyProvider.Loading ==
                                                                              true
                                                                          ? const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            )
                                                                          : mostLikedKeyProvider.list.isNotEmpty && filterProvider.messages == "true" || mostLikedKeyProvider.listPoll.isNotEmpty && filterProvider.messages != "true"
                                                                              ? SingleChildScrollView(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      filterProvider.messages == "true"
                                                                                          ? mostLikedKeyProvider.postKeywordListCount > 1
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.only(top: 3.5, bottom: 3.5),
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
                                                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                              onTap: () {
                                                                                                                mostLikedKeyProvider.getkeywordList(filterProvider.global, filterProvider.countryCode, getNextList1: false);
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.transparent,
                                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                                ),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    const Icon(
                                                                                                                      Icons.arrow_upward,
                                                                                                                      size: 16,
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                    ),
                                                                                                                    const SizedBox(width: 8),
                                                                                                                    Text('View ${((mostLikedKeyProvider.postKeywordListCount - 2) * 10) + 1} - ${(mostLikedKeyProvider.postKeywordListCount - 1) * 10}',
                                                                                                                        style: const TextStyle(
                                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container()
                                                                                          : mostLikedKeyProvider.pollKeywordListCount > 1
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.only(top: 3.5, bottom: 3.5),
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
                                                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                              onTap: () {
                                                                                                                mostLikedKeyProvider.getpollKeywordList(filterProvider.global, filterProvider.countryCode, getNextListPoll: false);
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.transparent,
                                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                                ),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    const Icon(
                                                                                                                      Icons.arrow_upward,
                                                                                                                      size: 16,
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                    ),
                                                                                                                    const SizedBox(width: 8),
                                                                                                                    Text('View ${((mostLikedKeyProvider.pollKeywordListCount - 2) * 10) + 1} - ${(mostLikedKeyProvider.pollKeywordListCount - 1) * 10}',
                                                                                                                        style: const TextStyle(
                                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container(),
                                                                                      ListView.builder(
                                                                                          physics: const NeverScrollableScrollPhysics(),
                                                                                          shrinkWrap: true,
                                                                                          itemCount: filterProvider.messages == "true" ? mostLikedKeyProvider.list.length : mostLikedKeyProvider.listPoll.length,
                                                                                          itemBuilder: (context, indexValue) {
                                                                                            return Padding(
                                                                                              padding: const EdgeInsets.symmetric(vertical: 3.5),
                                                                                              child: PhysicalModel(
                                                                                                elevation: 2,
                                                                                                color: Colors.transparent,
                                                                                                child: Material(
                                                                                                  color: Colors.white,
                                                                                                  child: InkWell(
                                                                                                    splashColor: Colors.grey.withOpacity(0.25),
                                                                                                    onTap: () async {
                                                                                                      await filterProvider.messages == "true"
                                                                                                          ? mostLikedKeyProvider.initList(
                                                                                                              mostLikedKeyProvider.list[indexValue].keyName ?? "",
                                                                                                              filterProvider.global,
                                                                                                              filterProvider.countryCode,
                                                                                                              filterProvider.oneValue,
                                                                                                            )
                                                                                                          : mostLikedKeyProvider.initPollList(
                                                                                                              mostLikedKeyProvider.listPoll[indexValue].keyName ?? "",
                                                                                                              filterProvider.global,
                                                                                                              filterProvider.countryCode,
                                                                                                              filterProvider.oneValue,
                                                                                                            );
                                                                                                      filterProvider.setisAllKey(false);
                                                                                                      filterProvider.setShowMessage(true);
                                                                                                      filterProvider.messages == "true" ? filterProvider.setTrendKeyStore(mostLikedKeyProvider.list[indexValue].keyName ?? "") : filterProvider.setTrendKeyStore(mostLikedKeyProvider.listPoll[indexValue].keyName ?? "");
                                                                                                      // filterProvider.messages == "true" ? filterProvider.setListPostPollId(mostLikedKeyProvider.list[indexValue].post_id ?? []) : filterProvider.setListPostPollId(mostLikedKeyProvider.listPoll[indexValue].pollId ?? []);
                                                                                                    },
                                                                                                    child: NoRadioListTile<String>(
                                                                                                      start: filterProvider.messages == "true" ? ((((mostLikedKeyProvider.postKeywordListCount - 1) * 10) + 1) + indexValue).toString() : ((((mostLikedKeyProvider.pollKeywordListCount - 1) * 10) + 1) + indexValue).toString(),
                                                                                                      center: filterProvider.messages == "true" ? mostLikedKeyProvider.list[indexValue].keyName ?? "" : mostLikedKeyProvider.listPoll[indexValue].keyName ?? "",
                                                                                                      end: filterProvider.messages == "true" ? mostLikedKeyProvider.list[indexValue].length.toString() : mostLikedKeyProvider.listPoll[indexValue].length.toString(),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          }),
                                                                                      filterProvider.messages == "true"
                                                                                          ? mostLikedKeyProvider.postKeywordLast == false
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.only(top: 3.5, bottom: 3.5),
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
                                                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                              onTap: () {
                                                                                                                mostLikedKeyProvider.getkeywordList(filterProvider.global, filterProvider.countryCode, getNextList1: true);
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.transparent,
                                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                                ),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    const Icon(
                                                                                                                      Icons.arrow_downward,
                                                                                                                      size: 16,
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                    ),
                                                                                                                    const SizedBox(width: 8),
                                                                                                                    Text("View ${(mostLikedKeyProvider.postKeywordListCount * 10) + 1} - ${(mostLikedKeyProvider.postKeywordListCount + 1) * 10}",
                                                                                                                        // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                                        style: const TextStyle(
                                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container()
                                                                                          : mostLikedKeyProvider.pollKeywordLast == false
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                              onTap: () {
                                                                                                                mostLikedKeyProvider.getpollKeywordList(filterProvider.global, filterProvider.countryCode, getNextListPoll: true);
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.transparent,
                                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                                ),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    const Icon(
                                                                                                                      Icons.arrow_downward,
                                                                                                                      size: 16,
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                    ),
                                                                                                                    const SizedBox(width: 8),
                                                                                                                    Text("View ${(mostLikedKeyProvider.pollKeywordListCount * 10) + 1} - ${(mostLikedKeyProvider.pollKeywordListCount + 1) * 10}",
                                                                                                                        // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                                        style: const TextStyle(
                                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container()
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : Center(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: const [
                                                                                      Text(
                                                                                        'No trending keywords yet.',
                                                                                        style: TextStyle(color: Colors.grey, fontSize: 18),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                    },
                                                                  );
                                                                }),
                                                              )
                                                            : filterProvider.isMostLiked &&
                                                                    filterProvider
                                                                        .searchController
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    filterProvider.showMessages ==
                                                                        false
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 6,
                                                                        bottom:
                                                                            3.5),
                                                                    child: Consumer<
                                                                            MostLikedKeyProvider>(
                                                                        builder: (context,
                                                                            mostLikedKeyProvider,
                                                                            child) {
                                                                      // print(
                                                                      //     "filterProvider.messages ${mostLikedKeyProvider.searchResultPoll}");
                                                                      return mostLikedKeyProvider.Loading ==
                                                                              true
                                                                          ? const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            )
                                                                          : mostLikedKeyProvider.searchResult.isEmpty && filterProvider.messages == "true" && filterProvider.showMessages == false || mostLikedKeyProvider.searchResultPoll.isEmpty && filterProvider.messages != "true" && filterProvider.showMessages == false
                                                                              ? Center(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: const [
                                                                                      Text(
                                                                                        'No keywords found.',
                                                                                        style: TextStyle(color: Colors.grey, fontSize: 18),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : SingleChildScrollView(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      filterProvider.messages == "true"
                                                                                          ? mostLikedKeyProvider.postKeywordListCount > 1
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                              onTap: () {
                                                                                                                mostLikedKeyProvider.getsearchData(
                                                                                                                  filterProvider.searchController.text,
                                                                                                                  filterProvider.global,
                                                                                                                  filterProvider.countryCode,
                                                                                                                  getnextPage: false,
                                                                                                                );
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.transparent,
                                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                                ),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    const Icon(
                                                                                                                      Icons.arrow_upward,
                                                                                                                      size: 16,
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                    ),
                                                                                                                    const SizedBox(width: 8),
                                                                                                                    Text('View ${((mostLikedKeyProvider.postKeywordListCount - 2) * 10) + 1} - ${(mostLikedKeyProvider.postKeywordListCount - 1) * 10}',
                                                                                                                        style: const TextStyle(
                                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container()
                                                                                          : mostLikedKeyProvider.pollKeywordListCount > 1
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                              onTap: () {
                                                                                                                mostLikedKeyProvider.getsearchDataPoll(filterProvider.searchController.text, filterProvider.global, filterProvider.countryCode, getnextPage: false);
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.transparent,
                                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                                ),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    const Icon(
                                                                                                                      Icons.arrow_upward,
                                                                                                                      size: 16,
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                    ),
                                                                                                                    const SizedBox(width: 8),
                                                                                                                    Text('View ${((mostLikedKeyProvider.pollKeywordListCount - 2) * 10) + 1} - ${(mostLikedKeyProvider.pollKeywordListCount - 1) * 10}',
                                                                                                                        style: const TextStyle(
                                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container(),
                                                                                      ListView.builder(
                                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        itemCount: filterProvider.messages == "true" ? mostLikedKeyProvider.searchResult.length : mostLikedKeyProvider.searchResultPoll.length,
                                                                                        itemBuilder: (context, index) => Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3.5),
                                                                                          child: PhysicalModel(
                                                                                            elevation: 2,
                                                                                            color: Colors.transparent,
                                                                                            child: Material(
                                                                                              color: Colors.white,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.grey.withOpacity(0.25),
                                                                                                onTap: () async {
                                                                                                  Future.delayed(const Duration(milliseconds: 250), () async {
                                                                                                    filterProvider.setShowMessage(true);
                                                                                                    filterProvider.messages == "true"
                                                                                                        ? mostLikedKeyProvider.initList(
                                                                                                            mostLikedKeyProvider.list[index].keyName ?? "",
                                                                                                            filterProvider.global,
                                                                                                            filterProvider.countryCode,
                                                                                                            filterProvider.oneValue,
                                                                                                          )
                                                                                                        : mostLikedKeyProvider.initPollList(
                                                                                                            mostLikedKeyProvider.listPoll[index].keyName ?? "",
                                                                                                            filterProvider.global,
                                                                                                            filterProvider.countryCode,
                                                                                                            filterProvider.oneValue,
                                                                                                          );
                                                                                                    // filterProvider.messages == "true" ? initList(_searchResult[index].keyName ?? "") : initPollList(_searchResultPoll[index].keyName ?? "");
                                                                                                    filterProvider.messages == "true" ? filterProvider.setTrendKeyStore(mostLikedKeyProvider.searchResult[index].keyName ?? "") : filterProvider.setTrendKeyStore(mostLikedKeyProvider.searchResultPoll[index].keyName ?? "");
                                                                                                    // filterProvider.messages == "true" ? filterProvider.setListPostPollId(mostLikedKeyProvider.list[index].post_id ?? []) : filterProvider.setListPostPollId(mostLikedKeyProvider.listPoll[index].pollId ?? []);
                                                                                                  });
                                                                                                },
                                                                                                child: SearchRadioListTile<String>(
                                                                                                  center: filterProvider.messages == "true" ? mostLikedKeyProvider.searchResult[index].keyName ?? "" : mostLikedKeyProvider.searchResultPoll[index].keyName ?? "",
                                                                                                  end: filterProvider.messages == "true" ? mostLikedKeyProvider.searchResult[index].length.toString() : mostLikedKeyProvider.searchResultPoll[index].length.toString(),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      filterProvider.messages == "true"
                                                                                          ? mostLikedKeyProvider.postKeywordLast == false
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                              splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                              onTap: () {
                                                                                                                mostLikedKeyProvider.getsearchData(
                                                                                                                  filterProvider.searchController.text,
                                                                                                                  filterProvider.global,
                                                                                                                  filterProvider.countryCode,
                                                                                                                  getnextPage: true,
                                                                                                                );
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.transparent,
                                                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                                                ),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  children: [
                                                                                                                    const Icon(
                                                                                                                      Icons.arrow_downward,
                                                                                                                      size: 16,
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                    ),
                                                                                                                    const SizedBox(width: 8),
                                                                                                                    Text("View ${(mostLikedKeyProvider.postKeywordListCount * 10) + 1} - ${(mostLikedKeyProvider.postKeywordListCount + 1) * 10}",
                                                                                                                        // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                                        style: const TextStyle(
                                                                                                                          color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container()
                                                                                          : mostLikedKeyProvider.pollKeywordLast == false
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 3.5),
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
                                                                                                            splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                            onTap: () {
                                                                                                              // Future.delayed(
                                                                                                              //     const Duration(
                                                                                                              //         milliseconds:
                                                                                                              //             100),
                                                                                                              //     () {});
                                                                                                              // setState(() {
                                                                                                              //   getNextListSearchPoll = true;
                                                                                                              // });
                                                                                                              mostLikedKeyProvider.getsearchDataPoll(filterProvider.searchController.text, filterProvider.global, filterProvider.countryCode, getnextPage: true);
                                                                                                            },
                                                                                                            child: Container(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Colors.transparent,
                                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                                              ),
                                                                                                              child: Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  const Icon(
                                                                                                                    Icons.arrow_downward,
                                                                                                                    size: 16,
                                                                                                                    color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                  ),
                                                                                                                  const SizedBox(width: 8),
                                                                                                                  Text(
                                                                                                                    "View ${(mostLikedKeyProvider.pollKeywordListCount * 10) + 1} - ${(mostLikedKeyProvider.pollKeywordListCount + 1) * 10}",
                                                                                                                    // '${keywordCount * 10 + 1} - ${(keywordCount + 1) * 10}',
                                                                                                                    style: const TextStyle(
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                                )
                                                                                              : Container()
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                    }),
                                                                  )
                                                                : filterProvider.showMessages == true && filterProvider.isMostLiked == true
                                                                    ? Consumer<MostLikedKeyProvider>(builder: (context, mostLikedKeyProvider, child) {
                                                                        return mostLikedKeyProvider.Loading ==
                                                                                true
                                                                            ? const Center(
                                                                                child: CircularProgressIndicator(),
                                                                              )
                                                                            : filterProvider.showMessages == true && filterProvider.isUser == false && mostLikedKeyProvider.postsList.isNotEmpty && filterProvider.messages == "true" || filterProvider.showMessages == true && filterProvider.isUser == false && mostLikedKeyProvider.pollsList.isNotEmpty && filterProvider.messages != "true"
                                                                                ? SingleChildScrollView(
                                                                                    controller: mostLikedKeyProvider.scrollController,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        filterProvider.messages == "true"
                                                                                            ? Visibility(
                                                                                                visible: mostLikedKeyProvider.previousButtonVisible,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(top: 10),
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
                                                                                                            splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                            onTap: () {
                                                                                                              Future.delayed(
                                                                                                                const Duration(milliseconds: 100),
                                                                                                                () {
                                                                                                                  if (filterProvider.messages == "true") {
                                                                                                                    mostLikedKeyProvider.initList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: false);
                                                                                                                  } else {
                                                                                                                    mostLikedKeyProvider.initPollList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: false);
                                                                                                                  }
                                                                                                                },
                                                                                                              );
                                                                                                            },
                                                                                                            child: Container(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Colors.transparent,
                                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                                              ),
                                                                                                              child: Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  const Icon(
                                                                                                                    Icons.arrow_upward,
                                                                                                                    size: 16,
                                                                                                                    color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                  ),
                                                                                                                  const SizedBox(width: 8),
                                                                                                                  Text(
                                                                                                                    'View ${(mostLikedKeyProvider.postPageCount - 2) * 6 + 1} - ${(mostLikedKeyProvider.postPageCount - 1) * 6}',
                                                                                                                    style: const TextStyle(
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                              )
                                                                                            : Visibility(
                                                                                                visible: mostLikedKeyProvider.previousButtonVisible,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(top: 10),
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
                                                                                                            splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                            onTap: () {
                                                                                                              Future.delayed(
                                                                                                                const Duration(milliseconds: 100),
                                                                                                                () {
                                                                                                                  if (filterProvider.messages == "true") {
                                                                                                                    mostLikedKeyProvider.initList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: false);
                                                                                                                  } else {
                                                                                                                    mostLikedKeyProvider.initPollList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: false);
                                                                                                                  }
                                                                                                                },
                                                                                                              );
                                                                                                            },
                                                                                                            child: Container(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Colors.transparent,
                                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                                              ),
                                                                                                              child: Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  const Icon(
                                                                                                                    Icons.arrow_upward,
                                                                                                                    size: 16,
                                                                                                                    color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                  ),
                                                                                                                  const SizedBox(width: 8),
                                                                                                                  Text(
                                                                                                                    'View ${(mostLikedKeyProvider.pollPageCount - 2) * 6 + 1} - ${(mostLikedKeyProvider.pollPageCount - 1) * 6}',
                                                                                                                    style: const TextStyle(
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                        // Consumer2<PostProvider, PollsProvider>(
                                                                                        //     builder: (context, postProvider,
                                                                                        //         pollProvider, child) {
                                                                                        //   forsetInitState(
                                                                                        //       postProvider, pollProvider);
                                                                                        //   return
                                                                                        ListView.builder(
                                                                                          physics: const NeverScrollableScrollPhysics(),
                                                                                          shrinkWrap: true,
                                                                                          itemCount: filterProvider.messages == "true" ? mostLikedKeyProvider.postsList.length : mostLikedKeyProvider.pollsList.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            final User? user = Provider.of<UserProvider>(context).getUser;
                                                                                            return filterProvider.messages == "true"
                                                                                                ? PostCardTest(key: Key(mostLikedKeyProvider.postsList[index].postId), post: mostLikedKeyProvider.postsList[index], archives: true, profileScreen: false, durationInDay: widget.durationInDay
                                                                                                    // currentUserId: null,
                                                                                                    )
                                                                                                : PollCard(key: Key(mostLikedKeyProvider.pollsList[index].pollId), poll: mostLikedKeyProvider.pollsList[index], archives: true, profileScreen: false, durationInDay: widget.durationInDay
                                                                                                    // currentUserId: null,
                                                                                                    );
                                                                                          },
                                                                                        ),
                                                                                        // }),
                                                                                        filterProvider.messages == "true"
                                                                                            ? Visibility(
                                                                                                visible: mostLikedKeyProvider.nextButtonVisible,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                                                                                                            splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                            onTap: () {
                                                                                                              Future.delayed(
                                                                                                                const Duration(milliseconds: 100),
                                                                                                                () {
                                                                                                                  if (filterProvider.messages == "true") {
                                                                                                                    mostLikedKeyProvider.initList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: true);
                                                                                                                  } else {
                                                                                                                    mostLikedKeyProvider.initPollList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: true);
                                                                                                                  }
                                                                                                                },
                                                                                                              );
                                                                                                            },
                                                                                                            child: Container(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Colors.transparent,
                                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                                              ),
                                                                                                              child: Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  const Icon(
                                                                                                                    Icons.arrow_downward,
                                                                                                                    size: 16,
                                                                                                                    color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                  ),
                                                                                                                  const SizedBox(width: 8),
                                                                                                                  Text(
                                                                                                                    'View ${mostLikedKeyProvider.postPageCount * 6 + 1} - ${(mostLikedKeyProvider.postPageCount + 1) * 6}',
                                                                                                                    style: const TextStyle(
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                              )
                                                                                            : Visibility(
                                                                                                visible: mostLikedKeyProvider.nextButtonVisible,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                                                                                                            splashColor: const Color.fromARGB(255, 245, 245, 245),
                                                                                                            onTap: () {
                                                                                                              Future.delayed(
                                                                                                                const Duration(milliseconds: 100),
                                                                                                                () {
                                                                                                                  if (filterProvider.messages == "true") {
                                                                                                                    mostLikedKeyProvider.initList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: true);
                                                                                                                  } else {
                                                                                                                    mostLikedKeyProvider.initPollList(filterProvider.trendkeystore ?? "", filterProvider.global, filterProvider.countryCode, filterProvider.oneValue, getNextList: true);
                                                                                                                  }
                                                                                                                },
                                                                                                              );
                                                                                                            },
                                                                                                            child: Container(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Colors.transparent,
                                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                                              ),
                                                                                                              child: Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  const Icon(
                                                                                                                    Icons.arrow_downward,
                                                                                                                    size: 16,
                                                                                                                    color: Color.fromARGB(255, 81, 81, 81),
                                                                                                                  ),
                                                                                                                  const SizedBox(width: 8),
                                                                                                                  Text(
                                                                                                                    'View ${mostLikedKeyProvider.pollPageCount * 6 + 1} - ${(mostLikedKeyProvider.pollPageCount + 1) * 6}',
                                                                                                                    // '${(postPageCount - 2) * 10 + 1} - ${(postPageCount - 1) * 10}',
                                                                                                                    style: const TextStyle(
                                                                                                                      color: Color.fromARGB(255, 81, 81, 81),
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
                                                                                              )
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                : filterProvider.showMessages == true && filterProvider.isUser == false && mostLikedKeyProvider.postsList.isEmpty && filterProvider.messages == "true"
                                                                                    ? Center(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: const [
                                                                                            Text(
                                                                                              'No messages found.',
                                                                                              style: TextStyle(color: Colors.grey, fontSize: 18),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : filterProvider.showMessages == true && filterProvider.isUser == false && mostLikedKeyProvider.pollsList.isEmpty && filterProvider.messages != "true"
                                                                                        ? Center(
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Column(
                                                                                                  children: const [
                                                                                                    Text(
                                                                                                      'No polls found.',
                                                                                                      style: TextStyle(color: Colors.grey, fontSize: 18),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        : Container();
                                                                      })
                                                                    : Container();
                              });
              },
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
      ),
    );
  }
}

class NoRadioListTile<T> extends StatefulWidget {
  final String start;
  final String center;
  final String end;

  const NoRadioListTile({
    super.key,
    required this.start,
    required this.center,
    required this.end,
  });

  @override
  State<NoRadioListTile<T>> createState() => _NoRadioListTileState<T>();
}

class _NoRadioListTileState<T> extends State<NoRadioListTile<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.start}.',
              style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Text(
                widget.center,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 81, 81, 81),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              '(${widget.end})',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchRadioListTile<T> extends StatefulWidget {
  final String center;
  final String end;

  const SearchRadioListTile({
    super.key,
    required this.center,
    required this.end,
  });

  @override
  State<SearchRadioListTile<T>> createState() => _SearchRadioListTileState<T>();
}

class _SearchRadioListTileState<T> extends State<SearchRadioListTile<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 81, 81, 81),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Text(
              '(${widget.end})',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
