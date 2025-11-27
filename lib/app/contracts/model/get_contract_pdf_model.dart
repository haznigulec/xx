class GetContractPdfModel {
  String? contractCode;
  String? contractDescription;
  String? contractRefCode;

  GetContractPdfModel({
    required this.contractCode,
    required this.contractDescription,
    required this.contractRefCode,
  });

  factory GetContractPdfModel.fromJson(Map<String, dynamic> json) => GetContractPdfModel(
        contractCode: json['contractCode'],
        contractDescription: json['contractDescription'],
        contractRefCode: json['contractRefCode'],
      );

  Map<String, dynamic> toJson() => {
        'contractCode': contractCode,
        'contractDescription': contractDescription,
        'contractRefCode': contractRefCode,
      };
}
