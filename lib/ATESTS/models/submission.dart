import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  final String submissionId;
  final String UID;
  final String bUsername;
  final String bProfImage;
  final String aTitle;
  int score;
  final List<dynamic> plus;
  final List<dynamic> neutral;
  final List<dynamic> minus;
  int plusCount;
  int neutralCount;
  int minusCount;
  int commentCount;
  final List<dynamic> votesUIDs;
  final dynamic reportCounter;
  bool reportChecked;
  bool reportRemoved;
  bool fairtalk;

  final datePublishedNTP;

  dynamic comments;

  Submission({
    required this.submissionId,
    // ignore: non_constant_identifier_names
    required this.UID,
    required this.bUsername,
    required this.bProfImage,
    required this.datePublishedNTP,
    required this.aTitle,
    required this.plus,
    required this.neutral,
    required this.minus,
    required this.score,
    required this.votesUIDs,
    required this.reportCounter,
    required this.plusCount,
    required this.minusCount,
    required this.neutralCount,
    required this.commentCount,
    required this.reportChecked,
    required this.reportRemoved,
    required this.fairtalk,
  });
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
        "submissionId": submissionId,
        "UID": UID,
        "bUsername": bUsername,
        "bProfImage": bProfImage,
        "datePublishedNTP": datePublishedNTP,
        "aTitle": aTitle,
        "plus": plus,
        "neutral": neutral,
        "minus": minus,
        "plusCount": plusCount,
        "neutralCount": neutralCount,
        "minusCount": minusCount,
        "commentCount": commentCount,
        "score": score,
        "votesUIDs": votesUIDs,
        "reportCounter": reportCounter,
        "reportChecked": reportChecked,
        "reportRemoved": reportRemoved,
        "fairtalk": fairtalk,
      };

  static Submission fromSnap(
    DocumentSnapshot snap,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(
      snapshot,
    );
  }

  static Submission fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return Submission(
      submissionId: snapshot['submissionId'] ?? "",
      UID: snapshot['UID'] ?? "",
      bUsername: snapshot['bUsername'] ?? "",
      bProfImage: snapshot['bProfImage'] ?? "",
      aTitle: snapshot['aTitle'] ?? "",
      plus: (snapshot['plus'] ?? []).cast<String>(),
      neutral: (snapshot['neutral'] ?? []).cast<String>(),
      minus: (snapshot['minus'] ?? []).cast<String>(),
      votesUIDs: (snapshot['votesUIDs'] ?? []).cast<String>(),
      datePublishedNTP: snapshot['datePublishedNTP'],
      reportCounter: snapshot['reportCounter'],
      plusCount: snapshot['plusCount'],
      neutralCount: snapshot['neutralCount'],
      commentCount: snapshot['commentCount'],
      minusCount: snapshot['minusCount'],
      reportChecked: snapshot['reportChecked'],
      reportRemoved: snapshot['reportRemoved'] ?? false,
      score: snapshot['score'],
      fairtalk: snapshot['fairtalk'],
    );
  }
}
