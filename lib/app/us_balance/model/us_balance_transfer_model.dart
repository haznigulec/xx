import 'package:equatable/equatable.dart';

class UsBalanceTransferModel extends Equatable {
  final String? id;
  final String? entryType;
  final String? fromAccount;
  final String? toAccount;
  final String? status;
  final String? symbol;
  final String? qty;
  final String? price;
  final String? token;
  final bool? success;
  final String? successMessage;

  const UsBalanceTransferModel({
    this.id,
    this.entryType,
    this.fromAccount,
    this.toAccount,
    this.status,
    this.symbol,
    this.qty,
    this.price,
    this.token,
    this.success,
    this.successMessage,
  });

  factory UsBalanceTransferModel.fromJson(Map<String, dynamic> json) {
    return UsBalanceTransferModel(
      id: json['id'],
      entryType: json['entry_type'],
      fromAccount: json['from_account'],
      toAccount: json['to_account'],
      status: json['status'],
      symbol: json['symbol'],
      qty: json['qty'],
      price: json['price'],
      token: json['token'],
      success: json['success'],
      successMessage: json['successMessage'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        entryType,
        fromAccount,
        toAccount,
        status,
        symbol,
        qty,
        price,
        token,
        success,
        successMessage,
      ];
}
