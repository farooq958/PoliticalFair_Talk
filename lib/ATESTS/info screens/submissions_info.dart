import 'package:flutter/material.dart';

import '../screens/statistics.dart';

class SubmissionInfo extends StatefulWidget {
  const SubmissionInfo({Key? key}) : super(key: key);

  @override
  State<SubmissionInfo> createState() => _SubmissionInfoState();
}

class _SubmissionInfoState extends State<SubmissionInfo> {
  final ScrollController _scrollController = ScrollController();

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
                    padding: const EdgeInsets.only(left: 8),
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
                        const SizedBox(width: 16),
                        const Text('What are submissions?',
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
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: PhysicalModel(
                            elevation: 3,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  const Text(
                                    "You decide the direction of the platform.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      letterSpacing: 0.3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  // const Text(
                                  //   "Today's popular social media platforms mostly operate like dictatorships because all major decisions are always taken by a single individual or a handful of individuals sitting around a table during a board meeting. By creating submissions, you're deciding which new features should be implemented or removed from our platform.",
                                  //   textAlign: TextAlign.left,
                                  //   style: TextStyle(
                                  //     letterSpacing: 0.3,
                                  //   ),
                                  // ),
                                  const Text(
                                    "By voting and/or creating a submission, you're deciding which new features should be implemented or removed from our platform. On other social media platforms, all decisions are mostly taken by a single individual or a handful of individuals during board meetings (dictatorships). On Fairtalk, all decisions are always taken by the majority (democracy).",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    "How do I create a submission?",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      letterSpacing: 0.3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    "Fairtalk is a completely new platform & submissions will only be made available once the platform reaches 500 verified users. We want to make sure there's enough people to participate. You can always track the current amount of verified users by clicking on the button below.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  PhysicalModel(
                                    elevation: 2.5,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    child: Material(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        splashColor:
                                            Colors.black.withOpacity(0.3),
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(milliseconds: 150),
                                              () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Statistics()),
                                            );
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 9),
                                          alignment: Alignment.center,
                                          child: const Center(
                                            child: Text(
                                              'Track Users',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  letterSpacing: 0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
