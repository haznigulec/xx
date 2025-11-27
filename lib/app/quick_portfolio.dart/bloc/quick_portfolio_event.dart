import 'package:piapiri_v2/app/quick_portfolio.dart/model/model_portfolio_item_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/robotic_and_fund_basket_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class QuickPortfolioEvent extends PEvent {}

class GetRoboticBasketsEvent extends QuickPortfolioEvent {
  final int portfolioId;

  GetRoboticBasketsEvent({
    required this.portfolioId,
  });
}

class GetModelPortfolioEvent extends QuickPortfolioEvent {
  final Function(List<ModelPortfolioModel>)? callback;
  GetModelPortfolioEvent({
    this.callback,
  });
}

class GetModelPortfolioByIdEvent extends QuickPortfolioEvent {
  final int id;
  GetModelPortfolioByIdEvent({
    required this.id,
  });
}

class GetSpecificListEvent extends QuickPortfolioEvent {
  final String mainGroup;
  GetSpecificListEvent({
    required this.mainGroup,
  });
}

class GetFundInfoFromSpecialListByIdEvent extends QuickPortfolioEvent {
  final String specialListId;
  GetFundInfoFromSpecialListByIdEvent({
    required this.specialListId,
  });
}

class GetFundFounderCodeEvent extends QuickPortfolioEvent {
  final List<String> codes;
  final Function(List<String>)? callback;
  GetFundFounderCodeEvent({
    required this.codes,
    this.callback,
  });
}

class GetPreparedPortfolioEvent extends QuickPortfolioEvent {
  final String portfolioKey;
  final Function(List<RoboticAndFundBasketModel>)? callback;

  GetPreparedPortfolioEvent({
    required this.portfolioKey,
    this.callback,
  });
}

class GetDetailsOfSymbolsEvent extends QuickPortfolioEvent {
  final List<String> codes;
  final Function(List<MarketListModel>)? callback;

  GetDetailsOfSymbolsEvent({
    required this.codes,
    this.callback,
  });
}
