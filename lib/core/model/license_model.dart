class LicenseModel {
  int id;
  String name;
  double price;
  String currency;
  String description;
  String code;
  bool hasLicence;
  LicenseLastRequestModel? lastRequest;
  String? startDate;

  LicenseModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.description,
    required this.code,
    required this.hasLicence,
    required this.lastRequest,
    required this.startDate,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      currency: json['currency'],
      description: json['description'],
      code: json['code'],
      hasLicence: json['hasLicence'],
      lastRequest: json['lastRequest'] != null ? LicenseLastRequestModel.fromJson(json['lastRequest']) : null,
      startDate: json['startDate'],
    );
  }
}

class LicenseLastRequestModel {
  int id;
  int type;
  int status;

  LicenseLastRequestModel({
    required this.id,
    required this.type,
    required this.status,
  });

  factory LicenseLastRequestModel.fromJson(Map<String, dynamic> json) {
    return LicenseLastRequestModel(
      id: json['id'],
      type: json['type'],
      status: json['status'],
    );
  }
}
