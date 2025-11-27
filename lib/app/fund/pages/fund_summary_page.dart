import 'package:piapiri_v2/common/widgets/charts/stacked_bar_chart.dart';
import 'package:piapiri_v2/common/widgets/charts/model/stacked_bar_model.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/pages/fund_brief.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_chart_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_components_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_info.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_market_session.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_performance_detail_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_performance_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/volume_infos_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/market_review_list.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/sectors_widget.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundSummaryPage extends StatefulWidget {
  final FundDetailModel fund;
  const FundSummaryPage({
    super.key,
    required this.fund,
  });

  @override
  State<FundSummaryPage> createState() => _FundSummaryPageState();
}

class _FundSummaryPageState extends State<FundSummaryPage> {
  late FundBloc _fundBloc;
  late List<Map<String, dynamic>> _keyValueList;
  Map<String, double> _performanceData = {};
  final TimeBloc _timeBloc = getIt<TimeBloc>();

  @override
  void initState() {
    _fundBloc = getIt<FundBloc>();
    _keyValueList = widget.fund.extra.entries
        .where((entry) => entry.value != null && entry.value != 0)
        .map((entry) => {'key': entry.key, 'value': entry.value})
        .toList();
    _performanceData = {
      '7g': widget.fund.performance1W,
      '30g': widget.fund.performance1M,
      '3M': widget.fund.performance3M,
      '6M': widget.fund.performance6M,
      'NEWYEAR': widget.fund.performanceNewYear,
      '52h': widget.fund.performance1Y,
      '3Y': widget.fund.performance3Y,
      '5Y': widget.fund.performance5Y,
    };
    super.initState();
  }

  DateTime getCurrentTime() {
    if (_timeBloc.state.mxTime != null) {
      DateTime mxtime = DateTime.fromMicrosecondsSinceEpoch(_timeBloc.state.mxTime!.timestamp.toInt());
      return DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, mxtime.hour, mxtime.minute, mxtime.second);
    } else {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: Grid.m,
      ),
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: FundInfo(
              fund: widget.fund,
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          if ((widget.fund.tefasStartTime.replaceAll(RegExp(r'\s+'), '').isNotEmpty &&
                  widget.fund.tefasEndTime.replaceAll(RegExp(r'\s+'), '').isNotEmpty) &&
              getCurrentTime().isAfter(DateTimeUtils.strToNowAndTime(widget.fund.tefasStartTime)) &&
              getCurrentTime().isBefore(DateTimeUtils.strToNowAndTime(widget.fund.tefasEndTime))) ...[
            const FundMarketSessionWidget(),
            const SizedBox(
              height: Grid.s,
            ),
          ],
          const SizedBox(
            height: Grid.s,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: FundChartWidget(
              fundCode: widget.fund.code,
            ),
          ),
          const SizedBox(height: Grid.l),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: FundBrief(
              fund: widget.fund,
              context: context,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: FundPerformanceDetailWidget(
              symbolName: widget.fund.code,
              price: widget.fund.price ?? 0,
              performanceData: _performanceData,
            ),
          ),
          const SizedBox(height: Grid.l),
          FundPerformanceWidget(
            fund: widget.fund,
          ),
          if (widget.fund.applicationCategoryName != null && widget.fund.applicationCategoryCode != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: SectorsWidget(
                title: L10n.tr('fund_sub_type'),
                sectors: [
                  {
                    'name': widget.fund.applicationCategoryName,
                    'code': widget.fund.applicationCategoryCode.toString(),
                  },
                ],
                onPressed: (name, code) async {
                  _fundBloc.add(
                    SetFilterEvent(
                      fundFilter: FundFilterModel(
                        institution: '',
                        institutionName: '',
                        applicationCategory: code,
                      ),
                      callback: (list) {},
                    ),
                  );
                  router.push(
                    FundsListRoute(
                      title: name,
                      fromSectors: true,
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: Grid.l),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              L10n.tr('fund_components'),
              style: context.pAppStyle.labelMed18textPrimary,
            ),
          ),
          const SizedBox(height: Grid.m),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  L10n.tr('fund_total_value'),
                  style: context.pAppStyle.labelMed14textSecondary,
                ),
                Text(
                  '₺${MoneyUtils().compactMoney(widget.fund.portfolioSize)}',
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.l / 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: StackedBarChart(
              charDataList: _generateChartModel(_keyValueList),
            ),
          ),
          const SizedBox(
            height: Grid.l,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: FundComponentsWidget(
              keyValueList: _keyValueList,
              totalValue: widget.fund.portfolioSize,
              isShowAllText: true,
            ),
          ),
          const SizedBox(height: Grid.l),
          const VolumeInfosWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: MarketReviewList(
              mainGroup: MarketTypeEnum.marketFund.value,
              symbolName: widget.fund.code,
            ),
          ),
        ],
      ),
    );
  }

  List<StackedBarModel> _generateChartModel(List<Map<String, dynamic>> keyValueList) {
    List<StackedBarModel> chartData = [];
    for (var i = 0; i < keyValueList.length; i++) {
      chartData.add(
        StackedBarModel(
          percent: keyValueList[i]['value'],
          color: i == keyValueList.length - 1
              ? context.pColorScheme.assetColors.last
              : context.pColorScheme.assetColors[i],
        ),
      );
    }
    return chartData;
  }
}
