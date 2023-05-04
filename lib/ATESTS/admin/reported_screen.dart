import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
import '../models/poll.dart';
import '../models/post.dart';
import '../models/reply.dart';
import '../provider/user_provider.dart';
import 'reported_comments.dart';
import 'reported_polls.dart';
import 'reported_posts.dart';
import '../models/user.dart';

import 'reported_replies.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    Key? key,
    required this.durationInDay,
  }) : super(key: key);
  final durationInDay;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var selected = 'messages';
  User? user;

  List<Post> postsList = [];
  StreamSubscription? loadDataStream;
  StreamController<Post> updatingStream = StreamController.broadcast();

  List<Poll> pollsList = [];
  StreamSubscription? loadDataStreamPoll;
  StreamController<Poll> updatingStreamPoll = StreamController.broadcast();

  List<Comment> commentsList = [];
  StreamSubscription? loadDataStreamComment;
  StreamController<Comment> updatingStreamComment =
      StreamController.broadcast();

  List<Reply> repliesList = [];
  StreamSubscription? loadDataStreamReply;
  StreamController<Reply> updatingStreamReply = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  void dispose() {
    super.dispose();
    if (loadDataStream != null) {
      loadDataStream!.cancel();
    }
    if (loadDataStreamPoll != null) {
      loadDataStreamPoll!.cancel();
    }
    if (loadDataStreamComment != null) {
      loadDataStreamComment!.cancel();
    }
    if (loadDataStreamReply != null) {
      loadDataStreamReply!.cancel();
    }
  }

  // Future<void>
  initList() async {
    if (loadDataStream != null) {
      loadDataStream!.cancel();
      postsList = [];
    }
    loadDataStream = FirebaseFirestore.instance
        .collection('posts')
        .where('reportChecked', isEqualTo: false)
        .where('reportRemoved', isEqualTo: false)
        // .where('time', isGreaterThanOrEqualTo: widget.durationInDay - 6)
        // .orderBy('time', descending: true)
        .orderBy('reportCounter', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            postsList.add(Post.fromMap(
              {...change.doc.data()!, 'updatingStream': updatingStream},
            ));
            break;
          case DocumentChangeType.modified:
            updatingStream.add(Post.fromMap(
              {...change.doc.data()!},
            ));
            break;
          case DocumentChangeType.removed:
            postsList.remove(Post.fromMap(
              {...change.doc.data()!},
            ));
            break;
        }
      }

      setState(() {});
    });
  }

  initPollList() async {
    if (loadDataStreamPoll != null) {
      loadDataStreamPoll!.cancel();
      pollsList = [];
    }
    loadDataStreamPoll = FirebaseFirestore.instance
        .collection('polls')
        .where('reportChecked', isEqualTo: false)
        .where('reportRemoved', isEqualTo: false)
        // .where('time', isGreaterThanOrEqualTo: 164)
        // .orderBy('time', descending: true)
        .orderBy('reportCounter', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            pollsList.add(Poll.fromMap({
              ...change.doc.data()!,
              'updatingStreamPoll': updatingStreamPoll
            })); // we are adding to a local list when the element is added in firebase collection
            break; //the Post element we will send on pair with updatingStream, because a Post constructor makes a listener on a stream.
          case DocumentChangeType.modified:
            updatingStreamPoll.add(Poll.fromMap({
              ...change.doc.data()!,
            })); // we are sending a modified object in the stream.
            break;
          case DocumentChangeType.removed:
            pollsList.remove(Poll.fromMap({
              ...change.doc.data()!
            })); // we are removing a Post object from the local list.
            break;
        }
      }

      setState(() {});
    });
  }

  initCommentList() async {
    if (loadDataStreamComment != null) {
      loadDataStreamComment!.cancel();
      commentsList = [];
    }
    loadDataStreamComment = FirebaseFirestore.instance
        .collection('comments')
        .where('reportChecked', isEqualTo: false)
        .where('reportRemoved', isEqualTo: false)
        .orderBy('reportCounter', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            commentsList.add(Comment.fromMap({
              ...change.doc.data()!,
              'updatingStreamComment': updatingStreamComment
            }));
            break;
          case DocumentChangeType.modified:
            updatingStreamComment.add(Comment.fromMap({
              ...change.doc.data()!,
            }));
            break;
          case DocumentChangeType.removed:
            commentsList.remove(Comment.fromMap({...change.doc.data()!}));
            break;
        }
      }

      setState(() {});
    });
  }

  initReplyList() async {
    if (loadDataStreamReply != null) {
      loadDataStreamReply!.cancel();
      repliesList = [];
    }
    loadDataStreamReply = FirebaseFirestore.instance
        .collection('replies')
        .where('reportChecked', isEqualTo: false)
        .where('reportRemoved', isEqualTo: false)
        .orderBy('reportCounter', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            repliesList.add(Reply.fromMap({
              ...change.doc.data()!,
              'updatingStreamReply': updatingStreamReply
            }));
            break;
          case DocumentChangeType.modified:
            updatingStreamReply.add(Reply.fromMap({
              ...change.doc.data()!,
            }));
            break;
          case DocumentChangeType.removed:
            repliesList.remove(Reply.fromMap({...change.doc.data()!}));
            break;
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.05),
          appBar: AppBar(
            elevation: 4,
            toolbarHeight: 68,
            backgroundColor: Colors.white,
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 36,
                            height: 35,
                            child: Material(
                              shape: const CircleBorder(),
                              color: Colors.white,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                splashColor: Colors.grey.withOpacity(0.5),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 50), () {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Icon(Icons.arrow_back,
                                    color: Color.fromARGB(255, 80, 80, 80)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 51,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  child: Text(
                                    selected == "messages"
                                        ? 'Messages'
                                        : selected == "polls"
                                            ? 'Polls'
                                            : selected == "comments"
                                                ? 'Comments'
                                                : 'Replies',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 55, 55, 55),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.5,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 232,
                                  height: 32.5,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selected = "messages";
                                              initList();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: selected == "messages"
                                                  ? const Color.fromARGB(
                                                      255, 125, 125, 125)
                                                  : const Color.fromARGB(
                                                      255, 228, 228, 228),
                                            ),
                                            height: 100,
                                            width: 58,
                                            child: const Center(
                                              child: Text(
                                                'M',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selected = "polls";

                                              initPollList();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: selected == "polls"
                                                  ? const Color.fromARGB(
                                                      255, 125, 125, 125)
                                                  : const Color.fromARGB(
                                                      255, 228, 228, 228),
                                            ),
                                            height: 100,
                                            width: 58,
                                            child: const Center(
                                              child: Text(
                                                'P',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selected = "comments";

                                              initCommentList();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: selected == "comments"
                                                  ? const Color.fromARGB(
                                                      255, 125, 125, 125)
                                                  : const Color.fromARGB(
                                                      255, 228, 228, 228),
                                            ),
                                            height: 100,
                                            width: 58,
                                            child: const Center(
                                              child: Text(
                                                'C',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selected = "replies";

                                              initReplyList();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: selected == "replies"
                                                  ? const Color.fromARGB(
                                                      255, 125, 125, 125)
                                                  : const Color.fromARGB(
                                                      255, 228, 228, 228),
                                            ),
                                            height: 100,
                                            width: 58,
                                            child: const Center(
                                              child: Text(
                                                'R',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                postsList.isNotEmpty && selected == "messages"
                    ? ListView.builder(
                        itemCount: postsList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ReportPosts(
                                post: postsList[index],
                              ),
                            ],
                          );
                        },
                      )
                    : pollsList.isNotEmpty && selected == "polls"
                        ? ListView.builder(
                            itemCount: pollsList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ReportPolls(
                                poll: pollsList[index],
                              );
                            })
                        : commentsList.isNotEmpty && selected == "comments"
                            ? ListView.builder(
                                itemCount: commentsList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ReportComments(
                                    comment: commentsList[index],
                                  );
                                })
                            : repliesList.isNotEmpty && selected == "replies"
                                ? ListView.builder(
                                    itemCount: repliesList.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ReportReplies(
                                        reply: repliesList[index],
                                      );
                                    })
                                : Row(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
