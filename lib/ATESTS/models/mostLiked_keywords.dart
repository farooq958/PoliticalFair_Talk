class MostLikedKeywords {
  List<String>? pollId;
  List<String>? post_id;
  List<String>? searchList;
  String? keyName;
  String? country;
  String? global;
  String? type;
  int? length;

  MostLikedKeywords({
    this.pollId,
    this.post_id,
    this.keyName,
    this.country,
    this.global,
    this.type,
    this.length,
    this.searchList,
  });

  MostLikedKeywords.fromJson(Map<String, dynamic> json) {
    pollId = (json['pollId'] ?? []).cast<String>();
    post_id = (json['post_id'] ?? []).cast<String>();
    searchList = (json["searchList"] ?? []).cast<String>();
    keyName = json['keyName'];
    country = json['country'];
    global = json['global'];
    type = json['type'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pollId'] = this.pollId;
    data['post_id'] = this.post_id;
    data['keyName'] = this.keyName;
    data['country'] = this.country;
    data['global'] = this.global;
    data['type'] = this.type;
    data['length'] = this.length;
    data['searchList'] = this.searchList;
    return data;
  }
}
