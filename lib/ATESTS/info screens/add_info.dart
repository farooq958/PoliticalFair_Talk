import 'package:aft/ATESTS/info%20screens/how_it_works.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../responsive/my_flutter_app_icons.dart';
import '../utils/global_variables.dart';
import 'add_post_rules.dart';
import 'terms_conditions.dart';

class AddInfo extends StatefulWidget {
  const AddInfo({Key? key}) : super(key: key);

  @override
  State<AddInfo> createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: testing,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: darkBlue,
              elevation: 4,
              toolbarHeight: 56,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 6, right: 6),
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
                              child: const Icon(
                                Icons.keyboard_arrow_left,
                                size: 24,
                                color: whiteDialog,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 16),
                        const Text('Posting on FairTalk',
                            style: TextStyle(
                                color: whiteDialog,
                                fontSize: 20,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ]),
          body: Padding(
            padding: const EdgeInsets.only(top: 2, right: 2, bottom: 2),
            child: RawScrollbar(
              radius: const Radius.circular(25),
              thickness: 6,
              thumbVisibility: true,
              thumbColor: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 16,
                  bottom: 16,
                ),
                child: SingleChildScrollView(
                  child: PhysicalModel(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "There are 4 different types of posts:",
                            style: TextStyle(
                              color: whiteDialog,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(MyFlutterApp.globe_americas,
                                  color: whiteDialog, size: 15),
                              SizedBox(width: 3),
                              Icon(Icons.message, color: whiteDialog, size: 15),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Global Messages",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(Icons.flag, color: whiteDialog, size: 15),
                              SizedBox(width: 3),
                              Icon(Icons.message, color: whiteDialog, size: 15),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "National Messages",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(MyFlutterApp.globe_americas,
                                  color: whiteDialog, size: 15),
                              SizedBox(width: 3),
                              RotatedBox(
                                quarterTurns: 1,
                                child: Icon(Icons.poll,
                                    color: whiteDialog, size: 15),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Global Polls",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(Icons.flag, color: whiteDialog, size: 15),
                              SizedBox(width: 3),
                              RotatedBox(
                                quarterTurns: 1,
                                child: Icon(Icons.poll,
                                    color: whiteDialog, size: 15),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "National Polls",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Once you create a post, it'll immediately get listed on our Home screen where other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the post that received the highest score will be saved and added to FairTalk's Archives collection.",
                            style: TextStyle(
                              color: whiteDialog,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Posts sent on a specific date compete against other posts sent on that same date.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: whiteDialog,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "You can only create one post of each type every 24 hours. This helps prevent spam and gives each user the same chance of getting their post archived. The cycle refreshes at 12:01AM EST each & every day.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: whiteDialog,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "To eliminate the manipulation of our voting system, only votes from verified accounts are counted.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: whiteDialog,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 15),
                          // RichText(
                          //   text: TextSpan(
                          //     children: <TextSpan>[
                          //       const TextSpan(
                          //           text: 'For additonal details ',
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               letterSpacing: 0)),
                          //       TextSpan(
                          //           text: 'click here.',
                          //           style: const TextStyle(
                          //               color: Colors.blue, letterSpacing: 0),
                          //           recognizer: TapGestureRecognizer()
                          //             ..onTap = () {
                          //               Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       const HowItWorks(),
                          //                 ),
                          //               );
                          //             }),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text:
                                              'To view our rules & restrictions, ',
                                          style: TextStyle(
                                            color: whiteDialog,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          )),
                                      TextSpan(
                                          text: 'click here.',
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 103, 187, 255),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddPostRules(),
                                                ),
                                              );
                                            }),
                                    ],
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
