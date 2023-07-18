import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String aEmail;
  final String UID;
  final String? photoUrl;
  final String username;
  final String usernameLower;
  String aaCountry;
  final String pending;
  final String bio;
  final dateCreated;
  final pendingDate;
  bool profileFlag;
  bool profileBadge;
  bool profileScore;
  bool profileVotes;
  final int profileScoreValue;
  int gMessageTime;
  int nMessageTime;
  final int gPollTime;
  final int nPollTime;
  final String aaName;
  int userReportCounter;
  final List blockList;
  final bool admin;

  // List<String> verificationPhotos;
  final String? photoOne;
  final String? photoTwo;
  String? fcmToken;
  String? fcmTopic;
  bool verProcess;
  String verFailReason;
  int submissionTime;
  String bot;
  // int tokensCounter;
  // int maxDailyTime;

  User({
    required this.aEmail,
    required this.UID,
    required this.photoUrl,
    required this.username,
    required this.usernameLower,
    required this.aaCountry,
    required this.bio,
    this.fcmToken,
    this.fcmTopic,
    required this.dateCreated,
    required this.pendingDate,
    required this.profileFlag,
    required this.pending,
    required this.profileBadge,
    required this.profileScore,
    required this.profileScoreValue,
    required this.profileVotes,
    required this.aaName,
    required this.userReportCounter,
    required this.blockList,
    required this.gMessageTime,
    required this.nMessageTime,
    required this.gPollTime,
    required this.nPollTime,
    required this.admin,
    // required this.verificationPhotos,
    required this.photoOne,
    required this.photoTwo,
    required this.verProcess,
    required this.verFailReason,
    required this.submissionTime,
    required this.bot,
    // required this.tokensCounter,
    // required this.maxDailyTime,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "usernameLower": usernameLower,
        "UID": UID,
        "aEmail": aEmail,
        "photoUrl": photoUrl,
        "aaCountry": aaCountry,
        "pending": pending,
        "pendingDate": pendingDate,
        "bio": bio,
        "fcmToken": fcmToken,
        "fcmTopic": fcmTopic,
        "dateCreated": dateCreated,
        "profileFlag": profileFlag,
        "profileBadge": profileBadge,
        "profileScore": profileScore,
        "profileVotes": profileVotes,
        "profileScoreValue": profileScoreValue,
        "aaName": aaName,
        "userReportCounter": userReportCounter,
        "blockList": blockList,
        "gMessageTime": gMessageTime,
        "nMessageTime": nMessageTime,
        "gPollTime": gPollTime,
        "nPollTime": nPollTime,
        "admin": admin,
        // "verificationPhotos": verificationPhotos,
        "photoOne": photoOne,
        "photoTwo": photoTwo,
        "verProcess": verProcess,
        "verFailReason": verFailReason,
        "submissionTime": submissionTime,
        "bot": bot,
        // "maxDailyTime": maxDailyTime,
        // "tokensCounter": tokensCounter,
      };

  Map<String, dynamic> toRTDBJson() => {
        "username": username,
        "usernameLower": usernameLower,
        "UID": UID,
        "aEmail": aEmail,
        "photoUrl": photoUrl,
        "aaCountry": aaCountry,
        "pending": pending,
        "pendingDate":
            pendingDate is Timestamp ? pendingDate.millisecondsSinceEpoch : "",
        "bio": bio,
        "fcmToken": fcmToken,
        "fcmTopic": fcmTopic,
        "dateCreated": dateCreated.millisecondsSinceEpoch,
        "profileFlag": profileFlag,
        "profileBadge": profileBadge,
        "profileScore": profileScore,
        "profileVotes": profileVotes,
        "profileScoreValue": profileScoreValue,
        "aaName": aaName,
        "userReportCounter": userReportCounter,
        "blockList": blockList,
        "gMessageTime": gMessageTime,
        "nMessageTime": nMessageTime,
        "gPollTime": gPollTime,
        "nPollTime": nPollTime,
        "admin": admin,
        // "verificationPhotos": verificationPhotos,
        "photoOne": photoOne,
        "photoTwo": photoTwo,
        "verProcess": verProcess,
        "verFailReason": verFailReason,
        "submissionTime": submissionTime,
        "bot": bot,
        // "maxDailyTime": maxDailyTime,
        // "tokensCounter": tokensCounter,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      fcmToken: snapshot['fcmToken'],
      fcmTopic: snapshot['fcmTopic'],
      username: snapshot['username'],
      usernameLower: snap['usernameLower'],
      UID: snapshot['UID'],
      photoUrl: snapshot['photoUrl'],
      aEmail: snapshot['aEmail'],
      aaCountry: snapshot['aaCountry'],
      pending: snapshot['pending'],
      pendingDate: snapshot['pendingDate'],
      bio: snapshot['bio'],
      dateCreated: snapshot['dateCreated'],
      profileFlag: snapshot['profileFlag'],
      profileBadge: snapshot['profileBadge'],
      profileScore: snapshot['profileScore'],
      profileVotes: snapshot['profileVotes'],
      profileScoreValue: snapshot['profileScoreValue'],
      aaName: snapshot['aaName'],
      userReportCounter: snapshot['userReportCounter'],
      blockList: snapshot["blockList"] ?? [],
      // verificationPhotos: snapshot["verificationPhotos"] ?? [],
      gMessageTime: snapshot['gMessageTime'],
      nMessageTime: snapshot['nMessageTime'],
      gPollTime: snapshot['gPollTime'],
      nPollTime: snapshot['nPollTime'],
      admin: snapshot['admin'],
      photoOne: snapshot['photoOne'],
      photoTwo: snapshot['photoTwo'],
      verProcess: snapshot['verProcess'],
      verFailReason: snapshot['verFailReason'],
      submissionTime: snapshot['submissionTime'],
      bot: snapshot['bot'],
      // tokensCounter: snapshot['tokensCounter'],
      // maxDailyTime: snapshot['maxDailyTime'],
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fcmToken: map['fcmToken'],
      fcmTopic: map['fcmTopic'],
      username: map['username'],
      usernameLower: map['usernameLower'],
      UID: map['UID'],
      photoUrl: map['photoUrl'],
      aEmail: map['aEmail'],
      aaCountry: map['aaCountry'],
      pending: map['pending'],
      pendingDate: map['pendingDate'],
      bio: map['bio'],
      dateCreated: map['dateCreated'],
      profileFlag: map['profileFlag'],
      profileBadge: map['profileBadge'],
      profileScore: map['profileScore'],
      profileVotes: map['profileVotes'],
      profileScoreValue: map['profileScoreValue'],
      aaName: map['aaName'],
      userReportCounter: map['userReportCounter'],
      blockList: map["blockList"] ?? [],
      // verificationPhotos: snapshot["verificationPhotos"] ?? [],
      gMessageTime: map['gMessageTime'],
      nMessageTime: map['nMessageTime'],
      gPollTime: map['gPollTime'],
      nPollTime: map['nPollTime'],
      admin: map['admin'],
      photoOne: map['photoOne'],
      photoTwo: map['photoTwo'],
      verProcess: map['verProcess'],
      verFailReason: map['verFailReason'],
      submissionTime: map['submissionTime'],
      bot: map['bot'],
      // tokensCounter: map['tokensCounter'],
      // maxDailyTime: map['maxDailyTime'],
    );
  }

  static fromJson(json) {}
}
