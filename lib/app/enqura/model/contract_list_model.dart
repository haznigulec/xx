class ContractListModel {
  final String code;
  final String name;

  ContractListModel({
    required this.code,
    required this.name,
  });

  factory ContractListModel.fromJson(Map<String, dynamic> json) {
    return ContractListModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}
