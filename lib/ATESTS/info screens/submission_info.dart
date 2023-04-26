// import 'package:flutter/material.dart';

// class SubmissionInfo extends StatefulWidget {
//   const SubmissionInfo({Key? key}) : super(key: key);

//   @override
//   State<SubmissionInfo> createState() => _SubmissionInfoState();
// }

// class _SubmissionInfoState extends State<SubmissionInfo> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Scaffold(
//             backgroundColor: Colors.black.withOpacity(0.05),
//             appBar: AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: Colors.white,
//                 elevation: 4,
//                 toolbarHeight: 56,
//                 actions: [
//                   Container(
//                     padding: const EdgeInsets.only(left: 6),
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
//                                 Icons.arrow_back,
//                                 size: 24,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(width: 8),
//                         const Text('Submission Info',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 letterSpacing: 0.3,
//                                 fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                   ),
//                 ]),
//             body: const Text('hi')),
//       ),
//     );
//   }
// }
