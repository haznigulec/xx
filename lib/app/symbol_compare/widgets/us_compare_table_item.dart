import 'dart:async';

import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_compare/compare_constants.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/search_us_symbol_page.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_compare_analysis_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsCompareTableItem extends StatefulWidget {
  final String? symbolName;
  final Function(String symbolName)? onTapSymbol;
  const UsCompareTableItem({
    super.key,
    this.symbolName,
    this.onTapSymbol,
  });

  @override
  State<UsCompareTableItem> createState() => _UsCompareTableItemState();
}

class _UsCompareTableItemState extends State<UsCompareTableItem> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  late UsCompareAnalysisModel? _usCompareAnalysisModel;
  bool _isLoading = false;

  @override
  void initState() {
    _usCompareAnalysisModel = widget.symbolName != null
        ? UsCompareAnalysisModel(
            symbolName: widget.symbolName!,
          )
        : null;
    if (widget.symbolName != null) {
      _getData(widget.symbolName!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: [
          _cellItem(
            enableShimmer: false,
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
              vertical: Grid.m,
            ),
            child: PCustomOutlinedButtonWithIcon(
              text: _usCompareAnalysisModel?.symbolName ?? L10n.tr('select'),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              iconSource: ImagesPath.chevron_down,
              foregroundColorApllyBorder: false,
              foregroundColor: context.pColorScheme.primary,
              backgroundColor: context.pColorScheme.secondary,
              iconAlignment: IconAlignment.end,
              onPressed: _isLoading
                  ? null
                  : () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('search_us'),
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        child: SearchCompareSymbolPage(
                          filterDbKeys: [SymbolSearchFilterEnum.foreign.dbKeys!.first],
                          hintText: 'search_us',
                          onTapSymbol: (symbol) async {
                            setState(() {
                              _isLoading = true;
                            });
                            _symbolChartBloc.add(
                              AddPerformanceEvent(
                                index: _usCompareAnalysisModel == null
                                    ? null
                                    : _symbolChartBloc.state.performanceData.indexWhere(
                                        (element) => element.symbolName == _usCompareAnalysisModel!.symbolName,
                                      ),
                                chartPerformance: ChartPerformanceModel(
                                  symbolName: symbol.name,
                                  underlyingName: symbol.underlyingName,
                                  description: symbol.description,
                                  symbolType: stringToSymbolType(
                                    symbol.typeCode,
                                  ),
                                ),
                              ),
                            );
                            setState(() {
                              widget.onTapSymbol?.call(symbol.name);
                              _isLoading = false;
                            });
                          },
                        ),
                      );
                    },
            ),
          ),
          const PDivider(),
          _cellItem(
            enableShimmer: _usCompareAnalysisModel != null &&
                _usCompareAnalysisModel?.marketCap == null &&
                !(_usCompareAnalysisModel?.isDataLoaded ?? false),
            child: _usCompareAnalysisModel?.marketCap == null
                ? Text(
                    '-',
                    style: context.pAppStyle.labelMed14textPrimary,
                  )
                : Text(
                    CurrencyEnum.dollar.symbol +
                        MoneyUtils().compactMoney(_usCompareAnalysisModel!.marketCap?.toDouble() ?? 0),
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
          ),
          const PDivider(),
          _cellItem(
            enableShimmer: _usCompareAnalysisModel != null &&
                _usCompareAnalysisModel?.fk == null &&
                !(_usCompareAnalysisModel?.isDataLoaded ?? false),
            child: _usCompareAnalysisModel?.fk == null
                ? Text(
                    '-',
                    style: context.pAppStyle.labelMed14textPrimary,
                  )
                : Text(
                    MoneyUtils().readableMoney(_usCompareAnalysisModel!.fk ?? 0),
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
          ),
          const PDivider(),
          _cellItem(
            enableShimmer: _usCompareAnalysisModel != null &&
                _usCompareAnalysisModel?.pdDd == null &&
                !(_usCompareAnalysisModel?.isDataLoaded ?? false),
            child: _usCompareAnalysisModel?.pdDd == null
                ? Text(
                    '-',
                    style: context.pAppStyle.labelMed14textPrimary,
                  )
                : Text(
                    MoneyUtils().readableMoney(_usCompareAnalysisModel!.pdDd ?? 0),
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
          ),
          const PDivider(),
          _cellItem(
            enableShimmer: _usCompareAnalysisModel != null &&
                _usCompareAnalysisModel?.exchange == null &&
                !(_usCompareAnalysisModel?.isDataLoaded ?? false),
            child: Text(
              _usCompareAnalysisModel?.exchange ?? '-',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
          const PDivider(),
          _cellItem(
            enableShimmer: _usCompareAnalysisModel != null &&
                _usCompareAnalysisModel?.sector == null &&
                !(_usCompareAnalysisModel?.isDataLoaded ?? false),
            child: Text(
              _usCompareAnalysisModel?.sector ?? '-',
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _getData(String symbolName) async {
    _usCompareAnalysisModel = UsCompareAnalysisModel(
      symbolName: symbolName,
      isDataLoaded: false,
    );
    final Completer<void> snapshotCompleter = Completer<void>();
    final Completer<void> tickerOverviewCompleter = Completer<void>();

    // Detay çekilecek
    _usEquityBloc.add(
      GetSymbolsDetailEvent(
        symbols: [symbolName],
        callback: (usSymbols) {
          snapshotCompleter.complete();
          _usCompareAnalysisModel = _usCompareAnalysisModel!.copyWith(
            price: usSymbols.first.session?.price ?? 0,
          );
        },
      ),
    );
    _usEquityBloc.add(
      GetTickerOverviewEvent(
        symbolName: symbolName,
        callback: (tickerOverView) {
          tickerOverviewCompleter.complete();
          if (tickerOverView == null) return;
          _usCompareAnalysisModel = _usCompareAnalysisModel!.copyWith(
            exchange: tickerOverView.primaryExchange,
            sector: tickerOverView.sicDescription,
            marketCap: tickerOverView.marketCap?.toDouble(),
          );
        },
      ),
    );
    await Future.wait([
      snapshotCompleter.future,
      tickerOverviewCompleter.future,
    ]);
    _usEquityBloc.add(
      GetFinancialDataEvent(
        symbolName: symbolName,
        callback: (usFinancialModel) {
          if (usFinancialModel?.financials.incomeStatement?.items['basic_earnings_per_share']?.value != null &&
              (_usCompareAnalysisModel?.price ?? 0) > 0) {
            _usCompareAnalysisModel = _usCompareAnalysisModel?.copyWith(
                fk: (_usCompareAnalysisModel?.price ?? 0) /
                    usFinancialModel!.financials.incomeStatement!.items['basic_earnings_per_share']!.value);
          }
          if (_usCompareAnalysisModel?.marketCap != null &&
              usFinancialModel?.financials.balanceSheet?.items['equity']?.value != null) {
            _usCompareAnalysisModel = _usCompareAnalysisModel?.copyWith(
                pdDd: _usCompareAnalysisModel!.marketCap! /
                    usFinancialModel!.financials.balanceSheet!.items['equity']!.value);
          }
          _usCompareAnalysisModel = _usCompareAnalysisModel!.copyWith(isDataLoaded: true);
          setState(() {});
        },
      ),
    );
  }

  Widget _cellItem({
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool enableShimmer = false,
  }) {
    return Shimmerize(
      enabled: enableShimmer,
      child: Container(
        height: CompareConstants().cellHeight.toDouble(),
        width: MediaQuery.sizeOf(context).width * 0.3,
        alignment: Alignment.center,
        padding: padding,
        child: child,
      ),
    );
  }
}
