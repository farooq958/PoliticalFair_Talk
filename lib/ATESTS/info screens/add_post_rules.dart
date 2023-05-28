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
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Fairtalk has a simple commitment that we will faithfully defend & follow. We fully recognize the importance of freedom of expression and for this reason, we will never censor anyone for any reason whatsoever. In return, we ask you to follow simple rules that are set in place to sustain a healthy community & improve the user experience.",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "If for any reason users find out that a specific username on Fairtalk is related to a specific individual (public figure), we'll ask them to delete their current account & create a new one. Everyone on Fairtalk is on the same footing. Everyone has the same opportunity to share their thoughts and ideas with the rest of the world or country. If you want to brag about how great you are as an individual, you already have thousands of other platforms such as Twitter & Instagram that let you do exactly just that. Public figures are more than welcome to participate in Fairtalk's discussions but they must remain anonymous just like everybody else.",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "In order for us to provide our service, we are obliged to follow Apple App Store & Google Play Store user-generated content rules & policies. For more information on those rules & policies, we suggest that you read & understand them by clicking on the two links below:",
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
                                      builder:
                                          (BuildContext context, followLink) =>
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
                                      builder:
                                          (BuildContext context, followLink) =>
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
        ),
      ),
    );
  }
}
