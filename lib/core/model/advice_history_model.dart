class AdviceHistoryModel {
  final int? closedAdviceCount;
  final int? closedWithProfit;
  final int? closedWithLoss;
  final double? profitRatio;
  final List<ClosedAdvices>? closedAdvices;

  const AdviceHistoryModel({
    this.closedAdviceCount,
    this.closedWithProfit,
    this.closedWithLoss,
    this.profitRatio,
    this.closedAdvices,
  });

  factory AdviceHistoryModel.fromJson(Map<String, dynamic> json) {
    List<ClosedAdvices> closedAdvices = json['closedAdvices'] == null
        ? []
        : json['closedAdvices']
            .map<ClosedAdvices>(
              (dynamic element) => ClosedAdvices.fromJson(element),
            )
            .toList();
    closedAdvices.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return AdviceHistoryModel(
      closedAdviceCount: json['closedAdviceCount'] ?? 0,
      closedWithProfit: json['closedWithProfit'] ?? 0,
      closedWithLoss: json['closedWithLoss'] ?? 0,
      profitRatio: json['profitRatio'].toDouble() ?? 0,
      closedAdvices: closedAdvices,
    );
  }


  AdviceHistoryModel copyWith({
    int? closedAdviceCount,
    int? closedWithProfit,
    int? closedWithLoss,
    double? profitRatio,
    List<ClosedAdvices>? closedAdvices,
  }) {
    return AdviceHistoryModel(
      closedAdviceCount: closedAdviceCount ?? this.closedAdviceCount,
      closedWithProfit: closedWithProfit ?? this.closedWithProfit,
      closedWithLoss: closedWithLoss ?? this.closedWithLoss,
      profitRatio: profitRatio ?? this.profitRatio,
      closedAdvices: closedAdvices ?? this.closedAdvices,
    );
  }
}

class ClosedAdvices {
  final String symbolName;
  final String createdDate;
  final double openingPrice;
  final double targetPrice;
  final double stopLoss;
  final String closingDate;
  final double closingPrice;
  final int advicePeriod;
  final double profit;

  ClosedAdvices({
    required this.symbolName,
    required this.createdDate,
    required this.openingPrice,
    required this.targetPrice,
    required this.stopLoss,
    required this.closingDate,
    required this.closingPrice,
    required this.advicePeriod,
    required this.profit,
  });

  factory ClosedAdvices.fromJson(Map<String, dynamic> json) {
    return ClosedAdvices(
      symbolName: json['symbolName'],
      createdDate: json['created'],
      openingPrice: json['openingPrice'],
      targetPrice: json['targetPrice'],
      stopLoss: json['stopLoss'],
      closingDate: json['closingDate'],
      closingPrice: json['closingPrice'],
      advicePeriod: json['advicePeriod'],
      profit: json['profit'],
    );
  }
}
