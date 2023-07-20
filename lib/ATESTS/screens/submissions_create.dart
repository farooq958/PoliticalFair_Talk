import 'dart:async';
import 'dart:io';

import 'package:aft/ATESTS/screens/statistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../methods/firestore_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class SubmissionCreate extends StatefulWidget {
  const SubmissionCreate({
    Key? key,
    this.durationInDay,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final durationInDay;

  @override
  State<SubmissionCreate> createState() => _SubmissionCreateState();
}

class Customer {
  String tagName;
  int tagValue;

  Customer(this.tagName, this.tagValue);

  @override
  String toString() {
    return '{ $tagName, $tagValue }';
  }
}

class _SubmissionCreateState extends State<SubmissionCreate> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final int _messageTitleTextfieldMaxLength = 999;
  User? user;
  var snap;
  bool _isLoading = false;
  bool isFairtalk = false;
  bool isDetailed = false;
  bool isWaitingMessage = false;
  int getCounterPost = 0;

  // InterstitialAd? interstitialAd;

  // final String interstitialAdUnitIdIOS =
  //     'ca-app-pub-1591305463797264/4735037493';
  // final String interstitialAdUnitIdAndroid =
  //     'ca-app-pub-1591305463797264/9016556769';

  void initState() {
    super.initState();
    // _loadInterstitialAd();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose;
  }

  void waitSubmission({required int time}) async {
    try {
      String res = await AuthMethods().waitSubmission(
        time: time,
      );
    } catch (e) {
      //
    }
  }

  final CollectionReference firestoreInstance =
      FirebaseFirestore.instance.collection('aPostCounter');

  Future<String> _loadMessageCounter() async {
    String res1 = "Some error occurred.";
    try {
      await firestoreInstance.doc('messageCounter').get().then((event) {
        setState(() {
          getCounterPost = event['counter'];
        });
      });
      res1 = "success";
    } catch (e) {
      //
    }
    return res1;
  }

  // void _loadInterstitialAd() {
  //   if (Platform.isIOS) {
  //     InterstitialAd.load(
  //       adUnitId: interstitialAdUnitIdIOS,

  //       request: const AdRequest(),
  //       adLoadCallback:
  //           InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
  //         interstitialAd = ad;

  //         _setFullScreenContentCallback(ad);
  //       }, onAdFailedToLoad: (LoadAdError loadAdError) {
  //         debugPrint('$loadAdError');
  //       }),
  //       // orientation: AppOpenAd.orientationPortrait,
  //     );
  //   } else if (Platform.isAndroid) {
  //     InterstitialAd.load(
  //       adUnitId: interstitialAdUnitIdAndroid,
  //       request: const AdRequest(),
  //       adLoadCallback:
  //           InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
  //         interstitialAd = ad;

  //         _setFullScreenContentCallback(ad);
  //       }, onAdFailedToLoad: (LoadAdError loadAdError) {
  //         debugPrint('$loadAdError');
  //       }),
  //       // orientation: AppOpenAd.orientationPortrait,
  //     );
  //   }
  // }

  // void _setFullScreenContentCallback(InterstitialAd ad) {
  //   ad.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) => print('$ad'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       debugPrint('$ad');
  //       // isWaitingMessage = true;
  //       showSnackBar(
  //         'Ballot successfully created.',
  //         context,
  //       );
  //       ballotMessage(context: context);
  //       ad.dispose();
  //       interstitialAd = null;
  //       _loadInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       debugPrint('$ad - error: $error');
  //       ad.dispose();
  //       interstitialAd = null;
  //       _loadInterstitialAd();
  //     },
  //     onAdImpression: (InterstitialAd ad) =>
  //         debugPrint('$ad Impression occurred'),
  //   );
  // }

  // void _showInterstitialAd() {
  //   interstitialAd?.show();
  // }

  void postImage(String uid, String username, String profImage, String sub,
      bool bot) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res1 = await _loadMessageCounter();
      String res = await FirestoreMethods().uploadPost(
        uid,
        username,
        profImage,
        '',
        'true',
        _titleController.text,
        _bodyController.text,
        '',
        '',
        getCounterPost,
        1,
        sub,
        bot,
        null,
      );
      if (res == "success" && res1 == "success") {
        Future.delayed(const Duration(milliseconds: 1500), () {
          // _showInterstitialAd();
          FocusScope.of(context).unfocus();
          _titleController.clear();

          setState(() {
            _isLoading = false;
          });

          showSnackBar(
            'Ballot successfully created.',
            context,
          );
          // ballotMessage(context: context);

          sub == 'fairtalk' ? null : waitSubmission(time: widget.durationInDay);
        });
      } else {
        // showSnackBar(res, context);
      }
      // }
    } catch (e) {
      showSnackBarError(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;

    return user == null
        ? buildSubmission(context)
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.UID ?? '')
                .snapshots(),
            builder: (content,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.data?.data() != null) {
                snap = snapshot.data != null
                    ? User.fromSnap(snapshot.data!)
                    : snap;

                return buildSubmission(context, snapshot);
              } else {
                return buildSubmission(context);
              }
            });
  }

  Widget buildSubmission(BuildContext context,
      [AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>? snapshot]) {
    User? user;
    user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: testing,
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: darkBlue,
                  elevation: 4,
                  toolbarHeight: 56,
                  actions: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                left: 5,
                                top: 8,
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Material(
                                    shape: const CircleBorder(),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      splashColor: Colors.grey.withOpacity(0.5),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(milliseconds: 50),
                                          () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.close,
                                          color: whiteDialog, size: 27),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 0, top: 16.5),
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: Text(
                                    "Create a Ballot",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 5),
                          _isLoading
                              ? const LinearProgressIndicator(
                                  color: Colors.white)
                              : const Padding(padding: EdgeInsets.only(top: 0))
                        ],
                      ),
                    ),
                  ]),
              body: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Column(
                                children: [
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 6, right: 8, left: 8),
                                  //   decoration: BoxDecoration(
                                  //     color: whiteDialog,
                                  //     borderRadius: const BorderRadius.only(
                                  //         topRight: Radius.circular(25),
                                  //         topLeft: Radius.circular(25)),
                                  //     border:
                                  //         Border.all(width: 5, color: darkBlue),
                                  //   ),
                                  //   child: Column(
                                  //     children: [
                                  //       const Text(
                                  //         'Tired of these guys dictating the direction of social media?',
                                  //         textAlign: TextAlign.center,
                                  //         style: TextStyle(
                                  //           color: darkBlue,
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         width: 280,
                                  //         child: Image.asset(
                                  //           'assets/musk-zuck.png',
                                  //           opacity:
                                  //               const AlwaysStoppedAnimation(
                                  //                   .9),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // PhysicalModel(
                                  //   color: darkBlue,
                                  //   elevation: 3,
                                  //   borderRadius: const BorderRadius.only(
                                  //       bottomRight: Radius.circular(25),
                                  //       bottomLeft: Radius.circular(25)),
                                  //   child: Container(
                                  //     width: MediaQuery.of(context).size.width,
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 12, vertical: 5),
                                  //     decoration: const BoxDecoration(
                                  //       borderRadius: BorderRadius.only(
                                  //           bottomRight: Radius.circular(25),
                                  //           bottomLeft: Radius.circular(25)),
                                  //       color: darkBlue,
                                  //     ),
                                  //     child: Padding(
                                  //       padding: EdgeInsets.only(
                                  //           bottom: isDetailed ? 15 : 0),
                                  //       child: Column(
                                  //         children: [
                                  //           InkWell(
                                  //             onTap: () {
                                  //               setState(() {
                                  //                 isDetailed = !isDetailed;
                                  //               });
                                  //             },
                                  //             child: Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   bottom: 4,
                                  //                   top: 8,
                                  //                   right: 10,
                                  //                   left: 10),
                                  //               child: Container(
                                  //                 width: MediaQuery.of(context)
                                  //                     .size
                                  //                     .width,
                                  //                 child: Column(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .spaceBetween,
                                  //                   children: [
                                  //                    const Text(
                                  //                       "Learn how FairTalk is replacing CEO's with a democratic system.",
                                  //                       textAlign:
                                  //                           TextAlign.center,
                                  //                       style: TextStyle(
                                  //                         color: whiteDialog,
                                  //                         letterSpacing: 0,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                         fontSize: 16,
                                  //                         overflow: TextOverflow
                                  //                             .visible,
                                  //                       ),
                                  //                     ),
                                  //                     Icon(
                                  //                         isDetailed
                                  //                             ? Icons
                                  //                                 .keyboard_arrow_up
                                  //                             : Icons
                                  //                                 .keyboard_arrow_down,
                                  //                         color: whiteDialog,
                                  //                         size: 28),
                                  //                     // const SizedBox(height: 8),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           isDetailed
                                  //               ? Padding(
                                  //                   padding: const EdgeInsets
                                  //                           .symmetric(
                                  //                       horizontal: 10),
                                  //                   child: Column(
                                  //                     // crossAxisAlignment:
                                  //                     //     CrossAxisAlignment
                                  //                     //         .start,
                                  //                     children: [
                                  //                       Container(
                                  //                         decoration:
                                  //                             const BoxDecoration(
                                  //                           border: Border(
                                  //                             top: BorderSide(
                                  //                                 color:
                                  //                                     whiteDialog,
                                  //                                 width: 0),
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 10),
                                  //                       Text(
                                  //                         "Creating Ballots",
                                  //                         textAlign:
                                  //                             TextAlign.center,
                                  //                         style: TextStyle(
                                  //                             letterSpacing: 0,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .bold,
                                  //                             color: whiteDialog
                                  //                                 .withOpacity(
                                  //                                     0.8),
                                  //                             fontSize: 16),
                                  //                       ),
                                  //                       Text(
                                  //                         "When you create a ballot, you're deciding which new features you want us to add, remove or modify from our platform. The ballot that receives the highest score every month will be added to the \"Winning Ballots\" list & will also become the newest feature that we will develop.",
                                  //                         style: TextStyle(
                                  //                           color: whiteDialog
                                  //                               .withOpacity(
                                  //                                   0.8),
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 13,
                                  //                         ),
                                  //                         textAlign:
                                  //                             TextAlign.center,
                                  //                       ),
                                  //                       const SizedBox(
                                  //                           height: 8),
                                  //                       Text(
                                  //                         "Rules",
                                  //                         textAlign:
                                  //                             TextAlign.center,
                                  //                         style: TextStyle(
                                  //                             letterSpacing: 0,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .bold,
                                  //                             color: whiteDialog
                                  //                                 .withOpacity(
                                  //                                     0.8),
                                  //                             fontSize: 16),
                                  //                       ),
                                  //                       Text(
                                  //                         "We want to give as much power & freedom as possible to our users. And for this reason, there are no rules. As long as your feature complies with both major App Stores, we'll do our very best to implement it.",
                                  //                         style: TextStyle(
                                  //                           color: whiteDialog
                                  //                               .withOpacity(
                                  //                                   0.8),
                                  //                           fontWeight:
                                  //                               FontWeight.w500,
                                  //                           fontSize: 13,
                                  //                         ),
                                  //                         textAlign:
                                  //                             TextAlign.center,
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 )
                                  //               : const SizedBox(),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 12),
                                  PhysicalModel(
                                    elevation: 3,
                                    color: darkBlue,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PhysicalModel(
                                            elevation: 0,
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(25),
                                                    topLeft:
                                                        Radius.circular(25)),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(25),
                                                        topLeft:
                                                            Radius.circular(
                                                                25)),
                                                border: Border.all(
                                                    color: darkBlue, width: 5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Icon(Icons.info_outline,
                                                    //     color: Colors.grey,
                                                    //     size: 18),
                                                    const Text(
                                                      "A guide for creating Ballots.",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: darkBlue,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Text(
                                                          "1. Be creative. This is finally your chance to control the direction of a social media platform, do we want FairTalk to be unique or resemble other platforms?",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            color: darkBlue,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(height: 6),
                                                        Text(
                                                          "2. Be descriptive. The goal is to implement your vision, not ours. Share as many details as you possibly can.",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            color: darkBlue,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(height: 6),
                                                        Text(
                                                          "3. Be realistic. Running FairTalk isn't free, server operations can be very expensive.",
                                                          // If it is financially impossible to implement certain features, we'll propose several alternatives. If the majority declines all alternatives, we'll simply have to move on.
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            color: darkBlue,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(height: 6),
                                                        Text(
                                                          "4. Be wild. You can modify our Privacy/Terms statements, you can replace FairTalk's current CEO. You can add, remove or modify just about anything.",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            color: darkBlue,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: WillPopScope(
                                                    onWillPop: () async {
                                                      return false;
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        TextField(
                                                          cursorColor:
                                                              whiteDialog,
                                                          style: const TextStyle(
                                                              color:
                                                                  whiteDialog),
                                                          maxLength:
                                                              _messageTitleTextfieldMaxLength,
                                                          onChanged: (val) {
                                                            setState(() {});
                                                          },
                                                          controller:
                                                              _titleController,
                                                          onTap: () {},
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Create a ballot",
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: whiteDialog
                                                                      .withOpacity(
                                                                          0.7),
                                                                  width: 2),
                                                            ),
                                                            focusedBorder:
                                                                const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          whiteDialog,
                                                                      width: 2),
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    left: 4,
                                                                    right: 45,
                                                                    bottom: 8),
                                                            isDense: true,
                                                            hintStyle:
                                                                TextStyle(
                                                              color: whiteDialog
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            labelStyle:
                                                                const TextStyle(
                                                                    color:
                                                                        whiteDialog),
                                                            counterText: '',
                                                          ),
                                                          maxLines: null,
                                                        ),
                                                        Positioned(
                                                          bottom: 5,
                                                          right: 0,
                                                          child: Text(
                                                            '${_titleController.text.length}/$_messageTitleTextfieldMaxLength',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: _titleController
                                                                          .text
                                                                          .length ==
                                                                      _messageTitleTextfieldMaxLength
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      220,
                                                                      105,
                                                                      96)
                                                                  : whiteDialog
                                                                      .withOpacity(
                                                                          0.7),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(height: 30),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: WillPopScope(
                                                    onWillPop: () async {
                                                      return false;
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        TextField(
                                                          cursorColor:
                                                              whiteDialog,
                                                          style: const TextStyle(
                                                              color:
                                                                  whiteDialog),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              // emptyPollQuestion = false;
                                                            });
                                                          },
                                                          controller:
                                                              _bodyController,
                                                          onTap: () {},
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Additional text (optional)",
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: whiteDialog
                                                                      .withOpacity(
                                                                          0.7),
                                                                  width: 2),
                                                            ),
                                                            focusedBorder:
                                                                const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          whiteDialog,
                                                                      width: 2),
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    left: 4,
                                                                    right: 45,
                                                                    bottom: 8),
                                                            isDense: true,
                                                            hintStyle:
                                                                TextStyle(
                                                              color: whiteDialog
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            labelStyle:
                                                                const TextStyle(
                                                              color:
                                                                  whiteDialog,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            counterText: '',
                                                          ),
                                                          maxLines: null,
                                                        ),
                                                        Positioned(
                                                          bottom: 5,
                                                          right: 0,
                                                          child: Text(
                                                            'unlimited',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: whiteDialog
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(height: 30),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            user == null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PhysicalModel(
                                        elevation: 3,
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(50),
                                        child: Material(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: InkWell(
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 150), () {
                                                performLoggedUserAction(
                                                    context: context,
                                                    action: () {});
                                              });
                                            },
                                            child: SizedBox(
                                              height: 42,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(Icons.send,
                                                        color: whiteDialog,
                                                        size: 19),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Send Ballot',
                                                      style: TextStyle(
                                                          color: whiteDialog,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          letterSpacing: 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : user != null && snapshot?.data != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          PhysicalModel(
                                            elevation: 3,
                                            color: whiteDialog,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Material(
                                              color: user == null
                                                  ? Colors.blue
                                                  : snap?.submissionTime ==
                                                          widget.durationInDay
                                                      ? whiteDialog
                                                      : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                splashColor: Colors.black
                                                    .withOpacity(0.3),
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 150),
                                                      () {
                                                    performLoggedUserAction(
                                                        context: context,
                                                        action: () {
                                                          snap?.submissionTime ==
                                                                  widget
                                                                      .durationInDay
                                                              ? sendTimerBallot(
                                                                  context:
                                                                      context,
                                                                  type:
                                                                      'Ballot',
                                                                )
                                                              : _titleController
                                                                      .text
                                                                      .trim()
                                                                      .isEmpty
                                                                  ? showSnackBarError(
                                                                      'Create a ballot text field cannot be empty.',
                                                                      context)
                                                                  : postImage(
                                                                      user?.UID ??
                                                                          '',
                                                                      user?.username ??
                                                                          '',
                                                                      user?.photoUrl ??
                                                                          '',
                                                                      user?.username ==
                                                                              'FairTalk'
                                                                          ? 'fairtalk'
                                                                          : 'sub',
                                                                      user?.admin ==
                                                                              true
                                                                          ? true
                                                                          : false);
                                                        });
                                                  });
                                                },
                                                child: SizedBox(
                                                  height: 42,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            snap?.submissionTime ==
                                                                    widget
                                                                        .durationInDay
                                                                ? Icons.timer
                                                                : Icons.send,
                                                            color: snap?.submissionTime ==
                                                                    widget
                                                                        .durationInDay
                                                                ? darkBlue
                                                                : whiteDialog,
                                                            size: 18),
                                                        const SizedBox(
                                                            width: 10),
                                                        snap?.submissionTime ==
                                                                widget
                                                                    .durationInDay
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                    'Waiting Time',
                                                                    style: TextStyle(
                                                                        color:
                                                                            darkBlue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16,
                                                                        letterSpacing:
                                                                            0),
                                                                  ),
                                                                ],
                                                              )
                                                            : const Text(
                                                                'Send Ballot',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      whiteDialog,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
