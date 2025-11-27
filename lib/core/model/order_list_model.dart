import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';

class OrderListModel extends Equatable {
  final List<TransactionModel> equityList;
  final List<TransactionModel> warrantList;
  final List<TransactionModel> viopList;
  final List<TransactionModel> fundList;
  final List<TransactionModel> fincList;
  final List<TransactionModel> americanStockExchangeList;

  const OrderListModel({
    this.equityList = const [],
    this.warrantList = const [],
    this.viopList = const [],
    this.fundList = const [],
    this.fincList = const [],
    this.americanStockExchangeList = const [],
  });

  @override
  List<Object?> get props => [
        equityList,
        warrantList,
        viopList,
        fundList,
        fincList,
        americanStockExchangeList,
      ];
}
