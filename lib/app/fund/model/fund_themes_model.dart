import 'package:equatable/equatable.dart';

class FundThemesModel extends Equatable {
  final int themeId;
  final String themeName;
  final String symbolNames;
  final String cdnUrl;
  final int? orderNo;

  const FundThemesModel({
    required this.themeId,
    required this.themeName,
    required this.symbolNames,
    required this.cdnUrl,
    required this.orderNo,
  });

  factory FundThemesModel.fromJson(Map<String, dynamic> json) {
    return FundThemesModel(
      themeId: json['themeId'],
      themeName: json['themeName'],
      symbolNames: json['symbolNames'],
      cdnUrl: json['cdnUrl'],
      orderNo: json['orderNo'],
    );
  }

  @override
  List<Object?> get props => [
        themeId,
        themeName,
        symbolNames,
        cdnUrl,
        orderNo,
      ];
}
