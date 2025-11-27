import 'package:piapiri_v2/app/us_symbol_detail/model/dividend_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/current_daily_bar.dart';
import 'package:piapiri_v2/core/model/dividend_model.dart';
import 'package:piapiri_v2/core/model/market_movers_model.dart';
import 'package:piapiri_v2/core/model/us_sector_model.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class UsEquityState extends PState {
  final List<MarketMoversModel> losers;
  final List<MarketMoversModel> gainers;
  final UsSymbolSnapshot? updatedSymbol;
  final List<CurrentDailyBar> graphData;
  final Dividend? dividend;
  final List<CashDividendsList> dividendYearlyList;
  final List<CashDividendsList> dividendTwoYearList;
  final PageState dividendWeeklyState;
  final PageState dividendYearlyState;
  final PageState dividendTwoYearState;

  final PageState? favoriteIncomingDividendsState;
  final PageState? allIncomingDividendsState;

  final List<String> favoriteIncomingDividends;
  final List<String> allIncomingDividends;

  final List<String> activeSymbols;
  final List<String> favoriteSymbols;
  final List<String> fractionableSymbols;

  final CurrencyEnum currencyType;
  final ChartType chartType;
  final ChartFilter chartFilter;

  final String polygonApiKey;
  final String capraWebsocketApikey;
  final List<UsSymbolSnapshot> polygonWatchingItems;
  final List<UsSectorModel> sectors;
  final String? sectorLanguageCode;


  const UsEquityState({
    super.type = PageState.initial,
    super.error,
    this.losers = const [],
    this.gainers = const [],
    this.updatedSymbol,
    this.graphData = const [],
    this.dividend,
    this.dividendYearlyList = const [],
    this.dividendTwoYearList = const [],
    this.dividendWeeklyState = PageState.initial,
    this.dividendYearlyState = PageState.initial,
    this.dividendTwoYearState = PageState.initial,
    this.favoriteIncomingDividends = const [],
    this.allIncomingDividends = const [],
    this.activeSymbols = const [],
    this.favoriteSymbols = const [],
    this.fractionableSymbols = const [],
    this.favoriteIncomingDividendsState = PageState.initial,
    this.allIncomingDividendsState = PageState.initial,
    this.currencyType = CurrencyEnum.dollar,
    this.chartType = ChartType.area,
    this.chartFilter = ChartFilter.oneDay,
    this.polygonApiKey = '',
    this.capraWebsocketApikey = '',
    this.polygonWatchingItems = const [],
    this.sectors = const [],
    this.sectorLanguageCode,
  });

  @override
  UsEquityState copyWith({
    PageState? type,
    PBlocError? error,
    List<MarketMoversModel>? losers,
    List<MarketMoversModel>? gainers,
    UsSymbolSnapshot? updatedSymbol,
    List<CurrentDailyBar>? graphData,
    Dividend? dividend,
    List<CashDividendsList>? dividendYearlyList,
    List<CashDividendsList>? dividendTwoYearList,
    PageState? dividendWeeklyState,
    PageState? dividendYearlyState,
    PageState? dividendTwoYearState,
    PageState? favoriteIncomingDividendsState = PageState.initial,
    PageState? allIncomingDividendsState = PageState.initial,
    List<String>? favoriteIncomingDividends,
    List<String>? allIncomingDividends,
    List<String>? activeSymbols,
    List<String>? favoriteSymbols,
    List<String>? fractionableSymbols,
    CurrencyEnum? currencyType,
    ChartType? chartType,
    ChartFilter? chartFilter,
    String? polygonApiKey,
    String? capraWebsocketApikey,
    List<UsSymbolSnapshot>? polygonWatchingItems,
    List<UsSectorModel>? sectors,
    String? sectorLanguageCode,
  }) {
    return UsEquityState(
      type: type ?? this.type,
      error: error ?? this.error,
      losers: losers ?? this.losers,
      gainers: gainers ?? this.gainers,
      updatedSymbol: updatedSymbol ?? this.updatedSymbol,
      graphData: graphData ?? this.graphData,
      dividend: dividend ?? this.dividend,
      dividendYearlyList: dividendYearlyList ?? this.dividendYearlyList,
      dividendTwoYearList: dividendTwoYearList ?? this.dividendTwoYearList,
      dividendWeeklyState: dividendWeeklyState ?? this.dividendWeeklyState,
      dividendYearlyState: dividendYearlyState ?? this.dividendYearlyState,
      dividendTwoYearState: dividendTwoYearState ?? this.dividendTwoYearState,
      favoriteIncomingDividendsState: favoriteIncomingDividendsState ?? this.favoriteIncomingDividendsState,
      allIncomingDividendsState: allIncomingDividendsState ?? this.allIncomingDividendsState,
      favoriteIncomingDividends: favoriteIncomingDividends ?? this.favoriteIncomingDividends,
      allIncomingDividends: allIncomingDividends ?? this.allIncomingDividends,
      activeSymbols: activeSymbols ?? this.activeSymbols,
      favoriteSymbols: favoriteSymbols ?? this.favoriteSymbols,
      fractionableSymbols: fractionableSymbols ?? this.fractionableSymbols,
      currencyType: currencyType ?? this.currencyType,
      chartType: chartType ?? this.chartType,
      chartFilter: chartFilter ?? this.chartFilter,
      polygonApiKey: polygonApiKey ?? this.polygonApiKey,
      capraWebsocketApikey: capraWebsocketApikey ?? this.capraWebsocketApikey,
      polygonWatchingItems: polygonWatchingItems ?? this.polygonWatchingItems,
      sectors: sectors ?? this.sectors,
      sectorLanguageCode: sectorLanguageCode ?? this.sectorLanguageCode,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        losers,
        gainers,
        updatedSymbol,
        graphData,
        dividend,
        dividendYearlyList,
        dividendTwoYearList,
        dividendWeeklyState,
        dividendYearlyState,
        dividendTwoYearState,
        favoriteIncomingDividendsState,
        allIncomingDividendsState,
        favoriteIncomingDividends,
        allIncomingDividends,
        activeSymbols,
        favoriteSymbols,
        fractionableSymbols,
        currencyType,
        chartType,
        chartFilter,
        polygonApiKey,
        capraWebsocketApikey,
        polygonWatchingItems,
        sectors,
        sectorLanguageCode,
      ];
}
