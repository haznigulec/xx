import 'package:p_core/extensions/date_time_extensions.dart';

class TwitterModel {
  final String tweetId;
  final String createdAt;
  final String tweetText;
  final String name;
  final String username;
  final String profileImageUrl;

  TwitterModel({
    required this.tweetId,
    required this.createdAt,
    required this.tweetText,
    required this.name,
    required this.username,
    required this.profileImageUrl,
  });

  factory TwitterModel.fromJson(Map<String, dynamic> json) {
    return TwitterModel(
      tweetId: json['tweetId'],
      createdAt: DateTime.parse(
        json['createdAt'].toString(),
      ).formatDayMonthYearTime(),
      tweetText: json['tweetText'],
      name: json['name'],
      username: json['username'],
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
