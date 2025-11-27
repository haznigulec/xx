class SymbolSuffixListModel {
  final String name;
  final String nameWithSuffix;
  final String suffix;

  SymbolSuffixListModel({
    required this.name,
    required this.nameWithSuffix,
    required this.suffix,
  });

  factory SymbolSuffixListModel.fromJson(Map<String, dynamic> json) {
    return SymbolSuffixListModel(
      name: json['name'] ?? '',
      nameWithSuffix: json['nameWithSuffix'] ?? '',
      suffix: json['suffix'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameWithSuffix': nameWithSuffix,
      'suffix': suffix,
    };
  }
}
