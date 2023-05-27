import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../utils/global_variables.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 4,
              toolbarHeight: 56,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          // color: Colors.blue,
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
                                  size: 24, color: Colors.black),
                            ),
                          ),
                        ),
                        Container(width: 22),
                        const Text('Terms of Use',
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
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
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
                          padding: const EdgeInsets.only(bottom: 24, top: 26.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: Image.asset(
                                  'assets/fairtalk_blue_transparent.png',
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('$version  •  $year',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                      color: Color.fromARGB(255, 36, 64, 101))),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Issuing Date",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "This Terms of Use statement was last updated on: April 17th, 2023.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                            // const Text(
                            //   "Introduction",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            // const SizedBox(height: 2),
                            // const Text(
                            //   "Please read this Agreement carefully and make sure you understand it. Our goal is to make this statement as simple and as clear as possible for everyone to understand. ",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),

                            // ),
                            const SizedBox(height: 15),
                            const Text(
                              "User engagement rules",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // const SizedBox(height: 2),
                            // const Text(
                            //   "Firstly, we have a simple commitment that we will faithfully defend & follow. We fully recognize the importance of freedom of expression and for this reason, we will never censor anyone for any political reason whatsoever. Additionally, we will never censor or terminate accounts unless we find clear evidence that our rules or restrictions have been broken. Our user engagement rules are listed below. ",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),
                            // const SizedBox(height: 7),
                            // const Text(
                            //   "You are not allowed to:",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),
                            // const SizedBox(height: 7),
                            // const Text(
                            //   "1.	Post erotic content.",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),
                            // const SizedBox(height: 7),
                            // const Text(
                            //   "2.	Promote terrorism.",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),
                            // const SizedBox(height: 7),
                            // const Text(
                            //   "3.	Promote violence.",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),
                            // const SizedBox(height: 7),
                            // const Text(
                            //   "4.	Spam.",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),
                            // const SizedBox(height: 7),
                            // Text(
                            //   "These rules apply to all forms of posts. This includes messages, polls, comments, replies, visual content such as profile pictures, shared images & videos, etc.",
                            //   style: TextStyle(
                            //     letterSpacing: 0.3,
                            //   ),
                            // ),

                            const Text(
                              "Fairtalk has a simple commitment that we will faithfully defend & follow. We fully recognize the importance of freedom of expression and for this reason, we will never censor anyone for any reason whatsoever. In return, we ask you to follow simple rules that are set in place to sustain a healthy community & improve the user experience.",
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
                              "These rules & policies apply to all forms of posts. This includes messages, polls, comments, replies, visual content such as profile pictures, shared images & videos, etc. Breaching Apple App Store's or Google Play Store's user-generated content rules & policies will result in consequences.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),

                            const SizedBox(height: 15),
                            const Text(
                              "Other important rules",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "We also have additional rules that must be respected at all times.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              "You are not allowed to:",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Column(
                              children: const [
                                Text(
                                  "1.	Disable, fraudulently engage with, or otherwise interfere with any part of the Service (or attempt to do any of these things), including security-related features.",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "2.	Access the Service using any automated means (such as robots, botnets or scrapers).",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "3.	Collect or harvest any information that might identify a person (for example, usernames or faces).",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "4.	Use the Service to distribute unsolicited promotional or commercial content or other unwanted or mass solicitations.",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "5.	Cause or encourage any inaccurate measurements of authentic user engagement. Example: manipulate metrics of our voting system or attempt to by-pass our account verification system.",
                                  style: TextStyle(
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),
                            const Text(
                              "What happens when you violate Fairtalk’s rules or restrictions?",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "If we find clear evidence that any of our rules or restrictions have been breached, your account will face consequences. Depending on the severity, your account will either face a temporary suspension or permanent termination. In most cases, breaching our rules will result in a temporary suspension but if they're continuously being violated, we will have no choice but to terminate your account. If you believe the suspension or termination has been made in error, you can always contact us by email and we can further investigate the reason behind your suspension or termination. You'll also have the opportunity to ask us to provide some evidence & show you the reason(s) for your account suspension/termination. If we're unable to provide any evidence, your account will be immediately re-instated. If your account gets temporarily suspended, you will need to prove to us that you have read and understood our Terms of Use statement. Until then, your account will remain suspended. We also keep track of each user's violations and suspensions and if your account reaches a certain threshold, it will result in a permanent termination of your account. If you wish to help Fairtalk sustain its healthy community and give every user the best possible experience, we recommend that you report/flag any content that breached our user engagement rules. Reported content will be picked up by our moderators and if the content has indeed breached any of our rules, it will be removed from our platform. If you believe your content has been wrongfully removed by our moderators, you may contact us by email and we'll do our best to resolve the issue.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Age requirements",
                              style: TextStyle(
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "To use Fairtalk, you must be at least 13 years old. However, if enabled by a parent or legal guardian, a child aged 12 years or younger can use the platform. If you are under 18, you must have your parent or guardian’s permission to use the platform. Please have them read this Agreement with you. Additionally, in order to successfully pass our account verification process, you must be at least 18 years or older. ",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Links to Other Websites",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Our platform may contain links to third-party websites and online services that are not owned or controlled by Fairtalk. We have no control over, and assume no responsibility for, such websites and online services. Be aware when you leave the Service; we suggest you read the terms and Data Privacy of each third-party website and online service that you visit.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Changes to our Terms of Use statement",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "We may update our Terms of Use from time to time. We will notify you of any changes by posting the new Terms of Use on this page. You are advised to review this Terms of Use periodically for any changes. Changes to this Terms of Use are effective when they are posted on this page.",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Contact Information",
                              style: TextStyle(
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "If you have any questions, inquiries or simply need help, feel free to contact us:",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              " •	By email: fairtalk.assist@gmail.com ",
                              style: TextStyle(
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                        // Text(
                        //   "${tcText}",
                        //   textAlign: TextAlign.left,
                        //   style: TextStyle(
                        //     letterSpacing: 0.3,
                        //   ),
                        // ),
                        // Text(
                        //   "Contact Information:",
                        //   style: TextStyle(
                        //     letterSpacing: 0.3,
                        //   ),
                        // ),
                        // SizedBox(height: 2),
                        // Text(
                        //   "Email: ${email}",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     letterSpacing: 0.3,
                        //   ),
                        // ),
                        // SizedBox(height: 15),
                      ],
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
