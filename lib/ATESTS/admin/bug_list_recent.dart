import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/reportedBug.dart';
import '../utils/utils.dart';

class BugListRecent extends StatefulWidget {
  final ReportedBug reportedBug;

  const BugListRecent({
    Key? key,
    required this.reportedBug,
  }) : super(key: key);

  @override
  State<BugListRecent> createState() => _BugListRecentState();
}

class _BugListRecentState extends State<BugListRecent> {
  late ReportedBug _reportedBug;
  var snap;

  @override
  void initState() {
    super.initState();
    _reportedBug = widget.reportedBug;
  }

  @override
  Widget build(BuildContext context) {
    _reportedBug = widget.reportedBug;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reportedBugs')
            .doc(_reportedBug.bugId)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          snap = snapshot.data != null
              ? ReportedBug.fromSnap(snapshot.data!)
              : snap;
          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          }
          return snap.saved == true || snap.removed == true
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
                    child: Column(
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
                                            child: Column(
                                              children: [
                                                const Text('Reported Bug:'),
                                                Text(
                                                  '${_reportedBug.reportedBugText} ',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                const Text('Device Type:'),
                                                Text(
                                                  '${_reportedBug.deviceType} ',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  saveBugDialog(
                                                    context: context,
                                                    bugId: _reportedBug.bugId,
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: const Color.fromARGB(
                                                        255, 204, 204, 204),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: 120,
                                                  child: const Center(
                                                    child: Text(
                                                      'SAVE',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  deleteBugDialog(
                                                    context: context,
                                                    bugId: _reportedBug.bugId,
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: const Color.fromARGB(
                                                        255, 255, 133, 124),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  width: 120,
                                                  child: const Center(
                                                    child: Text(
                                                      'DELETE',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                    ),
                  ),
                );
        });
  }
}
