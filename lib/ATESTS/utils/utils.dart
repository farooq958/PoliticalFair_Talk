// ignore_for_file: unnecessary_brace_in_string_interps
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../authentication/signup.dart';
import '../camera/camera_screen.dart';
import '../info screens/add_post_rules.dart';
import '../info screens/how_it_works.dart';
import '../info screens/terms_conditions.dart';
import '../info screens/verification_fail.dart';
import '../info screens/verification_success.dart';
import '../methods/firestore_methods.dart';
import '../methods/re_auth_delete_acc_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../methods/re_auth_methods.dart';
import '../responsive/AMobileScreenLayout.dart';
import '../responsive/AResponsiveLayout.dart';
import '../responsive/AWebScreenLayout.dart';
import '../authentication/login_screen.dart';
import '../responsive/my_flutter_app_icons.dart';

import '../screens/statistics.dart';
import '../screens/verify_one.dart';
import 'global_variables.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

pickVideo(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickVideo(source: source);

  if (_file != null) {
    return File(_file.path);
  }
}

showSnackBar(
  String content,
  BuildContext context,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 4),
      // width: MediaQuery.of(context).size.width * 0.85,
      // elevation: 0,
      // behavior: SnackBarBehavior.floating,
      backgroundColor:
          const Color.fromARGB(255, 105, 105, 105).withOpacity(0.8),
      shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(25.0),
          )));
}

showSnackBarAction(
  String content,
  bool action,
  BuildContext context,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(
        children: [
          Text(
            content,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 6,
          ),
          InkWell(
            onTap: () {
              verificationRequired(context: context);
              // action;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.white,
                      )),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      splashColor: const Color.fromARGB(255, 245, 245, 245),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          action
                              ? voteIfPending(context: context)
                              : verificationRequired(context: context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 17,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "FIND OUT WHY",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 5),
      // width: MediaQuery.of(context).size.width * 0.85,
      // elevation: 0,
      // behavior: SnackBarBehavior.floating,
      backgroundColor:
          const Color.fromARGB(255, 105, 105, 105).withOpacity(0.8),
      shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(25.0),
          )));
}

// showSnackBarAddPost(
//   String content,
//   BuildContext context,
//   String uid,
//   String type,
// ) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.check, color: Colors.white, size: 16),
//           const SizedBox(width: 10),
//           Text(
//             content,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//       // action: SnackBarAction(
//       //   label: 'VIEW',
//       //   textColor: Colors.white,
//       //   onPressed: () {
//       //     Navigator.push(
//       //       context,
//       //       MaterialPageRoute(
//       //           builder: (context) => ProfileAllUser(
//       //               uid: uid, initialTab: type == 'message' ? 1 : 2)),
//       //     );
//       //   },
//       // ),
//       duration: const Duration(seconds: 4),
//       backgroundColor:
//           const Color.fromARGB(255, 105, 105, 105).withOpacity(0.8),
//       shape: const RoundedRectangleBorder()));
// }

showSnackBarError(
  String content,
  BuildContext context,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline_outlined,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 4),
      // width: MediaQuery.of(context).size.width * 0.85,
      // elevation: 0,
      // behavior: SnackBarBehavior.floating,
      backgroundColor:
          const Color.fromARGB(255, 105, 105, 105).withOpacity(0.8),
      shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(25.0),
          )));
}

showSnackBarErrorLonger(
  String content,
  BuildContext context,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline_outlined,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 6),
      backgroundColor:
          const Color.fromARGB(255, 105, 105, 105).withOpacity(0.8),
      shape: const RoundedRectangleBorder()));
}

void goToLogin(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ),
    (route) => false,
  );
}

void goToLoginWithoutContext() {
  if (navigatorKey.currentContext != null) {
    Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }
}

void goToVerificationSuccess() {
  Navigator.of(navigatorKey.currentContext!).push(
    MaterialPageRoute(builder: (context) => const VerificationSuccess()),
  );
}

void goToVerificationFail(String reason) {
  Navigator.of(navigatorKey.currentContext!).push(
    MaterialPageRoute(builder: (context) => VerificationFail(reason: reason)),
  );
}

void goToSignup(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => SignupScreen(),
    ),
    (route) => false,
  );
}

void goToHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            )),
    (route) => false,
  );
}

void goToHomeAsGuest(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(guest: true),
              webScreenLayout: WebScreenLayout(),
            )),
    (route) => false,
  );
}

Future<String?> usernameValidator({required String? username}) async {
  // Validates username complexity
  bool isUsernameComplex(String? text) {
    final String _text = (text ?? "");
    // String? p = r"^(?=(.*[0-9]))(?=(.*[A-Za-z]))";
    String? p = r"^(?=(.*[ @$!%*?&=_+/#^.~`]))";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(_text);
  }

  final String _text = (username ?? "");

  // Complexity check
  if (isUsernameComplex(_text)) {
    return "Username can only contain letters and numbers.";
  }
  // Length check
  else if (_text.length < 3 || _text.length > 16) {
    return "Username must be between 3-16 characters long.";
  }

  // Availability check
  var val = await FirebaseFirestore.instance
      .collection('users')
      .where('usernameLower', isEqualTo: _text.toLowerCase())
      .get();
  if (val.docs.isNotEmpty) {
    return "This username is already taken.";
  }

  return null;
}

// Returns screen size
Size getScreenSize({required BuildContext context}) {
  return MediaQuery.of(context).size;
}

Future<dynamic> openCamera({
  required BuildContext context,
  required CameraFileType cameraFileType,
  required add,
}) async {
  dynamic photo;
  try {
    final cameras = await availableCameras();

    final firstCamera = cameras.first;
    CameraDescription? secondaryCamera;
    final addU = add;
    if (cameras.length > 1) {
      secondaryCamera = cameras[1];
    }

    List<File>? selectedImages = await Navigator.of(
      context,
      rootNavigator: true,
    ).push<List<File>>(CupertinoPageRoute(builder: (BuildContext context) {
      return CameraScreen(
        camera: firstCamera,
        secondaryCamera: secondaryCamera,
        cameraFileType: cameraFileType,
        add: addU,
      );
    }));

    if (selectedImages?.isNotEmpty ?? false) {
      photo = cameraFileType == CameraFileType.image
          ? selectedImages?.first.readAsBytesSync()
          : selectedImages?.first;
      // Navigator.pop(context, selectedImages?.first.readAsBytesSync());
    }
  } catch (e) {
    // showAlert(
    //   context: context,
    //   titleText: Localization.of(context).trans(LocalizationValues.error),
    //   message: '$e',
    //   actionCallbacks: {
    //     Localization.of(context).trans(LocalizationValues.ok): () {}
    //   },
    // );
  }
  return photo;
}

