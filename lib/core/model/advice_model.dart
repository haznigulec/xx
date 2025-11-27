import 'package:piapiri_v2/core/model/robo_signal_model.dart';

class AdviceModel {
  final String symbolName;
  final String adviceType;
  final String? description;
  final String adviceSide;
  final double targetPrice;
  final double? advicePrice;
  final double? closingPrice;
  final double? stopLoss;
  final String? closeDescription;
  final String created;
  final int adviceSideId;
  final int adviceTypeId;
  final double openingPrice;
  final bool? isRoboSignal;
  final String? code;
  final String? date;
  final double? close;
  final List<IndicatorModel>? indicators;

  const AdviceModel({
    required this.symbolName,
    required this.adviceType,
    this.description,
    required this.adviceSide,
    required this.targetPrice,
    this.advicePrice,
    this.closingPrice,
    this.stopLoss,
    this.closeDescription,
    required this.created,
    required this.adviceSideId,
    required this.adviceTypeId,
    required this.openingPrice,
    this.isRoboSignal,
    this.code,
    this.date,
    this.close,
    this.indicators,
  });

  factory AdviceModel.fromJson(dynamic json) {
    return AdviceModel(
      symbolName: json['symbolName'],
      adviceType: json['adviceType'],
      description: json['description'],
      adviceSide: json['adviceSide'],
      targetPrice: json['targetPrice'],
      advicePrice: json['advicePrice'],
      closingPrice: json['closingPrice'],
      stopLoss: json['stopLoss'],
      closeDescription: json['closeDescription'],
      created: json['created'],
      adviceSideId: json['adviceSideId'],
      adviceTypeId: json['adviceTypeId'],
      openingPrice: json['openingPrice'],
    );
  }

  AdviceModel setRoboSignal(
    final bool? isRoboSignal,
    final String? code,
    final String? date,
    final double? close,
    final List<IndicatorModel>? indicators,
  ) {
    return AdviceModel(
      symbolName: symbolName,
      adviceType: adviceType,
      adviceSide: adviceSide,
      targetPrice: targetPrice,
      created: created,
      adviceSideId: adviceSideId,
      adviceTypeId: adviceTypeId,
      openingPrice: openingPrice,
      isRoboSignal: isRoboSignal,
      code: code,
      date: date,
      close: close,
      indicators: indicators,
    );
  }
}
