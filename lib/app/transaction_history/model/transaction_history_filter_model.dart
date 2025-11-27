import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/core/model/account_model.dart';

class TransactionHistoryFilterModel extends Equatable {
  final AccountModel? account;
  final TransactionHistoryTypeEnum? transactionType;
  final TransactionMainTypeEnum? transactionMainType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? finInstName;
  final String? americanStockExchanges;

  const TransactionHistoryFilterModel({
    this.account,
    this.transactionType,
    this.transactionMainType,
    this.startDate,
    this.endDate,
    this.finInstName,
    this.americanStockExchanges,
  });

  TransactionHistoryFilterModel copyWith({
    AccountModel? account,
    TransactionHistoryTypeEnum? transactionType,
    TransactionMainTypeEnum? transactionMainType,
    DateTime? startDate,
    DateTime? endDate,
    String? finInstName,
    String? americanStockExchanges,
  }) {
    return TransactionHistoryFilterModel(
      account: account ?? this.account,
      transactionType: transactionType,
      transactionMainType: transactionMainType ?? this.transactionMainType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      finInstName: finInstName ?? this.finInstName,
      americanStockExchanges: americanStockExchanges ?? this.americanStockExchanges,
    );
  }

  TransactionHistoryFilterModel clearAccount() {
    return TransactionHistoryFilterModel(
      account: null,
      transactionType: transactionType,
      transactionMainType: transactionMainType,
      startDate: startDate,
      endDate: endDate,
      finInstName: finInstName,
      americanStockExchanges: americanStockExchanges,
    );
  }

  TransactionHistoryFilterModel clearTransactionType() {
    return TransactionHistoryFilterModel(
      account: account,
      transactionType: null,
      transactionMainType: transactionMainType,
      startDate: startDate,
      endDate: endDate,
      finInstName: finInstName,
      americanStockExchanges: americanStockExchanges,
    );
  }

  TransactionHistoryFilterModel clearTransactionMainType() {
    return TransactionHistoryFilterModel(
      account: account,
      transactionType: transactionType,
      transactionMainType: null,
      startDate: startDate,
      endDate: endDate,
      finInstName: finInstName,
      americanStockExchanges: americanStockExchanges,
    );
  }

  TransactionHistoryFilterModel clearDateRange() {
    return TransactionHistoryFilterModel(
      account: account,
      transactionType: transactionType,
      transactionMainType: transactionMainType,
      startDate: null,
      endDate: null,
      finInstName: finInstName,
      americanStockExchanges: americanStockExchanges,
    );
  }

  TransactionHistoryFilterModel clearFinInstName() {
    return TransactionHistoryFilterModel(
      account: account,
      transactionType: transactionType,
      transactionMainType: transactionMainType,
      startDate: startDate,
      endDate: endDate,
      finInstName: null,
      americanStockExchanges: americanStockExchanges,
    );
  }

  TransactionHistoryFilterModel clearAmericanStockExchanges() {
    return TransactionHistoryFilterModel(
      account: account,
      transactionType: transactionType,
      transactionMainType: transactionMainType,
      startDate: startDate,
      endDate: endDate,
      finInstName: finInstName,
      americanStockExchanges: null,
    );
  }

  TransactionHistoryFilterModel clearAllFilter() {
    return const TransactionHistoryFilterModel(
      account: null,
      transactionType: null,
      transactionMainType: null,
      startDate: null,
      endDate: null,
      finInstName: null,
      americanStockExchanges: null,
    );
  }

  @override
  List<Object?> get props => [
        account,
        transactionType,
        transactionMainType,
        startDate,
        endDate,
        finInstName,
        americanStockExchanges,
      ];
}
