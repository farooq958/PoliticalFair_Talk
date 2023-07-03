import 'dart:async';
import 'package:aft/ATESTS/provider/most_liked_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../poll/poll_view.dart';
import '../methods/firestore_methods.dart';
import '../provider/left_time_provider.dart';
import '../provider/poll_provider.dart';
import '../provider/searchpage_provider.dart';
import '../provider/timer_provider.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../screens/full_message_poll.dart';
import '../screens/profile_all_user.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../models/poll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PollCard extends StatefulWidget {
  final Poll poll;
  final profileScreen;
  final archives;
  var durationInDay;

  PollCard(
      {Key? key,
      required this.poll,
      required this.profileScreen,
      required this.archives,
      required this.durationInDay})
      : super(key: key);

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  final AuthMethods _authMethods = AuthMethods();
  User? _userProfile;

  bool _isPollEnded = false;
  bool isLikeAnimating = false;
  bool tileClick = false;

  // late Poll PollData;
  bool initialized = false;
  // DateTime ntpTime = DateTime.now();
  var snap;

  final TextStyle _pollOptionTextStyle =
      const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis);

  // late TimerProvider _timerProvider;

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
    // _timerProvider = TimerProvider(
    //   widget.poll.getEndDate(),
    // );
    //leftTime();
    if ((widget.durationInDay == (widget.poll.time + 0)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 1)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 2)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 3)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 4)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 5)) == true) {
      _isPollEnded = false;
    } else if ((widget.durationInDay == (widget.poll.time + 6)) == true) {
      _isPollEnded = false;
    } else {
      _isPollEnded = true;
    }
  }

  // leftTime() async {
  //   final leftTimeProvider =
  //       Provider.of<LeftTimeProvider>(context, listen: false);

  //   await leftTimeProvider.getDate();
  //   //debugPrint("end value $endTime");
  // }

  getAllUserDetails() async {
    User userProfile =
        await _authMethods.getUserProfileDetails(widget.poll.UID);
    if (!mounted) return;
    setState(() {
      _userProfile = userProfile;
    });
  }

  void deletePoll(Poll poll, User user) async {
    try {
      String res = await FirestoreMethods().deletePost(poll, 'poll', user);
      if (res == "success") {
        var provider = Provider.of<PollsProvider>(navigatorKey.currentContext!,
            listen: false);
        provider.deleteUserPoll(poll.pollId);
        if (!mounted) return;
        showSnackBar('Poll successfully deleted.', context);
      } else {}
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // final leftTimeProvider =
    //     Provider.of<LeftTimeProvider>(context, listen: false);
    final User? user = Provider.of<UserProvider>(context).getUser;
    // int endTime = widget.poll.endDate.millisecondsSinceEpoch;
    // _isPollEnded = (widget.poll.endDate as Timestamp).toDate().difference(
    //     // DateTime.now(),
    //     ntpTime).isNegative;

    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance
    //       .collection('polls')
    //       .doc(widget.poll.pollId)
    //       .snapshots(),
    //   builder: (context,
    //       AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }

    //     _poll = snapshot.data != null ? Poll.fromSnap(snapshot.data!) : _poll;

    //     _isPollEnded = (_poll.endDate as Timestamp)
    //       .toDate()
    //       .difference(
    //         DateTime.now(),
    //       )
    //       .isNegative;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.UID)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          snap = snapshot.data != null && snapshot.data!.data() != null
              ? User.fromMap(snapshot.data!.data()!)
              : snap;

          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          } else if (user == null) {
            return buildSettings(context);
          } else {
            return !snap.blockList.contains(widget.poll.UID)
                ? buildSettings(context)
                : Row();
          }
        });
  }

  Widget buildSettings(
    BuildContext context,
  ) {
    // final leftTimeProvider =
    //     Provider.of<LeftTimeProvider>(context, listen: false);
    final User? user = Provider.of<UserProvider>(context).getUser;
    // int endTime = widget.poll.endDate.millisecondsSinceEpoch;
    // _isPollEnded = (widget.poll.endDate as Timestamp).toDate().difference(
    //     // DateTime.now(),
    //     ntpTime).isNegative;

    return Padding(
      key: Key(widget.poll.pollId),
      padding: const EdgeInsets.only(
        top: 6,
      ),
      child: PhysicalModel(
        color: tileClick ? testing : whiteDialog,
        elevation: 3,
        child: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: const Color.fromARGB(255, 245, 245, 245)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  tileClick = true;
                });
                Future.delayed(const Duration(milliseconds: 50), () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullMessagePoll(
                            poll: widget.poll,
                            pollId: widget.poll.pollId,
                            durationInDay: widget.durationInDay)),
                  );

                  if (mounted) {
                    setState(() {
                      tileClick = false;
                    });
                  }
                });
              },
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileAllUser(
                                              uid: widget.poll.UID,
                                              initialTab: 0,
                                            )),
                                  );
                                },
                              );
                            },
                            child: Stack(
                              children: [
                                // PROFILE PIC
                                _userProfile?.photoUrl != null
                                    ? Material(
                                        color: Colors.grey,
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.hardEdge,
                                        child: Ink.image(
                                          image: NetworkImage(
                                            _userProfile?.photoUrl ?? '',
                                          ),
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          child: InkWell(
                                            splashColor:
                                                Colors.white.withOpacity(0.5),
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 100),
                                                () {
                                                  widget.profileScreen
                                                      ? null
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileAllUser(
                                                                    uid: widget
                                                                        .poll
                                                                        .UID,
                                                                    initialTab:
                                                                        0,
                                                                  )),
                                                        );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : Material(
                                        color: Colors.grey,
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.hardEdge,
                                        child: Ink.image(
                                          image: const AssetImage(
                                            'assets/avatarFT.jpg',
                                          ),
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          child: InkWell(
                                            splashColor:
                                                Colors.white.withOpacity(0.5),
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 100),
                                                () {
                                                  widget.profileScreen
                                                      ? null
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileAllUser(
                                                                    uid: widget
                                                                        .poll
                                                                        .UID,
                                                                    initialTab:
                                                                        0,
                                                                  )),
                                                        );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  bottom: 0,
                                  right: 3,
                                  child: Row(
                                    children: [
                                      _userProfile?.profileFlag == true
                                          ? SizedBox(
                                              width: 20,
                                              height: 10,
                                              child: Image.asset(
                                                  'icons/flags/png/${_userProfile?.aaCountry}.png',
                                                  package: 'country_icons'))
                                          : Row()
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 1,
                                  child: Row(
                                    children: [
                                      _userProfile?.profileBadge == true
                                          ? Stack(
                                              children: const [
                                                Positioned(
                                                  right: 3,
                                                  top: 3,
                                                  child: CircleAvatar(
                                                    radius: 4,
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Icon(Icons.verified,
                                                      color: Color.fromARGB(
                                                          255, 113, 191, 255),
                                                      size: 13),
                                                ),
                                              ],
                                            )
                                          : Row()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           ProfileAllUser(
                                    //             uid: widget.poll.UID,
                                    //             initialTab: 0,
                                    //           )),
                                    // );
                                  },
                                  child: Text(
                                    _userProfile?.username ?? '',
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        letterSpacing: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat.yMMMd().format(
                                    widget.poll.datePublishedNTP.toDate(),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 12.5, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Expanded(
                          //   child: Container(
                          //     height: 30,
                          //   ),
                          // ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                splashColor: Colors.grey.withOpacity(0.5),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 50), () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            children: [
                                              widget.profileScreen &&
                                                      widget.poll.UID ==
                                                          user?.UID
                                                  ? SimpleDialogOption(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.delete),
                                                          Container(width: 10),
                                                          const Text(
                                                              'Delete Poll',
                                                              style: TextStyle(
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontSize:
                                                                      15)),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    150), () {
                                                          performLoggedUserAction(
                                                            context: context,
                                                            action: () {
                                                              deleteConfirmation(
                                                                  context:
                                                                      context,
                                                                  phrase:
                                                                      'Deleting this poll is permanent and this action cannot be undone.',
                                                                  type:
                                                                      'Delete Poll',
                                                                  action:
                                                                      () async {
                                                                    if (user !=
                                                                        null) {
                                                                      deletePoll(
                                                                          widget
                                                                              .poll,
                                                                          user!);

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                  });
                                                            },
                                                          );
                                                        });
                                                      },
                                                    )
                                                  : Row(),
                                              widget.poll.UID == user?.UID
                                                  ? Row()
                                                  : SimpleDialogOption(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.block),
                                                          Container(width: 10),
                                                          const Text(
                                                              'Block User',
                                                              style: TextStyle(
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontSize:
                                                                      15)),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    150), () {
                                                          performLoggedUserAction(
                                                            context: context,
                                                            action: () {
                                                              blockDialog(
                                                                action:
                                                                    () async {
                                                                  var userRef = FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(user
                                                                          ?.UID);
                                                                  var blockListRef = FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(user
                                                                          ?.UID)
                                                                      .collection(
                                                                          'blockList')
                                                                      .doc(widget
                                                                          .poll
                                                                          .UID);
                                                                  var blockUserInfo = await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "users")
                                                                      .doc(widget
                                                                          .poll
                                                                          .UID)
                                                                      .get();
                                                                  if (blockUserInfo
                                                                      .exists) {
                                                                    final batch =
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .batch();
                                                                    final blockingUserData =
                                                                        blockUserInfo
                                                                            .data();
                                                                    blockingUserData?[
                                                                            'creatorUID'] =
                                                                        user?.UID;
                                                                    batch.update(
                                                                        userRef,
                                                                        {
                                                                          'blockList':
                                                                              FieldValue.arrayUnion([
                                                                            widget.poll.UID
                                                                          ])
                                                                        });
                                                                    batch.set(
                                                                      blockListRef,
                                                                      blockingUserData,
                                                                    );

                                                                    batch
                                                                        .commit();
                                                                  }

                                                                  showSnackBar(
                                                                      'User successfully blocked.',
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                context:
                                                                    context,
                                                                isSearch: false,
                                                              );
                                                            },
                                                          );
                                                        });
                                                      },
                                                    ),
                                              widget.poll.UID == user?.UID
                                                  ? Row()
                                                  : SimpleDialogOption(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons
                                                              .report_outlined),
                                                          Container(width: 10),
                                                          const Text(
                                                              'Report Message',
                                                              style: TextStyle(
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontSize:
                                                                      15)),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  150),
                                                          () {
                                                            performLoggedUserAction(
                                                                context:
                                                                    context,
                                                                action: () {
                                                                  reportDialog(
                                                                    context:
                                                                        context,
                                                                    type:
                                                                        'poll',
                                                                    typeCapital:
                                                                        'Poll',
                                                                    user: false,
                                                                    action:
                                                                        () async {
                                                                      await FirestoreMethods().reportCounter(
                                                                          widget
                                                                              .poll
                                                                              .pollId,
                                                                          widget
                                                                              .poll
                                                                              .reportChecked,
                                                                          'poll');

                                                                      showSnackBar(
                                                                          'Poll successfully reported.',
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  );
                                                                });
                                                          },
                                                        );
                                                      },
                                                    ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 150),
                                                      () {
                                                    keywordsDialog(
                                                        context: context);
                                                  });
                                                },
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 25,
                                                          child: Icon(Icons.key,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Container(width: 10),
                                                        widget.poll.tagsLowerCase
                                                                    ?.length ==
                                                                0
                                                            ? const Text(
                                                                'No keywords used.',
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : const Text(
                                                                'Keywords:',
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        widget.poll.tagsLowerCase?.length == 1 ||
                                                                widget
                                                                        .poll
                                                                        .tagsLowerCase
                                                                        ?.length ==
                                                                    2 ||
                                                                widget
                                                                        .poll
                                                                        .tagsLowerCase
                                                                        ?.length ==
                                                                    3
                                                            ? Row(
                                                                children: [
                                                                  const SizedBox(
                                                                      width:
                                                                          35),
                                                                  const Text(
                                                                    '•',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${widget.poll.tagsLowerCase?[0]}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : Row(),
                                                        widget.poll.tagsLowerCase
                                                                        ?.length ==
                                                                    2 ||
                                                                widget
                                                                        .poll
                                                                        .tagsLowerCase
                                                                        ?.length ==
                                                                    3
                                                            ? Row(
                                                                children: [
                                                                  const SizedBox(
                                                                      width:
                                                                          35),
                                                                  const Text(
                                                                    '•',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${widget.poll.tagsLowerCase?[1]}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : Row(),
                                                        widget.poll.tagsLowerCase
                                                                    ?.length ==
                                                                3
                                                            ? Row(
                                                                children: [
                                                                  const SizedBox(
                                                                      width:
                                                                          35),
                                                                  const Text(
                                                                    '•',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${widget.poll.tagsLowerCase?[2]}',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : Row(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  });
                                },
                                child: const Icon(Icons.more_vert),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.poll.aPollTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        PollView(
                          pollId: widget.poll.pollId,
                          pollEnded: _isPollEnded,
                          hasVoted: widget.poll.votesUIDs.contains(user?.UID),
                          userVotedOptionId:
                              _getUserPollOptionId(user?.UID ?? ""),
                          onVoted:
                              (PollOption pollOption, int newTotalVotes) async {
                            // debugPrint('working on this');

                            {
                              // final leftTimeProvider =
                              //     Provider.of<LeftTimeProvider>(context,
                              //         listen: false);
                              // await leftTimeProvider.getDate();

                              // DateTime now = await widget.poll.getEndDate();

                              if ((widget.durationInDay ==
                                      (widget.poll.time + 0)) ||
                                  (widget.durationInDay ==
                                      (widget.poll.time + 1)) ||
                                  (widget.durationInDay ==
                                      (widget.poll.time + 2)) ||
                                  (widget.durationInDay ==
                                      (widget.poll.time + 3)) ||
                                  (widget.durationInDay ==
                                      (widget.poll.time + 4)) ||
                                  (widget.durationInDay ==
                                      (widget.poll.time + 5)) ||
                                  (widget.durationInDay ==
                                      (widget.poll.time + 6))) {
                                // debugPrint("working condition fine ");
                                setState(() {
                                  _isPollEnded = false;
                                  // debugPrint(
                                  // "message is  false show$_isPollEnded ");
                                });
                              } else {
                                setState(() {
                                  _isPollEnded = true;
                                  // debugPrint(
                                  // "message is  true show$_isPollEnded ");
                                });
                              }

                              void unverifiedPoll(bool pending) async {
                                await FirestoreMethods().pollUnverified(
                                  poll: widget.poll,
                                  uid: user?.UID ?? '',
                                  optionIndex: pollOption.id!,
                                );
                                showSnackBarAction(
                                  "Votes from unverified accounts don't count!",
                                  pending,
                                  context,
                                );
                              }

                              performLoggedUserAction(
                                  context: context,
                                  action: () async {
                                    _isPollEnded
                                        ? showSnackBarError(
                                            "This poll's voting cycle has already ended.",
                                            context)
                                        : snap?.pending == 'true'
                                            ? unverifiedPoll(true)
                                            : snap?.aaCountry == ""
                                                ? unverifiedPoll(false)
                                                : widget.poll.country != "" &&
                                                        widget.poll.global ==
                                                            "false" &&
                                                        widget.poll.country !=
                                                            snap.aaCountry
                                                    ? showSnackBar(
                                                        "Action failed. Voting nationally is only available for your specific country.",
                                                        context)
                                                    : widget.archives == true
                                                        ? showSnackBarError(
                                                            "This poll's voting cycle has already ended.",
                                                            context)
                                                        : user?.admin == true
                                                            ? await FirestoreMethods()
                                                                .pollScore(
                                                                poll:
                                                                    widget.poll,
                                                                optionIndex:
                                                                    pollOption
                                                                        .id!,
                                                              )
                                                            : await FirestoreMethods()
                                                                .poll(
                                                                poll:
                                                                    widget.poll,
                                                                uid:
                                                                    user?.UID ??
                                                                        '',
                                                                optionIndex:
                                                                    pollOption
                                                                        .id!,
                                                              );
                                  });
                            }
                            Provider.of<PollsProvider>(context, listen: false)
                                .updatePoll(widget.poll.pollId, user?.UID ?? "",
                                    pollOption.id!);
                            Provider.of<SearchPageProvider>(context,
                                    listen: false)
                                .updatePoll(widget.poll.pollId, user?.UID,
                                    pollOption.id!);
                            Provider.of<MostLikedKeyProvider>(context,
                                    listen: false)
                                .updatePoll(widget.poll.pollId, user?.UID,
                                    pollOption.id!);
                          },
                          leadingVotedProgessColor: Colors.blue.shade200,
                          pollOptionsSplashColor: Colors.white,
                          votedProgressColor: Colors.blueGrey.withOpacity(0.3),
                          votedBackgroundColor: Colors.grey.withOpacity(0.2),
                          votedCheckmark: const Icon(
                            Icons.check_circle_outline,
                            color: Color.fromARGB(255, 10, 147, 15),
                            size: 18,
                          ),
                          pollOptions: [
                            PollOption(
                              id: 1,
                              title: Text(widget.poll.bOption1,
                                  maxLines: 1, style: _pollOptionTextStyle),
                              votes: widget.poll.voteCount1,
                            ),
                            PollOption(
                              id: 2,
                              title: Text(widget.poll.bOption2,
                                  maxLines: 1, style: _pollOptionTextStyle),
                              votes: widget.poll.voteCount2,
                            ),
                            if (widget.poll.bOption3 != '')
                              PollOption(
                                id: 3,
                                title: Text(widget.poll.bOption3,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount3,
                              ),
                            if (widget.poll.bOption4 != '')
                              PollOption(
                                id: 4,
                                title: Text(widget.poll.bOption4,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount4,
                              ),
                            if (widget.poll.bOption5 != '')
                              PollOption(
                                id: 5,
                                title: Text(widget.poll.bOption5,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount5,
                              ),
                            if (widget.poll.bOption6 != '')
                              PollOption(
                                id: 6,
                                title: Text(widget.poll.bOption6,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount6,
                              ),
                            if (widget.poll.bOption7 != '')
                              PollOption(
                                id: 7,
                                title: Text(widget.poll.bOption7,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount7,
                              ),
                            if (widget.poll.bOption8 != '')
                              PollOption(
                                id: 8,
                                title: Text(widget.poll.bOption8,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount8,
                              ),
                            if (widget.poll.bOption9 != '')
                              PollOption(
                                id: 9,
                                title: Text(widget.poll.bOption9,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount9,
                              ),
                            if (widget.poll.bOption10 != '')
                              PollOption(
                                id: 10,
                                title: Text(widget.poll.bOption10,
                                    maxLines: 1, style: _pollOptionTextStyle),
                                votes: widget.poll.voteCount10,
                              ),
                          ],
                          poll: widget.poll,
                        ),
                      ],
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4, left: 4),
                        child: Container(
                          height: 0,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // color: Colors.blue,
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 6,
                        top: 5.5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Text(
                          //   widget.pollTimeLeftLabel(poll: widget.poll),
                          //   style: const TextStyle(
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // Material(
                          //   color: Colors.transparent,
                          //   child: InkWell(
                          //     borderRadius:
                          //         BorderRadius.circular(5),
                          //     // customBorder: const CircleBorder(),
                          //     splashColor:
                          //         Colors.grey.withOpacity(0.3),
                          //     onTap: () {
                          //       Future.delayed(
                          //           const Duration(
                          //               milliseconds: 50), () {
                          //         scoreDialogPoll(context: context);
                          //       });
                          //     },
                          //     child: Text(placement,
                          //         style: const TextStyle(
                          //             color: Color.fromARGB(
                          //                 255, 143, 143, 143),
                          //             fontSize: 24,
                          //             fontStyle: FontStyle.italic,
                          //             fontWeight: FontWeight.w500)),
                          //   ),
                          // ),
                          SizedBox(
                            // width: 90,
                            height: 36,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    scoreDialogPoll(context: context);
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      ' Score ',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Container(height: 0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_box,
                                          size: 12,
                                          color: Color.fromARGB(
                                              255, 139, 139, 139),
                                        ),
                                        Container(width: 4),
                                        Text(
                                          widget.poll.totalVotes == 1
                                              ? '${widget.poll.totalVotes}'
                                              : '${widget.poll.totalVotes}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 120, 120, 120),
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),

                          SizedBox(
                            // width: 95,
                            height: 36,
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                splashColor: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    timerDialog(context: context, type: 'poll');
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Time Left',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.timer,
                                          size: 12,
                                          color: Color.fromARGB(
                                              255, 139, 139, 139),
                                        ),
                                        Container(width: 4),
                                        // _timeLeftLabel(),
                                        Text(
                                          widget.durationInDay ==
                                                  (widget.poll.time)
                                              ? '7 Days'
                                              : widget.durationInDay ==
                                                      (widget.poll.time + 1)
                                                  ? '6 Days'
                                                  : widget.durationInDay ==
                                                          (widget.poll.time + 2)
                                                      ? '5 Days'
                                                      : widget.durationInDay ==
                                                              (widget.poll
                                                                      .time +
                                                                  3)
                                                          ? '4 Days'
                                                          : widget.durationInDay ==
                                                                  (widget.poll
                                                                          .time +
                                                                      4)
                                                              ? '3 Days'
                                                              : widget.durationInDay ==
                                                                      (widget.poll
                                                                              .time +
                                                                          5)
                                                                  ? '2 Days'
                                                                  : widget.durationInDay ==
                                                                          (widget.poll.time +
                                                                              6)
                                                                      ? '1 Day'
                                                                      : 'None',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 120, 120, 120),
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          SizedBox(
                            // width: 90,
                            height: 36,
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                splashColor: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 50),
                                      () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullMessagePoll(
                                              poll: widget.poll,
                                              pollId: widget.poll.pollId,
                                              durationInDay:
                                                  widget.durationInDay)),
                                    );
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Comments',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          MyFlutterApp.comments,
                                          size: 12,
                                          color: Color.fromARGB(
                                              255, 139, 139, 139),
                                        ),
                                        Container(width: 6),
                                        Center(
                                          child: Text(
                                            '${widget.poll.commentCount}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 120, 120, 120),
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500),
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

  int? _getUserPollOptionId(String uid) {
    int? optionId;
    for (int i = 1; i <= 10; i++) {
      switch (i) {
        case 1:
          if (widget.poll.vote1.contains(uid)) {
            optionId = i;
          }
          break;
        case 2:
          if (widget.poll.vote2.contains(uid)) {
            optionId = i;
          }
          break;
        case 3:
          if (widget.poll.vote3.contains(uid)) {
            optionId = i;
          }
          break;
        case 4:
          if (widget.poll.vote4.contains(uid)) {
            optionId = i;
          }
          break;
        case 5:
          if (widget.poll.vote5.contains(uid)) {
            optionId = i;
          }
          break;
        case 6:
          if (widget.poll.vote6.contains(uid)) {
            optionId = i;
          }
          break;
        case 7:
          if (widget.poll.vote7.contains(uid)) {
            optionId = i;
          }
          break;
        case 8:
          if (widget.poll.vote8.contains(uid)) {
            optionId = i;
          }
          break;
        case 9:
          if (widget.poll.vote9.contains(uid)) {
            optionId = i;
          }
          break;
        case 10:
          if (widget.poll.vote10.contains(uid)) {
            optionId = i;
          }
          break;
      }
    }

    return optionId;
  }

  // _timeLeftLabel() {
  //   DateTime _currentDate = DateTime.now();
  //   _currentDate.toLocal();

  //   if (widget.poll.getEndDate().isBefore(_currentDate)) {
  //     return const Text(
  //       'None',
  //       style: TextStyle(
  //           fontSize: 12,
  //           color: Color.fromARGB(255, 120, 120, 120),
  //           letterSpacing: 0.5,
  //           fontWeight: FontWeight.w500),
  //     );
  //   } else if (widget.poll.getEndDate().isAfter(_currentDate)) {
  //     return ChangeNotifierProvider.value(
  //       value: _timerProvider,
  //       child:
  //           Consumer<TimerProvider>(builder: (context, timerProvider, child) {
  //         return Text(
  //           timerProvider.timeString,
  //           style: const TextStyle(
  //               fontSize: 12,
  //               color: Color.fromARGB(255, 120, 120, 120),
  //               letterSpacing: 0.5,
  //               fontWeight: FontWeight.w500),
  //         );
  //       }),
  //     );
  //   } else {
  //     return const Text("");
  //   }
  // }
}
