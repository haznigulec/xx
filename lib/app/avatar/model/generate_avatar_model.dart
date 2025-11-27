class GenerateAvatarModel {
  final String? image;
  final dynamic refCode;

  GenerateAvatarModel({
    this.image,
    this.refCode,
  });

  factory GenerateAvatarModel.fromJson(Map<String, dynamic> json) {
    return GenerateAvatarModel(
      image: json['image'],
      refCode: json['refCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'refCode': refCode,
    };
  }
}
