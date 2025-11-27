import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/profit/model/customer_target_model.dart';
import 'package:piapiri_v2/app/profit/model/potential_profit_loss_model.dart';
import 'package:piapiri_v2/app/profit/model/tax_detail_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

class ProfitState extends PState {
  final CustomerTargetModel? customerTarget;
  final PotentialProfitLossModel? potentialProfitLossModel;
  final TaxDetailModel? taxDetailModel;
  final DateTime? profitStartDate;
  final DateTime? profitEndDate;
  final PageState consolidateAssetState;
  final AssetModel? consolidatedAssets;
  final PageState usPortfolioState;
  final UsCapraSummaryModel? portfolioSummaryModel;

  const ProfitState({
    this.customerTarget,
    this.potentialProfitLossModel,
    this.taxDetailModel,
    this.profitStartDate,
    this.profitEndDate,
    super.type = PageState.initial,
    super.error,
    this.consolidateAssetState = PageState.initial,
    this.consolidatedAssets,
    this.usPortfolioState = PageState.initial,
    this.portfolioSummaryModel,
  });

  @override
  ProfitState copyWith({
    PageState? type,
    PBlocError? error,
    CustomerTargetModel? customerTarget,
    PotentialProfitLossModel? potentialProfitLossModel,
    TaxDetailModel? taxDetailModel,
    DateTime? profitStartDate,
    DateTime? profitEndDate,
    PageState? consolidateAssetState,
    AssetModel? consolidatedAssets,
    PageState? usPortfolioState,
    UsCapraSummaryModel? portfolioSummaryModel,
  }) {
    return ProfitState(
      type: type ?? this.type,
      error: error ?? this.error,
      customerTarget: customerTarget ?? this.customerTarget,
      potentialProfitLossModel: potentialProfitLossModel ?? this.potentialProfitLossModel,
      taxDetailModel: taxDetailModel ?? this.taxDetailModel,
      profitStartDate: profitStartDate ?? this.profitStartDate,
      profitEndDate: profitEndDate ?? this.profitEndDate,
      consolidateAssetState: consolidateAssetState ?? this.consolidateAssetState,
      consolidatedAssets: consolidatedAssets ?? this.consolidatedAssets,
      usPortfolioState: usPortfolioState ?? this.usPortfolioState,
      portfolioSummaryModel: portfolioSummaryModel ?? this.portfolioSummaryModel,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        customerTarget,
        potentialProfitLossModel,
        taxDetailModel,
        profitStartDate,
        profitEndDate,
        consolidateAssetState,
        consolidatedAssets,
        usPortfolioState,
        portfolioSummaryModel,
      ];
}
