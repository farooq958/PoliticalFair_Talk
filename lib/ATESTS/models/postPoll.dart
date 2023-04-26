import 'package:aft/ATESTS/models/poll.dart';
import 'package:aft/ATESTS/models/post.dart';

enum PostPollType { post, poll }

class PostPoll {
  final datePublished;
  final String postOrPollId;
  final PostPollType postPollType;
  Post? post;
  Poll? poll;

  PostPoll({
    required this.datePublished,
    required this.postOrPollId,
    required this.postPollType,
    this.post,
    this.poll,
  });
}
