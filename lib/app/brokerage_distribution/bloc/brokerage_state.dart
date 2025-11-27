import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/brokerage_model.dart';

class BrokerageState extends PState {
  final BrokerageModel? data;
  final int topBuyers;
  final int topSellers;

  const BrokerageState({
    super.type = PageState.initial,
    super.error,
    this.data,
    this.topBuyers = 0,
    this.topSellers = 0,
  });

  @override
  BrokerageState copyWith({
    PageState? type,
    PBlocError? error,
    BrokerageModel? data,
    int? topBuyers,
    int? topSellers,
  }) {
    return BrokerageState(
      type: type ?? this.type,
      error: error ?? this.error,
      data: data ?? this.data,
      topBuyers: topBuyers ?? this.topBuyers,
      topSellers: topSellers ?? this.topSellers,
    );
  }
}
