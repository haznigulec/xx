import 'package:equatable/equatable.dart';

class UsCapraSummaryModel extends Equatable {
  final double? tlExchangeRate;
  final List<UsOverallItemModel>? overallItemGroups;

  const UsCapraSummaryModel({
    this.tlExchangeRate,
    this.overallItemGroups,
  });

  factory UsCapraSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UsCapraSummaryModel(
      tlExchangeRate: double.parse(
        json['tlExchangeRate'].toString().replaceAll(',', '.'),
      ),
      overallItemGroups: json['overallItemGroups']
          ?.map<UsOverallItemModel>(
            (e) => UsOverallItemModel.fromJson(e),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        tlExchangeRate,
        overallItemGroups,
      ];
}

class UsOverallItemModel extends Equatable {
  final String? instrumentCategory;
  final double? totalAmount;
  final double? exchangeValue;
  final double? ratio;
  final double? totalPotentialProfitLoss;
  final List<UsOverallSubItem>? overallItems;

  const UsOverallItemModel({
    this.instrumentCategory,
    this.totalAmount,
    this.exchangeValue,
    this.ratio,
    this.totalPotentialProfitLoss,
    this.overallItems,
  });

  factory UsOverallItemModel.fromJson(Map<String, dynamic> json) {
    return UsOverallItemModel(
      instrumentCategory: json['instrumentCategory'],
      totalAmount: json['totalAmount'].toDouble(),
      exchangeValue: json['exchangeValue'].toDouble(),
      ratio: json['ratio'].toDouble() ?? 0,
      totalPotentialProfitLoss: double.parse(
        json['totalPotentialProfitLoss'].toString(),
      ),
      overallItems: json['overallItems']
          ?.map<UsOverallSubItem>(
            (e) => UsOverallSubItem.fromJson(e),
          )
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        instrumentCategory,
        totalAmount,
        exchangeValue,
        ratio,
        totalPotentialProfitLoss,
        overallItems,
      ];
}

class UsOverallSubItem extends Equatable {
  final String? assetId;
  final String? symbol;
  final String? exchange;
  final String? assetClass;
  final String? avgEntryPrice;
  final num? qty;
  final num? qtyAvailable;
  final String? side;
  final String? marketValue;
  final String? costBasis;
  final String? unrealizedPl;
  final String? unrealizedPlpc;
  final String? unrealizedIntradayPl;
  final String? unrealizedIntradayPlpc;
  final String? currentPrice;
  final String? lastdayPrice;
  final String? changeToday;

  const UsOverallSubItem({
    this.assetId,
    this.symbol,
    this.exchange,
    this.assetClass,
    this.avgEntryPrice,
    this.qty,
    this.side,
    this.marketValue,
    this.costBasis,
    this.unrealizedPl,
    this.unrealizedPlpc,
    this.unrealizedIntradayPl,
    this.unrealizedIntradayPlpc,
    this.currentPrice,
    this.lastdayPrice,
    this.changeToday,
    this.qtyAvailable,
  });

  factory UsOverallSubItem.fromJson(Map<String, dynamic> json) {
    return UsOverallSubItem(
      assetId: json['asset_id'],
      symbol: json['symbol'],
      exchange: json['exchange'],
      assetClass: json['asset_class'],
      avgEntryPrice: json['avg_entry_price'],
      qty: num.parse(json['qty']),
      side: json['side'],
      marketValue: json['market_value'],
      costBasis: json['cost_basis'],
      unrealizedPl: json['unrealized_pl'],
      unrealizedPlpc: json['unrealized_plpc'],
      unrealizedIntradayPl: json['unrealized_intraday_pl'],
      unrealizedIntradayPlpc: json['unrealized_intraday_plpc'],
      currentPrice: json['current_price'],
      lastdayPrice: json['lastday_price'],
      changeToday: json['change_today'],
      qtyAvailable: num.parse(json['qty_available']),
    );
  }

  @override
  List<Object?> get props => [
        assetId,
        symbol,
        exchange,
        assetClass,
        avgEntryPrice,
        qty,
        side,
        marketValue,
        costBasis,
        unrealizedPl,
        unrealizedPlpc,
        unrealizedIntradayPl,
        unrealizedIntradayPlpc,
        currentPrice,
        lastdayPrice,
        changeToday,
        qtyAvailable,
      ];
}
