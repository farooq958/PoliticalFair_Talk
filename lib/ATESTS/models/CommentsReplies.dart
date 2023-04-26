import 'package:aft/ATESTS/models/comment.dart';
import 'package:aft/ATESTS/models/poll.dart';
import 'package:aft/ATESTS/models/post.dart';
import 'package:aft/ATESTS/models/reply.dart';

enum CommentReplyType { comment, reply }

enum PostOrPollComment { post, poll }

class CommentsReplies {
  final datePublished;
  final datePublishedNTP;
  final CommentReplyType commentReplyType;
  Comment? comment;
  PostOrPollComment postOrPollComment;
  Reply? reply;
  Post? post;
  Poll? poll;

  CommentsReplies({
    required this.datePublished,
    required this.datePublishedNTP,
    required this.commentReplyType,
    required this.postOrPollComment,
    this.comment,
    this.reply,
    this.post,
    this.poll,
  });
}

class CommentsAndReplies {
  Comment comment;
  List<Reply> replyList;

  CommentsAndReplies({
    required this.comment,
    required this.replyList,
  });
}
