import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class CreateUsOrdersState extends PState {
  final double cashLimit;
  final double tradeLimit;
  final List<UsOverallSubItem> positionList;
  final List<MarketListModel> positionDetailedList;
  final double minCommission;
  final double commissionPerUnit;

  const CreateUsOrdersState({
    super.type = PageState.initial,
    super.error,
    this.cashLimit = 0,
    this.tradeLimit = 0,
    this.positionList = const [],
    this.positionDetailedList = const [],
    this.minCommission = 1.3,
    this.commissionPerUnit = 0.005,
  });

  @override
  CreateUsOrdersState copyWith({
    PageState? type,
    PBlocError? error,
    double? cashLimit,
    double? tradeLimit,
    List<UsOverallSubItem>? positionList,
    List<MarketListModel>? positionDetailedList,
    double? minCommission,
    String? comissionType,
    double? commissionPerUnit,
  }) {
    return CreateUsOrdersState(
      type: type ?? this.type,
      error: error ?? this.error,
      cashLimit: cashLimit ?? this.cashLimit,
      tradeLimit: tradeLimit ?? this.tradeLimit,
      positionList: positionList ?? this.positionList,
      positionDetailedList: positionDetailedList ?? this.positionDetailedList,
      minCommission: minCommission ?? this.minCommission,
      commissionPerUnit: commissionPerUnit ?? this.commissionPerUnit,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        cashLimit,
        tradeLimit,
        positionList,
        positionDetailedList,
        minCommission,
        commissionPerUnit,
      ];
}
