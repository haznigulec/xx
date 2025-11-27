import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/viop_session_enum.dart';

class TransactionModel {
  final String? symbol; // Sembol
  final double? orderAmount; // Tutar
  final num? orderUnit; // Adet
  final double? transactionPrice; // İşlem Fiyatı/Ort. Gerçekleşme Fiyatı
  final double? orderPrice; // Emir Fiyatı
  final String? orderDate; // Tarih
  final String? orderTime; // Saat
  final String? equityGroupCode; // V; Varant , E; Hisse
  final double? realizedUnit; // Gerçekleşen Adet
  final double? remainingUnit; // Kalan Adet
  final String? transactionType; // Emir Tipi
  final String? validity; // Geçerlilik
  final String? accountExtId;
  final String? customerExtId;
  final String? transactionExtId; // Referans No
  final String? transactionId; // Referans No
  final String? parentTransactionId; // Referans No
  final String? orderStatus;
  final int? chainNo;
  final int? session;
  //Condition
  final String? conditionSymbol;
  final String? conditionType;
  final double? conditionPrice;
  //StopLoss & TakeProfit
  final double? tpPrice;
  final double? slPrice;
  final DateTime? periodEndDate;
  final String? periodicTransactionId;
  // for FincList
  final String? asset;
  final int? sideType;
  final double? price;
  final double? rate;
  final double? amount;
  final double? units;
  final String? status;
  final String? valueDate;
  final String? created;
  final String? createdBy;
  final SymbolTypeEnum? symbolType;
  final String? orderType;
  final String? endingMarketSessionDate;
  // VIOP
  final double? multiplier;
  final String underlying;
  final int? decimalCount;
  final bool shortFall;
  final ViopSessionEnum? viopSession;
  // Amerikan Borsası
  final String? id;
  final bool isAmericanStockExchangeOrder;
  final double? stopPrice;
  final String? commission;
  final bool? extendedHours;
  final String? trailPercent;
  final String? trailPrice;
  final String? filledAt;
  final String? filledAvgPrice;
  //Fund
  final bool? fundCanBeCancelled;

  TransactionModel({
    required this.transactionPrice,
    required this.orderAmount,
    required this.orderPrice,
    required this.orderUnit,
    required this.orderDate,
    required this.orderTime,
    required this.symbol,
    this.equityGroupCode,
    required this.transactionExtId,
    required this.realizedUnit,
    required this.remainingUnit,
    required this.transactionType,
    required this.validity,
    required this.accountExtId,
    required this.customerExtId,
    required this.transactionId,
    this.parentTransactionId,
    required this.orderStatus,
    required this.chainNo,
    required this.session,
    this.conditionSymbol,
    this.conditionType,
    this.conditionPrice,
    this.asset,
    this.sideType,
    this.price,
    this.rate,
    this.amount,
    this.units,
    this.status,
    this.valueDate,
    this.created,
    this.createdBy,
    this.symbolType,
    this.orderType,
    this.endingMarketSessionDate,
    this.multiplier,
    this.underlying = '',
    this.tpPrice,
    this.slPrice,
    this.periodEndDate,
    this.periodicTransactionId,
    this.decimalCount,
    this.shortFall = false,
    this.viopSession,
    this.id,
    this.isAmericanStockExchangeOrder = false,
    this.stopPrice,
    this.commission,
    this.extendedHours,
    this.trailPercent,
    this.trailPrice,
    this.filledAt,
    this.filledAvgPrice,
    this.fundCanBeCancelled,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      symbol:
          json['symbol'].toString().contains('.HE') ? json['symbol'].toString().replaceAll('.HE', 'H') : json['symbol'],
      orderAmount: json['orderAmount'],
      orderPrice: json['orderPrice'],
      orderUnit: json['orderUnit'],
      orderDate: json['orderDate'],
      orderTime: json['orderTime'],
      transactionPrice: json['transactionPrice'],
      equityGroupCode: json['equityGroupCode'],
      transactionExtId: json["transactionExtId"],
      realizedUnit: json['realizedUnit'],
      remainingUnit: json['remainingUnit'],
      transactionType: json['transactionType'],
      validity: json['validity'] != null ? json['validity'].toString() : json['validity'],
      accountExtId: json['accountExtId'],
      customerExtId: json['customerExtId'],
      transactionId: json['transactionId'],
      parentTransactionId: json['parentTransactionId'],
      orderStatus: json['orderStatus'],
      conditionSymbol: json['conditionSymbol'],
      conditionType: json['conditionType'] == 'greaterthan' ? '2' : '3',
      conditionPrice: json['conditionPrice'],
      chainNo: json['chainNo'],
      session: json['session'],
      asset: json['asset'],
      sideType: json['sideType'],
      price: json['price'],
      rate: json['rate'],
      amount: json['amount'],
      units: json['units'],
      status: json['status'],
      valueDate: json['valueDate'],
      created: json['created'],
      createdBy: json['createdBy'],
      symbolType: json['symbolType'],
      orderType: json['orderType'],
      endingMarketSessionDate: json['endingMarketSessionDate'],
      multiplier: json['unitNominal'],
      underlying: json['underlying'] ?? '',
      tpPrice: json['tpPrice'],
      slPrice: json['slPrice'],
      periodEndDate: json['periodEndDate'],
      periodicTransactionId: json['periodicTransactionId'],
      decimalCount: json['decimalCount'],
      shortFall: json['shortFall'] ?? false,
      viopSession: json['initialMarketSessionSel'] != null && json['endingMarketSessionSel'] != null
          ? ViopSessionEnum.values.firstWhere((element) =>
              element.initialMarketSessionSel == json['initialMarketSessionSel'] &&
              element.endingMarketSessionSel == json['endingMarketSessionSel'])
          : null,
      fundCanBeCancelled: json['canBeCancelled'] == 'TRUE',
    );
  }

