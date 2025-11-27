class OnboardingContractsListModel {
  final String contractCode;
  final String contractName;
  final String contractPath;
  final String status;
  final String contractRefCode;

  OnboardingContractsListModel({
    required this.contractCode,
    required this.contractName,
    required this.contractPath,
    required this.status,
    required this.contractRefCode,
  });

  factory OnboardingContractsListModel.fromJson(Map<String, dynamic> json) {
    return OnboardingContractsListModel(
      contractCode: json['contractCode'] ?? '',
      contractName: json['contractName'] ?? '',
      contractPath: json['contractPath'] ?? '',
      status: json['status'] ?? '',
      contractRefCode: json['contractRefCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractCode': contractCode,
      'contractName': contractName,
      'contractPath': contractPath,
      'status': status,
      'contractRefCode': contractRefCode,
    };
  }
}
