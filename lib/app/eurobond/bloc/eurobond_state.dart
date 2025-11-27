import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_validate_order_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

class EuroBondState extends PState {
  final EuroBondListModel? bondListModel;
  final double? transactionLimit;
  final EuroBondValidateOrderModel? validateOrderModel;
  final PageState tradeLimitType;
  final PageState bondDescriptionType;
  final String? bondDescription;
  final OverallSubItemModel? eurobondAssets;

  const EuroBondState({
    super.type = PageState.initial,
    this.bondDescriptionType = PageState.initial,
    this.tradeLimitType = PageState.initial,
    super.error,
    this.bondListModel,
    this.transactionLimit,
    this.validateOrderModel,
    this.bondDescription,
    this.eurobondAssets,
  });

  @override
  EuroBondState copyWith({
    PageState? type,
    PageState? tradeLimitType,
    PageState? bondDescriptionType,
    PBlocError? error,
    EuroBondListModel? bondListModel,
    double? transactionLimit,
    EuroBondValidateOrderModel? validateOrderModel,
    String? bondDescription,
    OverallSubItemModel? eurobondAssets,
  }) {
    return EuroBondState(
      type: type ?? this.type,
      tradeLimitType: tradeLimitType ?? this.tradeLimitType,
      bondDescriptionType: bondDescriptionType ?? this.bondDescriptionType,
      error: error ?? this.error,
      bondListModel: bondListModel ?? this.bondListModel,
      transactionLimit: transactionLimit ?? this.transactionLimit,
      validateOrderModel: validateOrderModel ?? this.validateOrderModel,
      bondDescription: bondDescription ?? this.bondDescription,
      eurobondAssets: eurobondAssets ?? this.eurobondAssets,
    );
  }

  @override
  List<Object?> get props => [
        type,
        tradeLimitType,
        bondDescriptionType,
        error,
        bondListModel,
        transactionLimit,
        validateOrderModel,
        bondDescription,
        eurobondAssets,
      ];
}