  TransactionModel copyWith({
    String? symbol,
    double? orderAmount,
    num? orderUnit,
    double? transactionPrice,
    double? orderPrice,
    String? orderDate,
    String? orderTime,
    String? equityGroupCode,
    double? realizedUnit,
    double? remainingUnit,
    String? transactionType,
    String? validity,
    String? accountExtId,
    String? customerExtId,
    String? transactionExtId,
    String? transactionId,
    String? parentTransactionId,
    String? orderStatus,
    String? conditionSymbol,
    String? conditionType,
    double? conditionPrice,
    int? chainNo,
    int? session,
    String? asset,
    int? sideType,
    double? price,
    double? rate,
    double? amount,
    double? units,
    String? status,
    String? valueDate,
    String? created,
    String? createdBy,
    SymbolTypeEnum? symbolType,
    String? orderType,
    String? endingMarketSessionDate,
    double? multiplier,
    String? underlying,
    double? tpPrice,
    double? slPrice,
    DateTime? periodEndDate,
    String? periodicTransactionId,
    int? decimalCount,
    bool? shortFall,
    ViopSessionEnum? viopSession,
    String? id,
    bool? fundCanBeCancelled,
    bool? isAmericanStockExchangeOrder,
    double? stopPrice,
    String? commission,
    bool? extendedHours,
    String? trailPercent,
    String? trailPrice,
    String? filledAt,
    String? filledAvgPrice,
  }) {
    return TransactionModel(
      symbol: symbol ?? this.symbol,
      orderAmount: orderAmount ?? this.orderAmount,
      orderUnit: orderUnit ?? this.orderUnit,
      transactionPrice: transactionPrice ?? this.transactionPrice,
      orderPrice: orderPrice ?? this.orderPrice,
      orderDate: orderDate ?? this.orderDate,
      orderTime: orderTime ?? this.orderTime,
      equityGroupCode: equityGroupCode ?? this.equityGroupCode,
      realizedUnit: realizedUnit ?? this.realizedUnit,
      remainingUnit: remainingUnit ?? this.remainingUnit,
      transactionType: transactionType ?? this.transactionType,
      validity: validity ?? this.validity,
      accountExtId: accountExtId ?? this.accountExtId,
      customerExtId: customerExtId ?? this.customerExtId,
      transactionExtId: transactionExtId ?? this.transactionExtId,
      transactionId: transactionId ?? this.transactionId,
      parentTransactionId: parentTransactionId ?? this.parentTransactionId,
      orderStatus: orderStatus ?? this.orderStatus,
      conditionSymbol: conditionSymbol ?? this.conditionSymbol,
      conditionType: conditionType ?? this.conditionType,
      conditionPrice: conditionPrice ?? this.conditionPrice,
      chainNo: chainNo ?? this.chainNo,
      session: session ?? this.session,
      asset: asset ?? this.asset,
      sideType: sideType ?? this.sideType,
      price: price ?? this.price,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
      units: units ?? this.units,
      status: status ?? this.status,
      valueDate: valueDate ?? this.valueDate,
      created: created ?? this.created,
      createdBy: createdBy ?? this.createdBy,
      symbolType: symbolType ?? this.symbolType,
      orderType: orderType ?? this.orderType,
      endingMarketSessionDate: endingMarketSessionDate ?? this.endingMarketSessionDate,
      multiplier: multiplier ?? this.multiplier,
      underlying: underlying ?? this.underlying,
      tpPrice: tpPrice ?? this.tpPrice,
      slPrice: slPrice ?? this.slPrice,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      periodicTransactionId: periodicTransactionId ?? this.periodicTransactionId,
      decimalCount: decimalCount ?? this.decimalCount,
      shortFall: shortFall ?? this.shortFall,
      id: id ?? this.id,
      fundCanBeCancelled: fundCanBeCancelled ?? this.fundCanBeCancelled,
      isAmericanStockExchangeOrder: isAmericanStockExchangeOrder ?? this.isAmericanStockExchangeOrder,
      stopPrice: stopPrice ?? this.stopPrice,
      commission: commission ?? this.commission,
      extendedHours: extendedHours ?? this.extendedHours,
      trailPercent: trailPercent ?? this.trailPercent,
      trailPrice: trailPrice ?? this.trailPrice,
      filledAt: filledAt ?? this.filledAt,
      filledAvgPrice: filledAvgPrice ?? this.filledAvgPrice,
      viopSession: viopSession ?? this.viopSession,
    );
  }
}
