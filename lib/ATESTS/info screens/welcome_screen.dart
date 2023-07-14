import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/add_post_daily.dart';
import '../screens/verify_one.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'how_it_works.dart';

class WelcomeScreen extends StatefulWidget {
  var username;

  WelcomeScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isVerifyDialog = false;

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                darkBlue,
                testColor,
              ],
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 30),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 1 - 40,
                            child: Image.asset('assets/fairtalk_white.png')),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1 - 40,
                          child: const Text(
                            'The majority votes and decides everything.',
                            style: TextStyle(
                                color: whiteDialog,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                fontFamily: 'Capitalis'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Welcome to FairTalk,",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 19,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    Text(
                                      "${widget.username}!",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  "Our account verification system makes it nearly impossible for individuals to create bots and/or manipulate our voting metrics. Verifying your account is free and not mandatory.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Column(
                                children: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PhysicalModel(
                                          color: testColor,
                                          elevation: 3,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              splashColor:
                                                  Colors.black.withOpacity(0.3),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VerifyOne(),
                                                    ),
                                                  );
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          top: 12,
                                                          bottom: 12,
                                                          right: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons.verified,
                                                          size: 20,
                                                          color: whiteDialog),
                                                      Container(width: 8),
                                                      const Text(
                                                        'Verify My Account',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: whiteDialog),
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
                                  ),
                                  // const SizedBox(height: 8),

                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      // border: Border.all(
                                      //     color: Colors.white,
                                      //     width: 2),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [],
                                    ),
                                  ),
                                  const SizedBox(height: 7),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    130
                                                : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    70,
                                        // MediaQuery.of(context).size.width / 2 - 194,
                                        decoration: const BoxDecoration(
                                          // color: Colors.red,
                                          border: Border(
                                            top: BorderSide(
                                                width: 1, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 33,
                                        alignment: Alignment.center,
                                        child: const Text('or',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    600
                                                ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    130
                                                : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    70,
                                        decoration: const BoxDecoration(
                                          // color: Colors.red,
                                          border: Border(
                                            top: BorderSide(
                                                width: 1, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          splashColor:
                                              Colors.black.withOpacity(0.3),
                                          onTap: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 150), () {
                                              // widget.durationInDay == null
                                              //     ?
                                              goToHome(context);
                                              // : Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder:
                                              //             (context) =>
                                              //                 AddPostDaily(
                                              //                   durationInDay:
                                              //                       widget.durationInDay,
                                              //                 )),
                                              //   );
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8,
                                                  top: 12,
                                                  bottom: 12,
                                                  right: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.account_circle,
                                                      color: darkBlue,
                                                      size: 20),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Continue as Unverified',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: darkBlue,
                                                        letterSpacing: 0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 6),
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width *
                                  //       0.8,
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 10),
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15),
                                  //     // border: Border.all(
                                  //     //     color: Colors.white,
                                  //     //     width: 2),
                                  //   ),
                                  //   child: Column(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: const [
                                  //       Text(
                                  //         "If you wish to continue as an unverified account, you'll always have the option to verify your account at anytime in the future.",
                                  //         textAlign: TextAlign.center,
                                  //         style: TextStyle(
                                  //           fontSize: 11,
                                  //           color: whiteDialog,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.white.withOpacity(0.3),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HowItWorks()),
                                );
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Want to learn how FairTalk works?',
                                    style: TextStyle(
                                      color: whiteDialog,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  // Text(
                                  //   'Click here',
                                  //   style: TextStyle(
                                  //     color: whiteDialog,
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 17,
                                  //     decoration: TextDecoration.underline,
                                  //   ),
                                  // ),
                                  const SizedBox(height: 7),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PhysicalModel(
                                          color: darkBlue,
                                          elevation: 3,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              splashColor:
                                                  Colors.white.withOpacity(0.3),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HowItWorks(),
                                                    ),
                                                  );
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          top: 12,
                                                          bottom: 12,
                                                          right: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                          Icons.info_outline,
                                                          size: 19,
                                                          color: whiteDialog),
                                                      Container(width: 8),
                                                      const Text(
                                                        'FairTalk Explainer',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: whiteDialog),
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
