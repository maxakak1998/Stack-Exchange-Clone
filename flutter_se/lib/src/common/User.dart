import 'package:flutter_se/src/common/Badge.dart';

class User {
  int reputation;
  int userId;
  String profileImageUrl;
  String userName;
  String profileUrl;
  Badge badge;
  User(
      {this.profileImageUrl = "default",
      this.profileUrl = "default",
      this.reputation = -1,
      this.userId = -1,
      this.userName = "default",
      this.badge});

  User.fromJson(Map<String, dynamic> json)
      : reputation = json['reputation'],
        userId = json['user_id'],
        profileImageUrl = json['profile_image'],
        profileUrl = json['link'],
        userName = json['display_name'],
        badge = new Badge(json['badge_counts']['bronze'],
            json['badge_counts']['gold'], json['badge_counts']['silver']);
}
