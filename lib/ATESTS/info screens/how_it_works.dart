import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/global_variables.dart';

class HowItWorks extends StatefulWidget {
  const HowItWorks({Key? key}) : super(key: key);

  @override
  State<HowItWorks> createState() => _HowItWorksState();
}

class _HowItWorksState extends State<HowItWorks> {
  bool isBrief = true;
  bool isDetailed = false;

  bool isHowDoesItWork = false;
  bool isCompare = false;

  YoutubePlayerController? controller;

  String? videoUrl = '1N5JtsLr4l4';

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: '1N5JtsLr4l4',
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    controller!.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // log('Entered Fullscreen');
    };
    controller!.onExitFullscreen = () {
      // log('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );
    return YoutubePlayerControllerProvider(
      controller: controller!,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                toolbarHeight: 56,
                backgroundColor: Colors.white,
                actions: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 6,
                        left: 6,
                      ),
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
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(width: 22),
                          const Text('How does Fairtalk work?',
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
                    top: 16,
                    bottom: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 15, top: 24.0),
                        //   child: Column(
                        //     children: [
                        //       SizedBox(
                        //         height: 50,
                        //         child: Image.asset(
                        //           'assets/fairtalk_blue_transparent.png',
                        //         ),
                        //       ),
                        //       const SizedBox(height: 6),
                        //       Text('$version  •  $year',
                        //           style: const TextStyle(
                        //               fontSize: 12,
                        //               fontWeight: FontWeight.w500,
                        //               letterSpacing: 0.3,
                        //               color: Color.fromARGB(255, 36, 64, 101))),
                        //     ],
                        //   ),
                        // ),
                        PhysicalModel(
                          color: Colors.white,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              // border: Border.all(
                              //     width: 2,
                              //     color: const Color.fromARGB(255, 36, 64, 101)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isBrief ? 8 : 0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isBrief = !isBrief;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Brief Explanation",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                              isBrief
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                              size: 28)
                                        ],
                                      ),
                                    ),
                                  ),
                                  isBrief
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 3),
                                              const Text(
                                                "How does it work?",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "When you create a post, it'll immediately get listed on the Home screen where other users are given a total of 7 days to vote on it. Once the 7 days have passed, the post that received the highest score will be saved and added to Fairtalk's Archives collection. Posts sent on a specific date compete against other posts that were also sent on that same date."),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "Message score calculation",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: Icon(
                                                          Icons.add_circle,
                                                          color: Colors.green,
                                                          size: 15),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " increments the message's score by +1.",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: Icon(
                                                          Icons
                                                              .do_not_disturb_on,
                                                          color: Colors.red,
                                                          size: 15),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " decrements the message's score by -1.",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: RotatedBox(
                                                        quarterTurns: 1,
                                                        child: Icon(
                                                          Icons
                                                              .pause_circle_filled,
                                                          color: Color.fromARGB(
                                                              255,
                                                              104,
                                                              104,
                                                              104),
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " doesn't change the score at all.",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // const SizedBox(height: 5),
                                              // RichText(
                                              //   text: const TextSpan(
                                              //     children: [
                                              //       TextSpan(
                                              //         text: 'Message score = ',
                                              //         style: TextStyle(
                                              //             color: Colors.black,
                                              //             letterSpacing: 0.3),
                                              //       ),
                                              //       WidgetSpan(
                                              //         child: Icon(
                                              //             Icons.add_circle,
                                              //             color: Colors.green,
                                              //             size: 15),
                                              //       ),
                                              //       TextSpan(
                                              //           text: ' - ',
                                              //           style: TextStyle(
                                              //               color: Colors.black,
                                              //               fontWeight:
                                              //                   FontWeight.w500,
                                              //               letterSpacing:
                                              //                   0.3)),
                                              //       WidgetSpan(
                                              //         child: Icon(
                                              //             Icons
                                              //                 .do_not_disturb_on,
                                              //             color: Colors.red,
                                              //             size: 15),
                                              //       ),
                                              //       // TextSpan(
                                              //       //     text: ' votes.',
                                              //       //     style: TextStyle(
                                              //       //         color: Colors.black,
                                              //       //         letterSpacing: 0.3)),
                                              //     ],
                                              //   ),
                                              // ),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "Poll score calculation",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                "Poll score = Total votes received.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "There are 4 different types of posts:",
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: const [
                                                  Icon(
                                                      MyFlutterApp
                                                          .globe_americas,
                                                      color: Color.fromARGB(
                                                          255, 56, 56, 56),
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  Icon(Icons.message,
                                                      color: Color.fromARGB(
                                                          255, 56, 56, 56),
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
                                                      color: Color.fromARGB(
                                                          255, 56, 56, 56),
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  Icon(Icons.message,
                                                      color: Color.fromARGB(
                                                          255, 56, 56, 56),
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
                                                  Icon(
                                                      MyFlutterApp
                                                          .globe_americas,
                                                      color: Color.fromARGB(
                                                          255, 56, 56, 56),
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  RotatedBox(
                                                    quarterTurns: 1,
                                                    child: Icon(Icons.poll,
                                                        color: Color.fromARGB(
                                                            255, 56, 56, 56),
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
                                                      color: Color.fromARGB(
                                                          255, 56, 56, 56),
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  RotatedBox(
                                                    quarterTurns: 1,
                                                    child: Icon(Icons.poll,
                                                        color: Color.fromARGB(
                                                            255, 56, 56, 56),
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
                                                "You can only create one post of each type every 24 hours. This helps prevent spam and gives each user the same chance of getting their post archived. The cycle refreshes at 12:01AM EST each & every day.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "Verified accounts",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0.3,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                "National messages/polls can only be created by verified accounts. Additionally, voting is only allowed for verified accounts.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              const Text(
                                                'On Fairtalk, the majority votes & decides everything. This includes:',
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "• Which messages or polls should be Archived & displayed to everyone else."),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "• Which keywords or subjects should be trending."),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "• Which new features should be implemented or removed from our platform."),
                                              const SizedBox(height: 3),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        PhysicalModel(
                          color: Colors.white,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              // border: Border.all(
                              //     width: 2,
                              //     color: const Color.fromARGB(255, 36, 64, 101)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: isHowDoesItWork ? 8 : 0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHowDoesItWork = !isHowDoesItWork;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Detailed Explanation",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                              isHowDoesItWork
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                              size: 28)
                                        ],
                                      ),
                                    ),
                                  ),
                                  isHowDoesItWork
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 3),
                                              const Text(
                                                "Why do we need a platform like Fairtalk?",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "Unfortunately, we currently live in a time where we can't rely on our leaders or governments to resolve any major issues peacefully. They always play their little games of politics & care more about preserving their positions of power instead of doing what's best for the majority. There's currently more than 13,000 nuclear warheads stockpiled & ready to be launched at any moment. This issue likely won't be solved by starting a protest & releasing our anger on the properties of business owners who are simply trying to earn a living like the rest of us. The world desperately needs a platform where we can all collectively communicate with each other & show to our leaders/governments that we're tired of fighting their wars, we're tired of the political division, we're tired of corruption, we're tired of seeing prices increase faster than our salaries, we're tired of poor leadership, we're tired of being treated like we're mere chess pieces on a board."),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "Instead of keeping everyone divided, why not bring everyone together?",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "Whether it's Facebook, Instagram, Twitter, YouTube, Reddit or TikTok, all of these platforms use algorithms to suggest content for each individual user. This unfortunately divides everyone into their own little worlds and it simply becomes impossible to have any collective discussion. If we want a social media platform that impersonates a real life discussion where each person sits around a table and take turns exchanging thoughts & ideas, we can't have each user separated into their own worlds. Instead, we need to bring everyone together in the same room. Fairtalk does this by letting users collectively vote & decide which posts should be displayed to everyone else. In other words, the majority becomes the algorithm."),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "No more power to only politicians or billionaires.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "If we want to give everyone a fair chance to participate in Fairtalk's discussions, we had no choice but to remove the traditional following system often found on other platforms. Although this system may have advantages, it unfortunately gives all the power/attention to only a small percentage of individuals (politicians, billionaires, celebrities, etc.) and if you're not apart of this small group of people, you'll almost certainly be ignored. Giving public figures more power than what they already have is like slapping everyone else in the face and telling you that your voice doesn't matter unless you sit at the very top of the social hierarchy."),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "All users remain anonymous.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "If for any reason users find out that a specific username on Fairtalk is related to a specific individual (public figure), we'll ask them to delete their current account & create a new one. Everyone on Fairtalk is on the same footing. Everyone has the same opportunity to share their thoughts and ideas with the rest of the world or country. If you want to brag about how great you are as an individual, you already have thousands of other platforms such as Twitter & Instagram that let you do exactly just that. Public figures are more than welcome to participate in Fairtalk's discussions but they must remain anonymous just like everybody else."),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "An argument against Fairtalk",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                '"Letting the majority vote & decide everything is nothing new. The concept of a democracy has been around ever since Ancient Greece. Looking at the current state of the world and knowing how chaotic it can become even under democracies, why would we ever want a social media platform that mimics such a system"?',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "Response to the argument",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "Fairtalk's voting system works nothing like a democracy. Our platform gives each user the option to either up-vote, down-vote or neutral-vote (see Fairtalk's voting system below). Modern democracies unfortunately only give participants the option to up-vote leaders. But by also giving an option to down-vote, we can start filtering out the leaders or messages that always seem to divide us. If 51% of participants want a certain leader to be elected but the other 49% do not, why would we still elect this leader knowing that the entire country will be split in half? Why not simply use a voting system that can help us find leaders that people disagree with the least instead of always finding leaders that anger the other half the most?"),
                                              const SizedBox(height: 15),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: Icon(
                                                          Icons.add_circle,
                                                          color: Colors.green,
                                                          size: 15),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " increments the message's score by +1.",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: Icon(
                                                          Icons
                                                              .do_not_disturb_on,
                                                          color: Colors.red,
                                                          size: 15),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " decrements the message's score by -1.",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    WidgetSpan(
                                                      child: RotatedBox(
                                                        quarterTurns: 1,
                                                        child: Icon(
                                                          Icons
                                                              .pause_circle_filled,
                                                          color: Color.fromARGB(
                                                              255,
                                                              104,
                                                              104,
                                                              104),
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " doesn't change the score at all.",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "* The score determines which messages should be displayed to everyone else."),
                                              const SizedBox(height: 15),
                                              const Text(
                                                  "Since voting plays a crucial role into our platform's functionalities, we had to build a unique account verification system that helps eliminate all forms of voting manipulation. Verifying your account is not mandatory and it's completely free."),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "Summary",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                  "Fairtalk's purpose isn't to replace any other social media platform because we simply do not offer the same type of service. It's not a place where you connect with your friends, gain followers, upload video content or start an online business. Instead, Fairtalk is a place where users are voting & creating a historical collection of the best thoughts & ideas shared on a platform purposely built to give every single person a fair chance to participate."),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
