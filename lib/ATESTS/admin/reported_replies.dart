import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/reply.dart';
import '../models/user.dart';
import '../methods/auth_methods.dart';
import '../screens/full_image_profile.dart';
import '../utils/utils.dart';

class ReportReplies extends StatefulWidget {
  final Reply reply;

  const ReportReplies({
    Key? key,
    required this.reply,
  }) : super(key: key);

  @override
  State<ReportReplies> createState() => _ReportRepliesState();
}

class _ReportRepliesState extends State<ReportReplies> {
  final AuthMethods _authMethods = AuthMethods();
  User? _userProfile;
  late Reply _reply;
  var snap;

  @override
  void initState() {
    super.initState();

    _reply = widget.reply;

    getAllUserDetails();
  }

  getAllUserDetails() async {
    User userProfile = await _authMethods.getUserProfileDetails(_reply.UID);
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    _reply = widget.reply;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('replies')
            .doc(_reply.replyId)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          snap = snapshot.data != null ? Reply.fromSnap(snapshot.data!) : snap;
          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          }
          return snap.reportChecked == true || snap.reportRemoved == true
              ? Row()
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5,
                          color: const Color.fromARGB(255, 204, 204, 204)),
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  _userProfile?.photoUrl != null
                                      ? InkWell(
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 150),
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
                                                  _userProfile?.photoUrl ?? ''),
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
                                      letterSpacing: 0.5,
                                    ),
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
                                  color:
                                      const Color.fromARGB(255, 219, 219, 219),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Report Counter',
                                        style: TextStyle(fontSize: 13)),
                                    Text('${_reply.reportCounter}',
                                        style: const TextStyle(fontSize: 13))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10,
                                                left: 10,
                                                top: 4,
                                                bottom: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  24,
                                              child: Text(
                                                '${_reply.text} ',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      removeProfPicDialog(
                                                        context: context,
                                                        uid: _reply.UID,
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: const Icon(
                                                        Icons.person,
                                                        color: Color.fromARGB(
                                                            255, 236, 50, 37),
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      keepReportDialog(
                                                        context: context,
                                                        post: _reply.replyId,
                                                        type: 'reply',
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 204, 204, 204),
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      width: 120,
                                                      child: const Center(
                                                        child: Text(
                                                          'KEEP',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      removeReportDialog(
                                                        context: context,
                                                        post: _reply.replyId,
                                                        uid: _reply.UID,
                                                        type: 'reply',
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 255, 133, 124),
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      width: 120,
                                                      child: const Center(
                                                        child: Text(
                                                          'REMOVE',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                );
        });
  }
}