// Future<dynamic> openCameraOne({
//   required BuildContext context,
//   required CameraFileType cameraFileType,
//   required idk,
// }) async {
//   dynamic photo;
//   try {
//     final cameras = await availableCameras();
//     print('cameras.length: ${cameras.length}');
//     final firstCamera = cameras.first;
//     CameraDescription? secondaryCamera;
//     if (cameras.length > 1) {
//       secondaryCamera = cameras[1];
//     }

//     List<File>? selectedImages = await Navigator.of(
//       context,
//       rootNavigator: true,
//     ).push<List<File>>(CupertinoPageRoute(builder: (BuildContext context) {
//       return CameraScreenOne(
//         camera: firstCamera,
//         secondaryCamera: secondaryCamera,
//         cameraFileType: cameraFileType,
//         // idc: idk,
//       );
//     }));

//     if (selectedImages?.isNotEmpty ?? false) {
//       print(selectedImages?.first);
//       photo = cameraFileType == CameraFileType.image
//           ? selectedImages?.first.readAsBytesSync()
//           : selectedImages?.first;
//       // Navigator.pop(context, selectedImages?.first.readAsBytesSync());
//     }
//   } catch (e) {
//     // showAlert(
//     //   context: context,
//     //   titleText: Localization.of(context).trans(LocalizationValues.error),
//     //   message: '$e',
//     //   actionCallbacks: {
//     //     Localization.of(context).trans(LocalizationValues.ok): () {}
//     //   },
//     // );
//   }
//   return photo;
// }

////////////////////////////////
////////////////////////////////

