class ValidateAvatarModel {
  final bool isValid;
  final ImageDataModel? imageData;
  final LimitData limitData;

  ValidateAvatarModel({
    required this.isValid,
    required this.imageData,
    required this.limitData,
  });

  factory ValidateAvatarModel.fromJson(Map<String, dynamic> json) {
    return ValidateAvatarModel(
      isValid: json['isValid'],
      imageData: json['imageData'] != null ? ImageDataModel.fromJson(json['imageData']) : null,
      limitData: LimitData.fromJson(json['limitData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'imageData': imageData,
      'limitData': limitData,
    };
  }
}

class ImageDataModel {
  final String? refCode;
  final String image;

  ImageDataModel({
    required this.refCode,
    required this.image,
  });

  factory ImageDataModel.fromJson(Map<String, dynamic> json) {
    return ImageDataModel(
      refCode: json['refCode'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refCode': refCode,
      'image': image,
    };
  }
}

class LimitData {
  final int periodDuration;
  final int periodLimit;
  final int remainingUsageCount;

  LimitData({
    required this.periodDuration,
    required this.periodLimit,
    required this.remainingUsageCount,
  });

  factory LimitData.fromJson(Map<String, dynamic> json) {
    return LimitData(
      periodDuration: json['periodDuration'],
      periodLimit: json['periodLimit'],
      remainingUsageCount: json['remainingUsageCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodDuration': periodDuration,
      'periodLimit': periodLimit,
      'remainingUsageCount': remainingUsageCount,
    };
  }
}
