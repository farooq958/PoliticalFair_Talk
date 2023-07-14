import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../responsive/my_flutter_app_icons.dart';
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
                        const Text('Rules for posting on FairTalk',
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "FairTalk has a simple commitment that we will faithfully defend & follow. We fully recognize the importance of freedom of expression and for this reason, we will never censor anyone for any reason whatsoever. In return, we ask you to follow simple rules that are set in place to sustain a healthy community & improve the user experience.",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "If for any reason users find out that a specific username on FairTalk is related to a specific individual (public figure) where they gain an unfair advantage in discussions, we'll simply ask them to delete their current account & create a new one. Everyone on FairTalk is on the same footing, everyone has the same opportunity to fairly participate in discussions. Public figures are more than welcome to participate in FairTalk's discussions but they must remain anonymous just like everybody else.",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "In order for us to provide our service, we are obliged to follow Apple App Store & Google Play Store user-generated content rules & policies. For more information on those rules & policies, we suggest that you read & understand them by clicking on the two links below:",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 15,
                                      color: whiteDialog,
                                    ),
                                    const SizedBox(width: 10),
                                    Link(
                                      target: LinkTarget.blank,
                                      uri: Uri.parse(
                                          'https://developer.apple.com/app-store/review/guidelines/#safety'),
                                      builder:
                                          (BuildContext context, followLink) =>
                                              InkWell(
                                        onTap: followLink,
                                        child: const Text(
                                          "Apple App Store's Rules & Policies",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 103, 187, 255),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7.5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 15,
                                      color: whiteDialog,
                                    ),
                                    const SizedBox(width: 10),
                                    Link(
                                      target: LinkTarget.blank,
                                      uri: Uri.parse(
                                          'https://support.google.com/googleplay/android-developer/topic/9877466?hl=en&ref_topic=9858052'),
                                      builder:
                                          (BuildContext context, followLink) =>
                                              InkWell(
                                        onTap: followLink,
                                        child: const Text(
                                          "Google Play Store's Rules & Policies",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 103, 187, 255),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "These rules apply to all forms of posts. This includes messages, polls, comments, replies, visual content such as profile pictures, shared images & videos, etc. If we find any evidence that any rules or restrictions have been broken, your account will face consequences.",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
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
                                          color: whiteDialog,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                      TextSpan(
                                          text: 'Terms of Use',
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
                                                      const TermsConditions(),
                                                ),
                                              );
                                            }),
                                      const TextSpan(
                                        text:
                                            ' statement or simply reach out to us by email: contact@fairtalk.net',
                                        style: TextStyle(
                                          color: whiteDialog,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
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
