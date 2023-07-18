import 'dart:convert';
import 'dart:typed_data';
import 'package:aft/ATESTS/methods/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import '../info screens/data_privacy.dart';
import '../methods/storage_methods.dart';
import '../provider/user_provider.dart';
import '../methods/auth_methods.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'add_post_daily.dart';

final List<Uint8List> emailAttachmentPhotos = [];

class VerifyComplete extends StatefulWidget {
  var durationInDay;
  VerifyComplete({Key? key, this.durationInDay}) : super(key: key);

  @override
  State<VerifyComplete> createState() => _VerifyCompleteState();
}

class _VerifyCompleteState extends State<VerifyComplete> {
  bool isLoading = false;
  int getVerifiedCounter = 0;

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

  Future<String> sendEmailMessage() async {
    String res2 = "Some error ocurred.";
    try {
      sendEmail();
      res2 = "success";
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
    return res2;
  }

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
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
                            'Verification Completed',
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
                          border: Border(
                              bottom: BorderSide(color: darkBlue, width: 0)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height -
                                    56 -
                                    safePadding >=
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: Image.asset(
                                  'assets/finish.png',
                                ),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "All Done!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0),
                                      ),
                                      Container(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  width: 2,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(height: 8),
                                      const Text(
                                        "Once you click on continue, it'll only take between a few minutes to a few hours before you'll receive information on whether or not you've passed the verification process.",
                                        // "Once you click on continue, it'll only take a few minutes to a few hours before you'll receive an email informing you whether you've passed or failed the verification process.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(height: 8),
                                      const Text(
                                        "The personal data you've provided by verifying your account is 100% secure and will never be shared or sold.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(height: 8),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text:
                                                    "For more information, feel free to read our ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            TextSpan(
                                                text: 'Privacy Policy',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 85, 178, 255),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const DataPrivacy(),
                                                          ),
                                                        );
                                                      }),
                                            const TextSpan(
                                                text: ".",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            // TextSpan(
                                            //     text:
                                            //         " or contact us by email: fairtalk.assist@gmail.com",
                                            //     style: TextStyle(
                                            //       color: Colors.white,
                                            //       fontSize: 13.5,
                                            //       letterSpacing: 0,
                                            //     )),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    PhysicalModel(
                                      color: whiteDialog,
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(50),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          splashColor:
                                              Colors.grey.withOpacity(0.5),
                                          onTap: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 150),
                                                () async {
                                              if (emailAttachmentPhotos
                                                      .length ==
                                                  2) {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                List<String> photoUrls = [];
                                                for (Uint8List file
                                                    in emailAttachmentPhotos) {
                                                  // Upload image to Firestorage
                                                  String photoUrl =
                                                      await StorageMethods()
                                                          .uploadImageToStorage(
                                                              'email_attachment_photos',
                                                              file,
                                                              true);
                                                  photoUrls.add(photoUrl);
                                                }

                                                // Update download url in Firestore database
                                                var res = await AuthMethods()
                                                    .addEmailAttachmentPhotos(
                                                  photoOne: photoUrls[0],
                                                  photoTwo: photoUrls[1],
                                                );

                                                var res1 =
                                                    await _loadVerifiedCounter();
                                                // var ntpTime = await NTP.now();
                                                setState(()

                                                    // async
                                                    {
                                                  FirestoreMethods()
                                                      .postCounter('verified');
                                                  AuthMethods().changeIsPending(
                                                      pending: 'true');
                                                  AuthMethods().addPendingDate(
                                                      pendingDate:
                                                          getVerifiedCounter);
                                                  UserProvider userProvider =
                                                      Provider.of(context,
                                                          listen: false);
                                                  userProvider.refreshUser();
                                                  isLoading = false;
                                                });

                                                String res2 =
                                                    await sendEmailMessage();

                                                if (res == 'success' &&
                                                    res1 == 'success' &&
                                                    res2 == 'success') {
                                                  emailAttachmentPhotos.clear();

                                                  showSnackBar(
                                                      "Verification successfully completed.",
                                                      context);

                                                  // widget.durationInDay == null
                                                  //     ?
                                                  goToHome(context);
                                                  // : Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             AddPostDaily(
                                                  //               durationInDay:
                                                  //                   widget
                                                  //                       .durationInDay,
                                                  //             )),
                                                  //   );
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text('Continue',
                                                    style: TextStyle(
                                                        fontSize: 16.5,
                                                        color: darkBlue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0)),
                                                Container(width: 8),
                                                const Icon(
                                                  Icons.keyboard_arrow_right,
                                                  size: 20,
                                                  color: darkBlue,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   width:
                                    //       MediaQuery.of(context).size.width * 0.85,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.only(
                                    //         top: 8.0, right: 10, left: 10),
                                    //     child: RichText(
                                    //       text: TextSpan(
                                    //         children: <TextSpan>[
                                    //           const TextSpan(
                                    //               text:
                                    //                   'By clicking on Continue, you agree to our ',
                                    //               style: TextStyle(
                                    //                   color: Colors.white,
                                    //                   fontSize: 12)),
                                    //           TextSpan(
                                    //               text: 'Terms of Use',
                                    //               style: const TextStyle(
                                    //                   color: Colors.blue,
                                    //                   fontSize: 12),
                                    //               recognizer: TapGestureRecognizer()
                                    //                 ..onTap = () {
                                    //                   Navigator.of(context).push(
                                    //                     MaterialPageRoute(
                                    //                       builder: (context) =>
                                    //                           const TermsConditions(),
                                    //                     ),
                                    //                   );
                                    //                 }),
                                    //           const TextSpan(
                                    //               text:
                                    //                   ' and confirm that you have read and understood our ',
                                    //               style: TextStyle(
                                    //                   color: Colors.white,
                                    //                   fontSize: 12)),
                                    //           TextSpan(
                                    //               text: 'Privacy Policy',
                                    //               style: const TextStyle(
                                    //                   color: Colors.blue,
                                    //                   fontSize: 12),
                                    //               recognizer: TapGestureRecognizer()
                                    //                 ..onTap = () {
                                    //                   Navigator.of(context).push(
                                    //                     MaterialPageRoute(
                                    //                       builder: (context) =>
                                    //                           const DataPrivacy(),
                                    //                     ),
                                    //                   );
                                    //                 }),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
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
        ),
        Positioned.fill(
          child: Visibility(
            visible: isLoading,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future sendEmail() async {
  var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  var response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-type': 'application/json',
    },
    body: jsonEncode({
      'service_id': 'service_uwryr0u',
      'template_id': 'template_ln69u1g',
      'user_id': 'Kil1lduE_7f94fMy1',
      'template_params': {
        'sender_name': 'FairTalk',
        'sender_email': 'fairtalk.assist@gmail.com',
        'receiver_name': 'FairTalk',
        'receiver_email': 'fairtalk.assist@gmail.com',
        // 'sender_name': senderName,
        // 'sender_email': senderEmail,
        // 'receiver_name': receiverName,
        // 'receiver_email': receiverEmail,
        'subject': 'New Verification Alert',
        'message': 'New Verification Pending',
      }
    }),
  );
}
