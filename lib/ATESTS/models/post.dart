import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String UID;
  final String bUsername;
  final String bProfImage;
  String country;
  final String global;
  final String aTitle;
  final String aBody;
  final String aVideoUrl;
  final String aPostUrl;
  final String sub;
  int score;
  int time;
  final List<dynamic> plus;
  final List<dynamic> neutral;
  final List<dynamic> minus;
  int plusCount;
  int neutralCount;
  int minusCount;
  int commentCount;
  final List<dynamic> votesUIDs;
  // final List<dynamic> reportUIDs;
  final dynamic reportCounter;
  bool reportChecked;
  bool reportRemoved;
  bool bot;
  // final int? selected;
  final datePublished;
  final datePublishedNTP;
  // final endDate;
  //StreamController<Post>? updatingStream;
  dynamic comments;
  List<String>? tagsLowerCase;

  Post(
      {required this.postId,
      // ignore: non_constant_identifier_names
      required this.UID,
      required this.bUsername,
      required this.bProfImage,
      required this.country,
      required this.datePublished,
      required this.datePublishedNTP,
      required this.global,
      required this.aTitle,
      required this.aBody,
      required this.aVideoUrl,
      required this.aPostUrl,
      // required this.selected,
      required this.plus,
      required this.neutral,
      required this.minus,
      required this.score,
      required this.time,
      required this.votesUIDs,
      required this.reportCounter,
      // required this.endDate,
      required this.plusCount,
      required this.minusCount,
      required this.neutralCount,
      required this.commentCount,
      required this.reportChecked,
      required this.reportRemoved,
      required this.sub,
      required this.bot,

      //  this.updatingStream,
      this.tagsLowerCase});
  // {
  //   if (updatingStream != null) {
  //     updatingStream!.stream
  //         .where((event) => event.postId == postId)
  //         .listen((event) {
  //       plus         = event.plus;
  //       minus        = event.minus;
  //       neutral      = event.neutral;
  //       plusCount    = event.plusCount;
  //       minusCount   = event.minusCount;
  //       neutralCount = event.neutralCount;
  //       score = event.score;
  //     });
  //   }
  // }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "UID": UID,
        "bUsername": bUsername,
        "bProfImage": bProfImage,
        "country": country,
        "datePublished": datePublished,
        "datePublishedNTP": datePublishedNTP,
        "global": global,
        "aTitle": aTitle,
        "aBody": aBody,
        "aVideoUrl": aVideoUrl,
        "aPostUrl": aPostUrl,
        // "selected": selected,
        "plus": plus,
        "neutral": neutral,
        "minus": minus,
        "plusCount": plusCount,
        "neutralCount": neutralCount,
        "minusCount": minusCount,
        "commentCount": commentCount,
        "score": score,
        "time": time,
        "votesUIDs": votesUIDs,
        "reportCounter": reportCounter,
        "reportChecked": reportChecked,
        "tagsLowerCase": tagsLowerCase,
        "reportRemoved": reportRemoved,
        "sub": sub,
        "bot": bot,
        // "endDate": endDate
      };

  static Post fromSnap(
    DocumentSnapshot snap,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(
      snapshot,
    );
  }

  static Post fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return Post(
      postId: snapshot['postId'] ?? "",
      UID: snapshot['UID'] ?? "",
      bUsername: snapshot['bUsername'] ?? "",
      bProfImage: snapshot['bProfImage'] ?? "",
      country: snapshot['country'],
      global: snapshot['global'] ?? "",
      aTitle: snapshot['aTitle'] ?? "",
      aBody: snapshot['aBody'] ?? "",
      aVideoUrl: snapshot['aVideoUrl'] ?? "",
      aPostUrl: snapshot['aPostUrl'] ?? "",
      plus: (snapshot['plus'] ?? []).cast<String>(),
      neutral: (snapshot['neutral'] ?? []).cast<String>(),
      minus: (snapshot['minus'] ?? []).cast<String>(),
      votesUIDs: (snapshot['votesUIDs'] ?? []).cast<String>(),
      // reportUIDs: (snapshot['reportUIDs'] ?? []).cast<String>(),
      // selected: snapshot['selected'],
      datePublished: snapshot['datePublished'],
      datePublishedNTP: snapshot['datePublishedNTP'],
      reportCounter: snapshot['reportCounter'],
      plusCount: snapshot['plusCount'],
      neutralCount: snapshot['neutralCount'],
      commentCount: snapshot['commentCount'],
      minusCount: snapshot['minusCount'],
      time: snapshot['time'],
      reportChecked: snapshot['reportChecked'],
      reportRemoved: snapshot['reportRemoved'] ?? false,
      // endDate: snapshot['endDate'],
      score: snapshot['score'],
      sub: snapshot['sub'],
      bot: snapshot['bot'],
      // updatingStream: snapshot['updatingStream'],
      tagsLowerCase: (snapshot['tagsLowerCase'] ?? []).cast<String>(),
    );
  }

  // DateTime getEndDate() {
  //   Future.delayed(Duration.zero);

  //   var date = endDate.toDate().toLocal();

  //   return date.toLocal();
  // }
}
