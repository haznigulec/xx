import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_type_enum.dart';

class ViopState extends PState {
  final String selectedUnderlying;
  final String? selectedMaturity;
  final SymbolTypes? selectedContractType;
  final TransactionTypeEnum? selectedTransactionType;
  final List<MarketListModel> symbolList;
  final List<String> underlyingList;
  final List<String> maturityList;
  final List<String> subMarketList;


  const ViopState({
    super.type = PageState.success,
    super.error,
    this.selectedUnderlying = 'XU030',
    this.selectedMaturity,
    this.selectedContractType,
    this.selectedTransactionType,
    this.symbolList = const [],
    this.underlyingList = const [],
    this.maturityList = const [],
    this.subMarketList = const [],
  });

  @override
  ViopState copyWith({
    PageState? type,
    PBlocError? error,
    String? selectedUnderlying,
    String? selectedMaturity,
    SymbolTypes? selectedContractType,
    TransactionTypeEnum? selectedTransactionType,
    List<MarketListModel>? symbolList,
    List<String>? underlyingList,
    List<String>? maturityList,
    List<String>? subMarketList,
  }) {
    return ViopState(
      type: type ?? this.type,
      error: error ?? this.error,
      selectedUnderlying: selectedUnderlying ?? this.selectedUnderlying,
      selectedMaturity: selectedMaturity ?? this.selectedMaturity,
      selectedContractType: selectedContractType ?? this.selectedContractType,
      selectedTransactionType: selectedTransactionType ?? this.selectedTransactionType,
      symbolList: symbolList ?? this.symbolList,
      underlyingList: underlyingList ?? this.underlyingList,
      maturityList: maturityList ?? this.maturityList,
      subMarketList: subMarketList ?? this.subMarketList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        selectedUnderlying,
        selectedMaturity,
        selectedContractType,
        selectedTransactionType,
        symbolList,
        underlyingList,
        maturityList,
        subMarketList,
      ];
}
