import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  final int _messageTitleTextfieldMaxLength = 1000;
  User? user;
  var snap;
  bool _isLoading = false;

  bool isFairtalk = false;

  // @override
  // void initState() {
  //   super.initState();
  //   isFairtalk = user?.usernameLower == 'fairtalk' ? true : false;
  // }

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

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreMethods().uploadSubmission(
        uid,
        username,
        profImage,
        _titleController.text,
        isFairtalk ? true : false,
      );

      if (res == "success") {
        Future.delayed(const Duration(milliseconds: 1500), () {
          FocusScope.of(context).unfocus();
          _titleController.clear();

          setState(() {
            _isLoading = false;
          });

          waitSubmission(time: widget.durationInDay);
          showSnackBar(
            'Submission successfully created.',
            context,
          );
        });
      } else {
        showSnackBar(res, context);
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
        child: Scaffold(
          backgroundColor: testing,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: darkBlue,
              elevation: 4,
              toolbarHeight: 56,
              actions: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
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
                                  child: const Icon(
                                    Icons.keyboard_arrow_left,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text("Create a Submission",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 5),
                      _isLoading
                          ? const LinearProgressIndicator(color: Colors.white)
                          : const Padding(padding: EdgeInsets.only(top: 0)),
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
                          child:
                              // PhysicalModel(
                              //   elevation: 3,
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(5),
                              //   child: Container(
                              //     padding:
                              //         const EdgeInsets.symmetric(horizontal: 6),
                              //     // width: MediaQuery.of(context).size.width - 20,
                              //     decoration: const BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(5.0),
                              //       ),
                              //     ),
                              //     child: Padding(
                              //       padding:
                              //           const EdgeInsets.symmetric(horizontal: 8.0),
                              //       child: Column(
                              //         children: [
                              //           const SizedBox(height: 20),
                              //           Container(
                              //             padding: const EdgeInsets.symmetric(
                              //                 horizontal: 2),
                              //             child: WillPopScope(
                              //               onWillPop: () async {
                              //                 return false;
                              //               },
                              //               child: Stack(
                              //                 children: [
                              //                   TextField(
                              //                     maxLength:
                              //                         _messageTitleTextfieldMaxLength,
                              //                     onChanged: (val) {
                              //                       setState(() {});
                              //                       // setState(() {
                              //                       //   emptyTittle = false;
                              //                       //   // emptyPollQuestion = false;
                              //                       // });
                              //                     },
                              //                     controller: _titleController,
                              //                     onTap: () {},
                              //                     decoration: const InputDecoration(
                              //                       hintText: "Create a submission",
                              //                       focusedBorder:
                              //                           UnderlineInputBorder(
                              //                         borderSide: BorderSide(
                              //                             color: Colors.blue,
                              //                             width: 2),
                              //                       ),
                              //                       contentPadding: EdgeInsets.only(
                              //                           top: 0,
                              //                           left: 4,
                              //                           right: 45,
                              //                           bottom: 8),
                              //                       isDense: true,
                              //                       hintStyle: TextStyle(
                              //                         color: Colors.grey,
                              //                         fontSize: 16,
                              //                       ),
                              //                       labelStyle: TextStyle(
                              //                           color: Colors.black),
                              //                       counterText: '',
                              //                     ),
                              //                     maxLines: null,
                              //                   ),
                              //                   Positioned(
                              //                     bottom: 5,
                              //                     right: 0,
                              //                     child: Text(
                              //                       '${_titleController.text.length}/$_messageTitleTextfieldMaxLength',
                              //                       style: TextStyle(
                              //                         fontSize: 12,
                              //                         color: _titleController
                              //                                     .text.length ==
                              //                                 _messageTitleTextfieldMaxLength
                              //                             ? const Color.fromARGB(
                              //                                 255, 220, 105, 96)
                              //                             : Colors.grey,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //           Container(height: 20),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              PhysicalModel(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            elevation: 3,

                            // height: 200,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Stack(
                              children: [
                                TextField(
                                  maxLength: _messageTitleTextfieldMaxLength,
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                  controller: _titleController,
                                  onTap: () {},
                                  decoration: const InputDecoration(
                                    hintText: "Create a submission",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: 10,
                                        left: 10,
                                        right: 10,
                                        bottom: 24),
                                    isDense: true,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.5,
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    counterText: '',
                                  ),
                                  maxLines: 6,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 3,
                                  child: Text(
                                    '${_titleController.text.length}/$_messageTitleTextfieldMaxLength',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _titleController.text.length ==
                                              _messageTitleTextfieldMaxLength
                                          ? const Color.fromARGB(
                                              255, 220, 105, 96)
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                      borderRadius: BorderRadius.circular(50),
                                      child: InkWell(
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 150),
                                              () {
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
                                                  'Send Submission',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PhysicalModel(
                                        elevation: 3,
                                        color: whiteDialog,
                                        borderRadius: BorderRadius.circular(50),
                                        child: Material(
                                          color: user == null
                                              ? Colors.blue
                                              : snap?.pending == "true" ||
                                                      snap?.aaCountry == "" ||
                                                      snap?.submissionTime ==
                                                          widget.durationInDay
                                                  ? whiteDialog
                                                  : Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            splashColor:
                                                Colors.black.withOpacity(0.3),
                                            onTap: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 150), () {
                                                performLoggedUserAction(
                                                    context: context,
                                                    action: () {
                                                      snap?.pending == "true"
                                                          ? voteIfPending(
                                                              context: context)
                                                          : snap?.aaCountry ==
                                                                  ""
                                                              ? verificationRequired(
                                                                  context:
                                                                      context)
                                                              : snap?.submissionTime ==
                                                                      widget
                                                                          .durationInDay
                                                                  ? sendTimerDialog(
                                                                      context:
                                                                          context,
                                                                      type:
                                                                          'submission',
                                                                      type2: '')
                                                                  : _titleController
                                                                          .text
                                                                          .trim()
                                                                          .isEmpty
                                                                      ? showSnackBarError(
                                                                          'Create a submission field cannot be empty.',
                                                                          context)
                                                                      : postImage(
                                                                          user?.UID ??
                                                                              '',
                                                                          user?.username ??
                                                                              '',
                                                                          user?.photoUrl ??
                                                                              '',
                                                                        );
                                                    });
                                              });
                                            },
                                            child: SizedBox(
                                              height: 42,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  // border: Border.all(
                                                  //   color: darkBlue,
                                                  //   width: 0,
                                                  // ),
                                                ),
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        snap?.pending ==
                                                                    "true" ||
                                                                snap?.submissionTime ==
                                                                    widget
                                                                        .durationInDay
                                                            ? Icons.timer
                                                            : Icons.send,
                                                        color: snap?.pending ==
                                                                    "true" ||
                                                                snap?.submissionTime ==
                                                                    widget
                                                                        .durationInDay ||
                                                                snap?.aaCountry ==
                                                                    ""
                                                            ? darkBlue
                                                            : whiteDialog,
                                                        size: 18),
                                                    const SizedBox(width: 10),
                                                    snap?.submissionTime ==
                                                            widget.durationInDay
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
                                                        : Text(
                                                            snap?.pending ==
                                                                    "true"
                                                                ? 'Verification Pending'
                                                                : 'Send Submission',
                                                            style: TextStyle(
                                                              color: snap?.pending ==
                                                                          "true" ||
                                                                      snap?.aaCountry ==
                                                                          ""
                                                                  ? darkBlue
                                                                  : whiteDialog,
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