// performLoggedUserAction({
//   required BuildContext context,
//   required Function action,
// }) {
//   final User? user = Provider.of<UserProvider>(context, listen: false).getUser;
//   if (user != null) {
//     action();
//   } else {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: EdgeInsets.zero,
//         child: Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.center,
//           children: <Widget>[
//             Container(
//               width: 295,
//               height: 258,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: const darkBlue),
//               padding: const EdgeInsets.fromLTRB(20, 54, 20, 30),
//               child: Column(
//                 children: [
//                   const Text('Action Failed',
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white)),
//                   const Padding(
//                     padding: EdgeInsets.only(top: 4.0, bottom: 12),
//                     child: Text('A registered account is required.',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                         )),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Material(
//                         elevation: 3,
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(25),
//                         child: InkWell(
//                           splashColor: Colors.black.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(25),
//                           onTap: () {
//                             Future.delayed(const Duration(milliseconds: 150),
//                                 () async {
//                               goToLogin(context);
//                             });
//                           },
//                           child: Container(
//                             width: 175,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: Colors.transparent,
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text('Login',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: darkBlue,
//                                       fontWeight: FontWeight.bold,
//                                       letterSpacing: 0.25,
//                                     )),
//                                 Container(width: 10),
//                                 const Icon(Icons.login,
//                                     size: 20,
//                                     color: darkBlue)
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 60,
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   top:
//                                       BorderSide(width: 1, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                             Container(width: 4),
//                             const Text('or',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                 )),
//                             Container(width: 4),
//                             Container(
//                               width: 60,
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   top:
//                                       BorderSide(width: 1, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Material(
//                         color: Colors.white,
//                         elevation: 3,
//                         borderRadius: BorderRadius.circular(25),
//                         child: InkWell(
//                           splashColor: Colors.black.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(25),
//                           onTap: () {
//                             Future.delayed(const Duration(milliseconds: 150),
//                                 () {
//                               goToSignup(context);
//                             });
//                           },
//                           child: Container(
//                             width: 175,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: Colors.transparent,
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 12),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text('Sign Up',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       letterSpacing: 0.25,
//                                       color: darkBlue,
//                                       fontWeight: FontWeight.bold,
//                                     )),
//                                 Container(width: 10),
//                                 const Icon(Icons.verified_user,
//                                     size: 20,
//                                     color: darkBlue)
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Positioned(
//               top: -50,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: darkBlue,
//                 child: PhysicalModel(
//                   color: Colors.white,
//                   elevation: 4,
//                   shape: BoxShape.circle,
//                   child: CircleAvatar(
//                     radius: 46,
//                     backgroundColor: Colors.white,
//                     child: Icon(
//                       Icons.info,
//                       size: 45,
//                       color: darkBlue,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// deleteConfirmation(
//     {required BuildContext context,
//     required String phrase,
//     required String type,
//     required Function action}) {
//   return showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: <Widget>[
//           Container(
//             // width: 295,
//             // height: type == 'Delete Comment' ? 240 : 222,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: const Color.fromARGB(255, 231, 104, 104)),
//             padding: const EdgeInsets.fromLTRB(20, 54, 20, 5),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Are you sure?',
//                     style: TextStyle(
//                         fontSize: 19,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.w500,
//                         color: whiteDialog)),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 12),
//                   child: Column(
//                     children: [
//                       Text(
//                         phrase,
//                         textAlign: TextAlign.center,
//                         style:
//                             const TextStyle(fontSize: 15, color: whiteDialog),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 40,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25),
//                     color: whiteDialog,
//                   ),
//                   child: Material(
//                     elevation: 3,
//                     color: whiteDialog,
//                     borderRadius: BorderRadius.circular(25),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(25),
//                       onTap: () {
//                         Future.delayed(const Duration(milliseconds: 150), () {
//                           action();
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: Text(
//                           type,
//                           style: const TextStyle(
//                               fontSize: 15,
//                               letterSpacing: 0,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.red),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Container(
//                   color: const Color.fromARGB(255, 231, 104, 104),
//                   width: 200,
//                   height: 40,
//                   child: Material(
//                     borderRadius: BorderRadius.circular(25),
//                     color: const Color.fromARGB(255, 231, 104, 104),
//                     child: InkWell(
//                       splashColor: Colors.grey.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(25),
//                       onTap: () {
//                         Future.delayed(const Duration(milliseconds: 150), () {
//                           Navigator.of(context).pop();
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                               fontSize: 15,
//                               letterSpacing: 0,
//                               fontWeight: FontWeight.w500,
//                               color: whiteDialog),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const Positioned(
//             top: -50,
//             child: CircleAvatar(
//               backgroundColor: Color.fromARGB(255, 231, 104, 104),
//               radius: 50,
//               child: PhysicalModel(
//                 color: whiteDialog,
//                 elevation: 4,
//                 shape: BoxShape.circle,
//                 child: CircleAvatar(
//                   backgroundColor: whiteDialog,
//                   radius: 46,
//                   child: FittedBox(
//                     child: Icon(
//                       Icons.delete,
//                       size: 65,
//                       color: Color.fromARGB(255, 231, 104, 104),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }

// reportDialog(
//     {required BuildContext context,
//     required String type,
//     required String typeCapital,
//     required Function action}) {
//   return showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.zero,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: <Widget>[
//           Container(
//             width: 295,
//             height: 236,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: const darkBlue),
//             padding: const EdgeInsets.fromLTRB(6, 52, 6, 6),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
//                   child: Column(
//                     children: [
//                       Text('Report $typeCapital',
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 6.0, bottom: 10),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 0, horizontal: 10),
//                               child: Text(
//                                 "If you believe the content of this $type broke any of our rules, feel free to report it.",
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                     fontSize: 14, color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 4),
//                         child: PhysicalModel(
//                           color: Colors.white,
//                           elevation: 2,
//                           borderRadius: BorderRadius.circular(5),
//                           child: Material(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(25),
//                             child: InkWell(
//                               splashColor: Colors.grey.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(5),
//                               onTap: () {
//                                 // Future.delayed(
//                                 //     const Duration(milliseconds: 100), () {
//                                 //   Navigator.push(
//                                 //     context,
//                                 //     MaterialPageRoute(
//                                 //         builder: (context) =>
//                                 //             const AddPostRules()),
//                                 //   );
//                                 // });
//                               },
//                               child: Container(
//                                 width: 130,
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.transparent,
//                                   borderRadius: BorderRadius.circular(5),
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: const [
//                                     Text(
//                                       "View rules",
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: darkBlue,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     PhysicalModel(
//                       color: Colors.white,
//                       elevation: 3,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         topLeft: Radius.circular(3),
//                         bottomRight: Radius.circular(3),
//                         topRight: Radius.circular(3),
//                       ),
//                       child: Material(
//                         color: Colors.white,
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(20),
//                           topLeft: Radius.circular(3),
//                           bottomRight: Radius.circular(3),
//                           topRight: Radius.circular(3),
//                         ),
//                         child: InkWell(
//                           splashColor: Colors.grey.withOpacity(0.5),
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(20),
//                             topLeft: Radius.circular(3),
//                             bottomRight: Radius.circular(3),
//                             topRight: Radius.circular(3),
//                           ),
//                           onTap: () {
//                             action();
//                           },
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(20),
//                                 topLeft: Radius.circular(3),
//                                 bottomRight: Radius.circular(3),
//                                 topRight: Radius.circular(3),
//                               ),
//                               color: Colors.transparent,
//                             ),
//                             width: 138.3,
//                             height: 50,
//                             alignment: Alignment.center,
//                             child: Text(
//                               'Report $typeCapital',
//                               style: const TextStyle(
//                                   color: darkBlue,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     PhysicalModel(
//                       color: Colors.white,
//                       elevation: 3,
//                       borderRadius: const BorderRadius.only(
//                         bottomRight: Radius.circular(20),
//                         topLeft: Radius.circular(3),
//                         bottomLeft: Radius.circular(3),
//                         topRight: Radius.circular(3),
//                       ),
//                       child: Material(
//                         color: Colors.white,
//                         borderRadius: const BorderRadius.only(
//                           bottomRight: Radius.circular(20),
//                           topLeft: Radius.circular(3),
//                           bottomLeft: Radius.circular(3),
//                           topRight: Radius.circular(3),
//                         ),
//                         child: InkWell(
//                           splashColor: Colors.grey.withOpacity(0.5),
//                           borderRadius: const BorderRadius.only(
//                             bottomRight: Radius.circular(20),
//                             topLeft: Radius.circular(3),
//                             bottomLeft: Radius.circular(3),
//                             topRight: Radius.circular(3),
//                           ),
//                           onTap: () {
//                             Future.delayed(const Duration(milliseconds: 150),
//                                 () {
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                             });
//                           },
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(20),
//                                 topLeft: Radius.circular(3),
//                                 bottomLeft: Radius.circular(3),
//                                 topRight: Radius.circular(3),
//                               ),
//                               color: Colors.transparent,
//                             ),
//                             width: 138.3,
//                             height: 50,
//                             alignment: Alignment.center,
//                             child: const Text(
//                               'Cancel',
//                               style: TextStyle(
//                                   color: darkBlue,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           const Positioned(
//             top: -50,
//             child: CircleAvatar(
//               backgroundColor: darkBlue,
//               radius: 50,
//               child: PhysicalModel(
//                 color: Colors.white,
//                 elevation: 4,
//                 shape: BoxShape.circle,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 46,
//                   child: FittedBox(
//                     child: Icon(
//                       Icons.report,
//                       size: 70,
//                       color: darkBlue,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// blockDialog({
//   required BuildContext context,
//   required Function action,
//   // required bool isBlocked,
//   required bool isSearch,
// }) {
//   return showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.zero,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: <Widget>[
//           Container(
//             width: 295,
//             height: 230,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: const darkBlue),
//             padding: const EdgeInsets.fromLTRB(6, 52, 6, 6),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 4),
//                       const Text(
//                           // isBlocked ? 'Unblock this user?' :
//                           'Block this user?',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0, bottom: 13),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 0, horizontal: 10),
//                               child: const Text(
//                                 // isBlocked
//                                 //     ? "Unblocking this user will make their content become visible again. This includes messages, polls & comments."
//                                 //     :
//                                 "Blocking this user will make their content become invisible. This includes all of their messages, polls & comments.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     PhysicalModel(
//                       color: Colors.white,
//                       elevation: 3,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         topLeft: Radius.circular(3),
//                         bottomRight: Radius.circular(3),
//                         topRight: Radius.circular(3),
//                       ),
//                       child: Material(
//                         color: Colors.white,
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(20),
//                           topLeft: Radius.circular(3),
//                           bottomRight: Radius.circular(3),
//                           topRight: Radius.circular(3),
//                         ),
//                         child: InkWell(
//                           splashColor: Colors.grey.withOpacity(0.5),
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(20),
//                             topLeft: Radius.circular(3),
//                             bottomRight: Radius.circular(3),
//                             topRight: Radius.circular(3),
//                           ),
//                           onTap: () {
//                             action();
//                           },
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(20),
//                                 topLeft: Radius.circular(3),
//                                 bottomRight: Radius.circular(3),
//                                 topRight: Radius.circular(3),
//                               ),
//                               color: Colors.transparent,
//                             ),
//                             width: 138.3,
//                             height: 50,
//                             alignment: Alignment.center,
//                             child: const Text(
//                               // isBlocked ? 'Unblock' :
//                               'Block',
//                               style: TextStyle(
//                                   color: darkBlue,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     PhysicalModel(
//                       color: Colors.white,
//                       elevation: 3,
//                       borderRadius: const BorderRadius.only(
//                         bottomRight: Radius.circular(20),
//                         topLeft: Radius.circular(3),
//                         bottomLeft: Radius.circular(3),
//                         topRight: Radius.circular(3),
//                       ),
//                       child: Material(
//                         color: Colors.white,
//                         borderRadius: const BorderRadius.only(
//                           bottomRight: Radius.circular(20),
//                           topLeft: Radius.circular(3),
//                           bottomLeft: Radius.circular(3),
//                           topRight: Radius.circular(3),
//                         ),
//                         child: InkWell(
//                           splashColor: Colors.grey.withOpacity(0.5),
//                           borderRadius: const BorderRadius.only(
//                             bottomRight: Radius.circular(20),
//                             topLeft: Radius.circular(3),
//                             bottomLeft: Radius.circular(3),
//                             topRight: Radius.circular(3),
//                           ),
//                           onTap: () {
//                             isSearch
//                                 ? Future.delayed(
//                                     const Duration(milliseconds: 150), () {
//                                     Navigator.pop(context);
//                                   })
//                                 : Future.delayed(
//                                     const Duration(milliseconds: 150), () {
//                                     Navigator.pop(context);
//                                     Navigator.pop(context);
//                                   });
//                           },
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(20),
//                                 topLeft: Radius.circular(3),
//                                 bottomLeft: Radius.circular(3),
//                                 topRight: Radius.circular(3),
//                               ),
//                               color: Colors.transparent,
//                             ),
//                             width: 138.3,
//                             height: 50,
//                             alignment: Alignment.center,
//                             child: const Text(
//                               'Cancel',
//                               style: TextStyle(
//                                   color: darkBlue,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           const Positioned(
//             top: -50,
//             child: CircleAvatar(
//               backgroundColor: darkBlue,
//               radius: 50,
//               child: PhysicalModel(
//                 color: Colors.white,
//                 elevation: 4,
//                 shape: BoxShape.circle,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 46,
//                   child: FittedBox(
//                     child: Icon(
//                       Icons.block,
//                       size: 70,
//                       color: darkBlue,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// suspensionDialog({
//   required BuildContext context,
// }) {
//   return showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: <Widget>[
//           Container(
//             width: 300,
//             height: 255,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25), color: whiteDialog),
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//             child: SizedBox(
//               height: 180,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text('Account Suspended',
//                       style: TextStyle(
//                           fontSize: 19,
//                           fontWeight: FontWeight.w500,
//                           letterSpacing: 0)),
//                   RichText(
//                     text: const TextSpan(
//                       children: <TextSpan>[
//                         TextSpan(
//                           text:
//                               "If you believe this was a mistake, you can reach out to us by email: email@gmail.com and we'll further investigate the reason behind your suspension. If you can prove to us that you have read and understood our ",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         ),
//                         // TextSpan(
//                         //     text: 'Terms of Use',
//                         //     style: const TextStyle(
//                         //         color: Colors.blue, fontSize: 15),
//                         //     recognizer: TapGestureRecognizer()
//                         //       ..onTap = () {
//                         //         Navigator.of(context).push(
//                         //           MaterialPageRoute(
//                         //             builder: (context) =>
//                         //                 const TermsConditions(),
//                         //           ),
//                         //         );
//                         //       }),
//                         TextSpan(
//                             text:
//                                 ' statement, your account may get reinstated.',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 15)),
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text(
//                       'Close',
//                       style: TextStyle(
//                           fontSize: 15,
//                           letterSpacing: 0,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// deleteAccount({
//   required BuildContext context,
//   required Function action,
// }) {
//   return showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: const Color.fromARGB(255, 231, 104, 104)),
//             padding: const EdgeInsets.fromLTRB(20, 54, 20, 5),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Are you sure?',
//                     style: TextStyle(
//                         fontSize: 19,
//                         letterSpacing: 0,
//                         fontWeight: FontWeight.w500,
//                         color: whiteDialog)),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 12),
//                   child: Column(
//                     children: const [
//                       Text(
//                         'hi',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 15, color: whiteDialog),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 40,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25),
//                     color: whiteDialog,
//                   ),
//                   child: Material(
//                     elevation: 3,
//                     color: whiteDialog,
//                     borderRadius: BorderRadius.circular(25),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(25),
//                       onTap: () {
//                         Future.delayed(const Duration(milliseconds: 150), () {
//                           action();
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: const Text(
//                           'hi again',
//                           style: TextStyle(
//                               fontSize: 15,
//                               letterSpacing: 0,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.red),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Container(
//                   color: const Color.fromARGB(255, 231, 104, 104),
//                   width: 200,
//                   height: 40,
//                   child: Material(
//                     borderRadius: BorderRadius.circular(25),
//                     color: const Color.fromARGB(255, 231, 104, 104),
//                     child: InkWell(
//                       splashColor: Colors.grey.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(25),
//                       onTap: () {
//                         Future.delayed(const Duration(milliseconds: 150), () {
//                           Navigator.of(context).pop();
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                               fontSize: 15,
//                               letterSpacing: 0,
//                               fontWeight: FontWeight.w500,
//                               color: whiteDialog),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const Positioned(
//             top: -50,
//             child: CircleAvatar(
//               backgroundColor: Color.fromARGB(255, 231, 104, 104),
//               radius: 50,
//               child: PhysicalModel(
//                 color: whiteDialog,
//                 elevation: 4,
//                 shape: BoxShape.circle,
//                 child: CircleAvatar(
//                   backgroundColor: whiteDialog,
//                   radius: 46,
//                   child: FittedBox(
//                     child: Icon(
//                       Icons.delete_forever,
//                       size: 65,
//                       color: Color.fromARGB(255, 231, 104, 104),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }

/////////////////////////////////////////
/////////////////////////////////////////

performLoggedUserAction({
  required BuildContext context,
  required Function action,
}) {
  final User? user = Provider.of<UserProvider>(context, listen: false).getUser;
  if (user != null) {
    action();
  } else {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              // width: 295,
              // height: 253,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: whiteDialog),
              padding: const EdgeInsets.fromLTRB(20, 54, 20, 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Action Failed',
                      style: TextStyle(
                          fontSize: 19,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                          color: darkBlue)),
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 12),
                    child: Text('A registered account is required.',
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          color: darkBlue,
                        )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        elevation: 3,
                        color: darkBlue,
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 150),
                                () async {
                              goToLogin(context);
                            });
                          },
                          child: Container(
                            width: 175,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.transparent,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: whiteDialog,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0,
                                    )),
                                Container(width: 10),
                                const Icon(Icons.login,
                                    size: 20, color: whiteDialog)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(width: 1, color: darkBlue),
                                ),
                              ),
                            ),
                            Container(width: 4),
                            const Text('or',
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  color: darkBlue,
                                )),
                            Container(width: 4),
                            Container(
                              width: 60,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(width: 1, color: darkBlue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: darkBlue,
                        elevation: 3,
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 150),
                                () {
                              goToSignup(context);
                            });
                          },
                          child: Container(
                            width: 175,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.transparent,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Sign Up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      color: whiteDialog,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Container(width: 10),
                                const Icon(Icons.verified_user,
                                    size: 20, color: whiteDialog)
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
            const Positioned(
              top: -50,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: whiteDialog,
                child: PhysicalModel(
                  color: darkBlue,
                  elevation: 4,
                  shape: BoxShape.circle,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: darkBlue,
                    child: Icon(
                      MyFlutterApp.info,
                      size: 45,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

verificationRequired({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      // insetPadding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 273,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(15, 54, 15, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Verification Required',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: darkBlue)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: const Text(
                        "FairTalk wouldn't be considered fair if we allowed users to create multiple accounts and vote multiple times.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: darkBlue,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Material(
                      elevation: 3,
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        splashColor: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyOne()),
                            );
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.transparent,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.verified,
                                color: whiteDialog,
                                size: 20,
                              ),
                              Container(width: 8),
                              const Text(
                                'Verify My Account',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteDialog),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.verified,
                      size: 52,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

voteIfPending({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 254,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: whiteDialog,
            ),
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Verification Pending',
                    style: TextStyle(
                      fontSize: 19,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      color: darkBlue,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Column(
                      children: const [
                        Text(
                            "This account is currently being verified. Verification duration: 24 hours or less. Once verified, you'll have access to perform this action.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: darkBlue,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Material(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      splashColor: Colors.black.withOpacity(0.3),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: whiteDialog,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.verified_user,
                      size: 50,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

nationalityUnknown({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 220,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nationality Unknown',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: darkBlue)),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: const Text(
                        "The only possible method for us to validate your nationality is by verifying your account.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: darkBlue,

                          // fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      splashColor: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyOne()),
                          );
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.verified,
                                size: 20, color: whiteDialog),
                            Container(width: 10),
                            const Text('Verify My Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: whiteDialog,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.flag,
                      size: 50,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

nationalLearnMore({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 220,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('National',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: darkBlue)),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Text(
                      "Other platforms collect your IP address to determine your location/Nationality. This system is flawed because anyone can simply use a VPN to infiltrate & manipulate the voting results of other Nations. FairTalk is fixing this issue.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: darkBlue,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Material(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      splashColor: Colors.black.withOpacity(0.3),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                color: whiteDialog,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.flag,
                      size: 50,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

ballotMessage({required BuildContext context}) {
  return showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 220,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: darkBlue),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Waiting Period',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        color: whiteDialog)),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Column(children: [
                        Center(
                          child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text:
                                      "FairTalk's democracy will only begin once we've reached 1,000 verified users. To view the current amount of verified users, ",
                                  style: TextStyle(
                                    color: whiteDialog,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                    text: 'click here.',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 103, 187, 255),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Statistics(),
                                          ),
                                        );
                                      }),
                                const TextSpan(
                                    text:
                                        " This will ensure there's enough people that can vote & participate. In the meantime, you can still create ballots to suggest features and we'll do our best to implement the ones that receive the highest scores. We thank everyone for staying patient.",
                                    style: TextStyle(
                                      color: whiteDialog,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Material(
                    elevation: 3,
                    color: whiteDialog,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      splashColor: Colors.black.withOpacity(0.3),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                color: darkBlue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: darkBlue,
              radius: 50,
              child: PhysicalModel(
                color: whiteDialog,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: whiteDialog,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.timer,
                      size: 50,
                      color: darkBlue,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

scoreDialogProfile({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      // insetPadding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 217,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Column(
                      children: const [
                        Text(
                          'Profile Score',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: darkBlue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Everytime a verified user upvotes a message or poll that you've created, your profile score increases by +1.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: darkBlue,
                          ),
                        )
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: const [
                        //         Text('Total ',
                        //             style: TextStyle(
                        //               color: darkBlue,
                        //               fontSize: 15,
                        //             )),
                        //         Icon(Icons.add_circle,
                        //             color: Colors.green, size: 17),
                        //         Text(' votes received ',
                        //             style: TextStyle(
                        //               fontSize: 15,
                        //               color: darkBlue,
                        //             ))
                        //       ],
                        //     ),
                        //     // const SizedBox(height: 2),
                        //     const Text('+',
                        //         style: TextStyle(
                        //           color: darkBlue,
                        //           fontSize: 16,
                        //         )),
                        //     // const SizedBox(height: 2),
                        //     const Text('Total poll votes received',
                        //         style: TextStyle(
                        //           color: darkBlue,
                        //           fontSize: 15,
                        //         ))
                      ],
                    ),
                    //   ],
                    // ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                        splashColor: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HowItWorks()),
                            );
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.info_outline,
                                  color: whiteDialog, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Learn more about FairTalk',
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 0,
                                  color: whiteDialog,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      MyFlutterApp.medal,
                      size: 50,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

earnedDialogProfile({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      // insetPadding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding:
                const EdgeInsets.only(left: 20, top: 55, right: 20, bottom: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Column(
                    children: [
                      Column(
                        children: const [
                          Text(
                            'Coming Soon',
                            style: TextStyle(
                              fontSize: 19,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                              color: darkBlue,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Currently in development.',
                            style: TextStyle(
                              fontSize: 15,
                              color: darkBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                        splashColor: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HowItWorks()),
                            );
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.info_outline,
                                  color: whiteDialog, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Learn more about FairTalk',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: whiteDialog,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.5),
                    child: Icon(
                      Icons.attach_money,
                      size: 70,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

scoreDialogMessage({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      // insetPadding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 295,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const Text('Message Score',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         letterSpacing: 0,
                //         fontSize: 19,
                //         fontWeight: FontWeight.w500,
                //         color: darkBlue)),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: PhysicalModel(
                    color: darkBlue,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        // border: Border.all(width: 1, color: darkBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Message Score =',
                            style: TextStyle(
                                fontSize: 15,
                                color: whiteDialog,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500),
                          ),
                          // const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_circle,
                                color: Colors.green,
                                size: 19,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Votes',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.do_not_disturb_on,
                                  color: Colors.red, size: 19),
                              SizedBox(width: 4),
                              Text(
                                'Votes',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: whiteDialog,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(top: 12.0, bottom: 12, right: 0, left: 0),
                  child: Text(
                      "Only votes from verified accounts count. The message that receives the highest score by the end of its voting cycle will be added to FairTalk's Archives collection.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: darkBlue,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                        splashColor: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HowItWorks()),
                            );
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.info_outline,
                                  color: whiteDialog, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Learn more about FairTalk',
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 0,
                                  color: whiteDialog,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 18.0),
                      child: Icon(
                        MyFlutterApp.podium,
                        size: 60,
                        color: whiteDialog,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

scoreDialogPoll({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 276,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PhysicalModel(
                  color: darkBlue,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      // border: Border.all(width: 1, color: darkBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: const [
                        SizedBox(height: 8),
                        Text(
                          'Poll Score =',
                          style: TextStyle(
                              fontSize: 15,
                              color: whiteDialog,
                              fontWeight: FontWeight.w500),
                        ),
                        // SizedBox(height: 6),
                        Text(
                          'Total votes received',
                          style: TextStyle(
                              fontSize: 15,
                              color: whiteDialog,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(top: 12.0, bottom: 12, right: 0, left: 0),
                  child: Text(
                      "Only votes from verified accounts count. The poll that receives the highest score by the end of its voting cycle will be added to FairTalk's Archives collection.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: darkBlue,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    elevation: 3,
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                        splashColor: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HowItWorks()),
                            );
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.info_outline,
                                  color: whiteDialog, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Learn more about FairTalk',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: whiteDialog,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 18.0),
                      child: Icon(
                        MyFlutterApp.podium,
                        size: 60,
                        color: whiteDialog,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

contactInfo({required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const Text('Contact Information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: darkBlue)),
                        const SizedBox(height: 8),
                        const Text(
                            'Have any questions, suggestions, inquiries or simply need help?',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: darkBlue)),
                        const SizedBox(height: 8),
                        Container(
                          width: 210,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 1, color: darkBlue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Feel free to contact us by email:',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: darkBlue)),
                        Text(
                          '$email ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            fontSize: 16,
                            color: darkBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.email_outlined,
                      size: 55,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

timerDialog({
  required BuildContext context,
  // required String minutes,
  // required String hours,
  // required String days,
  required String type,
  // required bool votingEnd,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 261,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const Text('Time Left',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                color: darkBlue)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(
                              "Time left represents the total remaining time before this ${type}'s voting cycle ends.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15, color: darkBlue)),
                        ),
                        // const Text("Remaining time:",
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(fontSize: 15, color: darkBlue)),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 2, bottom: 12),
                        //   child: votingEnd == true
                        //       ? const Text(
                        //           'Voting has already ended.',
                        //           style: TextStyle(
                        //             fontSize: 15,
                        //             letterSpacing: 0,
                        //             fontWeight: FontWeight.w500,
                        //             color: darkBlue,
                        //           ),
                        //         )
                        //       : Container(
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             '${days} Days  •  ${hours} Hours  •  ${minutes} Mins',
                        //             style: const TextStyle(
                        //               fontSize: 15,
                        //               fontWeight: FontWeight.w500,
                        //               color: darkBlue,
                        //             ),
                        //           ),
                        //         ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Material(
                            color: darkBlue,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HowItWorks()),
                                  );
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.info_outline,
                                        color: whiteDialog, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Learn more about FairTalk',
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 0,
                                        color: whiteDialog,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.timer,
                      size: 55,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

sendTimerDialog({
  required BuildContext context,
  required String type,
  required String type2,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: type == 'message' ? 234 : 216,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const Text('Waiting Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: darkBlue)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(
                            'Each user is limited to one $type2 $type for every voting cycle. The duration of a voting cycle is 24 hours. Cycles refresh every day at 12:01 AM EST.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: darkBlue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Material(
                            color: darkBlue,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HowItWorks()),
                                  );
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.info_outline,
                                        color: whiteDialog, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Learn more about FairTalk',
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 0,
                                        color: whiteDialog,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.timer,
                      size: 55,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

sendTimerBallot({
  required BuildContext context,
  required String type,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: type == 'message' ? 234 : 216,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const Text('Waiting Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: darkBlue)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(
                            'Each user is limited to one $type for every voting cycle. The duration of a voting cycle is 24 hours. Cycles refresh every day at 12:01 AM EST.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: darkBlue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Material(
                            color: darkBlue,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HowItWorks()),
                                  );
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.info_outline,
                                        color: whiteDialog, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Learn more about FairTalk',
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 0,
                                        color: whiteDialog,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.timer,
                      size: 55,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

sendTimerDialogSubmission({
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: type == 'message' ? 234 : 216,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const Text('Waiting Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: darkBlue)),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(
                              'Every user is limited to one submission for every voting cycle. A new voting cycle begins every 30 days.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: darkBlue)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Material(
                            color: darkBlue,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HowItWorks()),
                                  );
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.info_outline,
                                        color: whiteDialog, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Learn more about FairTalk',
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 0,
                                        color: whiteDialog,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.timelapse,
                      size: 70,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

deleteConfirmation(
    {required BuildContext context,
    required String phrase,
    required String type,
    required Function action}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: type == 'Delete Comment' ? 240 : 222,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(255, 231, 104, 104)),
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure?',
                    style: TextStyle(
                        fontSize: 19,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: whiteDialog)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                  child: Column(
                    children: [
                      Text(
                        phrase,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 15, color: whiteDialog),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: whiteDialog,
                  ),
                  child: Material(
                    elevation: 3,
                    color: whiteDialog,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          action();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          type,
                          style: const TextStyle(
                              fontSize: 15,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  color: const Color.fromARGB(255, 231, 104, 104),
                  width: 200,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(255, 231, 104, 104),
                    child: InkWell(
                      splashColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                              color: whiteDialog),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 231, 104, 104),
              radius: 50,
              child: PhysicalModel(
                color: whiteDialog,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: whiteDialog,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.delete_forever_outlined,
                      size: 65,
                      color: Color.fromARGB(255, 231, 104, 104),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

keywordsDialog({
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Keywords',
                    style: TextStyle(
                        fontSize: 19,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: darkBlue)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                  child: Column(
                    children: const [
                      Text(
                        "Keywords should always represent the topic of your message or poll. They're used as a searching tool to help users find subjects or topics that interests them.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: darkBlue),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: darkBlue,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      splashColor: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HowItWorks()),
                          );
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.info_outline,
                                color: whiteDialog, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Learn more about FairTalk',
                              style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 0,
                                color: whiteDialog,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.key,
                      size: 65,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

percentageBarDialog({
  required BuildContext context,
  required int plusCount,
  required int neutralCount,
  required int minusCount,
  // required int totalCount,
  // required bool postEnded,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Voting Results',
                    // postEnded
                    //     ? 'Final Voting Results'
                    //     : 'Current Voting Results',
                    style: TextStyle(
                        fontSize: 19,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: darkBlue)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Votes:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: darkBlue,
                                      letterSpacing: 0.2),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '$plusCount',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: darkBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  plusCount == 0
                                      ? '(0%)'
                                      : '(${(plusCount / (plusCount + neutralCount + minusCount) * 100).toInt().toString()}%)',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color.fromARGB(255, 185, 185, 185),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          // color: Colors.red,
                          border: Border(
                            top: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.pause_circle_filled,
                                    color: Color.fromARGB(255, 111, 111, 111),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Votes:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: darkBlue,
                                      letterSpacing: 0.2),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '$neutralCount',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: darkBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  neutralCount == 0
                                      ? '(0%)'
                                      : '(${(neutralCount / (plusCount + neutralCount + minusCount) * 100).toInt().toString()}%)',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color.fromARGB(255, 185, 185, 185),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          // color: Colors.red,
                          border: Border(
                            top: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.do_not_disturb_on,
                                    color: Colors.red),
                                SizedBox(width: 6),
                                Text(
                                  "Votes:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: darkBlue,
                                      letterSpacing: 0.2),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '$minusCount',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: darkBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  minusCount == 0
                                      ? '(0%)'
                                      : '(${(minusCount / (plusCount + neutralCount + minusCount) * 100).toInt().toString()}%)',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color.fromARGB(255, 185, 185, 185),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: darkBlue,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      splashColor: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HowItWorks()),
                          );
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.info_outline,
                                color: whiteDialog, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Learn more about FairTalk',
                              style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 0,
                                color: whiteDialog,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.assessment_outlined,
                      size: 58,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

////////

reportDialog(
    {required BuildContext context,
    required String type,
    required String typeCapital,
    required bool user,
    required Function action}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 266,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(6, 55, 6, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Text('Report $typeCapital',
                          style: const TextStyle(
                              fontSize: 19,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                              color: darkBlue)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 10),
                        child: Column(
                          children: [
                            Text(
                              user
                                  ? "If you believe this user broke any of FairTalk's rules, please report them and we'll carefully review their content & actions."
                                  : "If you believe this $type broke any of FairTalk's rules, please report it and we'll carefully review its content.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15, color: darkBlue),
                            ),
                          ],
                        ),
                      ),
                      PhysicalModel(
                        color: darkBlue,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(25),
                        child: Material(
                          color: darkBlue,
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddPostRules()),
                                );
                              });
                            },
                            child: Container(
                              width: 130,
                              height: 35,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "View Rules",
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      color: whiteDialog,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PhysicalModel(
                        color: darkBlue,
                        elevation: 3,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(3),
                          bottomRight: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                        child: Material(
                          color: darkBlue,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(3),
                            bottomRight: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                            onTap: () {
                              action();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                color: Colors.transparent,
                              ),
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                'Report $typeCapital',
                                style: const TextStyle(
                                    color: whiteDialog,
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: PhysicalModel(
                        color: darkBlue,
                        elevation: 3,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(3),
                          bottomLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                        child: Material(
                          color: darkBlue,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(3),
                            bottomLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(3),
                                  bottomLeft: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                color: Colors.transparent,
                              ),
                              width: 131,
                              height: 45,
                              alignment: Alignment.center,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: whiteDialog,
                                    letterSpacing: 0,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.report,
                      size: 60,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

blockDialog({
  required BuildContext context,
  required Function action,
  // required bool isBlocked,
  required bool isSearch,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 295,
            // height: 206,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(6, 55, 6, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      const Text('Block this user?',
                          style: TextStyle(
                              fontSize: 19,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                              color: darkBlue)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: const Text(
                                "Blocking this user will result in you no longer seeing any of their content.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15, color: darkBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PhysicalModel(
                        color: darkBlue,
                        elevation: 3,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(3),
                          bottomRight: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                        child: Material(
                          color: darkBlue,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(3),
                            bottomRight: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                            onTap: () {
                              action();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                color: Colors.transparent,
                              ),
                              height: 45,
                              alignment: Alignment.center,
                              child: const Text(
                                // isBlocked ? 'Unblock' :
                                'Block',
                                style: TextStyle(
                                    color: whiteDialog,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: PhysicalModel(
                        color: darkBlue,
                        elevation: 3,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(3),
                          bottomLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                        child: Material(
                          color: darkBlue,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(3),
                            bottomLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(3),
                                  bottomLeft: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                ),
                                color: Colors.transparent,
                              ),
                              height: 45,
                              alignment: Alignment.center,
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: whiteDialog,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: whiteDialog,
              radius: 50,
              child: PhysicalModel(
                color: darkBlue,
                elevation: 4,
                shape: BoxShape.circle,
                child: CircleAvatar(
                  backgroundColor: darkBlue,
                  radius: 46,
                  child: FittedBox(
                    child: Icon(
                      Icons.block,
                      size: 65,
                      color: whiteDialog,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

keepReportDialog({
  required BuildContext context,
  required post,
  required String type,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: SizedBox(
              // height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Confirm Action',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () async {
                      await FirestoreMethods().keepReport(post, type);

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 204, 204, 204),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      width: 120,
                      child: const Center(
                        child: Text(
                          'KEEP',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 126, 126, 126)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

removeReportDialog({
  required BuildContext context,
  required post,
  required uid,
  required String type,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: SizedBox(
              // height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Confirm Action',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () async {
                      await FirestoreMethods().removeReport(post, uid, type);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 255, 133, 124),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      width: 120,
                      child: const Center(
                        child: Text(
                          'REMOVE',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 126, 126, 126)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

removeProfPicDialog({
  required BuildContext context,
  required uid,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: SizedBox(
              // height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Confirm Action',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () async {
                      await FirestoreMethods().removeProfPic(uid);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 255, 133, 124),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      width: 200,
                      child: const Center(
                        child: Text(
                          'REMOVE PROFILE PICTURE',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 126, 126, 126)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

saveBugDialog({
  required BuildContext context,
  required bugId,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: SizedBox(
              // height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Confirm Action',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () async {
                      await FirestoreMethods().bugAction(bugId, 'save');

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 204, 204, 204),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      width: 120,
                      child: const Center(
                        child: Text(
                          'SAVE',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 126, 126, 126)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

deleteBugDialog({
  required BuildContext context,
  required bugId,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: SizedBox(
              // height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Confirm Action',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () async {
                      await FirestoreMethods().bugAction(bugId, 'remove');
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 255, 133, 124),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      width: 120,
                      child: const Center(
                        child: Text(
                          'DELETE',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 126, 126, 126)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

suspensionDialog({
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            // width: 300,
            // height: 255,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: whiteDialog),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: SizedBox(
              // height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Account Suspended',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text:
                              "If you believe this was a mistake, you can reach out to us by email: contact@fairtalk.net and we'll further investigate the reason behind your suspension. If you can prove to us that you have read and understood our ",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        TextSpan(
                            text: 'Terms of Use',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 15),
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
                                ' statement, your account may get reinstated.',
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

filterDialog({
  required BuildContext context,
}) {
  bool sortingOrder = false;
  bool daysLeft = false;
  bool countries = false;
  return showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        //   statusBarColor: Colors.red,
        //   statusBarBrightness: Brightness.dark,
        // ));
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                // width: 295,
                // height: sortingOrder
                //     ? 287
                //     : daysLeft
                //         ? 332
                //         : countries
                //             ? 317
                //             : 232,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: whiteDialog),
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        const Text('Sort & Filter',
                            style: TextStyle(
                                fontSize: 20,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                color: darkBlue)),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  sortingOrder = !sortingOrder;
                                  daysLeft == true ? daysLeft = false : null;
                                  countries == true ? countries = false : null;
                                });
                              },
                              child: Container(
                                width: 230,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: darkBlue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.sort,
                                              color: whiteDialog,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Sorting Order',
                                              style: TextStyle(
                                                color: whiteDialog,
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          sortingOrder
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: whiteDialog,
                                        )
                                      ],
                                    ),
                                    sortingOrder
                                        ? const Padding(
                                            padding: EdgeInsets.only(
                                                top: 5.0,
                                                bottom: 5,
                                                right: 5,
                                                left: 5),
                                            child: Text(
                                              "This allows you to select the order by which posts will be displayed in your lists.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: whiteDialog,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          )
                                        : Row()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  sortingOrder == true
                                      ? sortingOrder = false
                                      : null;
                                  daysLeft = !daysLeft;
                                  countries == true ? countries = false : null;
                                });
                              },
                              child: Container(
                                width: 230,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: darkBlue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: const [
                                            Icon(
                                              MyFlutterApp.hourglass_2,
                                              color: whiteDialog,
                                              size: 20,
                                            ),
                                            SizedBox(width: 11),
                                            Text(
                                              'Voting Cycles',
                                              style: TextStyle(
                                                color: whiteDialog,
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          daysLeft
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: whiteDialog,
                                        )
                                      ],
                                    ),
                                    daysLeft
                                        ? const Padding(
                                            padding: EdgeInsets.only(
                                                top: 5.0,
                                                bottom: 5,
                                                right: 5,
                                                left: 5),
                                            child: Text(
                                              'This allows you to filter posts by their specific voting cycle. Example: selecting "≤ 1 Day" only displays posts that currently have 1 day or less before the end of their voting cycle.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: whiteDialog,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          )
                                        : Row()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                sortingOrder == true
                                    ? sortingOrder = false
                                    : null;
                                daysLeft == true ? daysLeft = false : null;
                                countries = !countries;
                              });
                            },
                            child: Container(
                              width: 230,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: darkBlue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.flag,
                                            color: whiteDialog,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Countries',
                                            style: TextStyle(
                                              color: whiteDialog,
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        countries
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: whiteDialog,
                                      )
                                    ],
                                  ),
                                  countries
                                      ? const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.0,
                                              bottom: 5,
                                              right: 5,
                                              left: 5),
                                          child: Text(
                                            "This allows you to filter posts by a specific country. This filtering option does not have any effect on global posts. ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: whiteDialog,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        )
                                      : Row()
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
              const Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: whiteDialog,
                  radius: 50,
                  child: PhysicalModel(
                    color: darkBlue,
                    elevation: 4,
                    shape: BoxShape.circle,
                    child: CircleAvatar(
                      backgroundColor: darkBlue,
                      radius: 46,
                      child: FittedBox(
                        child: Icon(
                          Icons.filter_list,
                          size: 65,
                          color: whiteDialog,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Future<bool> performReAuthenticationDeleteAccountAction({
  required BuildContext context,
}) async {
  bool? authenticated = false;
  final User? user = Provider.of<UserProvider>(context, listen: false).getUser;
  if (user != null) {
    authenticated = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteAccountDialog(),
    );
  }
  return authenticated ?? false;
}

Future<bool> performReAuthenticationAction({
  required BuildContext context,
  required username,
}) async {
  bool? authenticated = false;
  final User? user = Provider.of<UserProvider>(context, listen: false).getUser;
  var idk = username;
  if (user != null) {
    authenticated = await showDialog<bool>(
      context: context,
      builder: (_) => ReAuthenticationDialog(username: idk),
    );
  }
  return authenticated ?? false;
}

String trimText({
  required String text,
}) {
  String trimmedText = text;
  // Removes all line breaks and end blank spaces
  trimmedText = trimmedText.replaceAll('\n', ' ').trim();

  // Removes all consecutive blank spaces
  while (trimmedText.contains('  ')) {
    trimmedText = trimmedText.replaceAll('  ', ' ');
  }

  return trimmedText;
}
