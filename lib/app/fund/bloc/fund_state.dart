import 'package:piapiri_v2/app/fund/model/fund_comparion_enum.dart';
import 'package:piapiri_v2/app/fund/model/fund_comparion_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_financial_founder_list_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_performance_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_price_graph_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_subtype_list_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_themes_model.dart';
import 'package:piapiri_v2/app/fund/model/fund_volume_history_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';

class FundState extends PState {
  final String selectedCode;
  final List<(String, String)> institutionList;
  final FundFilterModel fundFilter;
  final List<Map<String, String>> subTypeFilter;
  final List<Map<String, String>> fundTitleList;
  final List<FundModel> fundList;
  final List<FundModel> allFundList;
  final double tradeLimit;
  final String valorDate;
  final List<FundComparionModel>? fundProfitsList;
  final List<FundComparionModel>? fundManagementFeesList;
  final List<FundComparionModel>? fundPortfolioSizesList;
  final FundComparionEnum selectedFundComparionType;
  final List<GetFinancialFounderListModel>? founderInfoList;
  final FundPerformanceModel? performanceRanking;
  final List<FundModel>? filterSortList;
  final List<FundPriceGraphModel>? fundGraphPriceList;
  final List<FundVolumeHistoryModel>? fundVolumeHistoryDataList;
  final List<FundApplicationCategoryListModel>? applicationCategories;
  final List<FundThemesModel>? fundThemeList;
  final PageState fundDetailPageState;
  final FundDetailModel? fundDetail;
  final CurrencyEnum currencyType;
  final ChartType chartType;
  final ChartFilter chartFilter;

  const FundState({
    super.type = PageState.initial,
    super.error,
    this.fundFilter = const FundFilterModel(),
    this.selectedCode = 'UNP',
    this.institutionList = const [],
    this.subTypeFilter = const [],
    this.fundTitleList = const [],
    this.fundList = const [],
    this.allFundList = const [],
    this.tradeLimit = 0,
    this.valorDate = '',
    this.fundProfitsList,
    this.fundManagementFeesList,
    this.fundPortfolioSizesList,
    this.selectedFundComparionType = FundComparionEnum.initial,
    this.founderInfoList,
    this.performanceRanking,
    this.filterSortList,
    this.fundGraphPriceList,
    this.fundVolumeHistoryDataList,
    this.applicationCategories,
    this.fundThemeList,
    this.fundDetailPageState = PageState.initial,
    this.fundDetail,
    this.currencyType = CurrencyEnum.turkishLira,
    this.chartType = ChartType.area,
    this.chartFilter = ChartFilter.oneDay,
  });

  @override
  FundState copyWith({
    PageState? type,
    PBlocError? error,
    FundFilterModel? fundFilter,
    String? selectedCode,
    List<(String, String)>? institutionList,
    List<Map<String, String>>? subTypeFilter,
    List<Map<String, String>>? fundTitleList,
    List<FundModel>? fundList,
    List<FundModel>? allFundList,
    double? tradeLimit,
    String? valorDate,
    List<FundComparionModel>? fundProfitsList,
    List<FundComparionModel>? fundManagementFeesList,
    List<FundComparionModel>? fundPortfolioSizesList,
    FundComparionEnum? selectedFundComparionType,
    List<GetFinancialFounderListModel>? founderInfoList,
    FundPerformanceModel? performanceRanking,
    List<FundModel>? filterSortList,
    List<FundPriceGraphModel>? fundGraphPriceList,
    List<FundVolumeHistoryModel>? fundVolumeHistoryDataList,
    List<FundApplicationCategoryListModel>? applicationCategories,
    List<FundThemesModel>? fundThemeList,
    PageState? fundDetailPageState,
    FundDetailModel? fundDetail,
    final CurrencyEnum? currencyType,
    final ChartType? chartType,
    final ChartFilter? chartFilter,
  }) {
    return FundState(
      type: type ?? this.type,
      error: error ?? this.error,
      fundFilter: fundFilter ?? this.fundFilter,
      selectedCode: selectedCode ?? this.selectedCode,
      institutionList: institutionList ?? this.institutionList,
      subTypeFilter: subTypeFilter ?? this.subTypeFilter,
      fundTitleList: fundTitleList ?? this.fundTitleList,
      fundList: fundList ?? this.fundList,
      allFundList: allFundList ?? this.allFundList,
      tradeLimit: tradeLimit ?? this.tradeLimit,
      valorDate: valorDate ?? this.valorDate,
      fundProfitsList: fundProfitsList ?? this.fundProfitsList,
      fundManagementFeesList: fundManagementFeesList ?? this.fundManagementFeesList,
      fundPortfolioSizesList: fundPortfolioSizesList ?? this.fundPortfolioSizesList,
      selectedFundComparionType: selectedFundComparionType ?? this.selectedFundComparionType,
      founderInfoList: founderInfoList ?? this.founderInfoList,
      performanceRanking: performanceRanking ?? this.performanceRanking,
      filterSortList: filterSortList ?? this.filterSortList,
      fundGraphPriceList: fundGraphPriceList ?? this.fundGraphPriceList,
      fundVolumeHistoryDataList: fundVolumeHistoryDataList ?? this.fundVolumeHistoryDataList,
      applicationCategories: applicationCategories ?? this.applicationCategories,
      fundThemeList: fundThemeList ?? this.fundThemeList,
      fundDetailPageState: fundDetailPageState ?? this.fundDetailPageState,
      fundDetail: fundDetail ?? this.fundDetail,
      currencyType: currencyType ?? this.currencyType,
      chartType: chartType ?? this.chartType,
      chartFilter: chartFilter ?? this.chartFilter,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        fundFilter,
        selectedCode,
        institutionList,
        subTypeFilter,
        fundTitleList,
        fundList,
        allFundList,
        tradeLimit,
        valorDate,
        fundProfitsList,
        fundManagementFeesList,
        fundPortfolioSizesList,
        selectedFundComparionType,
        founderInfoList,
        performanceRanking,
        filterSortList,
        fundGraphPriceList,
        fundVolumeHistoryDataList,
        applicationCategories,
        fundThemeList,
        fundDetailPageState,
        fundDetail,
        currencyType,
        chartType,
        chartFilter,
      ];
}
