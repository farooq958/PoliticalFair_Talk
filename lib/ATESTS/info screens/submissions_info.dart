// import 'package:flutter/material.dart';

// import '../screens/statistics.dart';
// import '../utils/global_variables.dart';

// class SubmissionInfo extends StatefulWidget {
//   const SubmissionInfo({Key? key}) : super(key: key);

//   @override
//   State<SubmissionInfo> createState() => _SubmissionInfoState();
// }

// class _SubmissionInfoState extends State<SubmissionInfo> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: testing,
//           appBar: AppBar(
//               automaticallyImplyLeading: false,
//               backgroundColor: darkBlue,
//               elevation: 4,
//               toolbarHeight: 56,
//               actions: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.only(left: 8),
//                     width: MediaQuery.of(context).size.width,
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 40,
//                           height: 40,
//                           child: Material(
//                             shape: const CircleBorder(),
//                             color: Colors.transparent,
//                             child: InkWell(
//                               customBorder: const CircleBorder(),
//                               splashColor: Colors.grey.withOpacity(0.5),
//                               onTap: () {
//                                 Future.delayed(
//                                   const Duration(milliseconds: 50),
//                                   () {
//                                     Navigator.pop(context);
//                                   },
//                                 );
//                               },
//                               child: const Icon(
//                                 Icons.keyboard_arrow_left,
//                                 size: 24,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         const Text("FairTalk's Democracy",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 letterSpacing: 0,
//                                 fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//           body: CustomScrollView(
//             controller: _scrollController,
//             slivers: [
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   [
//                     Column(
//                       children: [
//                         const SizedBox(height: 12),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: PhysicalModel(
//                             color: darkBlue,
//                             elevation: 3,
//                             borderRadius: BorderRadius.circular(15),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 12.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 4),
//                                   const Text(
//                                     "How does it work?",
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                       letterSpacing: 0,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 18,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 3),
//                                   // const Text(
//                                   //   "Today's popular social media platforms mostly operate like dictatorships because all major decisions are always taken by a single individual or a handful of individuals sitting around a table during a board meeting. By creating submissions, you're deciding which new features should be implemented or removed from our platform.",
//                                   //   textAlign: TextAlign.left,
//                                   //   style: TextStyle(
//                                   //     letterSpacing: 0,
//                                   //   ),
//                                   // ),
//                                   const Text(
//                                     "On FairTalk, the majority votes & decides everything. This includes the direction of our platform. By creating or giving votes on submissions, you choose what you want to add, remove or modify from FairTalk.",
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                       letterSpacing: 0,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   // const SizedBox(height: 15),
//                                   // const Text(
//                                   //   "How do I create a submission?",
//                                   //   textAlign: TextAlign.left,
//                                   //   style: TextStyle(
//                                   //     letterSpacing: 0,
//                                   //     fontWeight: FontWeight.w500,
//                                   //     fontSize: 18,
//                                   //     color: Colors.white,
//                                   //   ),
//                                   // ),
//                                   // const SizedBox(height: 3),
//                                   // const Text(
//                                   //   "FairTalk is a completely new platform & submissions will only be made available once the platform reaches 500 verified users. We want to make sure there's enough people to participate. You can always track the current amount of verified users by clicking on the button below.",
//                                   //   textAlign: TextAlign.left,
//                                   //   style: TextStyle(
//                                   //     letterSpacing: 0,
//                                   //     color: Colors.white,
//                                   //   ),
//                                   // ),
//                                   // const SizedBox(height: 15),
//                                   PhysicalModel(
//                                     elevation: 2.5,
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(50),
//                                     child: Material(
//                                       color: Colors.blueAccent,
//                                       borderRadius: BorderRadius.circular(30),
//                                       child: InkWell(
//                                         borderRadius: BorderRadius.circular(50),
//                                         splashColor:
//                                             Colors.black.withOpacity(0.3),
//                                         onTap: () {
//                                           Future.delayed(
//                                               const Duration(milliseconds: 150),
//                                               () {
//                                             Navigator.of(context).push(
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const Statistics()),
//                                             );
//                                           });
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 9),
//                                           alignment: Alignment.center,
//                                           child: const Center(
//                                             child: Text(
//                                               'Track Users',
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 15,
//                                                   letterSpacing: 0.5),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
