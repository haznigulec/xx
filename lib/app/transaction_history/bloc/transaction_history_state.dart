import 'package:piapiri_v2/app/transaction_history/model/transaction_history_capra_model.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_filter_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class TransactionHistoryState extends PState {
  final Map<String, List<Map<String, dynamic>>> transactionHistory;
  final Map<String, List<TransactionHistoryCapraModel>>? transactionCapraHistoryFilter;
  final Map<String, List<TransactionHistoryCapraModel>>? transactionCapraHistoryGrouped;
  final String? transactionFilterSide;
  final TransactionHistoryFilterModel transactionHistoryFilter;
  final List<TransactionHistoryCapraModel>? accountActivitiesList;

  const TransactionHistoryState({
    super.type = PageState.initial,
    super.error,
    this.transactionHistory = const {},
    this.transactionCapraHistoryFilter = const {},
    this.transactionCapraHistoryGrouped = const {},
    this.transactionFilterSide = '',
    this.transactionHistoryFilter = const TransactionHistoryFilterModel(),
    this.accountActivitiesList = const [],
  });

  @override
  TransactionHistoryState copyWith({
    PageState? type,
    PBlocError? error,
    Map<String, List<Map<String, dynamic>>>? transactionHistory,
    Map<String, List<TransactionHistoryCapraModel>>? transactionCapraHistoryFilter,
    Map<String, List<TransactionHistoryCapraModel>>? transactionCapraHistoryGrouped,
    String? transactionFilterSide,
    TransactionHistoryFilterModel? transactionHistoryFilter,
    List<TransactionHistoryCapraModel>? accountActivitiesList,
  }) {
    return TransactionHistoryState(
      type: type ?? this.type,
      error: error ?? this.error,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      transactionCapraHistoryFilter: transactionCapraHistoryFilter ?? this.transactionCapraHistoryFilter,
      transactionCapraHistoryGrouped: transactionCapraHistoryGrouped ?? this.transactionCapraHistoryGrouped,
      transactionFilterSide: transactionFilterSide ?? this.transactionFilterSide,
      transactionHistoryFilter: transactionHistoryFilter ?? this.transactionHistoryFilter,
      accountActivitiesList: accountActivitiesList ?? this.accountActivitiesList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        transactionHistory,
        transactionCapraHistoryFilter,
        transactionCapraHistoryGrouped,
        transactionFilterSide,
        transactionHistoryFilter,
        accountActivitiesList,
      ];
}
