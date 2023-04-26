class Keyword {
  final String keyName;
  final String postType;
  final int length;
  final int time;
  String country;
  final String global;
  List<dynamic> postIds = [];
  // List<dynamic> userIds = [];
  List<dynamic> nameSearchList = [];
  List<dynamic>? weekList = [];
  String? WeekName;
  int? lastDay;
  Keyword({
    required this.keyName,
    required this.postIds,
    // required this.userIds,
    required this.postType,
    required this.length,
    required this.country,
    required this.global,
    required this.nameSearchList,
    required this.time,
    this.weekList,
    this.WeekName,
    this.lastDay,
  });
  Map<String, dynamic> toJson() => {
        "keyName": keyName,
        "postIds": postIds,
        // "userIds": userIds,
        "postType": postType,
        "length": length,
        "country": country,
        "global": global,
        "nameSearchList": nameSearchList,
        "time": time,
        "weekList": weekList,
        "WeekName": WeekName,
        "lastDay": lastDay
      };
  static Keyword fromMap(Map<String, dynamic> snapshot) {
    return Keyword(
      keyName: snapshot["keyName"] ?? "",
      postIds: (snapshot['postIds'] ?? []).cast<String>(),
      // userIds: (snapshot['userIds'] ?? []).cast<String>(),
      postType: snapshot["postType"] ?? "",
      length: snapshot["length"] ?? "",
      country: snapshot["country"] ?? "",
      global: snapshot["global"] ?? "",
      nameSearchList: (snapshot["nameSearchList"] ?? []).cast<String>(),
      time: snapshot["time"] ?? "",
      weekList: (snapshot["weekList"] ?? []).cast<String>(),
      WeekName: snapshot["WeekName"],
      lastDay: snapshot["lastDay"],
    );
  }
}
