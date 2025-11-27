import 'package:piapiri_v2/app/assets/model/capra_collateral_info_model.dart';
import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

class AssetsState extends PState {
  final AssetModel? consolidatedAssets;
  final PageState consolidateAssetState;
  final double? saleableUnit;
  final double? saleableAmount;
  final List<dynamic>? allCashFlowList;
  final CollateralInfo? collateralInfo;
  final Map<String, dynamic>? limitInfos;
  final List<dynamic>? totalCashFlowList;
  final UsCapraSummaryModel? portfolioSummaryModel;
  final CapraCollateralInfoModel? capraCollateralInfo;
  final PageState capraCollateralAsset;
  final PageState usPortfolioState;
  final double? totalAsset;
  final bool? hasRefresh;
  final OverallItemModel? portfolioViop;
  final AssetModel? agreementConsolidatedAssets;
  final OverallItemModel? agreementViop;
  final bool? ipoStatus;

  const AssetsState({
    super.type = PageState.initial,
    super.error,
    this.consolidatedAssets,
    this.allCashFlowList,
    this.totalCashFlowList,
    this.collateralInfo,
    this.consolidateAssetState = PageState.initial,
    this.limitInfos,
    this.saleableUnit,
    this.saleableAmount,
    this.portfolioSummaryModel,
    this.capraCollateralInfo,
    this.capraCollateralAsset = PageState.initial,
    this.usPortfolioState = PageState.initial,
    this.totalAsset = 0.0,
    this.hasRefresh,
    this.portfolioViop,
    this.agreementConsolidatedAssets,
    this.agreementViop,
    this.ipoStatus = false,
  });

  @override
  AssetsState copyWith({
    PageState? type,
    PBlocError? error,
    AssetModel? consolidatedAssets,
    PageState? consolidateAssetState,
    double? saleableUnit,
    double? saleableAmount,
    List<dynamic>? allCashFlowList,
    CollateralInfo? collateralInfo,
    Map<String, dynamic>? limitInfos,
    List<dynamic>? totalCashFlowList,
    UsCapraSummaryModel? portfolioSummaryModel,
    CapraCollateralInfoModel? capraCollateralInfo,
    PageState? capraCollateralAsset,
    PageState? usPortfolioState,
    double? totalAsset,
    bool? hasRefresh,
    OverallItemModel? portfolioViop,
    AssetModel? agreementConsolidatedAssets,
    OverallItemModel? agreementViop,
    bool? ipoStatus,
  }) {
    return AssetsState(
      type: type ?? this.type,
      error: error ?? this.error,
      consolidatedAssets: consolidatedAssets ?? this.consolidatedAssets,
      allCashFlowList: allCashFlowList ?? this.allCashFlowList,
      totalCashFlowList: totalCashFlowList ?? this.totalCashFlowList,
      collateralInfo: collateralInfo ?? this.collateralInfo,
      consolidateAssetState: consolidateAssetState ?? this.consolidateAssetState,
      saleableUnit: saleableUnit ?? this.saleableUnit,
      saleableAmount: saleableAmount ?? this.saleableAmount,
      limitInfos: limitInfos ?? this.limitInfos,
      portfolioSummaryModel: portfolioSummaryModel ?? this.portfolioSummaryModel,
      capraCollateralInfo: capraCollateralInfo ?? this.capraCollateralInfo,
      capraCollateralAsset: capraCollateralAsset ?? this.capraCollateralAsset,
      usPortfolioState: usPortfolioState ?? this.usPortfolioState,
      totalAsset: totalAsset ?? this.totalAsset,
      hasRefresh: hasRefresh ?? this.hasRefresh,
      portfolioViop: portfolioViop ?? this.portfolioViop,
      agreementConsolidatedAssets: agreementConsolidatedAssets ?? this.agreementConsolidatedAssets,
      agreementViop: agreementViop ?? this.agreementViop,
      ipoStatus: ipoStatus ?? this.ipoStatus,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        consolidatedAssets,
        allCashFlowList,
        collateralInfo,
        consolidateAssetState,
        limitInfos,
        saleableUnit,
        saleableAmount,
        totalCashFlowList,
        portfolioSummaryModel,
        capraCollateralInfo,
        capraCollateralAsset,
        usPortfolioState,
        totalAsset,
        hasRefresh,
        portfolioViop,
        agreementConsolidatedAssets,
        agreementViop,
        ipoStatus,
      ];
}
