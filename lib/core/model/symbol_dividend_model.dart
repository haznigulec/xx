import 'package:equatable/equatable.dart';

class SymbolDividendModel extends Equatable {
  final String? recordDate;
  final double perShare;
  final double perRate;

  const SymbolDividendModel({
    required this.recordDate,
    required this.perShare,
    required this.perRate,
  });

  factory SymbolDividendModel.fromJson(Map<String, dynamic> json) {
    return SymbolDividendModel(
      recordDate: json['recordDate'],
      perShare: json['perShare']?.toDouble() ?? 0.0,
      perRate: json['perRate']?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        recordDate,
        perShare,
        perRate,
      ];
}
