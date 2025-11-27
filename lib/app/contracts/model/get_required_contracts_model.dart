class RequiredContractsModel {
  String? contractCode;
  String? contractDescription;
  String? contractRefCode;

  RequiredContractsModel({
    this.contractCode,
    this.contractDescription,
    this.contractRefCode,
  });

  factory RequiredContractsModel.fromJson(Map<String, dynamic> json) => RequiredContractsModel(
        contractCode: json['contractCode'],
        contractDescription: json['contractDescription'],
        contractRefCode: json['contractRefCode'],
      );
}
