import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/charts/range_bar.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundPerformanceWidget extends StatefulWidget {
  final FundDetailModel fund;
  const FundPerformanceWidget({
    super.key,
    required this.fund,
  });

  @override
  State<FundPerformanceWidget> createState() => _FundPerformanceWidgetState();
}

class _FundPerformanceWidgetState extends State<FundPerformanceWidget> {
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  final List<ChartFilter> _chartFilterList = [
    ChartFilter.oneMonth,
    ChartFilter.threeMonth,
    ChartFilter.sixMonth,
    ChartFilter.oneYear,
    ChartFilter.threeYear,
    ChartFilter.fiveYear,
  ];
  ChartFilter _selectedFilter = ChartFilter.oneMonth;
  Map<ChartFilter, double> _performanceData = {};
  @override
  void initState() {
    _symbolChartBloc.add(
      GetPerformanceEvent(
        performanceFilter: _selectedFilter,
        isInitial: true,
        isFundPerformance: true,
        chartPerformanceModels: [
          ..._symbolChartBloc.state.fundCompareSymbols,
          ChartPerformanceModel(
            symbolName: widget.fund.code,
            underlyingName: widget.fund.institutionCode,
            symbolType: SymbolTypes.fund,
            description: '',
          )
        ],
      ),
    );
    _performanceData = {
      ChartFilter.oneMonth: widget.fund.performance1M,
      ChartFilter.threeMonth: widget.fund.performance3M,
      ChartFilter.sixMonth: widget.fund.performance6M,
      ChartFilter.oneYear: widget.fund.performance1Y,
      ChartFilter.threeYear: widget.fund.performance3Y,
      ChartFilter.fiveYear: widget.fund.performance5Y,
    };
    _chartFilterList.removeWhere(
      (filter) => (_performanceData[filter] ?? 0) == 0,
    );
    if (!_chartFilterList.contains(_selectedFilter)) {
      _selectedFilter = _chartFilterList.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _chartFilterList.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .3,
                      child: Text(
                        L10n.tr('performans'),
                        style: context.pAppStyle.labelMed18textPrimary,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: SlidingSegment(
                        initialSelectedSegment: _chartFilterList.indexOf(_selectedFilter),
                        slidingSegmentWidth: MediaQuery.sizeOf(context).width * .6,
                        backgroundColor: context.pColorScheme.card,
                        slidingSegmentRadius: Grid.m,
                        dividerColor: context.pColorScheme.transparent,
                        selectedTextStyle: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m - Grid.xxs,
                          color: context.pColorScheme.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                        unSelectedTextStyle: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m - Grid.xxs,
                          color: context.pColorScheme.textTeritary,
                        ),
                        segmentList: _chartFilterList
                            .map(
                              (e) => PSlidingSegmentModel(
                                segmentTitle: L10n.tr(e.performanceLocalizationKey),
                                segmentColor: context.pColorScheme.backgroundColor,
                              ),
                            )
                            .toList(),
                        onValueChanged: (int value) {
                          _selectedFilter = _chartFilterList[value];
                          _symbolChartBloc.add(
                            GetPerformanceEvent(
                              performanceFilter: _selectedFilter,
                              isFundPerformance: true,
                              chartPerformanceModels: [
                                ..._symbolChartBloc.state.fundCompareSymbols,
                                ChartPerformanceModel(
                                  symbolName: widget.fund.code,
                                  underlyingName: widget.fund.institutionCode,
                                  symbolType: SymbolTypes.fund,
                                  description: '',
                                )
                              ],
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                PBlocBuilder<SymbolChartBloc, SymbolChartState>(
                  bloc: _symbolChartBloc,
                  builder: (context, state) {
                    double minValue = 0;
                    double maxValue = 0;
                    double maxDiffWidth = 0;

                    if (state.performanceData.isNotEmpty) {
                      minValue =
                          state.performanceData.map((e) => e.performance as double).reduce((a, b) => a < b ? a : b);
                      maxValue =
                          state.performanceData.map((e) => e.performance as double).reduce((a, b) => a > b ? a : b);
                      if (minValue > 0) minValue = 0;

                      // 🔹 Tüm DiffPercentage metinlerinin genişliğini ölç
                      final textStyle = context.pAppStyle.labelMed12textPrimary.copyWith(
                        fontSize: Grid.s + Grid.xs,
                      );
                      for (final perf in state.performanceData) {
                        final text =
                            "${(perf.performance ?? 0) >= 0 ? '+' : ''}${(perf.performance ?? 0).toStringAsFixed(2)}%";
                        final textPainter = TextPainter(
                          text: TextSpan(text: text, style: textStyle),
                          textDirection: TextDirection.ltr,
                        )..layout();
                        if (textPainter.width > maxDiffWidth) {
                          maxDiffWidth = textPainter.width;
                        }
                      }
                      maxDiffWidth += Grid.m + Grid.xxs;
                    }
                    if (maxDiffWidth <= 0) {
                      maxDiffWidth = 70;
                    }

                    return Shimmerize(
                      enabled: state.isLoading,
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.isLoading ? 5 : state.performanceData.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: Grid.m + Grid.xs,
                              ),
                          itemBuilder: (context, index) {
                            ChartPerformanceModel? performanceData;
                            if (state.performanceData.length > index) {
                              performanceData = state.performanceData[index];
                            } else {
                              performanceData = null;
                            }
                            SymbolTypes symbolType = performanceData?.symbolType ?? SymbolTypes.equity;
                            return Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .3,
                                  child: Row(
                                    children: [
                                      SymbolIcon(
                                        size: 15,
                                        symbolName: [
                                          SymbolTypes.future,
                                          SymbolTypes.option,
                                          SymbolTypes.warrant,
                                          SymbolTypes.fund,
                                        ].contains(symbolType)
                                            ? performanceData?.underlyingName ?? '-'
                                            : performanceData?.symbolName ?? '-',
                                        symbolType: symbolType,
                                      ),
                                      const SizedBox(
                                        width: Grid.xs,
                                      ),
                                      Text(
                                        L10n.tr(performanceData?.symbolName ?? '-------'),
                                        style: context.pAppStyle.labelReg12textPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: RangeBar(
                                          value: performanceData?.performance ?? 0,
                                          minValue: minValue,
                                          maxValue: maxValue,
                                        ),
                                      ),
                                      SizedBox(
                                        width: maxDiffWidth,
                                        child: DiffPercentage(
                                          percentage: performanceData?.performance ?? 0,
                                          rowMainAxisAlignment: MainAxisAlignment.end,
                                          fontSize: Grid.s + Grid.xs,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                    );
                  },
                ),
                const SizedBox(
                  height: Grid.l,
                )
              ],
            ),
          );
  }
}
