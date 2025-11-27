import 'package:piapiri_v2/app/quick_portfolio.dart/model/fund_special_list_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/model_portfolio_detail_info_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/model_portfolio_item_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/robotic_and_fund_basket_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class QuickPortfolioState extends PState {
  final List<QuickPortfolioAssetModel> roboticPortfolios;
  final List<ModelPortfolioModel> modelPortfolios;
  final String modelPortfoliosLangKey;
  final Map<String, List<RoboticAndFundBasketModel>> fundPortfolios;
  final String robotikSepetFundPortfoliosLangKey;
  final String specificListLangKey;
  final List<SpecificListModel> specificList;
  final List<SpecificListModel> homeSpecificList;
  final ModelPortfolioDetailInfoModel? modelPortfolioDetail;
  final List<FundSpecialListModel> fundSpecialList;
  final List<MarketListModel> equitySymbolList;
  final List<MarketListModel> viopSymbolList;
  final List<MarketListModel> warrantSymbolList;
  final List<String> fundFounderList;
  final List<MarketListModel> homepageEquitySymbolList;
  final List<MarketListModel> homepageWarrantSymbolList;
  final List<MarketListModel> homepageViopSymbolList;
  final List<String> homepageFundSymbolList;
  final List<String> homepageUsSymbolList;

  const QuickPortfolioState({
    super.type = PageState.initial,
    super.error,
    this.roboticPortfolios = const [],
    this.modelPortfolios = const [],
    this.modelPortfoliosLangKey = '',
    this.fundPortfolios = const {
      'fon_sepet': [],
    },
    this.robotikSepetFundPortfoliosLangKey = '',
    this.specificListLangKey = '',
    this.specificList = const [],
    this.homeSpecificList = const [],
    this.fundSpecialList = const [],
    this.modelPortfolioDetail,
    this.equitySymbolList = const [],
    this.viopSymbolList = const [],
    this.warrantSymbolList = const [],
    this.fundFounderList = const [],
    this.homepageEquitySymbolList = const [],
    this.homepageWarrantSymbolList = const [],
    this.homepageViopSymbolList = const [],
    this.homepageFundSymbolList = const [],
    this.homepageUsSymbolList = const [],
  });

  @override
  QuickPortfolioState copyWith({
    PageState? type,
    PBlocError? error,
    List<QuickPortfolioAssetModel>? roboticPortfolios,
    List<ModelPortfolioModel>? modelPortfolios,
    String? modelPortfoliosLangKey,
    Map<String, List<RoboticAndFundBasketModel>>? fundPortfolios,
    String? robotikSepetFundPortfoliosLangKey,
    String? specificListLangKey,
    List<SpecificListModel>? specificList,
    List<SpecificListModel>? homeSpecificList,
    List<FundSpecialListModel>? fundSpecialList,
    ModelPortfolioDetailInfoModel? modelPortfolioDetail,
    List<MarketListModel>? equitySymbolList,
    List<MarketListModel>? viopSymbolList,
    List<MarketListModel>? warrantSymbolList,
    List<String>? fundFounderList,
    List<MarketListModel>? homepageEquitySymbolList,
    List<MarketListModel>? homepageWarrantSymbolList,
    List<MarketListModel>? homepageViopSymbolList,
    List<String>? homepageFundSymbolList,
    List<String>? homepageUsSymbolList,
  }) {
    return QuickPortfolioState(
      type: type ?? this.type,
      error: error ?? this.error,
      roboticPortfolios: roboticPortfolios ?? this.roboticPortfolios,
      modelPortfolios: modelPortfolios ?? this.modelPortfolios,
      modelPortfoliosLangKey: modelPortfoliosLangKey ?? this.modelPortfoliosLangKey,
      fundPortfolios: fundPortfolios ?? this.fundPortfolios,
      robotikSepetFundPortfoliosLangKey: robotikSepetFundPortfoliosLangKey ?? this.robotikSepetFundPortfoliosLangKey,
      specificListLangKey: specificListLangKey ?? this.specificListLangKey,
      specificList: specificList ?? this.specificList,
      homeSpecificList: homeSpecificList ?? this.homeSpecificList,
      fundSpecialList: fundSpecialList ?? this.fundSpecialList,
      modelPortfolioDetail: modelPortfolioDetail ?? this.modelPortfolioDetail,
      equitySymbolList: equitySymbolList ?? this.equitySymbolList,
      viopSymbolList: viopSymbolList ?? this.viopSymbolList,
      warrantSymbolList: warrantSymbolList ?? this.warrantSymbolList,
      fundFounderList: fundFounderList ?? this.fundFounderList,
      homepageEquitySymbolList: homepageEquitySymbolList ?? this.homepageEquitySymbolList,
      homepageWarrantSymbolList: homepageWarrantSymbolList ?? this.homepageWarrantSymbolList,
      homepageViopSymbolList: homepageViopSymbolList ?? this.homepageViopSymbolList,
      homepageFundSymbolList: homepageFundSymbolList ?? this.homepageFundSymbolList,
      homepageUsSymbolList: homepageUsSymbolList ?? this.homepageUsSymbolList,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        roboticPortfolios,
        modelPortfolios,
        modelPortfoliosLangKey,
        fundPortfolios,
        robotikSepetFundPortfoliosLangKey,
        specificListLangKey,
        specificList,
        homeSpecificList,
        fundSpecialList,
        modelPortfolioDetail,
        equitySymbolList,
        viopSymbolList,
        warrantSymbolList,
        fundFounderList,
        homepageEquitySymbolList,
        homepageWarrantSymbolList,
        homepageViopSymbolList,
        homepageFundSymbolList,
        homepageUsSymbolList,
      ];
}
