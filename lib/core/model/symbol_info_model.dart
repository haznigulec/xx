class SymbolInfoModel {
  final String? description;
  final String? code;
  final String? capital;
  final String? address;
  final String? website;
  final String? phone;
  final String? fax;
  final String? activityArea;

  SymbolInfoModel({
    this.description = '',
    this.code = '',
    this.capital = '',
    this.address = '',
    this.website = '',
    this.phone = '',
    this.fax = '',
    this.activityArea = '',
  });

  factory SymbolInfoModel.fromJson(dynamic json) {
    return SymbolInfoModel(
      description: json['desc'],
      code: json['code'],
      capital: json['capital'].toString(),
      address: json['address'],
      website: json['website'],
      phone: json['tel'],
      fax: json['fax'],
      activityArea: json['activityArea'],
    );
  }
}
