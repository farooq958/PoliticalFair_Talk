import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../poll/poll_view.dart';
import '../provider/user_provider.dart';
import '../screens/full_image_profile.dart';
import '../utils/utils.dart';
import '../models/poll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPolls extends StatefulWidget {
  final Poll poll;

  const ReportPolls({
    Key? key,
    required this.poll,
  }) : super(key: key);

  @override
  State<ReportPolls> createState() => _ReportPollsState();
}

class _ReportPollsState extends State<ReportPolls> {
  final AuthMethods _authMethods = AuthMethods();
  User? _userProfile;
  late Poll _poll;
  final bool _isPollEnded = false;
  var snap;

  final TextStyle _pollOptionTextStyle =
      const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis);

  @override
  void initState() {
    super.initState();
    _poll = widget.poll;

    getAllUserDetails();
  }

  getAllUserDetails() async {
    User userProfile = await _authMethods.getUserProfileDetails(_poll.UID);
    if (!mounted) return;
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('polls')
            .doc(_poll.pollId)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          snap = snapshot.data != null ? Poll.fromSnap(snapshot.data!) : snap;
          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          }
          return snap.reportChecked == true || snap.reportRemoved == true
              ? Row()
              : Padding(
                  key: Key(_poll.pollId),
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5,
                          color: const Color.fromARGB(255, 204, 204, 204)),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    _userProfile?.photoUrl != null
                                        ? InkWell(
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 150),
                                                () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FullImageProfile(
                                                                photo: _userProfile
                                                                    ?.photoUrl)),
                                                  );
                                                },
                                              );
                                            },
                                            child: Material(
                                              color: Colors.grey,
                                              shape: const CircleBorder(),
                                              clipBehavior: Clip.hardEdge,
                                              child: Ink.image(
                                                image: NetworkImage(
                                                    _userProfile?.photoUrl ??
                                                        ''),
                                                fit: BoxFit.cover,
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                          )
                                        : Material(
                                            color: Colors.grey,
                                            shape: const CircleBorder(),
                                            clipBehavior: Clip.hardEdge,
                                            child: Ink.image(
                                              image: const AssetImage(
                                                  'assets/avatarFT.jpg'),
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
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
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 219, 219, 219),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Report Counter',
                                          style: TextStyle(fontSize: 13)),
                                      Text('${_poll.reportCounter}',
                                          style: const TextStyle(fontSize: 13))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                _poll.aPollTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              PollView(
                                pollId: _poll.pollId,
                                pollEnded: _isPollEnded,
                                hasVoted: _poll.votesUIDs.contains(user?.UID),
                                userVotedOptionId:
                                    _getUserPollOptionId(user?.UID ?? ""),
                                onVoted: (PollOption pollOption,
                                    int newTotalVotes) async {
                                  if (!_isPollEnded) {}
                                },
                                leadingVotedProgessColor: Colors.blue.shade200,
                                pollOptionsSplashColor: Colors.white,
                                votedProgressColor:
                                    Colors.blueGrey.withOpacity(0.3),
                                votedBackgroundColor:
                                    Colors.grey.withOpacity(0.2),
                                votedCheckmark: const Icon(
                                  Icons.check_circle_outline,
                                  color: Color.fromARGB(255, 10, 147, 15),
                                  size: 18,
                                ),
                                pollOptions: [
                                  PollOption(
                                    id: 1,
                                    title: Text(_poll.bOption1,
                                        maxLines: 1,
                                        style: _pollOptionTextStyle),
                                    votes: 0,
                                  ),
                                  PollOption(
                                    id: 2,
                                    title: Text(_poll.bOption2,
                                        maxLines: 1,
                                        style: _pollOptionTextStyle),
                                    votes: 0,
                                  ),
                                  if (_poll.bOption3 != '')
                                    PollOption(
                                      id: 3,
                                      title: Text(_poll.bOption3,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                  if (_poll.bOption4 != '')
                                    PollOption(
                                      id: 4,
                                      title: Text(_poll.bOption4,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                  if (_poll.bOption5 != '')
                                    PollOption(
                                      id: 5,
                                      title: Text(_poll.bOption5,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                  if (_poll.bOption6 != '')
                                    PollOption(
                                      id: 6,
                                      title: Text(_poll.bOption6,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                  if (_poll.bOption7 != '')
                                    PollOption(
                                      id: 7,
                                      title: Text(_poll.bOption7,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                  if (_poll.bOption8 != '')
                                    PollOption(
                                      id: 8,
                                      title: Text(_poll.bOption8,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                  if (_poll.bOption9 != '')
                                    PollOption(
                                      id: 9,
                                      title: Text(_poll.bOption9,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                  if (_poll.bOption10 != '')
                                    PollOption(
                                      id: 10,
                                      title: Text(_poll.bOption10,
                                          maxLines: 1,
                                          style: _pollOptionTextStyle),
                                      votes: 0,
                                    ),
                                ],
                                poll: widget.poll,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      removeProfPicDialog(
                                        context: context,
                                        uid: _poll.UID,
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Icon(
                                        Icons.person,
                                        color: Color.fromARGB(255, 236, 50, 37),
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      keepReportDialog(
                                        context: context,
                                        post: _poll.pollId,
                                        type: 'poll',
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color.fromARGB(
                                            255, 204, 204, 204),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      width: 120,
                                      child: const Center(
                                        child: Text(
                                          'KEEP',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      removeReportDialog(
                                          context: context,
                                          post: _poll.pollId,
                                          uid: _poll.UID,
                                          type: 'poll');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color.fromARGB(
                                            255, 255, 133, 124),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      width: 120,
                                      child: const Center(
                                        child: Text(
                                          'REMOVE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
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
                    ),
                  ),
                );
        });
  }

  int? _getUserPollOptionId(String uid) {
    int? optionId;
    for (int i = 1; i <= 10; i++) {
      switch (i) {
        case 1:
          if (_poll.vote1.contains(uid)) {
            optionId = i;
          }
          break;
        case 2:
          if (_poll.vote2.contains(uid)) {
            optionId = i;
          }
          break;
        case 3:
          if (_poll.vote3.contains(uid)) {
            optionId = i;
          }
          break;
        case 4:
          if (_poll.vote4.contains(uid)) {
            optionId = i;
          }
          break;
        case 5:
          if (_poll.vote5.contains(uid)) {
            optionId = i;
          }
          break;
        case 6:
          if (_poll.vote6.contains(uid)) {
            optionId = i;
          }
          break;
        case 7:
          if (_poll.vote7.contains(uid)) {
            optionId = i;
          }
          break;
        case 8:
          if (_poll.vote8.contains(uid)) {
            optionId = i;
          }
          break;
        case 9:
          if (_poll.vote9.contains(uid)) {
            optionId = i;
          }
          break;
        case 10:
          if (_poll.vote10.contains(uid)) {
            optionId = i;
          }
          break;
      }
    }

    return optionId;
  }
}
