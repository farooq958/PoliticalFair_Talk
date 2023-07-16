import 'dart:async';
// import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  final String pollId;
  // ignore: non_constant_identifier_names
  final String UID;
  final String bUsername;
  final String bProfImage;
  final String country;
  final String global;
  final String aPollTitle;

  final String bOption1;
  final String bOption2;
  final String bOption3;
  final String bOption4;
  final String bOption5;
  final String bOption6;
  final String bOption7;
  final String bOption8;
  final String bOption9;
  final String bOption10;
  List<dynamic> votesUIDs;
  List<dynamic> vote1;
  List<dynamic> vote2;
  List<dynamic> vote3;
  List<dynamic> vote4;
  List<dynamic> vote5;
  List<dynamic> vote6;
  List<dynamic> vote7;
  List<dynamic> vote8;
  List<dynamic> vote9;
  List<dynamic> vote10;
  int voteCount1;
  int voteCount2;
  int voteCount3;
  int voteCount4;
  int voteCount5;
  int voteCount6;
  int voteCount7;
  int voteCount8;
  int voteCount9;
  int voteCount10;
  int totalVotes;
  int time;
  int commentCount;

  // List<dynamic> reportUIDs;
  StreamController<Poll>? updatingStreamPoll;
  // ignore: prefer_typing_uninitialized_variables
  // final endDate;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  final datePublishedNTP;
  final int reportCounter;
  bool reportChecked;
  bool reportRemoved;
  bool bot;
  dynamic comments;
  List<String>? tagsLowerCase;

  Poll({
    required this.pollId,
    // ignore: non_constant_identifier_names
    required this.UID,
    required this.bUsername,
    required this.bProfImage,
    required this.country,
    required this.datePublished,
    required this.datePublishedNTP,
    // required this.endDate,
    required this.global,
    required this.aPollTitle,
    required this.bOption1,
    required this.bOption2,
    required this.bOption3,
    required this.bOption4,
    required this.bOption5,
    required this.bOption6,
    required this.bOption7,
    required this.bOption8,
    required this.bOption9,
    required this.bOption10,
    required this.vote1,
    required this.vote2,
    required this.vote3,
    required this.vote4,
    required this.vote5,
    required this.vote6,
    required this.vote7,
    required this.vote8,
    required this.vote9,
    required this.vote10,
    required this.voteCount1,
    required this.voteCount2,
    required this.voteCount3,
    required this.voteCount4,
    required this.voteCount5,
    required this.voteCount6,
    required this.voteCount7,
    required this.voteCount8,
    required this.voteCount9,
    required this.voteCount10,
    required this.totalVotes,
    required this.votesUIDs,
    required this.reportCounter,
    required this.reportChecked,
    required this.reportRemoved,
    required this.time,
    required this.commentCount,
    required this.bot,
    this.updatingStreamPoll,
    // this.tags,
    this.tagsLowerCase,
  });
  // {
  //   // if (updatingStreamPoll != null) {
  //   //   updatingStreamPoll!.stream
  //   //       .where((event) => event.pollId == pollId)
  //   //       .listen((event) {
  //   //     votesUIDs = event.votesUIDs;
  //   //     totalVotes = event.totalVotes;
  //   //
  //   //     vote1 = event.vote1;
  //   //     vote2 = event.vote2;
  //   //     vote3 = event.vote3;
  //   //     vote4 = event.vote4;
  //   //     vote5 = event.vote5;
  //   //     vote6 = event.vote6;
  //   //     vote7 = event.vote7;
  //   //     vote8 = event.vote8;
  //   //     vote9 = event.vote9;
  //   //     vote10 = event.vote10;
  //   //     voteCount1 = event.voteCount1;
  //   //     voteCount2 = event.voteCount2;
  //   //     voteCount3 = event.voteCount3;
  //   //     voteCount4 = event.voteCount4;
  //   //     voteCount5 = event.voteCount5;
  //   //     voteCount6 = event.voteCount6;
  //   //     voteCount7 = event.voteCount7;
  //   //     voteCount8 = event.voteCount8;
  //   //     voteCount9 = event.voteCount9;
  //   //     voteCount10 = event.voteCount10;
  //   //   });
  //   // }
  // }

  Map<String, dynamic> toJson() => {
        "pollId": pollId,
        "UID": UID,
        "bUsername": bUsername,
        "bProfImage": bProfImage,
        "country": country,
        "datePublished": datePublished,
        "datePublishedNTP": datePublishedNTP,
        // "endDate": endDate,
        "global": global,
        "aPollTitle": aPollTitle,
        "bOption1": bOption1,
        "bOption2": bOption2,
        "bOption3": bOption3,
        "bOption4": bOption4,
        "bOption5": bOption5,
        "bOption6": bOption6,
        "bOption7": bOption7,
        "bOption8": bOption8,
        "bOption9": bOption9,
        "bOption10": bOption10,
        "vote1": vote1,
        "vote2": vote2,
        "vote3": vote3,
        "vote4": vote4,
        "vote5": vote5,
        "vote6": vote6,
        "vote7": vote7,
        "vote8": vote8,
        "vote9": vote9,
        "vote10": vote10,
        "voteCount1": voteCount1,
        "voteCount2": voteCount2,
        "voteCount3": voteCount3,
        "voteCount4": voteCount4,
        "voteCount5": voteCount5,
        "voteCount6": voteCount6,
        "voteCount7": voteCount7,
        "voteCount8": voteCount8,
        "voteCount9": voteCount9,
        "voteCount10": voteCount10,
        "totalVotes": totalVotes,
        "votesUIDs": votesUIDs,
        "reportChecked": reportChecked,
        "reportCounter": reportCounter,
        "reportRemoved": reportRemoved,
        "time": time,
        "commentCount": commentCount,
        "bot": bot,
        // "tags": tags,
        "tagsLowerCase": tagsLowerCase
      };

  static Poll fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(snapshot);

    // return Poll(
    //   pollId: snapshot['pollId'] ?? "",
    //   uid: snapshot['uid'] ?? "",
    //   username: snapshot['username'] ?? "",
    //   profImage: snapshot['profImage'] ?? "",
    //   country: snapshot['country'] ?? "",
    //   global: snapshot['global'] ?? "",
    //   pollTitle: snapshot['pollTitle'] ?? "",
    //   option1: snapshot['option1'] ?? "",
    //   option2: snapshot['option2'] ?? "",
    //   option3: snapshot['option3'] ?? "",
    //   option4: snapshot['option4'] ?? "",
    //   option5: snapshot['option5'] ?? "",
    //   option6: snapshot['option6'] ?? "",
    //   option7: snapshot['option7'] ?? "",
    //   option8: snapshot['option8'] ?? "",
    //   option9: snapshot['option9'] ?? "",
    //   option10: snapshot['option10'] ?? "",
    //   vote1: (snapshot['vote1'] ?? []).cast<String>(),
    //   vote2: (snapshot['vote2'] ?? []).cast<String>(),
    //   vote3: (snapshot['vote3'] ?? []).cast<String>(),
    //   vote4: (snapshot['vote4'] ?? []).cast<String>(),
    //   vote5: (snapshot['vote5'] ?? []).cast<String>(),
    //   vote6: (snapshot['vote6'] ?? []).cast<String>(),
    //   vote7: (snapshot['vote7'] ?? []).cast<String>(),
    //   vote8: (snapshot['vote8'] ?? []).cast<String>(),
    //   vote9: (snapshot['vote9'] ?? []).cast<String>(),
    //   vote10: (snapshot['vote10'] ?? []).cast<String>(),
    //   datePublished: snapshot['datePublished'],
    //   endDate: snapshot['endDate'],
    //   totalVotes: snapshot['totalVotes'],
    //   allVotesUIDs: (snapshot['allVotesUIDs'] ?? []).cast<String>(),
    // );
  }

  static Poll fromMap(Map<String, dynamic> snapshot) {
    return Poll(
      pollId: snapshot['pollId'] ?? "",
      UID: snapshot['UID'] ?? "",
      bUsername: snapshot['bUsername'] ?? "",
      bProfImage: snapshot['bProfImage'] ?? "",
      country: snapshot['country'] ?? "",
      global: snapshot['global'] ?? "",
      aPollTitle: snapshot['aPollTitle'] ?? "",
      bOption1: snapshot['bOption1'] ?? "",
      bOption2: snapshot['bOption2'] ?? "",
      bOption3: snapshot['bOption3'] ?? "",
      bOption4: snapshot['bOption4'] ?? "",
      bOption5: snapshot['bOption5'] ?? "",
      bOption6: snapshot['bOption6'] ?? "",
      bOption7: snapshot['bOption7'] ?? "",
      bOption8: snapshot['bOption8'] ?? "",
      bOption9: snapshot['bOption9'] ?? "",
      bOption10: snapshot['bOption10'] ?? "",
      vote1: (snapshot['vote1'] ?? []).cast<String>(),
      vote2: (snapshot['vote2'] ?? []).cast<String>(),
      vote3: (snapshot['vote3'] ?? []).cast<String>(),
      vote4: (snapshot['vote4'] ?? []).cast<String>(),
      vote5: (snapshot['vote5'] ?? []).cast<String>(),
      vote6: (snapshot['vote6'] ?? []).cast<String>(),
      vote7: (snapshot['vote7'] ?? []).cast<String>(),
      vote8: (snapshot['vote8'] ?? []).cast<String>(),
      vote9: (snapshot['vote9'] ?? []).cast<String>(),
      vote10: (snapshot['vote10'] ?? []).cast<String>(),
      datePublished: snapshot['datePublished'],
      datePublishedNTP: snapshot['datePublishedNTP'],
      // endDate: snapshot['endDate'],
      totalVotes: snapshot['totalVotes'],
      voteCount1: snapshot['voteCount1'],
      voteCount2: snapshot['voteCount2'],
      voteCount3: snapshot['voteCount3'],
      voteCount4: snapshot['voteCount4'],
      voteCount5: snapshot['voteCount5'],
      voteCount6: snapshot['voteCount6'],
      voteCount7: snapshot['voteCount7'],
      voteCount8: snapshot['voteCount8'],
      voteCount9: snapshot['voteCount9'],
      voteCount10: snapshot['voteCount10'],
      time: snapshot['time'],
      bot: snapshot['bot'],

      reportCounter: snapshot['reportCounter'],
      commentCount: snapshot['commentCount'],
      reportChecked: snapshot['reportChecked'],
      reportRemoved: snapshot['reportRemoved'] ?? false,
      votesUIDs: (snapshot['votesUIDs'] ?? []).cast<String>(),

      updatingStreamPoll: snapshot['updatingStreamPoll'],
      // tags: (snapshot['tags'] ?? []).cast<String>(),
      tagsLowerCase: (snapshot['tagsLowerCase'] ?? []).cast<String>(),
    );
  }

  setVote(int index, String? uid) {
    switch (index) {
      case 1:
        {
          voteCount1++;
          vote1.add(uid);
          break;
        }
      case 2:
        {
          voteCount2++;
          vote2.add(uid);
          break;
        }
      case 3:
        {
          voteCount3++;
          vote3.add(uid);
          break;
        }
      case 4:
        {
          voteCount4++;
          vote4.add(uid);
          break;
        }
      case 5:
        {
          voteCount5++;
          vote5.add(uid);
          break;
        }
      case 6:
        {
          voteCount6++;
          vote6.add(uid);
          break;
        }
      case 7:
        {
          voteCount7++;
          vote7.add(uid);
          break;
        }
      case 8:
        {
          voteCount8++;
          vote8.add(uid);
          break;
        }
      case 9:
        {
          voteCount9++;
          vote9.add(uid);
          break;
        }
      case 10:
        {
          voteCount10++;
          vote10.add(uid);
          break;
        }
    }
  }

  // DateTime getEndDate() {
  //   Future.delayed(Duration.zero);

  //   var date = endDate.toDate().toLocal();

  //   return date.toLocal();
  // }
}
