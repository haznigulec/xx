class CampaignModel {
  final String code;
  final String listTitle;
  final String image;
  final String companyLogo;
  final String startDate;
  final String endDate;
  final bool isAvailable;
  final int rightToParticipate;

  CampaignModel({
    required this.code,
    required this.listTitle,
    required this.image,
    required this.companyLogo,
    required this.startDate,
    required this.endDate,
    required this.isAvailable,
    required this.rightToParticipate,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      code: json['campaignCode'],
      listTitle: json['listTitle'],
      image: json['image'],
      companyLogo: json['companyLogo'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      isAvailable: json['isAvailable'],
      rightToParticipate: json['rightToParticipate'],
    );
  }
}

class CampaignDetailModel {
  final String code;
  final String listTitle;
  final String image;
  final String companyLogo;
  final String detailTitle;
  final String detailImage;
  final String? description;
  final String? conditionsOfParticipation;
  final String startDate;
  final String endDate;
  final String? customerCampaignCode;
  final bool isAvailable;
  final int rightToParticipate;
  final int? conditionType;
  final int? campaignType;

  CampaignDetailModel({
    required this.code,
    required this.listTitle,
    required this.image,
    required this.companyLogo,
    required this.detailTitle,
    required this.detailImage,
    this.description,
    required this.conditionsOfParticipation,
    required this.startDate,
    required this.endDate,
    this.customerCampaignCode,
    required this.isAvailable,
    required this.rightToParticipate,
    this.conditionType,
    this.campaignType,
  });

  factory CampaignDetailModel.fromJson(Map<String, dynamic> json) {
    return CampaignDetailModel(
      code: json['campaignCode'],
      listTitle: json['listTitle'],
      image: json['image'],
      companyLogo: json['companyLogo'],
      detailTitle: json['detailTitle'],
      detailImage: json['detailImage'],
      description: json['description'],
      conditionsOfParticipation: json['conditionsOfParticipation'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      customerCampaignCode: json['customerCampaignCode'],
      isAvailable: json['isAvailable'],
      rightToParticipate: json['rightToParticipate'],
      conditionType: json['conditionType'],
      campaignType: json['campaignType'],
    );
  }
}
