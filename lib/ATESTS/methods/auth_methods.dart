import 'dart:typed_data';

import 'package:aft/ATESTS/services/firebase_notification.dart';
import 'package:aft/ATESTS/utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart' as model;
import '../provider/user_provider.dart';
import '../utils/utils.dart';
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// made user nullable
  ///
  Future<model.User?> getUserDetails() async {
    User? currentUser = _auth.currentUser;

    /// Check for null if not get detailsN
    if (currentUser != null) {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUser.uid).get();

      return model.User.fromSnap(snap);
    } else {
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<model.User> getAllUserDetails(String uid) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();

    return model.User.fromSnap(snap);
  }

  getUserProfileDetails(uid) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();

    return model.User.fromSnap(snap);
  }

//sign up user
  Future<String> signUpUser({
    required String aEmail,
    required String password,
    required String username,
    required String? bio,

    // required Uint8List file,
    required Uint8List? profilePicFile,
    required String aaCountry,
    required String pending,
  }) async {
    String res = "Some error occured";
    try {
      var timeNow = await NTP.now();
      String trimmedBio = trimText(text: '');

      if (aEmail.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: aEmail, password: password);
        // debugPrint('yes passed $cred');
        // print(cred.user!.uid);

        // If profile pic is selected by user
        String? profilePicUrl;
        if (profilePicFile != null) {
          profilePicUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', profilePicFile, false);
        }
        final fcmToken = await FirebaseNotification.getToken();

        //add user to our database
        model.User user = model.User(
          username: username,
          usernameLower: username.toLowerCase(),
          UID: cred.user!.uid,
          dateCreated: timeNow,
          photoUrl: profilePicUrl,
          aEmail: aEmail,
          aaCountry: aaCountry,
          pending: pending,
          bio: trimmedBio,
          profileFlag: false,
          profileBadge: false,
          profileScore: true,
          profileVotes: false,
          profileScoreValue: 0,
          aaName: '',
          userReportCounter: 0,
          blockList: [],
          gMessageTime: 0,
          nMessageTime: 0,
          gPollTime: 0,
          nPollTime: 0,
          admin: false,
          photoOne: '',
          photoTwo: '',
          pendingDate: '',
          fcmTopic: 'gm',
          fcmToken: fcmToken,
          verProcess: false,
          verFailReason: "",
          submissionTime: 0,
          bot: 'none',

          // timeNow.add(Duration(
          //   minutes: 3,
          // )),
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        await FirebaseNotification.subscribeTopic('gm');
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('userPassword', password);
        res = "success";
      } else if (aEmail.isEmpty || username.isEmpty || password.isEmpty) {
        res = "One or more text fields are empty.";
      }
    }
    //IF YOU WANT TO PUT MORE DETAILS IN ERRORS
    on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email address is badly formatted.';
      } else if (err.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account.';
      } else if (err.code == 'weak-password') {
        res = 'Password needs to be at least 6 characters long.';
      }
    } catch (err) {
      // debugPrint('singup error $err');
      res = err.toString();
    }
    return res;
  }

  Future<String> signUpUserGoogle({
    required String aEmail,
    required String password,
    required String username,
    required String? bio,

    // required Uint8List file,
    required Uint8List? profilePicFile,
    required String aaCountry,
    required String pending,
    required String UID,
  }) async {
    String res = "Some error occured";

    var timeNow = await NTP.now();
    String trimmedBio = trimText(text: '');

    final fcmToken = await FirebaseNotification.getToken();

    //add user to our database
    model.User user = model.User(
      username: username,
      usernameLower: username.toLowerCase(),
      UID: UID,
      dateCreated: timeNow,
      photoUrl: null,
      aEmail: aEmail,
      aaCountry: aaCountry,
      pending: pending,
      bio: trimmedBio,
      profileFlag: false,
      profileBadge: false,
      profileScore: true,
      profileVotes: false,
      profileScoreValue: 0,
      aaName: '',
      userReportCounter: 0,
      blockList: [],
      gMessageTime: 0,
      nMessageTime: 0,
      gPollTime: 0,
      nPollTime: 0,
      admin: false,
      photoOne: '',
      photoTwo: '',
      pendingDate: '',
      fcmTopic: 'gm',
      fcmToken: fcmToken,
      verProcess: false,
      verFailReason: "",
      submissionTime: 0,
      bot: 'none',

      // timeNow.add(Duration(
      //   minutes: 3,
      // )),
    );

    await _firestore.collection('users').doc(UID).set(
          user.toJson(),
        );
    await FirebaseNotification.subscribeTopic('gm');

    res = "success";

    //IF YOU WANT TO PUT MORE DETAILS IN ERRORS

    return res;
  }

  //logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred.";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('userPassword', password);
        res = "success";
      } else if (email.isEmpty || password.isEmpty) {
        res = "One or more text fields are empty.";
      }
      // else if (email.isEmpty) {
      //   res = "Username/email text field cannot be empty.";
      // } else if (password.isEmpty) {
      //   res = "Password text field cannot be empty.";
      // }
    }

    //OTHER DETAILED ERRORS
    on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        res = "Too many login attempts, please try again later.";
      } else if (e.code == 'user-disabled') {
        res =
            "This account has been disabled. If you believe this was a mistake, please contact us at: contact@fairtalk.net";
      } else if (e.code == 'user-not-found') {
        res = "No registered user found under these credentials.";
        // } else if (e.code == 'invalid-email') {
        //   res = "No registered user found under this email address.";
      } else if (e.code == 'invalid-email' && !email.contains('@')) {
        res = "No registered user found under these credentials.";
      } else if (e.code == 'wrong-password') {
        res = "Wrong password!";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  waitTimer({required int time, required String type}) async {
    try {
      User currentUser = _auth.currentUser!;

      // currentUser.uid == 'CyTDtKzwOabJ3LmaTzNCOjrkBp53' ||
      //         currentUser.uid == 'FqS7wZBAwtepk63ebd5ImJ1Xwa82'
      //     ? null
      //     :
      type == 'gMessage'
          ? await _firestore.collection('users').doc(currentUser.uid).update(
              {'gMessageTime': time},
            )
          : type == 'nMessage'
              ? await _firestore
                  .collection('users')
                  .doc(currentUser.uid)
                  .update({'nMessageTime': time})
              : type == 'gPoll'
                  ? await _firestore
                      .collection('users')
                      .doc(currentUser.uid)
                      .update({'gPollTime': time})
                  : type == 'nPoll'
                      ? await _firestore
                          .collection('users')
                          .doc(currentUser.uid)
                          .update({'nPollTime': time})
                      : null;
    } catch (err) {
      err.toString();
    }
  }

  waitSubmission({required int time}) async {
    try {
      User currentUser = _auth.currentUser!;

      await _firestore.collection('users').doc(currentUser.uid).update(
        {'submissionTime': time},
      );
    } catch (err) {
      err.toString();
    }
  }

  // commentWaitTimer() async {
  //   try {
  //     User currentUser = _auth.currentUser!;
  //     var timeNow = dateEST;

  //     await _firestore.collection('users').doc(currentUser.uid).update(
  //       {
  //         'timerCommentEnd': timeNow.add(const Duration(
  //           seconds: 120,
  //         )),
  //       },
  //     );
  //   } catch (err) {
  //     err.toString();
  //   }
  // }

  Future<void> changeUsername({
    required String username,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {
          'username': username,
          'usernameLower': username.toLowerCase(),
        },
      );
    } catch (err) {
      err.toString();
    }
  }

  Future<String> changeEmail({
    required String email,
  }) async {
    String res = "Some error occurred.";
    try {
      User currentUser = _auth.currentUser!;
      await currentUser.updateEmail(email);
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'aEmail': email},
      );
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "Please enter a valid email address.";
      } else if (e.code == 'email-already-in-use') {
        res = "This email is already in use.";
      }
    } catch (e) {
      // print(
    }
    return res;
  }

  // Future<String> changeBio({
  //   required String bio,
  // }) async {
  //   String res = "Some error occurred.";
  //   try {
  //     User currentUser = _auth.currentUser!;
  //     await _firestore.collection('users').doc(currentUser.uid).update(
  //       {'bio': bio},
  //     );
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<void> changeBio({
    required String bio,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'bio': bio},
      );
    } catch (err) {
      err.toString();
    }
  }

  changeProfileFlag({
    required bool profileFlag,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'profileFlag': profileFlag},
      );
    } catch (err) {
      err.toString();
    }
  }

  changeProfileBadge({
    required bool profileBadge,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'profileBadge': profileBadge},
      );
    } catch (err) {
      err.toString();
    }
  }

  changeProfileScore({
    required bool profileScore,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'profileScore': profileScore},
      );
    } catch (err) {
      err.toString();
    }
  }

  changeProfileVotes({
    required bool profileVotes,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'profileVotes': profileVotes},
      );
    } catch (err) {
      err.toString();
    }
  }

  changeIsPending({
    required String pending,
  }) async {
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'pending': pending},
      );
    } catch (err) {
      err.toString();
    }
  }

  Future<String> changeProfilePic({
    required String? profilePhotoUrl,
  }) async {
    String res = "Some error occurred.";
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {'photoUrl': profilePhotoUrl},
      );

      res = "success";
    } catch (e) {
      // print(
      //   e.toString(),
      // );
    }
    return res;
  }

  Future<String> verificationAccept({
    required String name,
    required String country,
    required String uid,
  }) async {
    String res = "Some error occurred.";
    try {
      await _firestore.collection('users').doc(uid).update(
        {
          'aaName': name,
          'aaCountry': country,
          'pending': 'false',
          'verProcess': true,
        },
      );
      res = "success";
    } catch (err) {
      err.toString();
    }
    return res;
  }

  Future<String> verificationDeny({
    required String uid,
    required String type,
  }) async {
    String res = "Some error occurred.";
    try {
      await _firestore.collection('users').doc(uid).update(
        {
          'pending': "false",
          'verFailReason': type,
          'verProcess': true,
        },
      );
      res = "success";
    } catch (err) {
      err.toString();
    }
    return res;
  }

  verificationSuccess() async {
    String res = "Some error occurred.";
    try {
      User currentUser = _auth.currentUser!;

      await _firestore.collection('users').doc(currentUser.uid).update(
        {
          'verProcess': false,
          // 'pending': "false",
          'profileBadge': true,
        },
      );
      res = "success";
    } catch (e) {
      // print(
    }
    return res;
  }

  verificationFailed() async {
    String res = "Some error occurred.";
    try {
      User currentUser = _auth.currentUser!;

      await _firestore.collection('users').doc(currentUser.uid).update(
        {
          'verProcess': false,
          // 'pending': "false",
        },
      );
      res = "success";
    } catch (e) {
      // print(
    }
    return res;
  }

  Future<String> adminUserChanges({
    required String uid,
    required String type,
    required value,
  }) async {
    String res = "Some error occurred.";
    try {
      await _firestore.collection('users').doc(uid).update(type == 'username'
          ? {
              'username': value,
              'usernameLower': value.toLowerCase(),
            }
          : type == 'email'
              ? {
                  'aEmail': value,
                }
              : type == 'country'
                  ? {
                      'aaCountry': value,
                    }
                  : type == 'pending'
                      ? {
                          'pending': value,
                        }
                      : type == 'photoUrl'
                          ? {
                              'photoUrl': value,
                            }
                          : type == 'reportCounter'
                              ? {
                                  'userReportCounter': value,
                                }
                              : type == 'admin'
                                  ? {
                                      'admin': value,
                                    }
                                  : {});
      type == 'photoUrl' ? await deleteImageToStorage(uid) : null;
      res = "success";
    } catch (err) {
      err.toString();
    }
    return res;
  }

  // Future<void> blockUser(
  //   String currentUID,
  //   String uid,
  // ) async {
  //   try {
  //     // if (blockedList.contains(uid)) {
  //     //   await _firestore.collection('users').doc(uid).update({
  //     //     'blockedList': FieldValue.arrayRemove([uid]),
  //     //   });
  //     // } else {
  //     await _firestore.collection('users').doc(currentUID).update({
  //       'blockedList': FieldValue.arrayUnion([uid]),
  //     });
  //     // }
  //   } catch (e) {
  //     print(
  //       e.toString(),
  //     );
  //   }
  // }

  Future<String> addEmailAttachmentPhotos({
    required String photoOne,
    required String photoTwo,
  }) async {
    String res = "Some error occurred.";
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {
          // 'verificationPhotos': {
          //   'photoOne': photoOne,
          //   'photoTwo': photoTwo,
          // }

          'photoOne': photoOne,
          'photoTwo': photoTwo,
        },
      );

      res = "success";
    } catch (e) {
      // print(
    }
    return res;
  }

  Future<String> addPendingDate({
    required pendingDate,
  }) async {
    String res = "Some error occurred.";
    try {
      User currentUser = _auth.currentUser!;
      await _firestore.collection('users').doc(currentUser.uid).update(
        {
          'pendingDate': pendingDate,
        },
      );

      res = "success";
    } catch (e) {
      // print(
    }
    return res;
  }

  Future<void> signOut() async {
    final userProvider =
        Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false);
    if (userProvider.getUser != null) {
      FirebaseNotification.unSubscribeTopic(
          userProvider.getUser!.fcmTopic ?? '');
      debugPrint("unsubscribe ${userProvider.getUser!.fcmTopic}");
      // FirebaseFirestore.instance
      //     .collection(FirestoreValues.userCollection)
      //     .doc(userProvider.getUser!.UID)
      //     .update({'fcmTopic': ''});
    }
    await _auth.signOut();
  }

  Future<String> deleteUser(
      {required BuildContext context, required String uid}) async {
    String res = "Some error occurred.";
    final user = _auth.currentUser;
    String? emailAddress = user?.email;
    try {
      final user = _auth.currentUser;

      if (user != null) {
        await deletePostsAndPolls(uid: uid, context: context);
        await deleteEmailAttachmentPhotos(uid);
        await deleteImageToStorage(uid);
        await deletePostsImageFromStorage(uid);
        await deleteUserDoc(uid);
        await user.delete();
        await AuthMethods().signOut();
        Provider.of<UserProvider>(context, listen: false).logoutUser();
        Future.delayed(const Duration(milliseconds: 150), () {
          goToLogin(context);
          showSnackBar('Account Deleted.', context);
        });
      }
      res = "success";
    } catch (err, step) {
      debugPrint('======== ${err.toString()} ========');
      debugPrint('======== $step ========');
      await reauthForDelete(emailAddress!, user!, context);
      // print('===Error fixed ===');
    }
    return res;
  }

  reauthForDelete(String emailAddress, User user, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? password = preferences.getString('userPassword');
    UserCredential? result = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: emailAddress, password: password!));
    result.user?.delete();

    await AuthMethods().signOut();
    Provider.of<UserProvider>(context, listen: false).logoutUser();
    Future.delayed(const Duration(milliseconds: 150), () {
      goToLogin(context);
      showSnackBar('Account Deleted.', context);
    });
  }

  deleteImageToStorage(String uid) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child("profilePics")
          .child(uid)
          .delete();
    } catch (e) {
      // print("No User Image Found : $e");
    }
  }

  deletePostsImageFromStorage(String uid) async {
    try {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child("posts").child(uid);

      storageRef.listAll().then((result) {
        for (var element in result.items) {
          element.delete();
        }

        //  result.items.forEach((element) {
        //   element.delete();
        // });
      });
    } catch (e, st) {
      // print("Error is $e and steps are $st");
    }
  }

  deleteEmailAttachmentPhotos(String uid) async {
    try {
      final Reference storageRef1 = FirebaseStorage.instance
          .ref()
          .child("email_attachment_photos")
          .child(uid);

      storageRef1.listAll().then((result1) {
        for (var element1 in result1.items) {
          element1.delete();
        }
      });
    } catch (e, st) {
      // print("Error is $e Steps are $st");
    }
  }

  deleteUserDoc(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      // print("Error While Deleting User Collection ::: $e");
    }
  }

  deletePostsAndPolls(
      {required String uid, required BuildContext context}) async {
    try {
      model.User? user =
          Provider.of<UserProvider>(context, listen: false).getUser;

      // delete polls
      QuerySnapshot<Map<String, dynamic>> pollsQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('polls')
              .where('UID', isEqualTo: uid)
              .get();
      for (var element in pollsQuerySnapshot.docs) {
        await element.reference.delete();
      }

      // delete posts
      QuerySnapshot<Map<String, dynamic>> postsQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('UID', isEqualTo: uid)
              .get();
      for (var element in postsQuerySnapshot.docs) {
        await element.reference.delete();
      }

      // delete comments
      QuerySnapshot<Map<String, dynamic>> commentsQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('comments')
              .where('UID', isEqualTo: uid)
              .get();
      for (var element in commentsQuerySnapshot.docs) {
        await element.reference.delete();
      }

      // delete replies
      QuerySnapshot<Map<String, dynamic>> repliesQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('replies')
              .where('UID', isEqualTo: uid)
              .get();
      for (var element in repliesQuerySnapshot.docs) {
        await element.reference.delete();
      }

      // delete mostLiked
      QuerySnapshot<Map<String, dynamic>> mostLikedQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('mostLiked')
              .where('UID', isEqualTo: uid)
              .get();
      for (var element in mostLikedQuerySnapshot.docs) {
        await element.reference.delete();
      }

      // delete mostLikedPolls
      QuerySnapshot<Map<String, dynamic>> mostLikedPollsQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('mostLikedPolls')
              .where('UID', isEqualTo: uid)
              .get();
      for (var element in mostLikedPollsQuerySnapshot.docs) {
        await element.reference.delete();
      }

      if (user?.aaCountry.isNotEmpty ?? false) {
        // delete mostLikedByCountry
        QuerySnapshot<Map<String, dynamic>> mostLikedByCountryQuerySnapshot =
            await FirebaseFirestore.instance
                .collection('mostLikedByCountry')
                .doc(user?.aaCountry)
                .collection('mostLiked')
                .where('UID', isEqualTo: uid)
                .get();
        for (var element in mostLikedByCountryQuerySnapshot.docs) {
          await element.reference.delete();
        }

        // delete mostLikedByCountryPolls
        QuerySnapshot<Map<String, dynamic>>
            mostLikedByCountryPollsQuerySnapshot = await FirebaseFirestore
                .instance
                .collection('mostLikedByCountryPolls')
                .doc(user?.aaCountry)
                .collection('mostLiked')
                .where('UID', isEqualTo: uid)
                .get();
        for (var element in mostLikedByCountryPollsQuerySnapshot.docs) {
          await element.reference.delete();
        }
      }
    } catch (e, st) {
      // print("Error is $e and steps are $st");
    }
  }
}
