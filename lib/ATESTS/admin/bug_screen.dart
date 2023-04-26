import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reportedBug.dart';
import '../provider/user_provider.dart';
import 'bug_list_recent.dart';
import '../models/user.dart';

class ReportBugAdmin extends StatefulWidget {
  const ReportBugAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportBugAdmin> createState() => _ReportBugAdminState();
}

class _ReportBugAdminState extends State<ReportBugAdmin> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var messages = 'true';

  List<ReportedBug> postsList = [];
  StreamSubscription? loadDataStream;
  StreamController<ReportedBug> updatingStream = StreamController.broadcast();

  List<ReportedBug> pollsList = [];
  StreamSubscription? loadDataStreamPoll;
  StreamController<ReportedBug> updatingStreamPoll =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    initList();
    // getValueM().then((value) => initList());
    // getValueM().then((value) => initPollList());
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
  }

  // Future<void>
  initList() async {
    if (loadDataStream != null) {
      loadDataStream!.cancel();
      postsList = [];
    }
    loadDataStream = FirebaseFirestore.instance
        .collection('reportedBugs')
        .where('saved', isEqualTo: false)
        .where('removed', isEqualTo: false)
        .orderBy('datePublished', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            postsList.add(ReportedBug.fromMap(
              {...change.doc.data()!, 'updatingStream': updatingStream},
              // 0
            )); // we are adding to a local list when the element is added in firebase collection
            break; //the Post element we will send on pair with updatingStream, because a Post constructor makes a listener on a stream.
          case DocumentChangeType.modified:
            updatingStream.add(ReportedBug.fromMap(
              {...change.doc.data()!},
              // 0
            )); // we are sending a modified object in the stream.
            break;
          case DocumentChangeType.removed:
            postsList.remove(ReportedBug.fromMap(
              {...change.doc.data()!},
              // 0
            )); // we are removing a Post object from the local list.
            break;
        }
      }

      setState(() {});
    });
  }

  // initPollList() async {
  //   if (loadDataStreamPoll != null) {
  //     loadDataStreamPoll!.cancel();
  //     pollsList = [];
  //   }
  //   loadDataStreamPoll = FirebaseFirestore.instance
  //       .collection('reportedBugs')
  //       .where('saved', isEqualTo: true)
  //       .where('removed', isEqualTo: false)
  //       .orderBy('datePublished', descending: true)
  //       .limit(1)
  //       .snapshots()
  //       .listen((event) {
  //     for (var change in event.docChanges) {
  //       switch (change.type) {
  //         case DocumentChangeType.added:
  //           pollsList.add(ReportedBug.fromMap({
  //             ...change.doc.data()!,
  //             'updatingStreamPoll': updatingStreamPoll
  //           })); // we are adding to a local list when the element is added in firebase collection
  //           break; //the Post element we will send on pair with updatingStream, because a Post constructor makes a listener on a stream.
  //         case DocumentChangeType.modified:
  //           updatingStreamPoll.add(ReportedBug.fromMap({
  //             ...change.doc.data()!,
  //           })); // we are sending a modified object in the stream.
  //           break;
  //         case DocumentChangeType.removed:
  //           pollsList.remove(ReportedBug.fromMap({
  //             ...change.doc.data()!
  //           })); // we are removing a Post object from the local list.
  //           break;
  //       }
  //     }

  //     setState(() {});
  //   });
  // }

  // Future<void> getValueM() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('selected_radio4') != null) {
  //     setState(() {
  //       messages = prefs.getString('selected_radio4')!;
  //     });
  //   }
  // }

  // // Future<void>
  // setValueM(String valuem) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     messages = valuem.toString();
  //     if (valuem == "true") {
  //       initList();
  //       initPollList();
  //     }
  //     prefs.setString('selected_radio4', messages);
  //   });
  // }

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
            toolbarHeight: 56,
            backgroundColor: Colors.white,
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 8, left: 8),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 35,
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
                          const SizedBox(width: 20),
                          const Text('Reported Bugs',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                          // Column(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 1.0),
                          //       child: Text(
                          //         messages == "true" ? 'Not Read' : 'Saved',
                          //         style: const TextStyle(
                          //           color: Color.fromARGB(255, 55, 55, 55),
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 14.5,
                          //           letterSpacing: 0.5,
                          //         ),
                          //       ),
                          //     ),
                          //     Container(
                          //       width: 116,
                          //       height: 32.5,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(25),
                          //         border: Border.all(
                          //           width: .75,
                          //           color: Colors.grey,
                          //         ),
                          //       ),
                          //       child: Row(
                          //         children: [
                          //           ClipRRect(
                          //             child: InkWell(
                          //               borderRadius: const BorderRadius.only(
                          //                 topLeft: Radius.circular(25),
                          //                 bottomLeft: Radius.circular(25),
                          //               ),
                          //               onTap: () {
                          //                 messages == "true"
                          //                     ? null
                          //                     : setState(() {
                          //                         messages = "true";
                          //                         initList();
                          //                         initPollList();
                          //                       });
                          //               },
                          //               child: Container(
                          //                   decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         const BorderRadius.only(
                          //                       topLeft: Radius.circular(25),
                          //                       bottomLeft: Radius.circular(25),
                          //                     ),
                          //                     color: messages == "true"
                          //                         ? const Color.fromARGB(
                          //                             255, 125, 125, 125)
                          //                         : const Color.fromARGB(
                          //                             255, 228, 228, 228),
                          //                   ),
                          //                   height: 100,
                          //                   width: 57.125,
                          //                   child: Icon(Icons.circle,
                          //                       color: Colors.white,
                          //                       size: messages == "true"
                          //                           ? 23
                          //                           : 13)),
                          //             ),
                          //           ),
                          //           ClipRRect(
                          //             child: InkWell(
                          //               borderRadius: const BorderRadius.only(
                          //                 topRight: Radius.circular(25),
                          //                 bottomRight: Radius.circular(25),
                          //               ),
                          //               onTap: () {
                          //                 messages != "true"
                          //                     ? null
                          //                     : setState(() {
                          //                         messages = "false";
                          //                         initList();
                          //                         initPollList();
                          //                       });
                          //               },
                          //               child: Container(
                          //                   decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         const BorderRadius.only(
                          //                       topRight: Radius.circular(25),
                          //                       bottomRight: Radius.circular(25),
                          //                     ),
                          //                     color: messages != "true"
                          //                         ? const Color.fromARGB(
                          //                             255, 125, 125, 125)
                          //                         : const Color.fromARGB(
                          //                             255, 228, 228, 228),
                          //                   ),
                          //                   height: 100,
                          //                   width: 57.125,
                          //                   child: Icon(Icons.circle,
                          //                       color: Colors.white,
                          //                       size: messages != "true"
                          //                           ? 23
                          //                           : 13)),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: postsList.isNotEmpty && messages == "true"
              ? SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: postsList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final User? user =
                          Provider.of<UserProvider>(context).getUser;
                      return BugListRecent(
                        reportedBug: postsList[index],
                      );
                    },
                  ),
                )
              // : pollsList.isNotEmpty && messages == "false"
              //     ? SingleChildScrollView(
              //         child: ListView.builder(
              //             itemCount: pollsList.length,
              //             shrinkWrap: true,
              //             physics: const NeverScrollableScrollPhysics(),
              //             itemBuilder: (context, index) {
              //               final User? user =
              //                   Provider.of<UserProvider>(context).getUser;

              //               return BugListSave(
              //                 reportedBug: pollsList[index],
              //               );
              //             }),
              //       )
              : const Center(
                  child: Text(
                    'No reported bugs yet.',
                    style: TextStyle(
                        color: Color.fromARGB(255, 114, 114, 114),
                        fontSize: 18),
                  ),
                ),
        ),
      ),
    );
  }
}
