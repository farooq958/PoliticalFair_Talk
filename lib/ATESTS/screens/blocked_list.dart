// import 'package:aft/ATESTS/provider/block_list_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/user.dart';
// import '../provider/user_provider.dart';
// import '../utils/utils.dart';

// class BlockedList extends StatefulWidget {
//   const BlockedList({Key? key}) : super(key: key);

//   @override
//   State<BlockedList> createState() => _BlockedListState();
// }

// class _BlockedListState extends State<BlockedList> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       final User? user =
//           Provider.of<UserProvider>(context, listen: false).getUser;
//       final blockListProvider =
//           Provider.of<BlockListProvider>(context, listen: false);
//       blockListProvider.getUserBlockList(user?.UID);
//       //_userScroller.addListener(userNextScroll);
//     });
//   }

//   // ignore: non_constant_identifier_names
//   // List Result = [];

//   // late QuerySnapshot getuserProfile;

//   // userBlockList(String? uid) async {
//   //   Result.clear();
//   //   var querySnapshot =
//   //       await FirebaseFirestore.instance.collection("users").doc(uid).get();
//   //   for (int i = 0; i < querySnapshot["blockList"].length; i++) {
//   //     getuserProfile = await FirebaseFirestore.instance
//   //         .collection("users")
//   //         .where("UID", isEqualTo: querySnapshot["blockList"][i])
//   //         .get();
//   //     for (var element in getuserProfile.docs) {
//   //       Result.add(element.data());
//   //     }
//   //   }
//   //   return querySnapshot;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final User? user = Provider.of<UserProvider>(context).getUser;
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: const Color.fromARGB(255, 245, 245, 245),
//           appBar: AppBar(
//               automaticallyImplyLeading: false,
//               elevation: 0,
//               backgroundColor: const darkBlue,
//               actions: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 40,
//                         height: 40,
//                         child: Material(
//                           shape: const CircleBorder(),
//                           color: Colors.transparent,
//                           child: InkWell(
//                             customBorder: const CircleBorder(),
//                             splashColor: Colors.grey.withOpacity(0.5),
//                             onTap: () {
//                               Future.delayed(
//                                 const Duration(milliseconds: 50),
//                                 () {
//                                   Navigator.pop(context);
//                                 },
//                               );
//                             },
//                             child: const Icon(Icons.arrow_back,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.only(left: 16.0),
//                         child: Text('Blocked List',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white,
//                             )),
//                       ),
//                     ],
//                   ),
//                 ),
//               ]),
//           body: Padding(
//             padding: const EdgeInsets.only(top: 8),

