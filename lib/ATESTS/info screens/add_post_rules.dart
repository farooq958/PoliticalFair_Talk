import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../utils/global_variables.dart';
import 'terms_conditions.dart';

class AddPostRules extends StatefulWidget {
  const AddPostRules({Key? key}) : super(key: key);

  @override
  State<AddPostRules> createState() => _AddPostRulesState();
}

class _AddPostRulesState extends State<AddPostRules> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.05),
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
                        Container(width: 8),
                        const Text('Rules for posting on Fairtalk',
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
                  right: 16.0,
                  left: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, top: 24.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Image.asset(
                                'assets/fairtalk_blue_transparent.png',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$version  •  $year',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                color: Color.fromARGB(255, 36, 64, 101),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   "In order for Fairtalk to continue providing our service, we are obliged to follow Google Play Store & Apple App Store user-generated content rules & policies.",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),
                            // SizedBox(height: 6),

                            const Text(
                              "Fairtalk has a simple commitment that we will faithfully defend & follow. We fully recognize the importance of freedom of expression and for this reason, we will never censor anyone for any political reason whatsoever. In return, we ask you to follow simple rules that are set in place to sustain a healthy community & improve the user experience.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Firstly, we need to make something clear. In order for us to provide our service, we are obliged to follow Apple App Store & Google Play Store user-generated content rules & policies. For more information on those rules & policies, we suggest that you read & understand them by clicking on the two links below:",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),

                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Icon(Icons.arrow_forward, size: 15),
                                const SizedBox(width: 10),
                                Link(
                                  target: LinkTarget.blank,
                                  uri: Uri.parse(
                                      'https://developer.apple.com/app-store/review/guidelines/#safety'),
                                  builder: (BuildContext context, followLink) =>
                                      InkWell(
                                    onTap: followLink,
                                    child: const Text(
                                      "Apple App Store's Rules & Policies",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          letterSpacing: 0.3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7.5),
                            Row(
                              children: [
                                const Icon(Icons.arrow_forward, size: 15),
                                const SizedBox(width: 10),
                                Link(
                                  target: LinkTarget.blank,
                                  uri: Uri.parse(
                                      'https://support.google.com/googleplay/android-developer/topic/9877466?hl=en&ref_topic=9858052'),
                                  builder: (BuildContext context, followLink) =>
                                      InkWell(
                                    onTap: followLink,
                                    child: const Text(
                                      "Google Play Store's Rules & Policies",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          letterSpacing: 0.3),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),
                            const Text(
                              "These rules apply to all forms of posts. This includes messages, polls, comments, replies, visual content such as profile pictures, shared images & videos, etc. If we find any evidence that any rules or restrictions have been broken, your account will face consequences.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),

                            const SizedBox(height: 15),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  const TextSpan(
                                      text:
                                          'For more details on our rules and restrictions, you can read our ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 0.3)),
                                  TextSpan(
                                      text: 'Terms of Use',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          letterSpacing: 0.3),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TermsConditions(),
                                            ),
                                          );
                                        }),
                                  const TextSpan(
                                      text:
                                          ' statement or simply reach out to us by email: fairtalk.assist@gmail.com',
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 0.3)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
