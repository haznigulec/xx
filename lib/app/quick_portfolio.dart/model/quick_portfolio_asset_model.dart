import 'package:equatable/equatable.dart';

class QuickPortfolioAssetModel extends Equatable {
  final int id;
  final String name;
  final String code;
  final String type;
  final double ratio;
  final double targetPrice;
  final double amount;
  final bool isChecked;
  final bool isChanged;
  final String? fundValorDate;
  final String? founderCode;
  final String? subType;
  final String? founderName;
  final int? portfolioId;
  final String? suitable;

  const QuickPortfolioAssetModel({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.ratio,
    required this.amount,
    required this.targetPrice,
    this.isChecked = true,
    this.isChanged = false,
    this.fundValorDate,
    this.founderCode,
    this.subType,
    this.founderName,
    this.portfolioId,
    this.suitable,
  });

  factory QuickPortfolioAssetModel.fromJson(Map<String, dynamic> json) {
    return QuickPortfolioAssetModel(
        id: json['VarlikId'] ?? 0,
        name: json['VarlikAd'] ?? json['name'] ?? json['code'] ?? json['symbolName'] ?? json['company'] ?? '',
        code: json['VarlikKod'] ?? json['code'] ?? json['name'] ?? json['symbolName'] ?? json['symbol'] ?? '',
        type: json['VarlikTur'] ?? '',
        ratio: json['VarlikPortfoyOran'] ?? json['rate'] ?? double.parse(json['ratio'].toString()) ?? 0.0,
        amount: json['VarlikTutar'] ?? 0.0,
        targetPrice: json['targetPrice'] ?? 0.0,
        isChecked: json['isChecked'] ?? true,
        isChanged: json['isChanged'] ?? false,
        fundValorDate: json['fundValorDate'] ?? '',
        founderCode: json['founderCode'] ?? '',
        subType: json['subType'] ?? '',
        founderName: json['founderName'] ?? '',
        portfolioId: json['portfolioId'] ?? 0,
        suitable: json['suitable'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'VarlikId': id,
      'VarlikAd': name,
      'VarlikKod': code,
      'VarlikTur': type,
      'VarlikPortfoyOran': ratio,
      'VarlikTutar': amount,
    };
  }

  QuickPortfolioAssetModel copyWith({
    String? name,
    double? ratio,
    double? amount,
    double? targetPrice,
    bool? isChecked,
    bool? isChanged,
    String? fundValorDate,
    String? founderCode,
    String? subType,
    String? founderName,
    int? portfolioId,
  }) {
    return QuickPortfolioAssetModel(
      id: id,
      name: name ?? this.name,
      code: code,
      type: type,
      ratio: ratio ?? this.ratio,
      isChecked: isChecked ?? this.isChecked,
      isChanged: isChanged ?? this.isChanged,
      amount: amount ?? this.amount,
      targetPrice: targetPrice ?? this.targetPrice,
      fundValorDate: fundValorDate ?? this.fundValorDate,
      founderCode: founderCode ?? this.founderCode,
      subType: subType ?? this.subType,
      founderName: founderName ?? this.founderName,
      portfolioId: portfolioId ?? this.portfolioId,
    );
  }

  @override
  List<Object?> get props => [
        isChecked,
        isChanged,
        fundValorDate,
        founderCode,
        founderName,
      ];
}
