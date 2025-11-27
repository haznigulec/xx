import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

abstract class AssetsEvent extends PEvent {}

class GetOverallSummaryEvent extends AssetsEvent {
  final String accountId;
  final bool isConsolidated;
  final bool allAccounts;
  final bool getInstant;
  final String? overallDate;
  final bool includeCashFlow;
  final bool includeCreditDetail;
  final bool calculateTradeLimit;
  final Function(AssetModel assetsModel)? callback;
  final String? fundSymbol;
  final bool isShowTotalAsset;
  final bool isFromAgreement;

  GetOverallSummaryEvent({
    required this.accountId,
    this.isConsolidated = true,
    this.allAccounts = false,
    this.getInstant = true,
    this.overallDate,
    this.includeCashFlow = false,
    this.includeCreditDetail = false,
    this.calculateTradeLimit = false,
    this.callback,
    this.fundSymbol,
    this.isShowTotalAsset = false,
    this.isFromAgreement = false,
  });
}

class GetAllCashFlowEvent extends AssetsEvent {
  final String accountExtId;
  final bool allAccounts;
  final bool isFromWidget;

  GetAllCashFlowEvent({
    required this.accountExtId,
    required this.allAccounts,
    this.isFromWidget = false,
  });
}

class TotalCashFlowEvent extends AssetsEvent {}

class GetAssetsCollateralInfoEvent extends AssetsEvent {
  final String accountId;
  final Function(CollateralInfo?)? callback;

  GetAssetsCollateralInfoEvent({
    required this.accountId,
    this.callback,
  });
}

class GetLimitInfosEvent extends AssetsEvent {
  final String accountExtId;
  final String? typeName;
  final Function(Map<String, dynamic>?)? calback;

  GetLimitInfosEvent({
    required this.accountExtId,
    this.typeName,
    this.calback,
  });
}

class GetCapraPortfolioSummaryEvent extends AssetsEvent {
  final Function()? onFecthed;

  GetCapraPortfolioSummaryEvent({
    this.onFecthed,
  });
}

class GetCapraCollateralInfoEvent extends AssetsEvent {
  final Function(double)? callback;
  GetCapraCollateralInfoEvent([
    this.callback,
  ]);
}

class HasRefreshEvent extends AssetsEvent {
  final bool? hasRefresh;
  HasRefreshEvent([
    this.hasRefresh,
  ]);
}

class ResetAssetsStateEvent extends AssetsEvent {}
