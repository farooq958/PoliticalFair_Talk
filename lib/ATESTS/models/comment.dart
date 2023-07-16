import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String parentId;
  final String username;
  final String UID;
  final String text;
  final String commentId;
  final datePublished;
  final datePublishedNTP;
  List<dynamic> likes;
  int likeCount;
  List<dynamic> dislikes;
  int dislikeCount;
  int reportCounter;
  bool reportChecked;
  bool reportRemoved;
  bool bot;
  StreamController<Comment>? updatingStreamComment;

  Comment({
    required this.parentId,
    required this.username,
    required this.UID,
    required this.text,
    required this.commentId,
    required this.datePublished,
    required this.datePublishedNTP,
    required this.likes,
    required this.likeCount,
    required this.dislikes,
    required this.dislikeCount,
    required this.reportCounter,
    required this.reportChecked,
    required this.reportRemoved,
    required this.bot,
    this.updatingStreamComment,
  }) {
    if (updatingStreamComment != null) {
      updatingStreamComment!.stream
          .where((event) => event.commentId == commentId)
          .listen((event) {});
    }
  }

  Map<String, dynamic> toJson() => {
        "parentId": parentId,
        "username": username,
        "UID": UID,
        "text": text,
        "commentId": commentId,
        "datePublished": datePublished,
        "datePublishedNTP": datePublishedNTP,
        "likes": likes,
        "likeCount": likeCount,
        "dislikes": dislikes,
        "dislikeCount": dislikeCount,
        "reportCounter": reportCounter,
        "reportChecked": reportChecked,
        "reportRemoved": reportRemoved,
        "bot": bot,
      };

  static Comment fromSnap(
    DocumentSnapshot snap,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(
      snapshot,
    );
  }

  static Comment fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return Comment(
      commentId: snapshot['commentId'] ?? "",
      parentId: snapshot['parentId'] ?? "",
      UID: snapshot['UID'] ?? "",
      username: snapshot['username'] ?? "",
      text: snapshot['text'] ?? "",
      likes: (snapshot['likes'] ?? []).cast<String>(),
      dislikes: (snapshot['dislikes'] ?? []).cast<String>(),
      datePublished: snapshot['datePublished'],
      datePublishedNTP: snapshot['datePublishedNTP'],
      reportCounter: snapshot['reportCounter'],
      likeCount: snapshot['likeCount'],
      dislikeCount: snapshot['dislikeCount'],
      reportChecked: snapshot['reportChecked'],
      reportRemoved: snapshot['reportRemoved'],
      bot: snapshot['bot'],
      updatingStreamComment: snapshot['updatingStreamComment'],
    );
  }
}
