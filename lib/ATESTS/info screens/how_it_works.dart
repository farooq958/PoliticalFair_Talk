import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../utils/global_variables.dart';

class HowItWorks extends StatefulWidget {
  const HowItWorks({Key? key}) : super(key: key);

  @override
  State<HowItWorks> createState() => _HowItWorksState();
}

class _HowItWorksState extends State<HowItWorks> {
  bool isBrief = false;
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
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15, top: 24.0),
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
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Stack(
                        //     children: [
                        //       player,
                        //       Positioned.fill(
                        //         child: YoutubeValueBuilder(
                        //           controller: controller,
                        //           builder: (context, value) {
                        //             return AnimatedCrossFade(
                        //               crossFadeState: value.isReady
                        //                   ? CrossFadeState.showSecond
                        //                   : CrossFadeState.showFirst,
                        //               duration:
                        //                   const Duration(milliseconds: 300),
                        //               secondChild: const SizedBox.shrink(),
                        //               firstChild: Material(
                        //                 child: DecoratedBox(
                        //                   // ignore: sort_child_properties_last
                        //                   child: const Center(
                        //                     child: CircularProgressIndicator(),
                        //                   ),
                        //                   decoration: BoxDecoration(
                        //                     image: DecorationImage(
                        //                       image: NetworkImage(
                        //                         YoutubePlayerController
                        //                             .getThumbnail(
                        //                           videoId: controller!
                        //                               .initialVideoId,
                        //                           quality:
                        //                               ThumbnailQuality.medium,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 15),
                        // PhysicalModel(
                        //   color: Colors.white,
                        //   elevation: 3,
                        //   borderRadius: BorderRadius.circular(5),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 10, vertical: 5),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(5),
                        //       color: Colors.white,
                        //       // border: Border.all(
                        //       //     width: 2,
                        //       //     color: const Color.fromARGB(255, 36, 64, 101)),
                        //     ),
                        //     child: Padding(
                        //       padding: EdgeInsets.only(bottom: isBrief ? 8 : 0),
                        //       child: Column(
                        //         children: [
                        //           InkWell(
                        //             onTap: () {
                        //               setState(() {
                        //                 isBrief = !isBrief;
                        //               });
                        //             },
                        //             child: Padding(
                        //               padding: const EdgeInsets.symmetric(
                        //                   vertical: 6, horizontal: 6),
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   const Text(
                        //                     "What is Fairtalk?",
                        //                     textAlign: TextAlign.center,
                        //                     style: TextStyle(
                        //                       color: Color.fromARGB(
                        //                           255, 36, 64, 101),
                        //                       letterSpacing: 0.5,
                        //                       fontWeight: FontWeight.w500,
                        //                       fontSize: 16,
                        //                     ),
                        //                   ),
                        //                   Icon(
                        //                       isBrief
                        //                           ? Icons.keyboard_arrow_up
                        //                           : Icons.keyboard_arrow_down,
                        //                       color: const Color.fromARGB(
                        //                           255, 36, 64, 101),
                        //                       size: 28)
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //           isBrief
                        //               ? Padding(
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 6),
                        //                   child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       const Padding(
                        //                         padding: EdgeInsets.only(
                        //                           top: 2.0,
                        //                         ),
                        //                         child: Text(
                        //                           "Summary",
                        //                           textAlign: TextAlign.left,
                        //                           style: TextStyle(
                        //                             letterSpacing: 0.3,
                        //                             fontWeight: FontWeight.w500,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "As soon as you send a post on Fairtalk, it'll immediately get listed on the Home screen where other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the post that received the highest score will be added and saved forever in Fairtalk's Archives. All other posts will be removed from the Home screen in order to make space for new posts and new voting cycles. There are two different types of posts: messages & polls.",
                        //                         // "As soon as you create a message or a poll, other users are given a total of 7 days to cast votes on it. Once the 7 days have passed, the message & poll that received the highest scores will get added to Fairtalk's Archives.",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Message score calculation",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       RichText(
                        //                         text: const TextSpan(
                        //                           children: [
                        //                             TextSpan(
                        //                               text: 'Message score = ',
                        //                               style: TextStyle(
                        //                                   color: Colors.black,
                        //                                   letterSpacing: 0.3),
                        //                             ),
                        //                             WidgetSpan(
                        //                               child: Icon(
                        //                                   Icons.add_circle,
                        //                                   color: Colors.green,
                        //                                   size: 15),
                        //                             ),
                        //                             TextSpan(
                        //                                 text: ' - ',
                        //                                 style: TextStyle(
                        //                                     color: Colors.black,
                        //                                     fontWeight:
                        //                                         FontWeight.w500,
                        //                                     letterSpacing:
                        //                                         0.3)),
                        //                             WidgetSpan(
                        //                               child: Icon(
                        //                                   Icons
                        //                                       .do_not_disturb_on,
                        //                                   color: Colors.red,
                        //                                   size: 15),
                        //                             ),
                        //                             // TextSpan(
                        //                             //     text: ' votes.',
                        //                             //     style: TextStyle(
                        //                             //         color: Colors.black,
                        //                             //         letterSpacing: 0.3)),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Poll score calculation",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "Poll score = Total # of votes received.",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "How is Fairtalk considered “Fair”?",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "Each individual user can only vote once for every post and trying to manipulate the voting metrics by creating bots and/or multiple accounts is impossible thanks to our account verification system.",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Additional details & information",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "If you still don’t fully understand how Fairtalk works, we suggest that you read the fully detailed explanation below.",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 )
                        //               : Row(),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 15),
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
                                            "What is Fairtalk?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 36, 64, 101),
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                              isBrief
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: const Color.fromARGB(
                                                  255, 36, 64, 101),
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
                                            children: const [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 2.0,
                                                  ),
                                                  child: Text(
                                                      'Fairtalk is a new social media platform that offers an alternative way of communicating online.')),
                                            ],
                                          ),
                                        )
                                      : SizedBox()
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
                                            "How does it work?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 36, 64, 101),
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                              isHowDoesItWork
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: const Color.fromARGB(
                                                  255, 36, 64, 101),
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
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 2.0,
                                                  ),
                                                  child: Text(
                                                      "Whenever you create a post, it'll immediately get listed on the Home screen where other users are given a total of 7 days to vote on it. Once the 7 days have passed, the post that received the highest score will be saved and added to Fairtalk's Archives. There are two types of posts: messages & polls. Calculating the score differs for each type of post.")),
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
                                                      text: 'Message score = ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          letterSpacing: 0.3),
                                                    ),
                                                    WidgetSpan(
                                                      child: Icon(
                                                          Icons.add_circle,
                                                          color: Colors.green,
                                                          size: 15),
                                                    ),
                                                    TextSpan(
                                                        text: ' - ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing:
                                                                0.3)),
                                                    WidgetSpan(
                                                      child: Icon(
                                                          Icons
                                                              .do_not_disturb_on,
                                                          color: Colors.red,
                                                          size: 15),
                                                    ),
                                                    // TextSpan(
                                                    //     text: ' votes.',
                                                    //     style: TextStyle(
                                                    //         color: Colors.black,
                                                    //         letterSpacing: 0.3)),
                                                  ],
                                                ),
                                              ),
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
                                                "Poll score = Total # of votes received.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
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
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: isCompare ? 8 : 0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isCompare = !isCompare;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "How does Fairtalk differ from other platforms?",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 36, 64, 101),
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                              isCompare
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: const Color.fromARGB(
                                                  255, 36, 64, 101),
                                              size: 28)
                                        ],
                                      ),
                                    ),
                                  ),
                                  isCompare
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 2.0,
                                                  ),
                                                  child: Text(
                                                      "• Other platforms will often use algorithms to suggest content for you. Our platform does not. The content displayed on Fairtalk is always the same for every single user. Instead of having each user divided into their own little corner, we're bringing everyone together. This makes our platform very similar to a real life discussion where each person sits around a large table and take turns exchanging thoughts and ideas.")),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  child: Text(
                                                      "• Most platforms today give all the power and attention to a very small percentage of individuals (politicians, billionaires, actors, etc.) and if you're not apart of this small group of people, you'll almost certainly be ignored. To make sure each user can fairly participate, we had to keep every user anonymous and we also had to remove the traditional following system which can often be found on other platforms.")),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  child: Text(
                                                      '• On other platforms, most decisions are taken by a few individuals sitting around a table during a board meeting. These platforms have unfortunately turned into little dictatorships and to fix this issue, we simply let our users vote and decide everything. This includes which new features should be implemented or removed from our platform.')),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  child: Text(
                                                      "• Since our voting metrics play a crucial role into our platform's functionalities, we had to build a unique account verification system that helps us eliminate all forms of voting manipulation. Verifying your account is not mandatory and it's completely free.")),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  child: Text(
                                                      "• Our platform isn't a place where you connect with your friends, gain followers, upload video content or start an online business. Fairtalk functions more like a democracy but instead of voting for politicians to represent us, we're instead voting for the best thoughts & ideas that were shared on the platform.")),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // PhysicalModel(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.circular(5),
                        //   elevation: 3,
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 10, vertical: 5),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(5),
                        //       color: Colors.white,
                        //       // border: Border.all(
                        //       //     width: 2,
                        //       //     color: const Color.fromARGB(255, 36, 64, 101)),
                        //     ),
                        //     child: Padding(
                        //       padding:
                        //           EdgeInsets.only(bottom: isDetailed ? 8 : 0),
                        //       child: Column(
                        //         children: [
                        //           InkWell(
                        //             onTap: () {
                        //               setState(() {
                        //                 isDetailed = !isDetailed;
                        //               });
                        //             },
                        //             child: Padding(
                        //               padding: const EdgeInsets.symmetric(
                        //                   vertical: 6, horizontal: 6),
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   const Text(
                        //                     "Detailed Explanation",
                        //                     textAlign: TextAlign.center,
                        //                     style: TextStyle(
                        //                       color: Color.fromARGB(
                        //                           255, 36, 64, 101),
                        //                       letterSpacing: 0.5,
                        //                       fontWeight: FontWeight.w500,
                        //                       fontSize: 16,
                        //                     ),
                        //                   ),
                        //                   Icon(
                        //                       isDetailed
                        //                           ? Icons.keyboard_arrow_up
                        //                           : Icons.keyboard_arrow_down,
                        //                       color: const Color.fromARGB(
                        //                           255, 36, 64, 101),
                        //                       size: 28)
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //           isDetailed
                        //               ? Padding(
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 6),
                        //                   child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       const Padding(
                        //                         padding: EdgeInsets.only(
                        //                           top: 2.0,
                        //                         ),
                        //                         child: Text(
                        //                           "Introduction",
                        //                           textAlign: TextAlign.left,
                        //                           style: TextStyle(
                        //                             letterSpacing: 0.3,
                        //                             fontWeight: FontWeight.w500,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       // Text(
                        //                       //   "On Fairtalk, everyone has an equal chance of getting their voices heard. Whether you're rich or poor, famous or unknown, everyone gets a seat at the table. One of the biggest issues today with popular social media platforms is the simple fact that you're allowed to create multiple accounts. This allows anyone with an internet connection to manipulate the platform’s voting metrics, and this can easily turn the social platform into an atmosphere of misinformation, inauthenticity, and corruption. Furthermore, digital connections to those social media platforms via an API really adds more fuel to the fire because now most activity performed online (such as: uploads, creating posts, liking, disliking etc.) are no longer being performed by humans but instead are now being performed automatically by bots. This can be very dangerous for many reasons and in our opinion, these large social media platforms are not doing enough to solve this growing issue. This is only one of the many reasons why we’ve created Fairtalk.",
                        //                       //   style: const TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 15),
                        //                       // const Text(
                        //                       //   "Solving the biggest issue with a simplistic approach",
                        //                       //   textAlign: TextAlign.left,
                        //                       //   style: TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //     fontWeight: FontWeight.w500,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 3),
                        //                       // Text(
                        //                       //   "With today’s technology, it’s nearly impossible to create a 100% fair & honest platform where each individual person only has access to one account. But at the same time, it’s most definitely possible to improve and implement a much more sophisticated system compared to the current authentication system used by most popular platforms today. Although Fairtalk also uses a similar authentication system (email & password), we’ve added one extra layer which gives each user an opportunity to verify their accounts. It is only when your account is successfully verified that you’ll gain access to important features such as: voting, creating messages, polls, etc. This simple verification system is not 100% full proof, but it is still proven to help, especially if the goal is to eliminate individuals from creating multiple accounts and voting multiple times. Our verification system is very similar to any other verification system currently used in other industries. For example, if you decide to switch banks and create a new bank account, you’ll likely need to provide identification for fraud prevention purposes. When verifying your account on our platform, you'll be asked to provide identification. But of course, it is not a requirement for you to verify your account. If your account is unverified, you'll still have access to most features on our platform, but the only difference is that you won’t have the ability to cast any votes or create any national messages or polls.",
                        //                       //   style: const TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 15),
                        //                       // const Text(
                        //                       //   "Data collection",
                        //                       //   textAlign: TextAlign.left,
                        //                       //   style: TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //     fontWeight: FontWeight.w500,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 3),
                        //                       // const Text(
                        //                       //   "Now we should also make something very clear, we will never share or sell any of your personal data collected. You are authorized to delete your account at any point in time and as soon as you delete your account, all of your personal data will be immediately removed from our servers. Unlike many other social media platforms, our goal is not to profit from any data collection whatsoever, our only goal is to provide a platform which gives every single person a fair chance of being heard.",
                        //                       //   style: TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //   ),
                        //                       // ),
                        //                       const Text(
                        //                         "Sadly in today’s world, if you’re not wealthy or famous you’re most likely going to be ignored. When a person’s voice is ignored for too long, frustration naturally builds up. Fairtalk hopes to alleviate this growing frustration by providing a platform that gives everyone an equal opportunity to participate in discussions. But to successfully provide a platform like this, we should first identify some of the biggest issues with other social media platforms and then find a solution to solve each one of those issues.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "• On other social media platforms, you'll often find a traditional 'following' system. Although this system serves its own purpose and has its own benefits, it unfortunately guarantees inequality. A person who is a well-known public figure will always have more influence and gain more followers over someone who isn't as often recognized in public. This would give all the attention to only a small percentage of individuals and silence everyone else. We already have thousands of platforms that do exactly just that. And if our goal is to provide a fair platform which gives every single person an equal chance of being heard, we had no choice but to remove the traditional 'following' system that can often be found on other social media platforms.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "• On Fairtalk, every user remains anonymous. Although every account still has an option to upload a profile picture, we will never verify that the person on the profile picture is you. Keeping all users anonymous will certainly not benefit public figures or wealthy individuals but will once again benefit the majority. Since we're living in a worshipping era, we unfortunately only put people such as politicians, billionaires, actors, models, sport figures, etc. at the forefront of public attention. And if you're not apart of this small group of people, you'll automatically be ignored. By keeping every user anonymous, we ensure that everyone (regardless of wealth or social status) has an equal chance of participating in discussions.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "• On other social media platforms, it is very easy to manipulate the voting metrics. All you have to do is create a new email address and then sign up to that platform with your new email address. Now you have two accounts under the control of one single individual and it doesn't simply stop with two accounts. Some individuals can easily have hundreds or thousands of accounts under their control and many of those accounts can easily be programmed to perform functions that benefits a specific individual or organization. In fact, a very large portion of online activity today (especially activity on popular social media platforms) is now being performed automatically by bots. This can be very dangerous for many reasons and to fix this issue, we've come up with a very simple solution. Fairtalk has implemented a system which gives every single account an option to become verified. It is not mandatory to verify your account but it is only verified accounts that are allowed to perform certain actions (such as voting on other posts). Implementing this simple verification system is beneficial because it allows us to visualize voting results much more accurately and it can also help everyone get a better sense of what the majority of us really think.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "• Other social media platforms will often look for ways to make extra profits by selling data collected about you. We simply do not. We will never share or sell any of your personal data. We only collect data that is necessary for our application to function and as soon as you delete your account, all personal data that was collected about you will be immediately removed from our servers.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Although all of these issues do exist, it's still very easy to understand why they haven't been fixed yet. Let's say you started a new business and you need to make a secondary account on a specific platform, wouldn't it be fair for you to have the freedom to create that secondary account? Of course the answer is likely yes, it would be fair. And we also understand that there's always going to be a demand for social platforms where you can share pictures about your life, connect with your friends, etc. These social platforms are being used by billions of people for a very good reason and they're definitely not going anywhere. Fairtalk's purpose isn't to replace any of these platforms because we simply do not offer the same kind of service. Fairtalk isn't a place where you connect with your friends like Facebook or Instagram. It's also not a place where you can grow an online business like YouTube or Twitter. Instead, what Fairtalk offers is a new method of communication between all of us where each person is only allowed to vote once for every post. This makes Fairtalk very similar to an election or democracy but instead of voting for a politician or buffoon to represent you, we're instead voting for the best ideas and messages that were shared on the platform.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Whenever people get frustrated and are unhappy with decisions made by policy makers, they'll often take to the streets to protest. Although their frustration is justified, it can often lead to violence, destruction of property and even deaths. Whenever someone protests, they'll be considered lucky to have their cardboard sign broadcasted on a popular television channel for only a few seconds. And how can you possibly convey your frustration and the message you want to share in only 3 to 5 words written on a small piece of cardboard? It's simply impossible and there's definitely a better solution. Fairtalk is the only current platform that offers every single person, a fair chance to finally speak up. And because we have a verification system which ensures that each individual person can only vote once for every post, Fairtalk becomes a place where we can observe much more accurate voting results and also get a much better sense of what the majority of us really think. This can be very beneficial as it can help all of us find commonality and instead of always focusing on subjects that divide us, now we can finally start finding subjects that unite us.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "If we want to unite and fix the world's biggest issues, we'll first need a place where we can all communicate openly, fairly and effectively. If history can teach us one thing, it is that we can never count on our leaders to solve any issues peacefully. They always play their little games of politics and send us to fight their useless wars. No generation before us had access to the internet like we do today, we have a small window of opportunity where we can finally unite and demand our leaders to cooperate instead of always letting them play with our lives like we're chess pieces on a board. And although the internet has been around for several decades, there was never a platform or system built to unite people and help us find things that we can all agree upon. Fairtalk was built for this exact purpose. Every 24 hours, the post that received the highest score will be saved and archived on our platform forever. In other words, the post that gets archived everyday is in fact the message that was the most agreed upon by the majority. And if we want our leaders to listen to us, all they have to do now is read through the archives on Fairtalk and that'll give them a much better idea of what the majority of us want. And remember, we've also built a system where each individual person can only vote once for each post so in other words, Fairtalk's voting metrics cannot be manipulated like other social media platforms. If we want to leave this world a better place then what it was when we first arrived, we'll need to learn to communicate and work together so that we can find solutions to some of the world's biggest issues. And hopefully Fairtalk can provide this new form of communication between all of us.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Creating messages and/or polls",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "To share something with the world, you'll first need to navigate to the 'create' tab. It is on this screen that users have the ability to create messages and/or polls. These can either be sent globally or nationally. Sending them globally allows any other user on the platform to vote on the post you've created. While sending a post nationally only allows people from the same country as yours to vote on the post you've created. How is your nationality determined? When you verify your account, you’ll be asked to provide a picture of your identification card. This is how we designate your account to a specific national country. Once you create a post, it'll immediately get listed on the home screen for other users to vote. Additionally, to avoid spam and to give everyone an equal chance of being heard, each user is only allowed to create one message and one poll for every voting cycle (once a day).",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Voting on messages",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "When voting for a message, you have a total of 3 different options to choose from:",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 6),
                        //                       RichText(
                        //                         text: const TextSpan(
                        //                           children: [
                        //                             TextSpan(
                        //                               text: '• Voting ',
                        //                               style: TextStyle(
                        //                                   color: Colors.black,
                        //                                   letterSpacing: 0.3),
                        //                             ),
                        //                             WidgetSpan(
                        //                               child: Icon(
                        //                                   Icons.add_circle,
                        //                                   color: Colors.green,
                        //                                   size: 15),
                        //                             ),
                        //                             TextSpan(
                        //                                 text:
                        //                                     ' gives a message a score of +1.',
                        //                                 style: TextStyle(
                        //                                     color: Colors.black,
                        //                                     letterSpacing:
                        //                                         0.3)),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       RichText(
                        //                         text: const TextSpan(
                        //                           children: [
                        //                             TextSpan(
                        //                               text: '• Voting ',
                        //                               style: TextStyle(
                        //                                   color: Colors.black,
                        //                                   letterSpacing: 0.3),
                        //                             ),
                        //                             WidgetSpan(
                        //                               child: RotatedBox(
                        //                                 quarterTurns: 1,
                        //                                 child: Icon(
                        //                                   Icons
                        //                                       .pause_circle_filled,
                        //                                   color: Color.fromARGB(
                        //                                       255,
                        //                                       104,
                        //                                       104,
                        //                                       104),
                        //                                   size: 15,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                             TextSpan(
                        //                                 text:
                        //                                     ' gives a message a score of +0.',
                        //                                 style: TextStyle(
                        //                                     color: Colors.black,
                        //                                     letterSpacing:
                        //                                         0.3)),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       RichText(
                        //                         text: const TextSpan(
                        //                           children: [
                        //                             TextSpan(
                        //                               text: '• Voting ',
                        //                               style: TextStyle(
                        //                                   color: Colors.black,
                        //                                   letterSpacing: 0.3),
                        //                             ),
                        //                             WidgetSpan(
                        //                               child: Icon(
                        //                                 Icons.do_not_disturb_on,
                        //                                 color: Colors.red,
                        //                                 size: 15,
                        //                               ),
                        //                             ),
                        //                             TextSpan(
                        //                                 text:
                        //                                     ' gives a message a score of -1.',
                        //                                 style: TextStyle(
                        //                                     color: Colors.black,
                        //                                     letterSpacing:
                        //                                         0.3)),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 6),
                        //                       const Text(
                        //                         "All votes from each voting options are then summed up to give us a final score. The message that receives the highest score at the end of each voting cycle will be added to Fairtalk's Archives. More information on voting cycles can be found further down below.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Voting on polls",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "Just like messages, polls that receive the highest score at the end of each voting cycle will also be added to Fairtalk's Archives. And to calculate the score for polls, we simply take the total amount of votes a poll received during its voting cycle. If you've ever seen polling results somewhere on the internet or television, you've probably asked yourself this question: “How can the results of this poll be accurate if only 50 people were asked to participate?” Well, you’re completely right. The results are often inaccurate and rarely represent what the majority thinks. Polls can also be manipulated to push certain narratives. This is the reason why we had to integrate a fair polling system into our platform, everyone deserves to participate and in turn this creates much more accurate and authentic polling results. ",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       // const Text(
                        //                       //   "Why voting matters",
                        //                       //   textAlign: TextAlign.left,
                        //                       //   style: TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //     fontWeight: FontWeight.w500,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 3),
                        //                       // const Text(
                        //                       //   "The more votes/highest score a specific post receives, the higher it'll be listed on our platform and more users will get to view it and read it. Additionally (as we've previously mentioned), the message and poll that receives the highest scores at the end of each voting cycle, gets the privilege to be added to Fairtalk's Archives. Within our app, anyone can access the Archives screen and look back in time to read and browse through the most popular posts that were created in the past. And as a quick reminder, those posts were created by real humans, and voted by real humans as well. In other words, Fairtalk creates a historical record of the best ideas ever shared by humans and this can really help us find similarities and things that we can all agree on instead of constantly fighting with each other over very small differences and disagreements.",
                        //                       //   style: TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Voting cycles",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "As soon as you create a message or a poll, it'll immediately get listed on the home screen for a total time period of 6 to 7 days (depending on the time of day your post was sent). Other posts that were created by other users during the same day will compete against your post for the reward of being added to Fairtalk's Archives. Once the voting cycle of a post expires (after 6-7 days), it'll no longer be listed on the home screen and other users will no longer have the ability to cast votes on it. Although your post will be removed from the home screen, it will not be deleted. All of your created posts are saved and can be accessed through your profile page. Once a voting cycle ends, a new voting cycle begins immediately afterwards (each day at 12:00AM EST). There's always a total of 7 voting cycles present on the home screen at all times.",

                        //                         // Other users will have 7 days to cast their votes (this is what we call a voting cycle). For messages, you have 3 voting options to choose from: +, = or -. Voting + gives your message a score of +1, voting = gives your message a score of +0 and voting – gives your message a score of -1. For polls, the score is simply determined by the total amount of votes it receives. The score of each message & poll is important because it determines the placement order on the home screen. The higher the score, the higher it'll be listed on the home screen. Additionally, the message and poll with the highest scores (at the end of a voting cycle) will be saved and added to Fairtalk's Archives. Every other message/poll from the same voting cycle will be removed from the home screen to make space for new messages/polls and to begin a new voting cycle. Every day, there’s a new voting cycle that begins at 12:00AM EST regardless of your time zone. There’s always a total of 7 voting cycles present on the Home Screen at all times and as soon as a voting cycle ends, a brand new voting cycle begins at the exact same time. The message you create only competes against other messages posted during that exact same day. The same goes for polls. Every user is limited to one message & one poll for every voting cycle. This gives every user the same odds of their message or poll getting archived and it also protects the platform from spammers. But to be more specific, you are only limited to one global message, one national message, one global poll and one national poll for every voting cycle (not just one single message/poll). ",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       // const Text(
                        //                       //   "How can we possibly give everyone an equal chance of getting their voices heard?",
                        //                       //   textAlign: TextAlign.left,
                        //                       //   style: TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //     fontWeight: FontWeight.w500,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 3),
                        //                       // const Text(
                        //                       //   "To answer this question, we should first look into another big issue with today’s popular social media platforms. Most platforms today have a “following” or “subscription” system. Although this system serves its own purpose and has its own benefits, it also guarantees inequality. The person with more followers will always have more influence over someone who barely has any followers. If Fairtalk implemented this kind of system, the messages/polls that would get archived everyday would certainly always be created by individuals who are already well-known public figures. In turn, this would give all the power and attention to only a small percentage of individuals and silence everyone else. This would defeat the whole purpose of providing a fair platform which gives everybody an equal chance of being heard. This is why we haven’t implemented a “following” or “subscription” system onto our platform, and it is also why every user on Fairtalk stays 100% anonymous.",
                        //                       //   style: TextStyle(
                        //                       //     letterSpacing: 0.3,
                        //                       //   ),
                        //                       // ),
                        //                       // const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Keywords & searching tools",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "Many applications today use algorithms for their platform’s searching tools. This can easily lead to confusion, manipulation, and lack of transparency. What we’ve done instead is simply show you a full list of what’s currently popular. This list isn’t randomly selected by algorithms but instead it’s selected by each user on the platform collectively. Whenever you create a message or poll, you have the option to add up to 3 keywords. The keywords you use should always represent the topic of your message or poll. If you navigate to the search screen, you can view the full list of currently trending keywords. These keywords are listed in order with the most used keywords being listed at the top. This list can easily help you find topics/discussions that are currently popular and/or find ones that interest you the most.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),
                        //                       const Text(
                        //                         "Rules for posting on Fairtalk",
                        //                         textAlign: TextAlign.left,
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       const Text(
                        //                         "Fairtalk has a simple commitment that we will faithfully defend & follow. We fully recognize the importance of freedom of expression and for this reason, we will never censor anyone for any political reason whatsoever. In return, we ask you to follow simple rules that are set in place to sustain a healthy community & improve the user experience.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 8),
                        //                       const Text(
                        //                         "To begin, we need to make something clear. In order for us to provide our service, we are obliged to follow Apple App Store & Google Play Store user-generated content rules & policies. For more information on those rules & policies, we suggest that you read & understand them by clicking on the two links below:",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 8),
                        //                       Row(
                        //                         children: [
                        //                           const Icon(
                        //                               Icons.arrow_forward,
                        //                               size: 15),
                        //                           const SizedBox(width: 10),
                        //                           Link(
                        //                             target: LinkTarget.blank,
                        //                             uri: Uri.parse(
                        //                                 'https://developer.apple.com/app-store/review/guidelines/#safety'),
                        //                             builder:
                        //                                 (BuildContext context,
                        //                                         followLink) =>
                        //                                     InkWell(
                        //                               onTap: followLink,
                        //                               child: const Text(
                        //                                 "Apple App Store's Rules & Policies",
                        //                                 style: TextStyle(
                        //                                     color: Colors.blue,
                        //                                     letterSpacing: 0.3),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       const SizedBox(height: 7.5),
                        //                       Row(
                        //                         children: [
                        //                           const Icon(
                        //                               Icons.arrow_forward,
                        //                               size: 15),
                        //                           const SizedBox(width: 10),
                        //                           Link(
                        //                             target: LinkTarget.blank,
                        //                             uri: Uri.parse(
                        //                                 'https://support.google.com/googleplay/android-developer/topic/9877466?hl=en&ref_topic=9858052'),
                        //                             builder:
                        //                                 (BuildContext context,
                        //                                         followLink) =>
                        //                                     InkWell(
                        //                               onTap: followLink,
                        //                               child: const Text(
                        //                                 "Google Play Store's Rules & Policies",
                        //                                 style: TextStyle(
                        //                                     color: Colors.blue,
                        //                                     letterSpacing: 0.3),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       const SizedBox(height: 8),
                        //                       const Text(
                        //                         "These rules apply to all forms of posts. This includes messages, polls, comments, replies, visual content such as profile pictures, shared images & videos, etc. If we find any evidence that any rules or restrictions have been broken, your account will face consequences.",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 8),
                        //                       RichText(
                        //                         text: TextSpan(
                        //                           children: <TextSpan>[
                        //                             const TextSpan(
                        //                                 text:
                        //                                     'For more details on our rules and restrictions, we highly suggest that you read our ',
                        //                                 style: TextStyle(
                        //                                     color: Colors.black,
                        //                                     letterSpacing:
                        //                                         0.3)),
                        //                             TextSpan(
                        //                                 text: 'Terms of Use',
                        //                                 style: const TextStyle(
                        //                                     color: Colors.blue,
                        //                                     letterSpacing: 0.3),
                        //                                 recognizer:
                        //                                     TapGestureRecognizer()
                        //                                       ..onTap = () {
                        //                                         Navigator.of(
                        //                                                 context)
                        //                                             .push(
                        //                                           MaterialPageRoute(
                        //                                             builder:
                        //                                                 (context) =>
                        //                                                     const TermsConditions(),
                        //                                           ),
                        //                                         );
                        //                                       }),
                        //                             const TextSpan(
                        //                                 text: ' statement.',
                        //                                 style: TextStyle(
                        //                                     color: Colors.black,
                        //                                     letterSpacing:
                        //                                         0.3)),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 15),

                        //                       const Text(
                        //                         "Contact information",
                        //                         style: TextStyle(
                        //                           letterSpacing: 0.3,
                        //                           fontWeight: FontWeight.w500,
                        //                         ),
                        //                       ),
                        //                       const SizedBox(height: 3),
                        //                       Text(
                        //                         "If you have any questions, suggestions or inquiries, feel free to reach out to us by sending us an email: $email",
                        //                         style: const TextStyle(
                        //                           letterSpacing: 0.3,
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 )
                        //               : Row(),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 8),
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
