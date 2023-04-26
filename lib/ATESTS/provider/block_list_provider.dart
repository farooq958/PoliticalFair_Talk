import 'package:aft/ATESTS/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BlockListProvider extends ChangeNotifier {
  bool _loading = false;
  List<User> _userList = [];
  bool _pageLoading = false;
  var db = FirebaseFirestore.instance;
  final int _pageSize = 20;

  QuerySnapshot<Map<String, dynamic>>? _userSnapshot;

  getUserBlockList(uid) async {
    try {
      _loading = true;
      notifyListeners();
      await Future.delayed(Duration.zero);
      _userSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('blockList')
          .limit(_pageSize)
          .get();
      if (_userSnapshot != null) {
        _userList =
            _userSnapshot!.docs.map((e) => User.fromMap(e.data())).toList();
      }
    } catch (e) {
      //
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  unblockUser(String? uid) {
    try {
      _userList.removeWhere((element) => element.UID == uid);
      if (_userSnapshot != null) {
        _userSnapshot!.docs.removeWhere((element) => element['UID'] == uid);
        notifyListeners();
      }
    } catch (e) {
      //
    }
  }

  getNextBlockedUsers(uid) async {
    try {
      notifyListeners();
      await Future.delayed(Duration.zero);
      if (_userSnapshot != null && _pageLoading == false) {
        _pageLoading = true;

        _userSnapshot = await db
            .collection('users')
            .doc(uid)
            .collection('blockList')
            .startAfterDocument(_userSnapshot!.docs.last)
            .limit(_pageSize)
            .get();

        _userList.addAll(
            _userSnapshot!.docs.map((e) => User.fromMap(e.data())).toList());
      }
    } catch (e) {
      //
    } finally {
      _pageLoading = false;
      notifyListeners();
    }
  }

  bool get loading => _loading;

  List<User> get blockedUsers => _userList;

  bool get pollsPageLoading => _pageLoading;
}


// import 'package:aft/ATESTS/models/user.dart';
// import 'package:aft/ATESTS/provider/user_provider.dart';
// import 'package:aft/ATESTS/utils/global_variables.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BlockListProvider extends ChangeNotifier {
//   bool _loading = false;
//   List<User> _userList = [];
//   bool _pageLoading = false;
//   var db = FirebaseFirestore.instance;
//   final int _pageSize = 6;
//   int _count = 0;
//   bool _last = false;

//   QuerySnapshot<Map<String, dynamic>>? _userSnapshot;
//   final ScrollController _scrollController = ScrollController();

//   startScrollerListener() {
//     _scrollController.addListener(blockUsersNextScroll);
//   }

//   stopScrollerListener() {
//     _scrollController.removeListener(() {});
//   }

//   blockUsersNextScroll() {
//     final userProvider =
//         Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false);
//     if (_scrollController.position.extentAfter < 1) {
//       if (userProvider.getUser != null) {
//         getNextBlockedUsers(userProvider.getUser!.UID);
//       }
//     }
//   }

//   getUserBlockList(uid) async {
//     try {
//       _loading = true;
//       notifyListeners();
//       await Future.delayed(Duration.zero);
//       _userSnapshot = await db
//           .collection('users')
//           .doc(uid)
//           .collection('blockList')
//           .limit(_pageSize)
//           .get();
//       if (_userSnapshot != null) {
//         _userList =
//             _userSnapshot!.docs.map((e) => User.fromMap(e.data())).toList();
//         _count = 1;
//         _last = false;
//         if (_userList.length < _pageSize) {
//           _last = true;
//         }
//       }
//     } catch (e, st) {
//       debugPrint('getUserBlockList error $e $st');
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   unblockUser(String? uid) {
//     try {
//       _userList.removeWhere((element) => element.UID == uid);
//       if (_userSnapshot != null) {
//         _userSnapshot!.docs.removeWhere((element) => element['UID'] == uid);
//         notifyListeners();
//       }
//     } catch (e, st) {
//       debugPrint('unblockUser error $e $st');
//     }
//   }

//   getNextBlockedUsers(uid) async {
//     try {
//       if (_last) {
//         return;
//       }
//       if (_userSnapshot != null &&
//           _userSnapshot!.docs.isNotEmpty &&
//           _loading != true) {
//         _loading = true;

//         notifyListeners();
//         await Future.delayed(Duration.zero);
//         if (_userSnapshot != null && _pageLoading == false) {
//           _pageLoading = true;

//           var data = await db
//               .collection('users')
//               .doc(uid)
//               .collection('blockList')
//               .startAfterDocument(_userSnapshot!.docs.last)
//               .limit(_pageSize)
//               .get();
//           if (data.docs.isNotEmpty) {
//             _count++;

//             _userList
//                 .addAll(data.docs.map((e) => User.fromMap(e.data())).toList());
//             if (data.docs.length < _pageSize) {
//               _last = true;
//             }
//           }
//         }
//       }
//     } catch (e, st) {
//       debugPrint('getNextBlockUsers error $e $st');
//     } finally {
//       _pageLoading = false;
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   getPreviousBlockedUsers(uid) async {
//     try {
//       if (_userSnapshot != null &&
//           _userSnapshot!.docs.isNotEmpty &&
//           _loading != true) {
//         _loading = true;

//         notifyListeners();
//         await Future.delayed(Duration.zero);
//         if (_userSnapshot != null && _pageLoading == false) {
//           _pageLoading = true;

//           var data = await db
//               .collection('users')
//               .doc(uid)
//               .collection('blockList')
//               .endBeforeDocument(_userSnapshot!.docs.first)
//               .limit(_pageSize)
//               .get();
//           if (data.docs.isNotEmpty) {
//             _count--;

//             _userList = data.docs.map((e) => User.fromMap(e.data())).toList();
//           }
//         }
//       }
//     } catch (e, st) {
//       debugPrint('getPreviousBlockUsers error $e $st');
//     } finally {
//       _pageLoading = false;
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   bool get loading => _loading;

//   List<User> get blockedUsers => _userList;

//   bool get pollsPageLoading => _pageLoading;
//   bool get last => _last;
//   int get count => _count;
//   int get pageSize => _pageSize;
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     stopScrollerListener();
//     // TODO: implement dispose
//     super.dispose();
//   }
// }
