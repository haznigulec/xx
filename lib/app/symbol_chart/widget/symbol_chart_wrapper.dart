import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_chart/widget/symbol_chart.dart';
import 'package:piapiri_v2/app/symbol_chart/widget/symbol_chart_options.dart';
import 'package:piapiri_v2/common/widgets/charts/chart_loading_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class SymbolChartWrapper extends StatefulWidget {
  final String symbolName;
  final String symbolType;

  const SymbolChartWrapper({
    super.key,
    required this.symbolName,
    required this.symbolType,
  });

  @override
  State<SymbolChartWrapper> createState() => _SymbolChartWrapperState();
}

class _SymbolChartWrapperState extends State<SymbolChartWrapper> {
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  final List<ChartFilter> _chartFilterList = ChartFilter.values
      .where(
        (element) =>
            element != ChartFilter.sixMonth &&
            element != ChartFilter.fiveYear &&
            element != ChartFilter.threeYear &&
            element != ChartFilter.threeMonth,
      )
      .toList();

  @override
  void initState() {
    final symbolType = stringToSymbolType(widget.symbolType);
    _symbolChartBloc.add(
      GetDataEvent(
        symbolName: widget.symbolName,
        chartCurrency: symbolType == SymbolTypes.parity ? CurrencyEnum.turkishLira : null,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PBlocBuilder<SymbolChartBloc, SymbolChartState>(
          bloc: _symbolChartBloc,
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(
                  height: Grid.m,
                ),
                if (state.isLoading || state.isFailed || (!state.isLoading && state.chartData.isEmpty))
                  ChartLoadingWidget(
                    isFailed: state.isFailed || (!state.isLoading && state.chartData.isEmpty),
                  )
                else ...[
                  SymbolChart(
                    symbolName: widget.symbolName,
                    chartType: state.chartType,
                    isFailed: state.isFailed,
                    chartData: state.chartData,
                    isLoading: state.isLoading,
                    chartCurrencySymbol:
                        stringToSymbolType(widget.symbolType) == SymbolTypes.parity ? '' : state.chartCurrency.symbol,
                    selectedFilter: state.selectedFilter,
                  ),
                ],
                const SizedBox(
                  height: Grid.s,
                ),

                /// Burada Chart periodu, Currency ve chart type seçimleri yapılıyor
                SymbolChartOptions(
                  selectedCurrencyEnum: state.chartCurrency,
                  chartFilter: state.selectedFilter,
                  chartFilterList: _chartFilterList,
                  selectedType: state.chartType,
                  onFilterChanged: (index) {
                    _symbolChartBloc.add(
                      GetDataEvent(
                        symbolName: widget.symbolName,
                        filter: _chartFilterList[index],
                        chartCurrency: stringToSymbolType(widget.symbolType) == SymbolTypes.parity
                            ? CurrencyEnum.turkishLira
                            : null,
                      ),
                    );
                  },
                  onCurrencyChanged: (currencyEnum) {
                    Navigator.pop(context);
                    if (currencyEnum != _symbolChartBloc.state.chartCurrency) {
                      _symbolChartBloc.add(
                        SymbolChangeChartCurrencyEvent(),
                      );
                      _symbolChartBloc.add(
                        GetDataEvent(
                          symbolName: widget.symbolName,
                          chartCurrency: stringToSymbolType(widget.symbolType) == SymbolTypes.parity
                              ? CurrencyEnum.turkishLira
                              : null,
                        ),
                      );
                    }
                  },
                  onTypeChanged: (chartType) {
                    Navigator.pop(context);
                    if (chartType != state.chartType) {
                      _symbolChartBloc.add(
                        SetChartTypeEvent(
                          chartType: chartType,
                        ),
                      );
                    }
                  },
                  showChartCurrency: stringToSymbolType(widget.symbolType) != SymbolTypes.parity,
                ),
                const SizedBox(
                  height: Grid.l,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
