import 'package:flutter/material.dart';

import '../screens/add_post_daily.dart';
import '../screens/verify_one.dart';
import '../utils/utils.dart';

class WelcomeScreen extends StatefulWidget {
  var username;
  var durationInDay;
  WelcomeScreen({Key? key, required this.username, this.durationInDay})
      : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                          color: Color.fromARGB(255, 36, 64, 101),
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 36, 64, 101),
                                  width: 0)),
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
                                      'assets/fairtalk_blue_transparent.png',
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
                                          color:
                                              Color.fromARGB(255, 36, 64, 101),
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
                              color: Color.fromARGB(255, 36, 64, 101),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(),
                                // Column(
                                //   children: [
                                //     Text(
                                //       'Welcome to Fairtalk,',
                                //       textAlign: TextAlign.center,
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 22,
                                //           letterSpacing: 0.5,
                                //           color: Colors.white),
                                //     ),
                                //     SizedBox(height: 3),
                                //     Text(
                                //       '${widget.username}!',
                                //       textAlign: TextAlign.center,
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 22,
                                //           letterSpacing: 0.5,
                                //           color: Colors.white),
                                //     ),
                                //   ],
                                // ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Welcome to Fairtalk, ${widget.username}!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      Container(height: 8),
                                      // Text(
                                      //   "Your account is currently unverified.",
                                      //   textAlign: TextAlign.center,
                                      //   style: TextStyle(
                                      //     color: Colors.white,
                                      //     fontWeight: FontWeight.w500,
                                      //     fontSize: 18,
                                      //     letterSpacing: 0.3,
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  width: 0,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(height: 8),
                                      // const Text(
                                      //   "Your account is currently unverified.",
                                      //   textAlign: TextAlign.center,
                                      //   style: TextStyle(
                                      //     color: Colors.white,
                                      //     fontWeight: FontWeight.w500,
                                      //     fontSize: 18,
                                      //     letterSpacing: 0.3,
                                      //   ),
                                      // ),
                                      // Container(height: 8),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 10),
                                      //   child: Container(
                                      //     width:
                                      //         MediaQuery.of(context).size.width,
                                      //     decoration: const BoxDecoration(
                                      //       border: Border(
                                      //         top: BorderSide(
                                      //             width: 0,
                                      //             color: Colors.white),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Container(height: 8),
                                      Column(
                                        children: const [
                                          Text(
                                            "You must either: verify your account or continue as an unverified account.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.5,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "As an unverified account, you'll still have access to most features on the platform but you won't be able to cast any votes. Our account verification system prevents users from manipulating our platform's voting metrics. Verifying your account is completely free.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.5,
                                              letterSpacing: 0.3,
                                            ),
                                          ),

                                          // SizedBox(height: 8),
                                          // Text(
                                          //   "Without a verification system, it would be very easy for anyone to simply create multiple accounts and unfairly manipulate the platform's voting metrics.",
                                          //   textAlign: TextAlign.center,
                                          //   style: TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: 13.5,
                                          //     letterSpacing: 0.3,
                                          //   ),
                                          // ),

                                          // SizedBox(height: 2),
                                          // Text(
                                          //   "",
                                          //   textAlign: TextAlign.center,
                                          //   style: TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: 13.5,
                                          //     letterSpacing: 0.3,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 6),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white,
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
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VerifyOne(
                                                                durationInDay:
                                                                    widget
                                                                        .durationInDay),
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black),
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
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
                                                            Icons.verified,
                                                            size: 20,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    36,
                                                                    64,
                                                                    101)),
                                                        Container(width: 8),
                                                        const Text(
                                                          'Verify My Account',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  0.3,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      36,
                                                                      64,
                                                                      101)),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context)
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
                                          decoration: const BoxDecoration(
                                            // color: Colors.red,
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1,
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
                                                  color: Colors.white)),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context)
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
                                          decoration: const BoxDecoration(
                                            // color: Colors.red,
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6, bottom: 0),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              splashColor:
                                                  Colors.black.withOpacity(0.3),
                                              onTap: () {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 150), () {
                                                  // goToHome(context);

                                                  widget.durationInDay == null
                                                      ? goToHome(context)
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      AddPostDaily(
                                                                        durationInDay:
                                                                            widget.durationInDay,
                                                                      )),
                                                        );
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black),
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
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
                                                    children: const [
                                                      Text(
                                                        'Continue as Unverified',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    36,
                                                                    64,
                                                                    101),
                                                            letterSpacing: 0.3),
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
                                    SizedBox(height: 5),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: const Text(
                                        "If you wish to continue as an unverified account, you'll always have the option to verify your account at anytime in the future.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox()
                              ],
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