//             child: Consumer<BlockListProvider>(
//               builder: (context, blockListProvider, child) {
//                 if (blockListProvider.loading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (blockListProvider.blockedUsers.isNotEmpty) {
//                   return ListView(children: [
//                     blockListProvider.count <= 1 || blockListProvider.loading
//                         ? const SizedBox()
//                         : TextButton(
//                             onPressed: () {
//                               final userProvider = Provider.of<UserProvider>(
//                                   context,
//                                   listen: false);
//                               if (userProvider.getUser != null) {
//                                 blockListProvider.getPreviousBlockedUsers(
//                                     userProvider.getUser!.UID);
//                               }
//                             },
//                             child: Text(
//                                 'Load ${(blockListProvider.count - 1) * blockListProvider.pageSize} - ${(blockListProvider.count) * blockListProvider.pageSize + 1}')),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       //  physics: const NeverScrollableScrollPhysics(),
//                       itemCount: blockListProvider.blockedUsers.length,
//                       itemBuilder: ((context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12.0, vertical: 2.5),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 0, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               border:
//                                   Border.all(width: 0.5, color: Colors.grey),
//                             ),
//                             child: ListTile(
//                               leading: Stack(
//                                 children: [
//                                   blockListProvider
//                                               .blockedUsers[index].photoUrl !=
//                                           null
//                                       ? CircleAvatar(
//                                           backgroundImage: NetworkImage(
//                                           blockListProvider
//                                               .blockedUsers[index].photoUrl!,
//                                         ))
//                                       : const CircleAvatar(
//                                           backgroundImage: AssetImage(
//                                               'assets/avatarFT.jpg')),
//                                 ],
//                               ),
//                               title: Text(
//                                 blockListProvider.blockedUsers[index].username,
//                                 style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     overflow: TextOverflow.ellipsis),
//                               ),
//                               trailing: TextButton(
//                                 style: ButtonStyle(
//                                   overlayColor: MaterialStateProperty.all(
//                                       Colors.red.withOpacity(0.3)),
//                                 ),
//                                 onPressed: () {
//                                   performLoggedUserAction(
//                                     context: context,
//                                     action: () async {
//                                       Future.delayed(
//                                           const Duration(milliseconds: 100),
//                                           () {
//                                         final batch =
//                                             FirebaseFirestore.instance.batch();
//                                         var userRef = FirebaseFirestore.instance
//                                             .collection("users")
//                                             .doc(user?.UID);
//                                         var blockedUerRef = FirebaseFirestore
//                                             .instance
//                                             .collection("users")
//                                             .doc(user?.UID)
//                                             .collection('blockList')
//                                             .doc(blockListProvider
//                                                 .blockedUsers[index].UID);
//                                         batch.update(userRef, {
//                                           'blockList': FieldValue.arrayRemove([
//                                             blockListProvider
//                                                 .blockedUsers[index].UID
//                                           ])
//                                         });
//                                         batch.delete(blockedUerRef);
//                                         batch.commit();
//                                         showSnackBar(
//                                             'User successfully unblocked.',
//                                             context);
//                                         blockListProvider.unblockUser(
//                                             blockListProvider
//                                                 .blockedUsers[index].UID);
//                                       });
//                                     },
//                                   );
//                                 },
//                                 child: const Text(
//                                   "Unblock",
//                                   style: TextStyle(
//                                     color: Color.fromARGB(255, 227, 115, 107),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                     blockListProvider.last || blockListProvider.loading
//                         ? const SizedBox()
//                         : TextButton(
//                             onPressed: () {
//                               final userProvider = Provider.of<UserProvider>(
//                                   context,
//                                   listen: false);
//                               if (userProvider.getUser != null) {
//                                 blockListProvider.getPreviousBlockedUsers(
//                                     userProvider.getUser!.UID);
//                               }
//                             },
//                             child: Text(
//                                 'Load ${blockListProvider.count * blockListProvider.pageSize + 1} - ${(blockListProvider.count + 1) * blockListProvider.pageSize + 1}')),
//                   ]);
//                 } else {
//                   return const Center(
//                     child: Text('No Users found'),
//                   );
//                 }
//               },
//             ),

//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

import 'package:aft/ATESTS/provider/block_list_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class BlockedList extends StatefulWidget {
  const BlockedList({Key? key}) : super(key: key);

  @override
  State<BlockedList> createState() => _BlockedListState();
}

