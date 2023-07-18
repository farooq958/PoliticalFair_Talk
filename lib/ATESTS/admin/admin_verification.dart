import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../screens/full_image_profile.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'admin_verification_check.dart';

class AdminVerification extends StatefulWidget {
  const AdminVerification({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminVerification> createState() => _AdminVerificationState();
}

class _AdminVerificationState extends State<AdminVerification> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool isCheck = false;
  var streamData;

  // String verificationSuccess =
  //     "Congratulations, your FairTalk account has been successfully verified!\n With a verified account, you have full access to all of FairTalk's features. This includes voting, creating National message/polls, more profile personalization options & much more!";
  // String unclearPictures =
  //     "Unfortunately your account did not pass the verification process.\n Here's why:\n One or both pictures taken were unclear. Please make sure that the quality of the pictures taken are clear and that the information on your ID card can easily be read.";
  // String alreadyHaveAnotherAccount =
  //     "Unfortunately your account did not pass the verification process.\n Here's why:\n Our dataset showed us that you've already created and verified another account on FairTalk. It wouldn't be fair for other users if you had access to multiple verified accounts and had the ability to vote multiple times. This is why this rule is stricly reinforced.";
  // String twoPicturesDontMatch =
  //     "Unfortunately your account did not pass the verification process.\n Here's why:\n With the help of our facial recognition technology, the person on the ID card did not match the person holding the ID card. These results are not always 100% accurate and you'll always have the opportunity to try the verification process again.";
  // String fakeId =
  //     "Unfortunately your account did not pass the verification process.\n Here's why:\n With the help of our technology, your identification card was classified as being inauthentic. These results are not always 100% accurate and you'll always have the opportunity to try the verification process again.";
  // String under18 =
  //     "Unfortunately your account did not pass the verification process.\n Here's why:\n We're currently only accepting individuals who are over the age of 18. You'll always have the opportunity to get verified once you're over the age of 18!";

  bool isUnclearPictures = false;
  bool isAlreadyHaveAnotherAccount = false;
  bool isTwoPicturesDontMatch = false;
  bool isFakeId = false;
  bool isUnder18 = false;

  int getVerifiedCounter = 0;

  @override
  void initState() {
    super.initState();
    isCheck = false;
    streamData = FirebaseFirestore.instance
        .collection('users')
        .where('pending', isEqualTo: "true")
        .where('aaCountry', isEqualTo: "")
        // .orderBy('aaCountry', descending: false)
        .orderBy('pendingDate', descending: false)
        .limit(1)
        .snapshots();

    _loadVerifiedCounter();
  }

  final CollectionReference firestoreInstance =
      FirebaseFirestore.instance.collection('aPostCounter');

  Future<String> _loadVerifiedCounter() async {
    String res1 = "Some error occurred.";
    try {
      await firestoreInstance.doc('verifiedCounter').get().then((event) {
        setState(() {
          getVerifiedCounter = event['counter'];
        });
      });
      res1 = "success";
    } catch (e) {
      //
    }
    return res1;
  }

  void verificationAccepted(String name, String country, String uid,
      String username, String email, bool isAccept) async {
    try {
      String res = await AuthMethods()
          .verificationAccept(name: name, country: country, uid: uid);
      if (res == "success") {
        setState(() {
          isCheck = false;

          _nameController.clear();
          _countryController.clear();
        });
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
        // sendEmailMessage(username, email, isAccept);
      } else {}
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  void verificationDenied(
      String name,
      String country,
      String uid,
      String username,
      // String email,
      bool isAccept) async {
    try {
      String res = await AuthMethods().verificationDeny(
          uid: uid,
          type: isUnclearPictures
              ? "unclearPictures"
              : isAlreadyHaveAnotherAccount
                  ? "alreadyHaveAnotherAccount"
                  : isTwoPicturesDontMatch
                      ? "twoPicturesDontMatch"
                      : isFakeId
                          ? "fakeId"
                          : isUnder18
                              ? "under18"
                              : "");

      // String res2 = await sendEmailMessage(username, email, isAccept);
      if (res == "success")
      // && res2 == "success"

      {
        setState(() {
          isCheck = false;
          isUnclearPictures = false;
          isAlreadyHaveAnotherAccount = false;
          isTwoPicturesDontMatch = false;
          isFakeId = false;
          isUnder18 = false;
          _nameController.clear();
          _countryController.clear();
        });
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
      } else {}
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  // Future<String> sendEmailMessage(
  //   String username,
  //   String email,
  //   bool isAccept,
  // ) async {
  //   String res = "Some error ocurred";
  //   try {
  //     sendEmail(
  //         // receiverName: username,
  //         // receiverEmail: email,
  //         // // receiverEmail: 'seb.doyon21@gmail.com',
  //         // senderEmail: 'fairtalk.assist@gmail.com',
  //         // senderName: 'FairTalk',
  //         // subject: 'Account Verification',
  //         // message: isAccept
  //         //     ? verificationSuccess
  //         //     : isUnclearPictures
  //         //         ? unclearPictures
  //         //         : isAlreadyHaveAnotherAccount
  //         //             ? alreadyHaveAnotherAccount
  //         //             : isTwoPicturesDontMatch
  //         //                 ? twoPicturesDontMatch
  //         //                 : isFakeId
  //         //                     ? fakeId
  //         //                     : isUnder18
  //         //                         ? under18
  //         //                         : '',
  //         );
  //     res = "success";
  //   } catch (e) {
  //     // showSnackBar(e.toString(), context);
  //   }
  //   return res;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              elevation: 4,
              toolbarHeight: 56,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: SizedBox(
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
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(width: 22),
                      const Text('Verification System',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ]),
          body: ListView(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6 - 6,
                  child: TextField(
                    // onChanged: (val) {
                    //   setState(() {
                    //     isCheck = false;
                    //   });
                    // },
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: darkBlue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                      ),
                      labelText: 'Name',
                      labelStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      fillColor: const Color.fromARGB(255, 245, 245, 245),
                      filled: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: TextField(
                        // onChanged:
                        // (val) {
                        //   setState(() {
                        //     isCheck = false;
                        //   });
                        // },
                        controller: _countryController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: darkBlue, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                          labelText: 'Country',
                          labelStyle:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          fillColor: const Color.fromARGB(255, 245, 245, 245),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Material(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        splashColor: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          setState(() {
                            isCheck = true;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.3 - 12,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                              child: Text('Verify',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500)),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              StreamBuilder(
                stream: streamData,

                // FirebaseFirestore.instance
                //     .collection('users')
                //     .where('pending', isEqualTo: "true")
                //     .where('aaCountry', isEqualTo: "")
                //     // .orderBy('aaCountry', descending: false)
                //     .orderBy('pendingDate', descending: false)
                //     .limit(1)
                //     .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row();
                  }
                  return snapshot.data?.docs.length != 0
                      ? SingleChildScrollView(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              User user = User.fromSnap(
                                snapshot.data!.docs[index],
                              );

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                        'In queue:  ${(getVerifiedCounter - user.pendingDate).toString()}',
                                        // DateFormat('MMM d - hh:mm a').format(
                                        //   user.pendingDate.toDate(),
                                        // ),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                          fontSize: 16,
                                        )),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Future.delayed(
                                            const Duration(milliseconds: 150),
                                            () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullImageProfile(
                                                            photo:
                                                                user.photoOne)),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                            height: 170,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 241, 241, 241),
                                            ),
                                            child: Image.network(
                                                user.photoOne ?? '',
                                                width: 100,
                                                height: 100)),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Future.delayed(
                                            const Duration(milliseconds: 150),
                                            () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullImageProfile(
                                                            photo:
                                                                user.photoTwo)),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                            height: 170,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 241, 241, 241),
                                            ),
                                            child: Image.network(
                                                user.photoTwo ?? '',
                                                width: 100,
                                                height: 100)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  isCheck
                                      ? Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12.0),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          width: 1,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Text(
                                                      'Users with identical name & country:',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5)),
                                                ),
                                                const SizedBox(height: 8),
                                                StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where('aaName',
                                                          isEqualTo:
                                                              _nameController
                                                                  .text)
                                                      .where('aaCountry',
                                                          isEqualTo:
                                                              _countryController
                                                                  .text)
                                                      .limit(10)
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot<
                                                                  Map<String,
                                                                      dynamic>>>
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Row();
                                                    }
                                                    return snapshot.data?.docs
                                                                .length !=
                                                            0
                                                        ? SingleChildScrollView(
                                                            child: ListView
                                                                .builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  snapshot
                                                                      .data
                                                                      ?.docs
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                User user = User
                                                                    .fromSnap(
                                                                  snapshot.data!
                                                                          .docs[
                                                                      index],
                                                                );

                                                                return Column(
                                                                  children: [
                                                                    AdminVerificationCheck(
                                                                      user:
                                                                          user,
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : Column(
                                                            children: const [
                                                              Center(
                                                                child: Text(
                                                                  'No identical results found.',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    letterSpacing:
                                                                        0.3,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 8),
                                                            ],
                                                          );
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12.0),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          width: 1,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) => Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          alignment:
                                                              Alignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                              width: 300,
                                                              height: 180,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                  color:
                                                                      whiteDialog),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      10,
                                                                      10,
                                                                      10),
                                                              child: SizedBox(
                                                                height: 180,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                        'Confirm Action',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500)),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        verificationAccepted(
                                                                            _nameController.text,
                                                                            _countryController.text,
                                                                            user.UID,
                                                                            user.username,
                                                                            user.aEmail,
                                                                            true);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(25),
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        width:
                                                                            120,
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            'ACCEPT',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                126,
                                                                                126,
                                                                                126)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      child: const Center(
                                                        child: Text('ACCEPT',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    isUnclearPictures ==
                                                                false &&
                                                            isAlreadyHaveAnotherAccount ==
                                                                false &&
                                                            isTwoPicturesDontMatch ==
                                                                false &&
                                                            isFakeId == false &&
                                                            isUnder18 == false
                                                        ? showSnackBar(
                                                            'Select reason for decline.',
                                                            context)
                                                        : showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                Dialog(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: Stack(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 300,
                                                                    height: 180,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                25),
                                                                        color:
                                                                            whiteDialog),
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          180,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                              'Confirm Action',
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              verificationDenied(
                                                                                  _nameController.text,
                                                                                  _countryController.text,
                                                                                  user.UID,
                                                                                  user.username,
                                                                                  // user.aEmail,
                                                                                  false);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(25),
                                                                                color: Colors.red,
                                                                              ),
                                                                              padding: const EdgeInsets.all(10),
                                                                              width: 120,
                                                                              height: 40,
                                                                              child: const Center(
                                                                                child: Text(
                                                                                  'DENY',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Cancel',
                                                                              style: TextStyle(fontWeight: FontWeight.w500, color: Color.fromARGB(255, 126, 126, 126)),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      child: const Center(
                                                        child: Text('DENY',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(
                                                              (() {
                                                                isUnclearPictures
                                                                    ? isUnclearPictures =
                                                                        false
                                                                    : isUnclearPictures =
                                                                        true;
                                                                isAlreadyHaveAnotherAccount =
                                                                    false;
                                                                isTwoPicturesDontMatch =
                                                                    false;
                                                                isFakeId =
                                                                    false;
                                                                isUnder18 =
                                                                    false;
                                                              }),
                                                            );
                                                          },
                                                          child: Icon(
                                                              isUnclearPictures
                                                                  ? Icons
                                                                      .check_box
                                                                  : Icons
                                                                      .check_box_outline_blank_outlined,
                                                              color:
                                                                  Colors.blue)),
                                                      const SizedBox(width: 10),
                                                      const Text(
                                                          'Unclear picture(s)',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(
                                                              (() {
                                                                isAlreadyHaveAnotherAccount
                                                                    ? isAlreadyHaveAnotherAccount =
                                                                        false
                                                                    : isAlreadyHaveAnotherAccount =
                                                                        true;
                                                                isUnclearPictures =
                                                                    false;
                                                                isTwoPicturesDontMatch =
                                                                    false;
                                                                isFakeId =
                                                                    false;
                                                                isUnder18 =
                                                                    false;
                                                              }),
                                                            );
                                                          },
                                                          child: Icon(
                                                              isAlreadyHaveAnotherAccount
                                                                  ? Icons
                                                                      .check_box
                                                                  : Icons
                                                                      .check_box_outline_blank_outlined,
                                                              color:
                                                                  Colors.blue)),
                                                      const SizedBox(width: 10),
                                                      const Text(
                                                          'Already created a verified account',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(
                                                              (() {
                                                                isTwoPicturesDontMatch
                                                                    ? isTwoPicturesDontMatch =
                                                                        false
                                                                    : isTwoPicturesDontMatch =
                                                                        true;
                                                                isAlreadyHaveAnotherAccount =
                                                                    false;
                                                                isUnclearPictures =
                                                                    false;
                                                                isFakeId =
                                                                    false;
                                                                isUnder18 =
                                                                    false;
                                                              }),
                                                            );
                                                          },
                                                          child: Icon(
                                                              isTwoPicturesDontMatch
                                                                  ? Icons
                                                                      .check_box
                                                                  : Icons
                                                                      .check_box_outline_blank_outlined,
                                                              color:
                                                                  Colors.blue)),
                                                      const SizedBox(width: 10),
                                                      const Text(
                                                          'Pictures do not match',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(
                                                              (() {
                                                                isFakeId
                                                                    ? isFakeId =
                                                                        false
                                                                    : isFakeId =
                                                                        true;
                                                                isAlreadyHaveAnotherAccount =
                                                                    false;
                                                                isTwoPicturesDontMatch =
                                                                    false;
                                                                isUnclearPictures =
                                                                    false;
                                                                isUnder18 =
                                                                    false;
                                                              }),
                                                            );
                                                          },
                                                          child: Icon(
                                                              isFakeId
                                                                  ? Icons
                                                                      .check_box
                                                                  : Icons
                                                                      .check_box_outline_blank_outlined,
                                                              color:
                                                                  Colors.blue)),
                                                      const SizedBox(width: 10),
                                                      const Text('Fake ID',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(
                                                              (() {
                                                                isUnder18
                                                                    ? isUnder18 =
                                                                        false
                                                                    : isUnder18 =
                                                                        true;
                                                                isAlreadyHaveAnotherAccount =
                                                                    false;
                                                                isTwoPicturesDontMatch =
                                                                    false;
                                                                isFakeId =
                                                                    false;
                                                                isUnclearPictures =
                                                                    false;
                                                              }),
                                                            );
                                                          },
                                                          child: Icon(
                                                              isUnder18
                                                                  ? Icons
                                                                      .check_box
                                                                  : Icons
                                                                      .check_box_outline_blank_outlined,
                                                              color:
                                                                  Colors.blue)),
                                                      const SizedBox(width: 10),
                                                      const Text('Under 18',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(),
                                ],
                              );
                            },
                          ),
                        )
                      : Column(
                          children: const [
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                'No pending verifications.',
                                style: TextStyle(
                                  fontSize: 17,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Future sendEmail(
//     // {
//     // Sender
//     // required String senderName,
//     // required String senderEmail,

//     // Receiver
//     // required String receiverName,
//     // required String receiverEmail,

//     // Email
//     // required String subject,
//     // required String message,
// // }
//     ) async {
//   var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
//   var response = await http.post(
//     url,
//     headers: {
//       'origin': 'http://localhost',
//       'Content-type': 'application/json',
//     },
//     body: jsonEncode({
//       'service_id': 'service_uwryr0u',
//       'template_id': 'template_ln69u1g',
//       'user_id': 'Kil1lduE_7f94fMy1',
//       'template_params': {
//         'sender_name': 'FairTalk',
//         'sender_email': 'fairtalk.assist@gmail.com',
//         'receiver_name': 'FairTalk',
//         'receiver_email': 'fairtalk.assist@gmail.com',
//         // 'sender_name': senderName,
//         // 'sender_email': senderEmail,
//         // 'receiver_name': receiverName,
//         // 'receiver_email': receiverEmail,
//         'subject': 'New Verification Alert',
//         'message': 'New Verification Pending',
//       }
//     }),
//   );
// }
