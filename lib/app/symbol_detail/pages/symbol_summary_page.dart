import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/dividend/widgets/symbol_dividend_widget.dart';
import 'package:piapiri_v2/app/news/widgets/news_widget.dart';
import 'package:piapiri_v2/app/pivot_analysis/pages/pivot_analysis_page.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_chart/widget/symbol_chart_wrapper.dart';
import 'package:piapiri_v2/app/symbol_detail/symbol_detail_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/detail_performance_gauge.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/direction_viop_warrant_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/market_review_list.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/market_status_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_sectors.dart';
import 'package:piapiri_v2/app/twitter/widget/twitter_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/symbol_info.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_state.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSummary extends StatelessWidget {
  final MarketListModel symbol;
  final SymbolTypes type;
  const SymbolSummary({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SymbolInfo(
              symbol: symbol,
              type: type,
            ),
            PBlocBuilder<MatriksBloc, MatriksState>(
              bloc: getIt<MatriksBloc>(),
              builder: (context, state) {
                //xu030 ve xu100 dışında diğer endeksler gecikmeli
                if (!shouldShow(state) || symbol.symbolCode == 'XU030' || symbol.symbolCode == 'XU100') {
                  return const SizedBox.shrink();
                }
                if (symbol.type == SymbolTypes.indexType.dbKey && getIt<AuthBloc>().state.isLoggedIn) {
                  return delayedAlert('delayed_data_text');
                }
                return delayedAlert('delayed_data_info');
              },
            ),
            Row(
              children: [
                Expanded(
                  child: MarketStatusWidget(
                    symbol: symbol,
                    type: type,
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                PBlocBuilder<SymbolChartBloc, SymbolChartState>(
                  bloc: getIt<SymbolChartBloc>(),
                  builder: (context, state) {
                    if (state.chartData.isEmpty ||
                        type == SymbolTypes.warrant ||
                        type == SymbolTypes.option ||
                        type == SymbolTypes.future ||
                        type == SymbolTypes.parity ||
                        type == SymbolTypes.crypto) {
                      return const SizedBox.shrink();
                    }
                    return InkWell(
                      child: SvgPicture.asset(
                        ImagesPath.arrows_diagonal,
                        width: 18,
                        height: 18,
                      ),
                      onTap: () => router.push(
                        TradingviewRoute(
                          symbol: symbol.symbolCode,
                          symbolExchange: symbol.exchangeCode,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SymbolChartWrapper(
              symbolName: symbol.symbolCode,
              symbolType: symbol.symbolType,
            ),
            PBlocBuilder<SymbolBloc, SymbolState>(
              bloc: getIt<SymbolBloc>(),
              buildWhen: (previous, current) =>
                  current.isUpdated && current.updatedSymbol.symbolCode == symbol.symbolCode,
              builder: (context, state) {
                MarketListModel newSymbol = state.watchingItems.firstWhere(
                  (element) => element.symbolCode == symbol.symbolCode,
                  orElse: () => symbol,
                );
                newSymbol = SymbolDetailUtils().fetchWithSubscribedSymbol(newSymbol, symbol);
                return Column(
                  children: [
                    SymbolBrief(
                      symbol: newSymbol,
                      type: type,
                    ),
                    DetailPerformanceGauge(
                      key: ValueKey('7g::${newSymbol.weekLow}::${newSymbol.weekHigh}'),
                      symbolName: newSymbol.symbolCode,
                      title: '7g',
                      lowPrice: newSymbol.weekLow,
                      highPrice: newSymbol.weekHigh,
                      price: MoneyUtils().getPrice(newSymbol, null),
                      showMinMaxLabel: true,
                      type: newSymbol.type,
                      subMarketCode: newSymbol.subMarketCode,
                    ),
                    DetailPerformanceGauge(
                      key: ValueKey('30g::${newSymbol.monthLow}::${newSymbol.monthHigh}'),
                      symbolName: newSymbol.symbolCode,
                      title: '30g',
                      lowPrice: newSymbol.monthLow,
                      highPrice: newSymbol.monthHigh,
                      price: MoneyUtils().getPrice(newSymbol, null),
                      type: newSymbol.type,
                      subMarketCode: newSymbol.subMarketCode,
                    ),
                    if (type == SymbolTypes.equity)
                      DetailPerformanceGauge(
                        key: ValueKey('52h::${newSymbol.yearLow}::${newSymbol.yearHigh}'),
                        symbolName: newSymbol.symbolCode,
                        title: '52h',
                        lowPrice: newSymbol.yearLow,
                        highPrice: newSymbol.yearHigh,
                        price: MoneyUtils().getPrice(newSymbol, null),
                        type: newSymbol.type,
                        subMarketCode: newSymbol.subMarketCode,
                      ),
                    if (type == SymbolTypes.future ||
                        type == SymbolTypes.option ||
                        type == SymbolTypes.warrant ||
                        type == SymbolTypes.equity)
                      DirectionViopWarrantWidget(
                        detailSymbolName: newSymbol.symbolCode,
                        underlyingSymbolName:
                            type == SymbolTypes.future || type == SymbolTypes.option || type == SymbolTypes.warrant
                                ? newSymbol.underlying
                                : newSymbol.symbolCode,
                      ),
                    const SizedBox(
                      height: Grid.l,
                    ),
                    PivotAnalysisPage(
                      symbol: newSymbol,
                      type: type,
                    ),
                    if (type == SymbolTypes.equity &&
                        newSymbol.sectorCode != null &&
                        getIt<AuthBloc>().state.isLoggedIn) ...[
                      SymbolSectors(
                        key: ValueKey('SECTORS_${newSymbol.symbolCode}_${newSymbol.sectorCode}'),
                        symbol: newSymbol,
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                    ],
                    SymbolDividendWidget(
                      symbolCode: newSymbol.symbolCode,
                    ),
                    NewsWidget(
                      symbol: newSymbol,
                      type: type,
                      fromSymbolDetail: true,
                    ),
                    MarketReviewList(
                      symbolName: symbol.symbolCode,
                      mainGroup: MarketTypeEnum.marketBist.value,
                    ),
                    TwitterWidget(
                      symbol: newSymbol,
                      type: type,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget delayedAlert(String infoText) {
    return Column(
      children: [
        PInfoWidget(
          infoText: L10n.tr(infoText),
        ),
        const SizedBox(
          height: Grid.xs,
        ),
      ],
    );
  }

  bool shouldShow(MatriksState state) {
    if (type.matriks.isEmpty) {
      return true;
    }
    if (state.topics['mqtt']['market'][type.matriks]['qos'] != 'dl') {
      return false;
    }
    return true;
  }
}