class _BlockedListState extends State<BlockedList> {
  ScrollController _userScroller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final User? user =
          Provider.of<UserProvider>(context, listen: false).getUser;
      final blockListProvider =
          Provider.of<BlockListProvider>(context, listen: false);
      blockListProvider.getUserBlockList(user?.UID);
      _userScroller.addListener(userNextScroll);
    });
  }

  userNextScroll() async {
    final User? user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    final blockListProvider =
        Provider.of<BlockListProvider>(context, listen: false);

    if (_userScroller.position.extentAfter < 1) {
      blockListProvider.getNextBlockedUsers(user?.UID);
    }
  }

  // ignore: non_constant_identifier_names
  // List Result = [];

  // late QuerySnapshot getuserProfile;

  // userBlockList(String? uid) async {
  //   Result.clear();
  //   var querySnapshot =
  //       await FirebaseFirestore.instance.collection("users").doc(uid).get();
  //   for (int i = 0; i < querySnapshot["blockList"].length; i++) {
  //     getuserProfile = await FirebaseFirestore.instance
  //         .collection("users")
  //         .where("UID", isEqualTo: querySnapshot["blockList"][i])
  //         .get();
  //     for (var element in getuserProfile.docs) {
  //       Result.add(element.data());
  //     }
  //   }
  //   return querySnapshot;
  // }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    var safePadding = MediaQuery.of(context).padding.top;
    return Container(
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              child: const Icon(Icons.keyboard_arrow_left,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text('Blocked List',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          body: Padding(
            padding: const EdgeInsets.only(top: 8),

            child: SingleChildScrollView(
              controller: _userScroller,
              child: Consumer<BlockListProvider>(
                builder: (context, blockListProvider, child) {
                  if (blockListProvider.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (blockListProvider.blockedUsers.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: blockListProvider.blockedUsers.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 2.5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                            ),
                            child: ListTile(
                              leading: Stack(
                                children: [
                                  blockListProvider
                                              .blockedUsers[index].photoUrl !=
                                          null
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                          blockListProvider
                                              .blockedUsers[index].photoUrl!,
                                        ))
                                      : const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/avatarFT.jpg')),
                                ],
                              ),
                              title: Text(
                                blockListProvider.blockedUsers[index].username,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.red.withOpacity(0.3)),
                                ),
                                onPressed: () {
                                  performLoggedUserAction(
                                    context: context,
                                    action: () async {
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        final batch =
                                            FirebaseFirestore.instance.batch();
                                        var userRef = FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(user?.UID);
                                        var blockedUerRef = FirebaseFirestore
                                            .instance
                                            .collection("users")
                                            .doc(user?.UID)
                                            .collection('blockList')
                                            .doc(blockListProvider
                                                .blockedUsers[index].UID);
                                        batch.update(userRef, {
                                          'blockList': FieldValue.arrayRemove([
                                            blockListProvider
                                                .blockedUsers[index].UID
                                          ])
                                        });
                                        batch.delete(blockedUerRef);
                                        batch.commit();
                                        showSnackBar(
                                            'User successfully unblocked.',
                                            context);
                                        blockListProvider.unblockUser(
                                            blockListProvider
                                                .blockedUsers[index].UID);
                                      });
                                    },
                                  );
                                },
                                child: const Text(
                                  "Unblock",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 227, 115, 107),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          safePadding,
                      child: const Center(
                        child: Text(
                          'No blocked users yet.',
                          style: TextStyle(
                              color: Color.fromARGB(255, 114, 114, 114),
                              fontSize: 18),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            // child: FutureBuilder(
            //   future: userBlockList(user?.UID),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //
            //     return (snapshot.data as dynamic)["blockList"].length != 0
            //         ? SingleChildScrollView(
            //             child: ListView.builder(
            //               shrinkWrap: true,
            //               physics: const NeverScrollableScrollPhysics(),
            //               itemCount: Result.length,
            //               itemBuilder: ((context, index) {
            //                 return Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 12.0, vertical: 2.5),
            //                   child: Container(
            //                     padding: const EdgeInsets.symmetric(
            //                         horizontal: 0, vertical: 4),
            //                     decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(8),
            //                       border: Border.all(
            //                           width: 0.5, color: Colors.grey),
            //                     ),
            //                     child: ListTile(
            //                       leading: Stack(
            //                         children: [
            //                           Result[index]['photoUrl'] != null
            //                               ? CircleAvatar(
            //                                   backgroundImage: NetworkImage(
            //                                   Result[index]['photoUrl'],
            //                                 ))
            //                               : const CircleAvatar(
            //                                   backgroundImage: AssetImage(
            //                                       'assets/avatarFT.jpg')),
            //                         ],
            //                       ),
            //                       title: Text(
            //                         Result[index]['username'],
            //                         style: const TextStyle(
            //                             fontSize: 16,
            //                             fontWeight: FontWeight.w500,
            //                             overflow: TextOverflow.ellipsis),
            //                       ),
            //                       trailing: TextButton(
            //                         style: ButtonStyle(
            //                           overlayColor: MaterialStateProperty.all(
            //                               Colors.red.withOpacity(0.3)),
            //                         ),
            //                         onPressed: () {
            //                           performLoggedUserAction(
            //                             context: context,
            //                             action: () async {
            //                               Future.delayed(
            //                                   const Duration(milliseconds: 100),
            //                                   () {
            //                                 FirebaseFirestore.instance
            //                                     .collection("users")
            //                                     .doc(user?.UID)
            //                                     .update({
            //                                   'blockList':
            //                                       FieldValue.arrayRemove(
            //                                           [Result[index]['UID']])
            //                                 });
            //                                 showSnackBar(
            //                                     'User successfully unblocked.',
            //                                     context);
            //                                 setState(() {});
            //                               });
            //                             },
            //                           );
            //                         },
            //                         child: const Text(
            //                           "Unblock",
            //                           style: TextStyle(
            //                             color:
            //                                 Color.fromARGB(255, 227, 115, 107),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               }),
            //             ),
            //           )
            //         : const Center(
            //             child: Text("No blocked users yet.",
            //                 style: TextStyle(
            //                     fontSize: 18,
            //                     color: Color.fromARGB(255, 95, 95, 95))),
            //           );
            //   },
            // ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userScroller.dispose();
    super.dispose();
  }
}
