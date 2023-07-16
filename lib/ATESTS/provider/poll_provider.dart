import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../utils/global_variables.dart';
import 'duration_provider.dart';
import 'filter_provider.dart';

class PollsProvider extends ChangeNotifier {
  bool _loading = false;
  bool _scrollLoading = false;
  List<Poll> _pollsList = [];
  List<Poll> _userPollsList = [];
  bool _pollPageLoading = false;
  var db = FirebaseFirestore.instance;
  final int _pageSize = 6;
  bool _last = false;
  bool _userPollsLast = false;
  int _count = 0;

  bool _isButtonVisible = false;

  QuerySnapshot<Map<String, dynamic>>? _pollsSnapshot;
  QuerySnapshot<Map<String, dynamic>>? _userPollSnapshot;

  StreamController<Poll> updatingStreamPoll = StreamController.broadcast();

  final ScrollController _pollScrollController = ScrollController();

  startScrollListener() {
    _pollScrollController.addListener(pollNextScroll);
  }

  stopListener() {
    _pollScrollController.removeListener(() {});
  }

  setButtonVisibility() async {
    await Future.delayed(const Duration(seconds: 1));
    _isButtonVisible = true;
    notifyListeners();
  }

  updatePollRealTime(Poll poll) async {
    await Future.delayed(Duration.zero);
    try {
      bool? elementFoundInPollList =
          elementFoundInList(_pollsList, poll.pollId);
      bool? elementFoundInUserPollList =
          elementFoundInList(_userPollsList, poll.pollId);

      // debugPrint("elementFoundInPollList $elementFoundInPollList");
      // debugPrint("elementFoundInUserPollList $elementFoundInUserPollList");

      if (elementFoundInPollList) {
        _pollsList[_pollsList.indexOf(_pollsList
            .firstWhere((element) => poll.pollId == element.pollId))] = poll;
      }
      if (elementFoundInUserPollList) {
        _userPollsList[_userPollsList.indexOf(_userPollsList
            .firstWhere((element) => poll.pollId == element.pollId))] = poll;
      }
      notifyListeners();
    } catch (e) {
      // debugPrint("Got Error While Getting Element From List $st");
    }
  }

  pollNextScroll() async {
    final filterProvider = Provider.of<FilterProvider>(
        navigatorKey.currentContext!,
        listen: false);

    if (_pollScrollController.position.extentAfter < 1) {
      getNextPolls(
          filterProvider.twoValue,
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.durationInDay,
          filterProvider.oneValue);
    }
  }

  bool elementFoundInList(List<Poll> list, String pollId) {
    bool foundInList = false;
    for (var element in list) {
      if (element.pollId == pollId) {
        foundInList = true;
      }
    }
    return foundInList;
  }

  getPolls(String twoValue, String global, String countryCode,
      int durationInDay, String oneValue) async {
    try {
      _isButtonVisible = false;
      // debugPrint('getPolls');
      if (_loading == false) {
        _loading = true;
        notifyListeners();
        // durationInDay = await DurationProvider.getDurationInDays();
        var query = (twoValue == "All Days"

            // "All Days"
            ? (global == "true"
                    ? FirebaseFirestore.instance.collection('polls')
                    : FirebaseFirestore.instance
                        .collection('polls')
                        .where("country", isEqualTo: countryCode))
                .where("global", isEqualTo: global)
                .where('reportRemoved', isEqualTo: false)
                .where('time', whereIn: [
                durationInDay - 0,
                durationInDay - 1,
                durationInDay - 2,
                durationInDay - 3,
                durationInDay - 4,
                durationInDay - 5,
                durationInDay - 6,
              ]).orderBy(
                    oneValue == "Highest Score"
                        ? "totalVotes"
                        : "datePublished",
                    descending: true)
            :
            // NOT "All Days"
            (global == "true"
                    ? FirebaseFirestore.instance.collection('polls')
                    : FirebaseFirestore.instance
                        .collection('polls')
                        .where("country", isEqualTo: countryCode))
                .where("global", isEqualTo: global)
                .where('reportRemoved', isEqualTo: false)
                .where('time',
                    // isEqualTo: widget.durationInDay
                    isEqualTo: twoValue == '≤ 1 Day'
                        ? durationInDay - 6
                        : twoValue == '≤ 2 Days'
                            ? durationInDay - 5
                            : twoValue == '≤ 3 Days'
                                ? durationInDay - 4
                                : twoValue == '≤ 4 Days'
                                    ? durationInDay - 3
                                    : twoValue == '≤ 5 Days'
                                        ? durationInDay - 2
                                        : twoValue == '≤ 6 Days'
                                            ? durationInDay - 1
                                            : durationInDay)
                .orderBy(
                    oneValue == "Highest Score"
                        ? "totalVotes"
                        : "datePublished",
                    descending: true));
        var snap = await query.count().get();
        // debugPrint('count is ${snap.count}');

        notifyListeners();
        Future.delayed(Duration.zero);
        _pollsSnapshot = await query.limit(_pageSize).get();
        _pollsList =
            _pollsSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList();

        _count = 1;
        _last = false;
        if (_pollsList.length < _pageSize || _pageSize == snap.count) {
          _last = true;
        }
      }
    } catch (e) {
      // debugPrint("getPolls error $e $st");
    } finally {
      _loading = false;
      await Future.delayed(Duration.zero);
      notifyListeners();
      setButtonVisibility();
    }
  }

