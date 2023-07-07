import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/add_post_daily.dart';
import '../screens/verify_one.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

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
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: darkBlue,
                          border: Border(
                              bottom: BorderSide(color: darkBlue, width: 0)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height:
                            MediaQuery.of(context).size.height - safePadding >=
                                    600
                                ? (MediaQuery.of(context).size.height -
                                        safePadding) *
                                    0.25
                                : 150,
                      ),
                      Positioned(
                        child: Container(
                          height: MediaQuery.of(context).size.height -
                                      safePadding >=
                                  600
                              ? (MediaQuery.of(context).size.height -
                                      safePadding) *
                                  0.25
                              : 150,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(75),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height -
                                        safePadding >=
                                    600
                                ? (MediaQuery.of(context).size.height -
                                        safePadding) *
                                    0.25
                                : 150,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                      'assets/fairtalk_new_blue_transparent.png',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1 -
                                            80,
                                    child: const Text(
                                      'A platform built to unite us all.',
                                      style: TextStyle(
                                          color: darkBlue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                          fontFamily: 'Capitalis'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // SizedBox(height: 15),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Text(
                                  //       'Welcome to Fairtalk,',
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 10,
                                  //           letterSpacing: 0.5,
                                  //           fontFamily: 'Capitalis',
                                  //           color: Color.fromARGB(
                                  //               255, 36, 64, 101)),
                                  //     ),
                                  //     Text(
                                  //       '${widget.username}!',
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.w500,
                                  //           fontSize: 30,
                                  //           letterSpacing: 0.5,
                                  //           // fontFamily: 'Capitalis',
                                  //           color: Color.fromARGB(
                                  //               255, 36, 64, 101)),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Positioned(
                        child: Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: darkBlue,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(75),
                              ),
                            ),
                            padding: const EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height -
                                        safePadding >=
                                    600
                                ? (MediaQuery.of(context).size.height -
                                        safePadding) *
                                    0.75
                                : 450,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(15),
                              //   border: Border.all(
                              //       color: Colors.white, width: 2),
                              // ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Welcome, ${widget.username}!",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  width: 2,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          child: Text(
                                              "Since Fairtalk is fully centered around a democratic system, we had to come up with a unique approach to eliminate all forms of voting manipulation. ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              "Choose an option:",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // const SizedBox(height: 8),
                                            // Container(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width *
                                            //       0.7,
                                            //   decoration: const BoxDecoration(
                                            //     border: Border(
                                            //       top: BorderSide(
                                            //           width: 2,
                                            //           color: Colors.white),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Column(
                                          children: [
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.white,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      splashColor: Colors.black
                                                          .withOpacity(0.3),
                                                      onTap: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    150), () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      VerifyOne(),
                                                            ),
                                                          );
                                                        });
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                                  Icons
                                                                      .verified,
                                                                  size: 20,
                                                                  color:
                                                                      darkBlue),
                                                              Container(
                                                                  width: 8),
                                                              const Text(
                                                                'Verify My Account',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    letterSpacing:
                                                                        0.3,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        darkBlue),
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
                                            const SizedBox(height: 8),
                                            // Container(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width *
                                            //       0.8,
                                            //   padding:
                                            //       const EdgeInsets.symmetric(
                                            //           horizontal: 0,
                                            //           vertical: 3),
                                            //   decoration: BoxDecoration(
                                            //     border: Border.all(
                                            //         color: Colors.white,
                                            //         width: 2),
                                            //     borderRadius:
                                            //         BorderRadius.circular(10),
                                            //     color: darkBlue,
                                            //   ),
                                            //   child: Padding(
                                            //     padding: EdgeInsets.only(
                                            //         bottom:
                                            //             isVerifyDialog ? 0 : 0),
                                            //     child: Column(
                                            //       children: [
                                            //         InkWell(
                                            //           onTap: () {
                                            //             setState(() {
                                            //               isVerifyDialog =
                                            //                   !isVerifyDialog;
                                            //             });
                                            //           },
                                            //           child: Padding(
                                            //             padding:
                                            //                 const EdgeInsets
                                            //                         .symmetric(
                                            //                     vertical: 0,
                                            //                     horizontal: 0),
                                            //             child: Row(
                                            //               mainAxisAlignment:
                                            //                   MainAxisAlignment
                                            //                       .center,
                                            //               children: [
                                            //                 Icon(
                                            //                     isVerifyDialog
                                            //                         ? Icons
                                            //                             .keyboard_arrow_up
                                            //                         : Icons
                                            //                             .keyboard_arrow_down,
                                            //                     color:
                                            //                         whiteDialog,
                                            //                     size: 28),
                                            //                 const SizedBox(
                                            //                     width: 4),
                                            //                 const Text(
                                            //                   "Benefits of Account Verification",
                                            //                   textAlign:
                                            //                       TextAlign
                                            //                           .center,
                                            //                   style: TextStyle(
                                            //                     color:
                                            //                         whiteDialog,
                                            //                     letterSpacing:
                                            //                         0.5,
                                            //                     fontWeight:
                                            //                         FontWeight
                                            //                             .w500,
                                            //                     fontSize: 15,
                                            //                   ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ),
                                            //         ),
                                            //         isVerifyDialog
                                            //             ? Column(
                                            //                 mainAxisAlignment:
                                            //                     MainAxisAlignment
                                            //                         .start,
                                            //                 crossAxisAlignment:
                                            //                     CrossAxisAlignment
                                            //                         .start,
                                            //                 children: const [
                                            //                   Text(
                                            //                     "• Participate in Fairtalk's democracy.",
                                            //                     textAlign:
                                            //                         TextAlign
                                            //                             .start,
                                            //                     style: TextStyle(
                                            //                         fontSize:
                                            //                             13,
                                            //                         color:
                                            //                             whiteDialog,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w500,
                                            //                         letterSpacing:
                                            //                             0),
                                            //                   ),
                                            //                   Text(
                                            //                     "• Send messages & polls Nationally.",
                                            //                     style: TextStyle(
                                            //                         fontSize:
                                            //                             13,
                                            //                         color:
                                            //                             whiteDialog,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w500,
                                            //                         letterSpacing:
                                            //                             0),
                                            //                   ),
                                            //                   Text(
                                            //                     "• Give votes that count.",
                                            //                     style: TextStyle(
                                            //                         fontSize:
                                            //                             13,
                                            //                         color:
                                            //                             whiteDialog,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w500,
                                            //                         letterSpacing:
                                            //                             0),
                                            //                   ),
                                            //                   Text(
                                            //                     "• Additional personalization options.",
                                            //                     style: TextStyle(
                                            //                         fontSize:
                                            //                             13,
                                            //                         color:
                                            //                             whiteDialog,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w500,
                                            //                         letterSpacing:
                                            //                             0),
                                            //                   ),
                                            //                   Text(
                                            //                     "• And much more!",
                                            //                     style: TextStyle(
                                            //                         fontSize:
                                            //                             13,
                                            //                         color:
                                            //                             whiteDialog,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w500,
                                            //                         letterSpacing:
                                            //                             0),
                                            //                   ),
                                            //                 ],
                                            //               )
                                            //             : const SizedBox(),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width >
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    // color: Colors.red,
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 2,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 33,
                                                  alignment: Alignment.center,
                                                  child: const Text('or',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white)),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width >
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    // color: Colors.red,
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 2,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Material(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.white,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    splashColor: Colors.black
                                                        .withOpacity(0.3),
                                                    onTap: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  150), () {
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8,
                                                                top: 12,
                                                                bottom: 12,
                                                                right: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text(
                                                              'Continue as Unverified',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      darkBlue,
                                                                  letterSpacing:
                                                                      0),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                // border: Border.all(
                                                //     color: Colors.white,
                                                //     width: 2),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    "If you wish to continue as an unverified account, you'll still have the option to verify your account at anytime in the future.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: whiteDialog,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                ],
              )),
        ),
      ),
    );
  }
}
