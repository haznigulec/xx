class SplashStoryModel {
  final String title;
  final String message;
  final String imageUrl;

  SplashStoryModel({
    required this.title,
    required this.message,
    required this.imageUrl,
  });

  factory SplashStoryModel.fromJson(Map<String, dynamic> json) {
    return SplashStoryModel(
      title: json['title'] as String,
      message: json['message'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'imageUrl': imageUrl,
    };
  }
}