  updatePoll(String pollId, String uid, int optionIndex) {
    var poll;
    db.collection("polls").doc(pollId).get().then((value) {
      poll = Poll.fromMap(value.data()!);
      for (var i = 0; i < _pollsList.length; i++) {
        if (_pollsList[i].pollId == pollId) {
          _pollsList[i] = poll;
        }
      }

      for (var i = 0; i < _userPollsList.length; i++) {
        if (_userPollsList[i].pollId == pollId) {
          _userPollsList[i] = poll;
        }
      }

      notifyListeners();
    });

    if (_pollsList.isNotEmpty) {
      _updatePollInList(pollId, uid, optionIndex, _pollsList);
    }
    if (_userPollsList.isNotEmpty) {
      _updatePollInList(pollId, uid, optionIndex, _userPollsList);
    }
    notifyListeners();
  }

  _updatePollInList(
      String pollId, String uid, int optionIndex, List<Poll> pollList) {
    if (pollList.isNotEmpty) {
      for (var element in pollList) {
        if (element.pollId == pollId) {
          element.votesUIDs.add(uid);
          element.totalVotes++;
          element.setVote(optionIndex, uid);
        }
      }
    }
  }

  getNextPolls(String twoValue, String global, String countryCode,
      int durationInDay, String oneValue) async {
    try {
      if (_last) {
        return;
      }

      // print('INSIDE, getNextPolls, _pageSize: $_pageSize');
      // debugPrint(
      //     'one value at pagination $oneValue $twoValue $durationInDay $countryCode');
      if (_pollsSnapshot != null &&
          _pollsSnapshot!.docs.isNotEmpty &&
          _loading != true &&
          _pollPageLoading != true) {
        if (oneValue == 'Highest Score') {
          _loading = true;
        } else {
          _pollPageLoading = true;
          _loading = true;
        }
        notifyListeners();

        // debugPrint("_pollsSnapshot!.docs.last: ${_pollsSnapshot!.docs.last.data()}");
        // durationInDay = await DurationProvider.getDurationInDays();
        await Future.delayed(Duration.zero);
        _isButtonVisible = false;
        var query = (twoValue == "All Days"
                ? (global == "true"
                        ? FirebaseFirestore.instance.collection('polls')
                        : FirebaseFirestore.instance
                            .collection('polls')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time', whereIn: [
                    durationInDay - 0,
                    durationInDay - 1,
                    durationInDay - 2,
                    durationInDay - 3,
                    durationInDay - 4,
                    durationInDay - 5,
                    durationInDay - 6,
                  ]).orderBy(
                        oneValue == "Highest Score"
                            ? "totalVotes"
                            : "datePublished",
                        descending: true)
                : (global == "true"
                        ? FirebaseFirestore.instance.collection('polls')
                        : FirebaseFirestore.instance
                            .collection('polls')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time',
                        isEqualTo: twoValue == '≤ 1 Day'
                            ? durationInDay - 6
                            : twoValue == '≤ 2 Days'
                                ? durationInDay - 5
                                : twoValue == '≤ 3 Days'
                                    ? durationInDay - 4
                                    : twoValue == '≤ 4 Days'
                                        ? durationInDay - 3
                                        : twoValue == '≤ 5 Days'
                                            ? durationInDay - 2
                                            : twoValue == '≤ 6 Days'
                                                ? durationInDay - 1
                                                : durationInDay)
                    .orderBy(
                        oneValue == "Highest Score"
                            ? "totalVotes"
                            : "datePublished",
                        descending: true))
            .startAfterDocument(_pollsSnapshot!.docs.last);

        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();

        if (data.docs.isNotEmpty) {
          _pollsSnapshot = data;
          _count++;
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
            // debugPrint('last is true');
          }
        } else {
          _last = false;
        }

        if (oneValue == 'Highest Score') {
          _pollsList =
              _pollsSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList();
        } else {
          _pollsList =
              _pollsSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList();
          // _posts =  _postsSnapshot!.docs.map((e) => Post.fromMap(e.data())).toList();
          // _pollsList.addAll(
          //     _pollsSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList());
        }

        // _pollsList.addAll(
        //     _pollsSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList());
      }
    } catch (e) {
      // debugPrint('getNextMostLikedPosts error $e $st');
    } finally {
      _pollPageLoading = false;
      _loading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getPreviousPolls(String twoValue, String global, String countryCode,
      int durationInDay, String oneValue) async {
    try {
      if (_pollsSnapshot != null
          // && oneValue == 'Highest Score'
          ) {
        _loading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        _isButtonVisible = false;
        // durationInDay = await DurationProvider.getDurationInDays();
        var data = await (twoValue == "All Days"
                ? (global == "true"
                        ? FirebaseFirestore.instance.collection('polls')
                        : FirebaseFirestore.instance
                            .collection('polls')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time', whereIn: [
                    durationInDay - 0,
                    durationInDay - 1,
                    durationInDay - 2,
                    durationInDay - 3,
                    durationInDay - 4,
                    durationInDay - 5,
                    durationInDay - 6,
                    // durationInDay - 7,
                  ])
                    // .where('time', isGreaterThanOrEqualTo: durationInDay - 6)
                    // .orderBy('time', descending: true)
                    .orderBy(
                        oneValue == "Highest Score"
                            ? "totalVotes"
                            : "datePublished",
                        descending: true)
                : (global == "true"
                        ? FirebaseFirestore.instance.collection('polls')
                        : FirebaseFirestore.instance
                            .collection('polls')
                            .where("country", isEqualTo: countryCode))
                    .where("global", isEqualTo: global)
                    .where('reportRemoved', isEqualTo: false)
                    .where('time',
                        // isEqualTo: widget.durationInDay
                        isEqualTo: twoValue == '≤ 1 Day'
                            ? durationInDay - 6
                            : twoValue == '≤ 2 Days'
                                ? durationInDay - 5
                                : twoValue == '≤ 3 Days'
                                    ? durationInDay - 4
                                    : twoValue == '≤ 4 Days'
                                        ? durationInDay - 3
                                        : twoValue == '≤ 5 Days'
                                            ? durationInDay - 2
                                            : twoValue == '≤ 6 Days'
                                                ? durationInDay - 1
                                                : durationInDay)
                    .orderBy(
                        oneValue == "Highest Score"
                            ? "totalVotes"
                            : "datePublished",
                        descending: true))
            .endBeforeDocument(_pollsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();

        if (data.docs.isNotEmpty) {
          _pollsSnapshot = data;
          _count--;

          _last = false;
        }

        _pollsList = data.docs.map((e) => Poll.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostLikedPosts error $e $st');
    } finally {
      _pollPageLoading = false;
      _loading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getUserPolls(String? userId) async {
    try {
      // debugPrint('called');
      if (_loading == false) {
        _loading = true;
        var query = (FirebaseFirestore.instance
            .collection('polls')
            .where('reportRemoved', isEqualTo: false)
            .where('UID', isEqualTo: userId ?? '')
            .orderBy('datePublished', descending: true));

        var snap = await query.count().get();
        // debugPrint('count is ${snap.count}');

        notifyListeners();
        Future.delayed(Duration.zero);
        _userPollSnapshot = await query.limit(_pageSize).get();
        _userPollsList =
            _userPollSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList();
        // debugPrint("User polls length ::: ${_userPollsList.length}");
        _userPollsLast = false;
        if (_userPollsList.length < _pageSize || _pageSize == snap.count) {
          _userPollsLast = true;
        }
      }
    } catch (e) {
      // debugPrint("");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  getNextUserPolls(String? userId) async {
    try {
      // debugPrint('called');
      if (_scrollLoading == false) {
        _scrollLoading = true;
        var query = (FirebaseFirestore.instance
            .collection('polls')
            .where('reportRemoved', isEqualTo: false)
            .where('UID', isEqualTo: userId ?? '')
            .orderBy('datePublished', descending: true));

        var snap = await query.count().get();
        // debugPrint('count is ${snap.count}');

        notifyListeners();
        Future.delayed(Duration.zero);
        _userPollSnapshot = await query
            .startAfterDocument(_userPollSnapshot!.docs.last)
            .limit(_pageSize)
            .get();
        _userPollsList.addAll(_userPollSnapshot!.docs
            .map((e) => Poll.fromMap(e.data()))
            .toList());
        // debugPrint("User polls length ::: ${_userPollsList.length}");
        _count = 1;
        _userPollsLast = false;
        // debugPrint(
        //     "_userPollsList.length == snap.count ===> ${_userPollsList.length == snap.count}");
        // debugPrint("_pageSize ===> $_pageSize");
        if (_userPollsList.length < _pageSize ||
            _userPollsList.length == snap.count) {
          _userPollsLast = true;
        }
      }
    } catch (e) {
      // debugPrint("");
    } finally {
      _scrollLoading = false;
      notifyListeners();
    }
  }

  getOrganicPolls(int durationInDay) async {
    try {
      await Future.delayed(Duration.zero);
      _isButtonVisible = false;
      _loading = true;
      notifyListeners();
      var query = (FirebaseFirestore.instance
          .collection('polls')
          .where('reportRemoved', isEqualTo: false)
          .where('bot', isEqualTo: false)
          .where('time', whereIn: [
        durationInDay - 0,
        durationInDay - 1,
        durationInDay - 2,
        durationInDay - 3,
        durationInDay - 4,
        durationInDay - 5,
        durationInDay - 6,
      ]).orderBy('datePublished', descending: true));
      var snap = await query.count().get();

      notifyListeners();
      Future.delayed(Duration.zero);
      _pollsSnapshot = await query.limit(_pageSize).get();
      _pollsList = _pollsSnapshot!.docs.map((e) => Poll.fromSnap(e)).toList();

      _count = 1;
      _last = false;
      if (_pollsList.length < _pageSize || _pageSize == snap.count) {
        _last = true;
      }
    } catch (e) {
      // debugPrint('PostProvider getPosts error $e $st');
    } finally {
      _loading = false;
      notifyListeners();
      setButtonVisibility();
    }
  }

  getNextOrganicPolls(int durationInDay) async {
    try {
      if (_pollsSnapshot != null) {
        _loading = true;
        notifyListeners();
        await Future.delayed(Duration.zero);
        var data = await (FirebaseFirestore.instance
                .collection('polls')
                .where('reportRemoved', isEqualTo: false)
                .where('bot', isEqualTo: false)
                .where('time', whereIn: [
          durationInDay - 0,
          durationInDay - 1,
          durationInDay - 2,
          durationInDay - 3,
          durationInDay - 4,
          durationInDay - 5,
          durationInDay - 6,
        ]).orderBy('datePublished', descending: true))
            .endBeforeDocument(_pollsSnapshot!.docs.first)
            .limitToLast(_pageSize)
            .get();
        if (data.docs.isNotEmpty) {
          _pollsSnapshot = data;
          _count--;
          _last = false;
        }
        _pollsList =
            _pollsSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList();
      }
    } catch (e) {
      //
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  getPreviousOrganicPolls(int durationInDay) async {
    try {
      if (_last) {
        return;
      }

      if (_pollsSnapshot != null &&
          _pollsSnapshot!.docs.isNotEmpty &&
          _loading != true &&
          _pollPageLoading != true) {
        {
          _pollPageLoading = true;
          _loading = true;
        }
        notifyListeners();
        await Future.delayed(Duration.zero);
        var query = (FirebaseFirestore.instance
                .collection('polls')
                .where('reportRemoved', isEqualTo: false)
                .where('bot', isEqualTo: false)
                .where('time', whereIn: [
          durationInDay - 0,
          durationInDay - 1,
          durationInDay - 2,
          durationInDay - 3,
          durationInDay - 4,
          durationInDay - 5,
          durationInDay - 6,
        ]).orderBy('datePublished', descending: true))
            .startAfterDocument(_pollsSnapshot!.docs.last);
        var snap = await query.count().get();
        var data = await query.limit(_pageSize).get();
        if (data.docs.isNotEmpty) {
          _pollsSnapshot = data;
          _count++;
          if (data.docs.length < _pageSize || _pageSize == snap.count) {
            _last = true;
          }
        } else {
          _last = false;
        }
        _pollsList =
            _pollsSnapshot!.docs.map((e) => Poll.fromMap(e.data())).toList();
      }
    } catch (e) {
      // debugPrint('getNextMostPosts error $e $st');
    } finally {
      _pollPageLoading = false;
      _loading = false;
      notifyListeners();
    }
  }

  deleteUserPoll(String pollId) {
    // debugPrint("Post Id ::: $pollId");
    try {
      _userPollsList.removeWhere((element) => element.pollId == pollId);
      _pollsList.removeWhere((element) => element.pollId == pollId);
      notifyListeners();
    } catch (e) {
      // debugPrint("Got Error While Deleting Poll");
    }
  }

  @override
  void dispose() {
    _pollScrollController.dispose();
    stopListener();
    super.dispose();
  }

  bool get loading => _loading;

  bool get scrollLoading => _scrollLoading;

  List<Poll> get polls => _pollsList;

  List<Poll> get userPolls => _userPollsList;

  int get count => _count;

  bool get last => _last;

  bool get userPollsLast => _userPollsLast;

  bool get pollsPageLoading => _pollPageLoading;

  int get pageSize => _pageSize;

  bool get isButtonVisible => _isButtonVisible;

  ScrollController get pollScrollController => _pollScrollController;
}
