import 'package:equatable/equatable.dart';

class CurrenyRatios extends Equatable {
  final double? debitPrice;
  final double? creditPrice;
  final String? currencyName;
  final String? valueDate;

  const CurrenyRatios({
    this.debitPrice,
    this.creditPrice,
    this.currencyName,
    this.valueDate,
  });

  factory CurrenyRatios.fromJson(Map<String, dynamic> json) {
    return CurrenyRatios(
      debitPrice: json['debitPrice'],
      creditPrice: json['creditPrice'],
      currencyName: json['currencyName'],
      valueDate: json['valueDate'],
    );
  }

  @override
  List<Object?> get props => [
        debitPrice,
        creditPrice,
        currencyName,
        valueDate,
      ];
}
