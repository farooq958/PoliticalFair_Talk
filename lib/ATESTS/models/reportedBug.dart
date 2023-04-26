import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportedBug {
  final String bugId;
  final String reportedBugText;
  final String deviceType;
  final datePublished;
  bool saved;
  bool removed;

  ReportedBug({
    required this.bugId,
    required this.reportedBugText,
    required this.deviceType,
    required this.saved,
    required this.datePublished,
    required this.removed,
  });

  Map<String, dynamic> toJson() => {
        "bugId": bugId,
        "reportedBugText": reportedBugText,
        "deviceType": deviceType,
        "datePublished": datePublished,
        "saved": saved,
        "removed": removed,
      };

  static ReportedBug fromSnap(
    DocumentSnapshot snap,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(
      snapshot,
    );
  }

  static ReportedBug fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return ReportedBug(
      bugId: snapshot['bugId'],
      reportedBugText: snapshot['reportedBugText'],
      deviceType: snapshot['deviceType'],
      datePublished: snapshot['datePublished'],
      saved: snapshot['saved'],
      removed: snapshot['removed'],
    );
  }
}
