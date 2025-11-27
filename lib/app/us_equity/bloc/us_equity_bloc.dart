import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/repository/us_equity_repository.dart';
import 'package:piapiri_v2/app/us_symbol_detail/model/dividend_model.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/websocket_client/polygon_wss_client_helper.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/current_daily_bar.dart';
import 'package:piapiri_v2/core/model/dividend_model.dart';
import 'package:piapiri_v2/core/model/market_movers_model.dart';
import 'package:piapiri_v2/core/model/performance_gauge_mdoel.dart';
import 'package:piapiri_v2/core/model/sort_enum.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';
import 'package:piapiri_v2/core/model/ticker_overview.dart';
import 'package:piapiri_v2/core/model/us_financial_model.dart';
import 'package:piapiri_v2/core/model/us_market_movers_enum.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_sector_model.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsEquityBloc extends PBloc<UsEquityState> {
  final UsEquityRepository _usEquityRepository;

  UsEquityBloc({
    required UsEquityRepository usEquityRepository,
  })  : _usEquityRepository = usEquityRepository,
        super(initialState: const UsEquityState()) {
    on<GetLosersGainersEvent>(_onGetLosersGainers);
    on<UpdateUsSymbolEvent>(_onUpdateUsSymbol);
    on<SubscribeSymbolEvent>(_onSubscribeSymbol);
    on<UnsubscribeSymbolEvent>(_onUnsubscribeSymbol);
    on<ChangeSubscriptionStatusEvent>(_onChangeSubscriptionStatus);
    on<GetCustomBarsEvent>(_onGetCustomBars);
    on<GetDividendWeeklyEvent>(_onGetDividendWeekly);
    on<GetDividendYearlyEvent>(_onGetDividendYearly);
    on<GetDividendTwoYearEvent>(_onGetDividendTwoYear);
    on<GetUsIncomingDividends>(_onGetUsIncomingDividends);
    on<SetUsChartCurrentType>(_onSetUsChartCurrentType);
    on<SetUsChartType>(_onSetUsChartType);
    on<GetActiveSymbols>(_onGetActiveSymbols);
    on<GetFavoriteSymbols>(_onGetFavoriteSymbols);
    on<GetFractionableSymbols>(_onGetFractionableSymbols);
    on<GetPolygonApiKeyEvent>(_onGetPolygonApiKey);
    on<GetSymbolsDetailEvent>(_onGetSymbolsDetail);
    on<GetTickerOverviewEvent>(_onGetTickerOverview);
    on<GetFinancialDataEvent>(_onGetFinancialData);
    on<GetPerformanceGaugeEvent>(_onGetPerformanceGauge);
    on<GetRelatedTickersEvent>(_onGetRelatedTickers);
    on<GetDailyTransactionEvent>(_onGetDailyTransaction);
    on<GetUsSectorsEvent>(_onGetUsSectors);
  }

  FutureOr<void> _onGetLosersGainers(
    GetLosersGainersEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: state.losers.isEmpty || state.gainers.isEmpty ? PageState.loading : null,
      ),
    );
    List<MarketMoversModel> gainers = [];
    List<MarketMoversModel> losers = [];

    List<ApiResponse> responseList = await Future.wait([
      _usEquityRepository.getLosersGainersPolygon(marketMover: UsMarketMovers.gainers),
      _usEquityRepository.getLosersGainersPolygon(marketMover: UsMarketMovers.losers)
    ]);
    for (var i = 0; i < responseList.length; i++) {
      ApiResponse response = responseList[i];
      if (response.success) {
        List<MarketMoversModel> marketMover = List<MarketMoversModel>.from(response.data['tickers']
            .where((e) => state.activeSymbols.contains(e['ticker']))
            .map((e) => MarketMoversModel(symbol: e['ticker'].toString()))).toList();

        if (i == 0) {
          gainers = marketMover;
        } else {
          losers = marketMover;
        }
      }
    }

    if (gainers.isEmpty || losers.isEmpty) {
      ApiResponse response = await _usEquityRepository.getLosersGainersCapra();
      if (response.success) {
        List<dynamic> data = response.data;
        if (gainers.isEmpty) {
          gainers = List<MarketMoversModel>.from(data
              .where((e) => e['type'] == UsMarketMovers.gainers.name && state.activeSymbols.contains(e['ticker']))
              .map((e) => MarketMoversModel.fromJson(e)));
        }
        if (losers.isEmpty) {
          losers = List<MarketMoversModel>.from(data
              .where((e) => e['type'] == UsMarketMovers.losers.name && state.activeSymbols.contains(e['ticker']))
              .map((e) => MarketMoversModel.fromJson(e)));
        }
      }
    }
    emit(
      state.copyWith(
        type: PageState.success,
        losers: losers,
        gainers: gainers,
      ),
    );
  }

  FutureOr<void> _onGetCustomBars(
    GetCustomBarsEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    ChartFilter chartFilter = event.chartFilter ?? state.chartFilter;

    String from = DateTimeUtils.serverDate(DateTime.now().subtract(chartFilter.duration));
    String to = DateTimeUtils.serverDate(DateTime.now());
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _usEquityRepository.getCustomBars(
      symbols: event.symbols,
      from: from,
      to: to,
      timeframe: chartFilter.usPeriod!,
    );
    if (response.success) {
      List<CurrentDailyBar> graphData =
          response.data['results'].map<CurrentDailyBar>((json) => CurrentDailyBar.fromJson(json)).toList();
      for (var e in graphData) {
        e.symbol = event.symbols;
      }

      emit(
        state.copyWith(
          type: PageState.success,
          chartFilter: chartFilter,
          graphData: graphData,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          chartFilter: chartFilter,
          graphData: [],
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUpdateUsSymbol(
    UpdateUsSymbolEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    UsSymbolSnapshot? snapshot = state.polygonWatchingItems.firstWhereOrNull(
      (e) => e.ticker == event.symbolName,
    );

    if (snapshot == null) {
      LogUtils.pLog('POLYGON:: Symbol ${event.symbolName} not found in watching items');
      return;
    }

    if (snapshot.ticker == event.symbolName) {
      UsMarketStatus marketStatus = getMarketPhase(event.timestamp);
      // Check if the market status has changed
      if (snapshot.marketStatus != marketStatus) {
        // The marketStatus of the symbol in the state is updated to avoid multiple Api requests
        int updatedIndex = state.polygonWatchingItems.indexWhere((element) => element.ticker == event.symbolName);

        List<UsSymbolSnapshot> updatedList = List.from(state.polygonWatchingItems);
        updatedList[updatedIndex] = snapshot.copyWith(
          marketStatus: marketStatus,
        );
        emit(
          state.copyWith(polygonWatchingItems: updatedList, updatedSymbol: snapshot),
        );
        final Completer<void> symbolDetailCompleter = Completer<void>();
        add(
          GetSymbolsDetailEvent(
            symbols: [snapshot.ticker],
            callback: (symbols) {
              snapshot = symbols.first;
              symbolDetailCompleter.complete();
            },
          ),
        );
        await symbolDetailCompleter.future;
      }
      double? earlyTradingChange = 0;
      double? earlyTradingChangePercent = 0;
      double? lateTradingChange = 0;
      double? lateTradingChangePercent = 0;
      double? regularTradingChange = 0;
      double? regularTradingChangePercent = 0;
      double price = double.parse(event.price.toStringAsFixed(2));
      if (marketStatus == UsMarketStatus.open) {
        regularTradingChange = price - (snapshot?.session?.previousClose ?? 0);
        regularTradingChangePercent = (regularTradingChange / (snapshot?.session?.previousClose ?? 1)) * 100;
      } else if (marketStatus == UsMarketStatus.preMarket) {
        earlyTradingChange = price - (snapshot?.session?.close ?? 0);
        earlyTradingChangePercent = (earlyTradingChange / (snapshot?.session?.close ?? 1)) * 100;
      } else if (marketStatus == UsMarketStatus.afterMarket) {
        lateTradingChange = price - (snapshot?.session?.close ?? 0);
        lateTradingChangePercent = (lateTradingChange / (snapshot?.session?.close ?? 1)) * 100;
      }

      snapshot = snapshot?.copyWith(
        fmv: price,
        marketStatus: marketStatus,
        session: snapshot?.session?.copyWith(
          price: marketStatus == UsMarketStatus.open ? price : null,
          earlyTradingChange: earlyTradingChange != 0 ? earlyTradingChange : null,
          earlyTradingChangePercent: earlyTradingChangePercent != 0 ? earlyTradingChangePercent : null,
          lateTradingChange: lateTradingChange != 0 ? lateTradingChange : null,
          lateTradingChangePercent: lateTradingChangePercent != 0 ? lateTradingChangePercent : null,
          regularTradingChange: regularTradingChange != 0 ? regularTradingChange : null,
          regularTradingChangePercent: regularTradingChangePercent != 0 ? regularTradingChangePercent : null,
          timestamp: event.timestamp,
          high: price > (snapshot?.session?.high ?? 0) ? price : snapshot?.session?.high,
          low: price < (snapshot?.session?.low ?? 0) ? price : snapshot?.session?.low,
        ),
      );
    }

    int updatedIndex = state.polygonWatchingItems.indexWhere((element) => element.ticker == event.symbolName);
    if (updatedIndex == -1) {
      LogUtils.pLog('POLYGON:: Symbol ${event.symbolName} not found in watching items');
      return;
    }
    List<UsSymbolSnapshot> updatedList = List.from(state.polygonWatchingItems);
    updatedList[updatedIndex] = snapshot!;

    emit(
      state.copyWith(
        polygonWatchingItems: updatedList,
        updatedSymbol: snapshot,
      ),
    );
  }

  FutureOr<void> _onSubscribeSymbol(
    SubscribeSymbolEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );

    List<String> getDetailsList = [];
    List<String> subscribeList = [];
    List<UsSymbolSnapshot> symbolList = [];

    for (String symbolName in event.symbolName) {
      UsSymbolSnapshot? match = state.polygonWatchingItems.firstWhereOrNull(
        (e) => e.ticker == symbolName,
      );
      if (match == null) {
        getDetailsList.add(symbolName);
        continue;
      }
      symbolList.add(match);

      if (!match.isSubscribed) {
        subscribeList.add(symbolName);
      }
    }

    if (subscribeList.isEmpty && getDetailsList.isEmpty) {
      event.callback?.call(symbolList, event.symbolName);
      return;
    }
    if (getDetailsList.isNotEmpty) {
      final Completer<void> symbolDetailCompleter = Completer<void>();
      add(
        GetSymbolsDetailEvent(
          symbols: getDetailsList,
          callback: (symbols) {
            symbolList.addAll(symbols);
            subscribeList.addAll(
              symbols.where((e) => !e.isSubscribed).map((e) => e.ticker),
            );
            symbolDetailCompleter.complete();
          },
        ),
      );
      await symbolDetailCompleter.future;
    }
    List<String> alreadySubscribed = subscribeList
        .where(
          (e) => state.polygonWatchingItems.any((item) => item.ticker == e && item.isSubscribed),
        )
        .toList();
    PolygonWSSClientHelper.subscribe(symbolList: subscribeList);
    final existingTickers = state.polygonWatchingItems.map((e) => e.ticker).toSet();
    event.callback?.call(
      symbolList,
      alreadySubscribed,
    );
    emit(
      state.copyWith(
        type: PageState.fetched,
        polygonWatchingItems: [
          ...state.polygonWatchingItems,
          ...symbolList.where((e) => !existingTickers.contains(e.ticker)),
        ],
      ),
    );
  }

  FutureOr<void> _onUnsubscribeSymbol(
    UnsubscribeSymbolEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    //Carouseldeki semboller ve secili favori listelerinden gelen semboller hariç unsubscribe edilir.
    List<String> ignoreUnsubscribeSymbols = getIt<SymbolBloc>()
        .state
        .marketCarousel
        .where((element) => element.symbolSource == SymbolSourceEnum.alpaca)
        .map((e) => e.code)
        .toList();

    if (getIt<FavoriteListBloc>().state.selectedList != null) {
      ignoreUnsubscribeSymbols.addAll(
        getIt<FavoriteListBloc>()
            .state
            .selectedList!
            .favoriteListItems
            .where(
              (element) => element.symbolSource == SymbolSourceEnum.alpaca,
            )
            .map((e) => e.symbol)
            .toList(),
      );
    }

    List<String> unsubscribeList = event.symbolName
        .where(
          (element) => state.polygonWatchingItems.any(
            (e) => e.ticker == element && e.isSubscribed && !ignoreUnsubscribeSymbols.contains(e.ticker),
          ),
        )
        .toList();
    if (unsubscribeList.isEmpty) return;

    PolygonWSSClientHelper.unsubscribe(symbolList: unsubscribeList);
  }

  FutureOr<void> _onChangeSubscriptionStatus(
    ChangeSubscriptionStatusEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    List<UsSymbolSnapshot> updatedList = state.polygonWatchingItems;
    for (String symbol in event.symbolList) {
      updatedList = updatedList.map((e) {
        if (e.ticker == symbol) {
          return e.copyWith(isSubscribed: event.isSubscribed);
        }
        return e;
      }).toList();
    }
    emit(
      state.copyWith(
        polygonWatchingItems: updatedList,
      ),
    );
  }

  FutureOr<void> _onGetDividendWeekly(
    GetDividendWeeklyEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        dividendWeeklyState: PageState.loading,
      ),
    );
    DateTime today = DateTime.now();
    ApiResponse response = await _usEquityRepository.getDividends(
      symbols: event.symbols,
      types: const [3],
      startDate: today.addMonths(-1).toString().split(' ')[0],
      endDate: today.addMonths(3).toString().split(' ')[0],
      sortDirection: 0,
    );

    if (response.success) {
      DividendModel dividendModel = DividendModel.fromJson(response.data);
      Dividend? dividend;
      if (dividendModel.cashDividends?.isNotEmpty == true) {
        List<Dividend> records = dividendModel.cashDividends!
            .where((e) => e.recordDate?.isNotEmpty == true)
            .map(
              (e) {
                return Dividend(
                  symbol: event.symbols.first,
                  dateTime: DateTime.tryParse(e.recordDate!),
                  value: e.rate,
                );
              },
            )
            .where((e) => e.dateTime != null)
            .map(
              (e) => Dividend(
                symbol: event.symbols.first,
                dateTime: e.dateTime!,
                value: e.value,
              ),
            )
            .toList();

        records.sort(
          (a, b) {
            return a.dateTime!.compareTo(b.dateTime!);
          },
        );

        dividend = records
            .where((e) {
              return e.dateTime!.isSameDayOrAfter(today);
            })
            .toList()
            .firstOrNull;

        dividend ??= records
            .where((e) {
              return e.dateTime!.isSameDayOrBefore(today);
            })
            .toList()
            .lastOrNull;
      }

      emit(
        state.copyWith(
          dividendWeeklyState: PageState.success,
          dividend: dividend,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dividendWeeklyState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDividendYearly(
    GetDividendYearlyEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        dividendYearlyState: PageState.loading,
      ),
    );

    DateTime today = DateTime.now();

    DateTime oneYearAgo = today.getOneYearAgo(today);

    ApiResponse response = await _usEquityRepository.getDividends(
      symbols: event.symbols,
      types: const [3],
      startDate: oneYearAgo.toString().split(' ')[0],
      endDate: today.toString().split(' ')[0],
      sortDirection: 0,
    );

    if (response.success) {
      DividendModel dividend = DividendModel.fromJson(response.data);

      emit(
        state.copyWith(
          dividendYearlyState: PageState.success,
          dividendYearlyList: dividend.cashDividends,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dividendYearlyState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US07',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDividendTwoYear(
    GetDividendTwoYearEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        dividendTwoYearState: PageState.loading,
      ),
    );
    DateTime today = DateTime.now();

    DateTime twoYearAgo = today.getTwoYearAgo(today);

    ApiResponse response = await _usEquityRepository.getDividends(
      symbols: event.symbols,
      types: [3],
      startDate: twoYearAgo.toString().split(' ')[0],
      endDate: today.toString().split(' ')[0],
      sortDirection: 0,
    );

    if (response.success) {
      DividendModel dividend = DividendModel.fromJson(response.data);

      emit(
        state.copyWith(
          dividendTwoYearState: PageState.success,
          dividendTwoYearList: dividend.cashDividends,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dividendTwoYearState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'US08',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetUsIncomingDividends(
    GetUsIncomingDividends event,
    Emitter emit,
  ) async {
    if (event.isFavorite) {
      emit(
        state.copyWith(
          favoriteIncomingDividendsState: PageState.loading,
        ),
      );
    } else {
      emit(
        state.copyWith(
          allIncomingDividendsState: PageState.loading,
        ),
      );
    }

    DateTime startDay = DateTime.now();
    DateTime endDay = startDay.addMonths(2);
    ApiResponse response = await _usEquityRepository.getIncomingDividends(
      types: [3],
      startDate: startDay.toString().split(' ')[0],
      endDate: endDay.toString().split(' ')[0],
      sortDirection: 0,
      onlyFavorites: event.isFavorite,
    );

    if (response.success) {
      List<String> dividends = (response.data['cashDividends'] as List<dynamic>)
          .where((e) {
            if (e['symbol'] == null || e['symbol']?.toString().isEmpty == true) return false;

            final recordDateString = e['recordDate']?.toString();
            if (recordDateString == null || recordDateString.isEmpty) return false;

            try {
              final recordDate = DateTime.parse(recordDateString);
              final recordDay = DateTime(recordDate.year, recordDate.month, recordDate.day);
              final start = DateTime(startDay.year, startDay.month, startDay.day);
              return recordDay.isAfter(start);
            } catch (_) {
              return false;
            }
          })
          .map((e) => e['symbol'].toString())
          .toSet()
          .toList();

      dividends = dividends.where((e) => state.activeSymbols.contains(e)).toList();

      if (event.isFavorite) {
        emit(
          state.copyWith(
            favoriteIncomingDividendsState: PageState.success,
            favoriteIncomingDividends: dividends.where((e) => state.favoriteSymbols.contains(e)).toList(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            allIncomingDividendsState: PageState.success,
            allIncomingDividends: dividends,
          ),
        );
      }
      event.successCallback?.call();
    } else {
      if (event.isFavorite) {
        emit(
          state.copyWith(
            favoriteIncomingDividendsState: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: 'US09',
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            allIncomingDividendsState: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: 'US09',
            ),
          ),
        );
      }
    }
  }

  FutureOr<void> _onSetUsChartCurrentType(
    SetUsChartCurrentType event,
    Emitter emit,
  ) {
    emit(
      state.copyWith(
        currencyType: state.currencyType == CurrencyEnum.dollar ? CurrencyEnum.turkishLira : CurrencyEnum.dollar,
      ),
    );
  }

  FutureOr<void> _onSetUsChartType(
    SetUsChartType event,
    Emitter emit,
  ) {
    emit(
      state.copyWith(
        chartType: event.usChartType,
      ),
    );
  }

  FutureOr<void> _onGetActiveSymbols(
    GetActiveSymbols event,
    Emitter emit,
  ) async {
    Map<String, dynamic>? activeSymbols = await _usEquityRepository.readActiveSymbolsLocal();
    String lastModified = '';
    if (activeSymbols != null) {
      ApiResponse headerResponse = await _usEquityRepository.getActiveSymbolsHead();
      if (headerResponse.success) {
        final headers = headerResponse.dioResponse?.headers;
        lastModified = headers?['last-modified']?.first.toString() ?? '';
      }
    }
    if (activeSymbols == null || activeSymbols['lastModified'] != lastModified) {
      ApiResponse response = await _usEquityRepository.getActiveSymbols();

      if (response.success) {
        final String rawText = response.data;

        // Satırları böl ve boş olmayanları al
        List<String> symbols = rawText
            .split('\n')
            .map((e) => e.trim())
            .where(
              (e) => e.isNotEmpty,
            )
            .toList();

        _usEquityRepository.writeActiveSymbolsLocal({
          'lastModified': response.dioResponse?.headers['last-modified']?.first.toString(),
          'symbols': symbols,
        });
        emit(
          state.copyWith(
            activeSymbols: symbols,
          ),
        );
        return;
      }
    }
    emit(
      state.copyWith(
        activeSymbols: activeSymbols!['symbols'] as List<String>?,
      ),
    );
  }

  FutureOr<void> _onGetFavoriteSymbols(
    GetFavoriteSymbols event,
    Emitter emit,
  ) async {
    Map<String, dynamic>? favoriteSymbols = await _usEquityRepository.readFavoriteSymbolsLocal();
    String lastModified = '';
    if (favoriteSymbols != null) {
      ApiResponse headerResponse = await _usEquityRepository.getFavoriteSymbolsHead();
      if (headerResponse.success) {
        final headers = headerResponse.dioResponse?.headers;
        lastModified = headers?['last-modified']?.first.toString() ?? '';
      }
    }
    if (favoriteSymbols == null || favoriteSymbols['lastModified'] != lastModified) {
      ApiResponse response = await _usEquityRepository.getFavoriteSymbols();

      if (response.success) {
        final String rawText = response.data;

        // Satırları böl ve boş olmayanları al
        List<String> symbols = rawText
            .split('\n')
            .map((e) => e.trim())
            .where(
              (e) => e.isNotEmpty,
            )
            .toList();

        _usEquityRepository.writeFavoriteSymbolsLocal({
          'lastModified': response.dioResponse?.headers['last-modified']?.first.toString(),
          'symbols': symbols,
        });
        emit(
          state.copyWith(
            favoriteSymbols: symbols,
          ),
        );
        return;
      }
    }
    emit(
      state.copyWith(
        favoriteSymbols: favoriteSymbols!['symbols'] as List<String>?,
      ),
    );
  }

  FutureOr<void> _onGetFractionableSymbols(
    GetFractionableSymbols event,
    Emitter emit,
  ) async {
    Map<String, dynamic>? fractionableSymbols = await _usEquityRepository.readFractionableSymbolsLocal();
    String lastModified = '';
    if (fractionableSymbols != null) {
      ApiResponse headerResponse = await _usEquityRepository.getFractionableSymbolsHead();
      if (headerResponse.success) {
        final headers = headerResponse.dioResponse?.headers;
        lastModified = headers?['last-modified']?.first.toString() ?? '';
      }
    }
    if (fractionableSymbols == null || fractionableSymbols['lastModified'] != lastModified) {
      ApiResponse response = await _usEquityRepository.getFractionableSymbols();

      if (response.success) {
        final String rawText = response.data;

        // Satırları böl ve boş olmayanları al
        List<String> symbols = rawText
            .split('\n')
            .map((e) => e.trim())
            .where(
              (e) => e.isNotEmpty,
            )
            .toList();

        _usEquityRepository.writeFractionableSymbolsLocal({
          'lastModified': response.dioResponse?.headers['last-modified']?.first.toString(),
          'symbols': symbols,
        });
        emit(
          state.copyWith(
            fractionableSymbols: symbols,
          ),
        );
        return;
      }
    }
    emit(
      state.copyWith(
        fractionableSymbols: fractionableSymbols!['symbols'] as List<String>?,
      ),
    );
  }

  FutureOr<void> _onGetPolygonApiKey(
    GetPolygonApiKeyEvent event,
    Emitter emit,
  ) async {
    String polygonApiKey = remoteConfig.getString('polygonApiKey');
    Map<String, dynamic> capraWebsokcetSettings = jsonDecode(remoteConfig.getString('capraWebsokcetSettings'));
    String capraWebsocketApikey = AppConfig.instance.flavor == Flavor.prod
        ? capraWebsokcetSettings['prodToken'] ?? ''
        : capraWebsokcetSettings['devToken'] ?? '';

    emit(
      state.copyWith(
        polygonApiKey: polygonApiKey,
        capraWebsocketApikey: capraWebsocketApikey,
      ),
    );
  }

  FutureOr<void> _onGetSymbolsDetail(
    GetSymbolsDetailEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    List<ApiResponse> responses = await Future.wait(
      event.symbols.map(
        (e) => _usEquityRepository.getTickerSnapshot(
          symbol: e,
        ),
      ),
    );
    List<String> notAvaliableTickers = [];
    List<UsSymbolSnapshot> usSymbolSnapshotList = [];

    for (final response in responses) {
      final data = response.data;

      List<dynamic>? results;
      if (data is Map<String, dynamic> && data['results'] is List && (data['results'] as List).isNotEmpty) {
        results = data['results'] as List;
      }

      Map<String, dynamic>? first;
      if (results != null && results.isNotEmpty && results.first is Map<String, dynamic>) {
        first = results.first as Map<String, dynamic>;
      }

      if (response.success && first != null && first['error'] == null) {
        UsSymbolSnapshot snapshot = UsSymbolSnapshot.fromJson(first);

        if (snapshot.marketStatus == UsMarketStatus.closed) {
          final double close = snapshot.session?.close ?? 0;
          final double previousClose = snapshot.session?.previousClose ?? 0;

          final double denominator = previousClose == 0 ? 1 : previousClose;

          final double change = close - previousClose;
          final double changePercent = (change / denominator) * 100;

          snapshot = snapshot.copyWith(
            session: snapshot.session?.copyWith(
              regularTradingChange: change,
              regularTradingChangePercent: changePercent,
            ),
          );
        }

        usSymbolSnapshotList.add(snapshot);
      } else {
        final String ticker = first?['ticker']?.toString() ?? '';
        final String? message = first?['message']?.toString();
        notAvaliableTickers.add(ticker);
        LogUtils.pLog(
          'POLYGON:: ${message ?? response.error?.message ?? 'Unknown error::$ticker'}',
        );
      }
    }

    if (usSymbolSnapshotList.isNotEmpty && usSymbolSnapshotList.first.marketStatus == UsMarketStatus.preMarket) {
      String from = DateTimeUtils.serverDate(DateTime.now().subtract(const Duration(days: 365)));
      String to = DateTimeUtils.serverDate(DateTime.now());

      List<ApiResponse> previousBarResponseList = await Future.wait(
        event.symbols.map(
          (e) => _usEquityRepository.getCustomBars(
              symbols: e,
              from: from,
              to: to,
              timeframe: ChartFilter.oneDay.usPeriod!,
              sortEnum: SortEnum.descending,
              limit: 5),
        ),
      );
      for (var i = 0; i < usSymbolSnapshotList.length; i++) {
        UsSymbolSnapshot symbol = usSymbolSnapshotList[i];
        ApiResponse? previousBarResponse = previousBarResponseList.firstWhereOrNull(
          (e) => e.success && e.data['ticker'] == symbol.ticker,
        );
        if (previousBarResponse != null) {
          CurrentDailyBar previousBar = CurrentDailyBar.fromJson(previousBarResponse.data['results'][2]);
          CurrentDailyBar currentBar = CurrentDailyBar.fromJson(previousBarResponse.data['results'][1]);
          double change = (symbol.session?.previousClose ?? 0) - (previousBar.close ?? 0);
          double changePercent = (change / (previousBar.close ?? 1)) * 100;
          usSymbolSnapshotList[i] = symbol.copyWith(
            session: symbol.session?.copyWith(
              regularTradingChange: change,
              regularTradingChangePercent: changePercent,
              previousClose: previousBar.close,
              close: symbol.session?.previousClose,
              open: currentBar.open,
              high: currentBar.high,
              low: currentBar.low,
              volume: currentBar.volume,
            ),
          );
        }
      }
    }

    event.callback?.call(usSymbolSnapshotList);
  }

  FutureOr<void> _onGetTickerOverview(
    GetTickerOverviewEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _usEquityRepository.getTickerOverview(
      symbolName: event.symbolName,
    );
    if (response.success) {
      TickerOverview tickerOverview = TickerOverview.fromJson(response.data['results']);
      event.callback?.call(tickerOverview);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      event.callback?.call(null);
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('error_us_symbol_data'),
            errorCode: 'US10',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFinancialData(
    GetFinancialDataEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _usEquityRepository.getFinancialData(
      symbolName: event.symbolName,
    );
    if (response.success) {
      UsFinancialModel? financialModel = response.data['results'] != null && response.data['results'].isNotEmpty
          ? UsFinancialModel.fromJson(response.data['results'].first)
          : null;
      event.callback?.call(financialModel);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      event.callback?.call(null);
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: 'US10',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetPerformanceGauge(
    GetPerformanceGaugeEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    String weeklyFrom = DateTimeUtils.serverDate(DateTime.now().subtract(const Duration(days: 7)));
    String monthlyFrom = DateTimeUtils.serverDate(DateTime.now().subtract(const Duration(days: 30)));
    String yearlyFrom = DateTimeUtils.serverDate(DateTime.now().subtract(const Duration(days: 364)));
    String to = DateTimeUtils.serverDate(DateTime.now());

    List<ApiResponse> responses = await Future.wait([
      _usEquityRepository.getCustomBars(
        symbols: event.symbolName,
        timeframe: 'day',
        from: weeklyFrom,
        to: to,
        sortEnum: SortEnum.descending,
      ),
      _usEquityRepository.getCustomBars(
        symbols: event.symbolName,
        timeframe: 'day',
        from: monthlyFrom,
        to: to,
        sortEnum: SortEnum.descending,
      ),
      _usEquityRepository.getCustomBars(
        symbols: event.symbolName,
        timeframe: 'week',
        from: yearlyFrom,
        to: to,
        sortEnum: SortEnum.descending,
      ),
    ]);
    PerformanceGaugeModel? weeklyBar;
    PerformanceGaugeModel? monthlyBar;
    PerformanceGaugeModel? yearlyBar;

    for (var i = 0; i < responses.length; i++) {
      ApiResponse response = responses[i];
      if (response.success) {
        List<dynamic> data = response.data['results'];
        double highest = data.first['h'].toDouble();
        double lowest = data.first['l'].toDouble();
        for (var entry in data) {
          if (entry['h'] > highest) {
            highest = entry['h'].toDouble();
          }
          if (entry['l'] < lowest) {
            lowest = entry['l'].toDouble();
          }
        }
        PerformanceGaugeModel bar = PerformanceGaugeModel(
          high: highest,
          low: lowest,
          referancePrice: data.last['c'].toDouble(),
        );

        if (i == 0) {
          weeklyBar = bar;
        } else if (i == 1) {
          monthlyBar = bar;
        } else if (i == 2) {
          yearlyBar = bar;
        }
      }
    }
    event.callback?.call(weeklyBar, monthlyBar, yearlyBar);
  }

  FutureOr<void> _onGetRelatedTickers(
    GetRelatedTickersEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    ApiResponse response = await _usEquityRepository.getRelatedTickers(
      symbolName: event.symbolName,
    );

    if (response.success) {
      List<String> relatedTickers = [];
      if (response.data['results'] != null) {
        relatedTickers = List<String>.from(
          response.data['results'].map((e) => e['ticker'].toString()).where(
                (e) => state.activeSymbols.contains(e),
              ),
        ).toList();
      }
      event.callback?.call(relatedTickers);
    }
  }

  FutureOr<void> _onGetDailyTransaction(
    GetDailyTransactionEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    ApiResponse response = await _usEquityRepository.getDailyTransactionInfo();

    if (response.success) {
      event.callback?.call(
        int.tryParse(response.data['last5WorkingDayDailyBuySellCount']) ?? 0,
      );
    }
  }

  FutureOr<void> _onGetUsSectors(
    GetUsSectorsEvent event,
    Emitter<UsEquityState> emit,
  ) async {
    if (state.sectors.isNotEmpty && state.sectorLanguageCode == getIt<LanguageBloc>().state.languageCode) {
      event.callback?.call(state.sectors);
      return;
    }
    ApiResponse response = await _usEquityRepository.getUsSectors();

    if (response.success) {
      List<UsSectorModel> sectors =
          List<UsSectorModel>.from(response.data.map((e) => UsSectorModel.fromJson(e)).toList());
      event.callback?.call(sectors);
      emit(
        state.copyWith(
          sectors: sectors,
          sectorLanguageCode: getIt<LanguageBloc>().state.languageCode,
        ),
      );
    }
  }
}
