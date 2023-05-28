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
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
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
                                Icons.arrow_back,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 12),
                        const Text('Posting on Fairtalk',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500)),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "There are 4 different types of posts:",
                            style: TextStyle(
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(MyFlutterApp.globe_americas,
                                  color: Color.fromARGB(255, 56, 56, 56),
                                  size: 15),
                              SizedBox(width: 3),
                              Icon(Icons.message,
                                  color: Color.fromARGB(255, 56, 56, 56),
                                  size: 15),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Global Messages",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(Icons.flag,
                                  color: Color.fromARGB(255, 56, 56, 56),
                                  size: 15),
                              SizedBox(width: 3),
                              Icon(Icons.message,
                                  color: Color.fromARGB(255, 56, 56, 56),
                                  size: 15),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "National Messages",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(MyFlutterApp.globe_americas,
                                  color: Color.fromARGB(255, 56, 56, 56),
                                  size: 15),
                              SizedBox(width: 3),
                              RotatedBox(
                                quarterTurns: 1,
                                child: Icon(Icons.poll,
                                    color: Color.fromARGB(255, 56, 56, 56),
                                    size: 15),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Global Polls",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(Icons.flag,
                                  color: Color.fromARGB(255, 56, 56, 56),
                                  size: 15),
                              SizedBox(width: 3),
                              RotatedBox(
                                quarterTurns: 1,
                                child: Icon(Icons.poll,
                                    color: Color.fromARGB(255, 56, 56, 56),
                                    size: 15),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "National Polls",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Once you create a post, it'll immediately get listed on our Home screen where other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the post that received the highest score will be saved and added to Fairtalk's Archives collection.",
                            style: TextStyle(
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Posts sent on a specific date compete against other posts that were also sent on that same date.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "You can only create one post of each type every 24 hours. This helps prevent spam and gives each user the same chance of getting their post archived. The cycle refreshes at 12:01AM EST each & every day.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "National messages/polls can only be created by verified accounts. Additionally, voting is also only allowed for verified accounts.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              letterSpacing: 0.3,
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
                          //               letterSpacing: 0.3)),
                          //       TextSpan(
                          //           text: 'click here.',
                          //           style: const TextStyle(
                          //               color: Colors.blue, letterSpacing: 0.3),
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
                                              'To view our rules & restrictions to post on Fairtalk, ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              letterSpacing: 0.3)),
                                      TextSpan(
                                          text: 'click here.',
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              letterSpacing: 0.3),
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
