import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  final String parentMessageId;
  final String parentCommentId;
  final String username;
  final String UID;
  final String text;
  final String replyId;
  final datePublished;
  final datePublishedNTP;
  List<dynamic> likes;
  int likeCount;
  List<dynamic> dislikes;
  int dislikeCount;
  int reportCounter;
  bool reportChecked;
  bool reportRemoved;
  StreamController<Reply>? updatingStreamReply;

  Reply({
    required this.parentMessageId,
    required this.parentCommentId,
    required this.username,
    required this.UID,
    required this.text,
    required this.replyId,
    required this.datePublished,
    required this.datePublishedNTP,
    required this.likes,
    required this.likeCount,
    required this.dislikes,
    required this.dislikeCount,
    required this.reportCounter,
    required this.reportChecked,
    required this.reportRemoved,
    this.updatingStreamReply,
  }) {
    if (updatingStreamReply != null) {
      updatingStreamReply!.stream
          .where((event) => event.replyId == replyId)
          .listen((event) {});
    }
  }

  Map<String, dynamic> toJson() => {
        "parentMessageId": parentMessageId,
        "parentCommentId": parentCommentId,
        "username": username,
        "UID": UID,
        "text": text,
        "replyId": replyId,
        "datePublished": datePublished,
        "datePublishedNTP": datePublishedNTP,
        "likes": likes,
        "likeCount": likeCount,
        "dislikes": dislikes,
        "dislikeCount": dislikeCount,
        "reportCounter": reportCounter,
        "reportChecked": reportChecked,
        "reportRemoved": reportRemoved,
      };

  static Reply fromSnap(
    DocumentSnapshot snap,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(
      snapshot,
    );
  }

  static Reply fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return Reply(
      replyId: snapshot['replyId'] ?? "",
      parentMessageId: snapshot['parentMessageId'] ?? "",
      parentCommentId: snapshot['parentCommentId'] ?? "",
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
      updatingStreamReply: snapshot['updatingStreamReply'],
    );
  }
}
