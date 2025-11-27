import 'package:equatable/equatable.dart';

class TransactionHistoryCapraModel extends Equatable {
  final String? id;
  final String? accountId;
  final String? activityType;
  final String? date;
  final String? type;
  final String? price;
  final String? orderId;
  final String? qty;
  final String? side;
  final String? symbol;
  final String? leavesQty;
  final String? cumQty;
  final String? netAmount;
  final String? description;
  final String? status;
  final String? groupedPrice;
  final String? groupedQty;

  const TransactionHistoryCapraModel({
    this.id,
    this.accountId,
    this.activityType,
    this.date,
    this.type,
    this.price,
    this.orderId,
    this.qty,
    this.side,
    this.symbol,
    this.leavesQty,
    this.cumQty,
    this.netAmount,
    this.description,
    this.status,
    this.groupedPrice,
    this.groupedQty,
  });

  factory TransactionHistoryCapraModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryCapraModel(
      id: json['id'],
      accountId: json['account_id'],
      activityType: json['activity_type'],
      date: json['date'],
      type: json['type'],
      price: json['price'],
      orderId: json['order_id'],
      qty: json['qty'],
      side: json['side'],
      symbol: json['symbol'],
      leavesQty: json['leaves_qty'],
      cumQty: json['cum_qty'],
      netAmount: json['net_amount'],
      description: json['description'],
      status: json['status'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        accountId,
        activityType,
        date,
        type,
        price,
        orderId,
        qty,
        side,
        symbol,
        leavesQty,
        cumQty,
        netAmount,
        description,
        status,
        groupedPrice,
        groupedQty,
      ];
}
