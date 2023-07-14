import 'package:flutter/material.dart';
import '../info screens/how_it_works.dart';
import '../utils/global_variables.dart';
import 'verify_two.dart';

class VerifyOne extends StatefulWidget {
  var durationInDay;

  VerifyOne({Key? key, this.durationInDay}) : super(key: key);

  @override
  State<VerifyOne> createState() => _VerifyOneState();
}

class _VerifyOneState extends State<VerifyOne> {
  bool isVerifyDialog = false;

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 56,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              splashColor: Colors.grey.withOpacity(0.5),
                              child: const Icon(Icons.keyboard_arrow_left,
                                  color: darkBlue),
                              onTap: () {
                                Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Account Verification',
                        style: TextStyle(
                            color: darkBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      border:
                          Border(bottom: BorderSide(color: darkBlue, width: 0)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height:
                        MediaQuery.of(context).size.height - 56 - safePadding >=
                                600
                            ? (MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding) *
                                0.35
                            : 182,
                  ),
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                                  56 -
                                  safePadding >=
                              600
                          ? (MediaQuery.of(context).size.height -
                                  56 -
                                  safePadding) *
                              0.35
                          : 182,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(75),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding >=
                                600
                            ? (MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding) *
                                0.35
                            : 182,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: SizedBox(
                            // height: 105,
                            child: Image.asset('assets/stepOneVerif.png'),
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
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              darkBlue,
                              testColor,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 20, bottom: 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding >=
                                600
                            ? (MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding) *
                                0.65
                            : 362,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: const EdgeInsets.only(
                                  right: 12, left: 12, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Why does FairTalk have an account verification system?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 2, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(height: 8),
                                  const Text(
                                    "Without a verification system, anyone could simply create multiple accounts and unfairly manipulate our voting metrics. Verifying your account is completely free. Data collected during the verification process is encrypted, secure and will never be shared or sold.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // const SizedBox(height: 8),
                                  // const Text(
                                  //   "Verifying your account is completely free. Data collected during the verification process is encrypted and will never be shared or sold.",
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 14,
                                  //       letterSpacing: 0),
                                  // ),
                                  const SizedBox(height: 8),
                                  PhysicalModel(
                                    color: testColor,
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: testColor,
                                      ),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isVerifyDialog =
                                                    !isVerifyDialog;
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    isVerifyDialog
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    color: whiteDialog,
                                                    size: 22),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  "Perks for verifying account",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: whiteDialog,
                                                    letterSpacing: 0.5,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          isVerifyDialog
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    SizedBox(height: 2),
                                                    Text(
                                                      "• Participate in FairTalk's democracy.",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: whiteDialog,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0),
                                                    ),
                                                    Text(
                                                      "• Send messages & polls Nationally.",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: whiteDialog,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0),
                                                    ),
                                                    Text(
                                                      "• Give votes that count.",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: whiteDialog,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0),
                                                    ),
                                                    Text(
                                                      "• Additional personalization options.",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: whiteDialog,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0),
                                                    ),
                                                    Text(
                                                      "• And much more.",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: whiteDialog,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                PhysicalModel(
                                  elevation: 3,
                                  color: whiteDialog,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      splashColor: Colors.grey.withOpacity(0.5),
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(milliseconds: 150),
                                            () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VerifyTwo(
                                                    durationInDay:
                                                        widget.durationInDay)),
                                          );
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Start Account Verification',
                                                style: TextStyle(
                                                  fontSize: 16.5,
                                                  color: darkBlue,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            SizedBox(width: 6),
                                            Icon(
                                              Icons.keyboard_arrow_right,
                                              size: 20,
                                              color: darkBlue,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        decoration: const ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(25),
                                            ),
                                          ),
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
