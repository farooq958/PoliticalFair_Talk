import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../responsive/my_flutter_app_icons.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<String> counters = [];
  int getVerifiedCounter = 0;
  int getUserCounter = 0;
  int getMessageCounter = 0;
  int getPollCounter = 0;

  // Future getDocId() async {
  //   await FirebaseFirestore.instance.collection('postCounter').get().then(
  //         (snapshot) => snapshot.docs.forEach((element) {
  //           counters.add(element.reference.id);
  //         }),
  //       );
  // }

  final CollectionReference firestoreInstance =
      FirebaseFirestore.instance.collection('postCounter');

  Future<String> _loadVerifiedCounter() async {
    String res1 = "Some error occurred.";
    try {
      await firestoreInstance.doc('verifiedCounter').get().then((event) {
        setState(() {
          getVerifiedCounter = event['counter'];
        });
      });
      await firestoreInstance.doc('userCounter').get().then((event) {
        setState(() {
          getUserCounter = event['counter'];
        });
      });
      await firestoreInstance.doc('messageCounter').get().then((event) {
        setState(() {
          getMessageCounter = event['counter'];
        });
      });
      await firestoreInstance.doc('pollCounter').get().then((event) {
        setState(() {
          getPollCounter = event['counter'];
        });
      });
      res1 = "success";
    } catch (e) {
      //
    }
    return res1;
  }

  @override
  void initState() {
    super.initState();
    _loadVerifiedCounter();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    var safePadding = MediaQuery.of(context).padding.top;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                toolbarHeight: 56,
                backgroundColor: Colors.white,
                actions: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text('Statistics',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  PhysicalModel(
                    elevation: 3,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.person_outlined, size: 17),
                                      SizedBox(width: 8),
                                      Text('Accounts:',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                              Text('$getUserCounter',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.verified_outlined, size: 17),
                                  SizedBox(width: 8),
                                  Text('Verified Accounts:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Text('$getVerifiedCounter',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.message_outlined, size: 17),
                                  SizedBox(width: 8),
                                  Text('Messages:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Text('$getMessageCounter',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(Icons.poll_outlined, size: 17),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Polls:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Text('$getPollCounter',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
