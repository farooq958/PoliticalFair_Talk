import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../methods/auth_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';

class VerificationSuccess extends StatefulWidget {
  const VerificationSuccess({Key? key}) : super(key: key);

  @override
  State<VerificationSuccess> createState() => _VerificationSuccessState();
}

class _VerificationSuccessState extends State<VerificationSuccess> {
  var snap;

  void verificationSuccess() async {
    try {
      String res = await AuthMethods().verificationSuccess();
      if (res == "success") {
        Navigator.pop(context);
      } else {
        // showSnackBar(res, context);
      }
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.UID)
            .snapshots(),
        builder: (content,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          snap = snapshot.data != null ? User.fromSnap(snapshot.data!) : snap;
          if (!snapshot.hasData || snapshot.data == null) {
            return Row();
          }
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20),
                  child: Center(
                    child: SingleChildScrollView(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                    'Congratulations, your account has been successfully verified!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.verified,
                                        size: 55, color: Colors.blue),
                                    SizedBox(
                                        width: 65,
                                        height: 32.5,
                                        child: Image.asset(
                                            'icons/flags/png/${snap?.aaCountry}.png',
                                            package: 'country_icons')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "With a verified account, you now have full access to all of Fairtalk's features, this includes:",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0),
                                ),
                                // Container(height: 8),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 2),
                                //   child: Container(
                                //     width: MediaQuery.of(context).size.width,
                                //     decoration: const BoxDecoration(
                                //       border: Border(
                                //         top: BorderSide(
                                //             width: 1, color: Colors.black),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(height: 10),
                                Text(
                                  " • Participating in Fairtalk's democracy.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  " • Voting on posts will now count.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  " • Sending messages & polls Nationally.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0),
                                ),

                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  " • More profile personalization options.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  " • And much more!",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 10),
                            child: Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                splashColor: Colors.black.withOpacity(0.3),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 150), () {
                                    verificationSuccess();
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, top: 12, bottom: 12, right: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(width: 8),
                                        const Text(
                                          'Continue as Verified',
                                          style: TextStyle(
                                              fontSize: 18,
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
        },
      ),
    );
  }
}
