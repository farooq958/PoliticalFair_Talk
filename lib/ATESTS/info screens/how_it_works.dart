import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../responsive/my_flutter_app_icons.dart';
import '../utils/global_variables.dart';

class HowItWorks extends StatefulWidget {
  const HowItWorks({Key? key}) : super(key: key);

  @override
  State<HowItWorks> createState() => _HowItWorksState();
}

class _HowItWorksState extends State<HowItWorks> {
  bool isBrief = false;
  bool isDetailed = false;
  bool isShortVideo = false;

  bool isHowDoesItWork = false;
  bool isCompare = false;

  YoutubePlayerController? controller;

  String? videoUrl = 'b9JQWJ7B1Go';

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: 'b9JQWJ7B1Go',
      params: const YoutubePlayerParams(
        // showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,

        // loop: true,
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
  void dispose() {
    super.dispose();
    controller!.close();
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
            backgroundColor: testing,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                toolbarHeight: 56,
                backgroundColor: darkBlue,
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
                                  Icons.keyboard_arrow_left,
                                  size: 24,
                                  color: whiteDialog,
                                ),
                              ),
                            ),
                          ),
                          Container(width: 16),
                          const Text('Fairtalk Explainer',
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
                    right: 16.0,
                    left: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PhysicalModel(
                          color: darkBlue,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                right: 12,
                                left: 12,
                                top: 6,
                                bottom: isShortVideo ? 0 : 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: darkBlue,
                              // border: Border.all(
                              //     width: 2,
                              //     color: const darkBlue),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: isShortVideo ? 15 : 0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          isShortVideo = !isShortVideo;
                                          isShortVideo == false
                                              ? controller!.close()
                                              : null;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Brief Explainer (Video)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isShortVideo == true
                                                  ? whiteDialog.withOpacity(0.7)
                                                  : whiteDialog,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                              isShortVideo
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: isShortVideo == true
                                                  ? whiteDialog.withOpacity(0.7)
                                                  : whiteDialog,
                                              size: 28)
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isShortVideo ? 3 : 0),
                                  isShortVideo
                                      ? LayoutBuilder(
                                          builder: (context, constraints) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600
                                                  ? 598
                                                  : MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: darkBlue,
                                                      ),
                                                      child: player),
                                                  Positioned.fill(
                                                    child: YoutubeValueBuilder(
                                                      controller: controller,
                                                      builder:
                                                          (context, value) {
                                                        return AnimatedCrossFade(
                                                          crossFadeState: value
                                                                  .isReady
                                                              ? CrossFadeState
                                                                  .showSecond
                                                              : CrossFadeState
                                                                  .showFirst,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          secondChild:
                                                              const SizedBox(),
                                                          firstChild: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Stack(
                                                              children: const [
                                                                Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        PhysicalModel(
                          color: darkBlue,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: darkBlue,
                              // border: Border.all(
                              //     width: 2,
                              //     color: const darkBlue),
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
                                          Text(
                                            "Brief Explainer (Text)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isBrief == true
                                                  ? whiteDialog.withOpacity(0.7)
                                                  : whiteDialog,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                              isBrief
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: isBrief == true
                                                  ? whiteDialog.withOpacity(0.7)
                                                  : whiteDialog,
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
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteDialog,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              // const SizedBox(height: 3),
                                              const Text(
                                                "As soon as you create a post, it'll immediately get listed on the Home screen where other users are given a total of 7 days to vote on it. Once the 7 days have passed, the post that received the highest score will be saved and added to Fairtalk's Archives collection. Posts sent on a specific date compete against other posts sent on that same date.",
                                                style: TextStyle(
                                                  color: whiteDialog,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Message score calculation",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteDialog,
                                                  fontSize: 16,
                                                ),
                                              ),

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
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
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
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

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
                                                              195,
                                                              195,
                                                              195),
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " doesn't change the score at all.",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
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
                                              //             letterSpacing: 0),
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
                                              //       //         letterSpacing: 0)),
                                              //     ],
                                              //   ),
                                              // ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Poll score calculation",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteDialog,
                                                  fontSize: 16,
                                                ),
                                              ),

                                              const Text(
                                                "Poll score = Total votes received.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteDialog,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Verified accounts",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteDialog,
                                                  fontSize: 16,
                                                ),
                                              ),

                                              const Text(
                                                "To eliminate the manipulation of our voting system, only votes from verified accounts are counted.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteDialog,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "There are 4 types of posts",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteDialog,
                                                  fontSize: 16,
                                                ),
                                              ),

                                              Row(
                                                children: const [
                                                  Icon(
                                                      MyFlutterApp
                                                          .globe_americas,
                                                      color: whiteDialog,
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  Icon(Icons.message,
                                                      color: whiteDialog,
                                                      size: 15),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      "Global Messages",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteDialog,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: const [
                                                  Icon(Icons.flag,
                                                      color: whiteDialog,
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  Icon(Icons.message,
                                                      color: whiteDialog,
                                                      size: 15),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      "National Messages",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteDialog,
                                                        fontSize: 13,
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
                                                      color: whiteDialog,
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  RotatedBox(
                                                    quarterTurns: 1,
                                                    child: Icon(Icons.poll,
                                                        color: whiteDialog,
                                                        size: 15),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      "Global Polls",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteDialog,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: const [
                                                  Icon(Icons.flag,
                                                      color: whiteDialog,
                                                      size: 15),
                                                  SizedBox(width: 3),
                                                  RotatedBox(
                                                    quarterTurns: 1,
                                                    child: Icon(Icons.poll,
                                                        color: whiteDialog,
                                                        size: 15),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      "National Polls",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteDialog,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "You can only create one post of each type every 24 hours. This helps prevent spam and gives each user the same chance of getting their post archived. The cycle refreshes at 12:01AM EST each day.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteDialog,
                                                  fontSize: 13,
                                                ),
                                              ),

                                              // const SizedBox(height: 15),
                                              // const Text(
                                              //   'On Fairtalk, the majority votes & decides everything. This includes:',
                                              //   style: TextStyle(
                                              //     letterSpacing: 0,
                                              //     fontWeight: FontWeight.w500,
                                              //   ),
                                              // ),
                                              // const SizedBox(height: 3),
                                              // const Text(
                                              //     "• Which messages or polls should be Archived & displayed to everyone else."),
                                              // const SizedBox(height: 3),
                                              // const Text(
                                              //     "• Which keywords or subjects should be trending."),
                                              // const SizedBox(height: 3),
                                              // const Text(
                                              //     "• Which new features should be implemented or removed from our platform."),
                                              // const SizedBox(height: 3),
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
                          color: darkBlue,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: darkBlue,
                              // border: Border.all(
                              //     width: 2,
                              //     color: const darkBlue),
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
                                          Text(
                                            "Detailed Explainer (Text)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isHowDoesItWork == true
                                                  ? whiteDialog.withOpacity(0.7)
                                                  : whiteDialog,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                              isHowDoesItWork
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: isHowDoesItWork == true
                                                  ? whiteDialog.withOpacity(0.7)
                                                  : whiteDialog,
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
                                                "The majority dictates everything.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                "On Fairtalk, our users make all the decisions, not the CEO. We let our users vote & decide which features they want to see added or removed from the platform. If democracies work better than dictatorships, then why not adopt a similar system when it comes to social media?",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteDialog,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Platform manipulation",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                  "Since Fairtalk is fully centered around a democratic system, we had to come up with a unique approach to eliminate all forms of voting manipulation. On other platforms, all they do is collect your IP address & device token which is very easy to modify (you can simply use VPNs & hard reset your device). With Fairtalk's account verification system, we ensure that platform manipulation becomes nearly impossible. This finally opens up the gates to online democracy because we finally have a voting system which is nearly impossible to manipulate.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteDialog,
                                                    fontSize: 13,
                                                  )),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "An argument against Fairtalk",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                '"Letting the majority vote & decide everything is nothing new. The concept of a democracy has been around ever since Ancient Greece. Looking at the current state of the world and knowing how chaotic it can become even under democracies, why would we ever want a social media platform that mimics such a system"?',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteDialog,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Response to argument",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                  "Fairtalk's voting system works nothing like a democracy. Our platform gives each user the option to either up-vote, down-vote or neutral-vote (see Fairtalk's voting system below). Modern democracies only give participants the option to \"up-vote\" leaders. But by also giving an option to down-vote, we can easily start filtering out the leaders or messages that always seem to divide us. If 51% of participants want a certain leader to be elected but the other 49% do not, why would we still elect this person knowing that the entire country will be split in half? By not giving an option to down-vote, we're completely hiding the real sentiment towards specific leaders or messages. This can be very dangerous as it can often result in the election of political figures that create division. Fairtalk's voting system helps filter out the messages that divide us so that we can finally pay more attention to the messages that unite us.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteDialog,
                                                    fontSize: 13,
                                                  )),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Fairtalk's voting system",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteDialog,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteDialog,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "",
                                                    ),
                                                    WidgetSpan(
                                                      child: RotatedBox(
                                                        quarterTurns: 1,
                                                        child: Icon(
                                                          Icons
                                                              .pause_circle_filled,
                                                          color: Color.fromARGB(
                                                              255,
                                                              200,
                                                              200,
                                                              200),
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " doesn't change the score at all.",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteDialog,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Text(
                                                "* The score determines which messages should be displayed to everyone else.",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteDialog,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "No more algorithms that divide us.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                  "Whether it's Facebook, Instagram, Twitter, YouTube, Reddit or TikTok, all of these platforms use algorithms to suggest content for each individual user (a.k.a \"For You\" pages). This may be beneficial in some ways, but it also divides everyone into their own little worlds and it simply becomes impossible to have any collective discussion. Instead of keeping everyone divided, Fairtalk brings everyone together. We do this by displaying the same content for each user on the platform. This content isn't randomly chosen by algorithms but instead it's always chosen by the majority. In other words, the majority becomes the algorithm.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteDialog,
                                                    fontSize: 13,
                                                  )),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "All attention no longer given to only public figures.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                  "If we want to give each user a fair chance to participate in Fairtalk's discussions, we had no choice but to remove the \"following\" system often found on other platforms. Although this system may have advantages, it unfortunately gives all the power/attention to only a small percentage of individuals (politicians, billionaires, celebrities, etc.) and if you're not apart of this small group of people, you'll almost certainly be ignored. Giving public figures more attention than what they already have is like slapping everyone else in the face and telling you that your voice doesn't matter unless you sit at the very top of the social hierarchy.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteDialog,
                                                    fontSize: 13,
                                                  )),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "All users remain anonymous.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                  "If for any reason users find out that a specific username on Fairtalk is related to a specific individual (public figure) where they gain an unfair advantage in discussions, we'll simply ask them to delete their current account & create a new one. Everyone on Fairtalk is on the same footing, everyone has the same opportunity to fairly participate in discussions. Public figures are more than welcome to participate in Fairtalk's discussions but they must remain anonymous just like everybody else.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteDialog,
                                                    fontSize: 13,
                                                  )),
                                              const SizedBox(height: 20),
                                              const Text(
                                                "Summary",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteDialog,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                  "Fairtalk is the very first platform to introduce democracy to social media. By eliminating platform manipulation & no longer prioritizing certain individuals in discussions (public figures or those that can afford monthly fees for blue checkmarks), we finally have a platform where everyone is on the same footing. With a fair system like this, we can finally let the majority dictate the direction of our platform by letting them choose which functionalities they want to see added or removed from Fairtalk.",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteDialog,
                                                    fontSize: 13,
                                                  )),
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
