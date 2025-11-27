import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/charts/stacked_bar_chart.dart';
import 'package:piapiri_v2/common/widgets/charts/model/stacked_bar_model.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/brokerage_distribution/bloc/brokerage_bloc.dart';
import 'package:piapiri_v2/app/brokerage_distribution/bloc/brokerage_state.dart';
import 'package:piapiri_v2/app/brokerage_distribution/brokerage_constants.dart';
import 'package:piapiri_v2/app/brokerage_distribution/widget/brokerage_expansion_header.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/common/widgets/list/expansion_sub_tile.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/brokerage_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BrokerageChartPage extends StatefulWidget {
  final int institutionCount;
  final bool isBuyer;
  final int? subExpandedIndex;
  final Function(int) onTapSubTile;
  const BrokerageChartPage({
    super.key,
    required this.institutionCount,
    required this.isBuyer,
    required this.subExpandedIndex,
    required this.onTapSubTile,
  });

  @override
  State<BrokerageChartPage> createState() => _BrokerageChartPageState();
}

class _BrokerageChartPageState extends State<BrokerageChartPage> {
  bool _isBuyerExpanded = true;
  late BrokerageBloc _brokerageBloc;
  late AppInfoState _appInfoState;
  @override
  void initState() {
    _brokerageBloc = getIt<BrokerageBloc>();
    _appInfoState = getIt<AppInfoBloc>().state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<BrokerageBloc, BrokerageState>(
        bloc: _brokerageBloc,
        builder: (context, state) {
          List<MainBrokerageModel> mainBrokerageList =
              widget.isBuyer ? (state.data?.tops.bid ?? []) : (state.data?.tops.ask ?? []);
          if (state.isLoading) return const PLoading();

          return PExpandablePanel(
            initialExpanded: _isBuyerExpanded,
            isExpandedChanged: (isExpanded) {
              _isBuyerExpanded = isExpanded;
            },
            titleBuilder: (isExpanded) {
              return Row(
              children: [
                Text(
                  widget.isBuyer ? L10n.tr('buyer') : L10n.tr('seller'),
                  style: context.pAppStyle.labelMed16textPrimary,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                SvgPicture.asset(
                    isExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(context.pColorScheme.textPrimary, BlendMode.srcIn),
                ),
              ],
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: BrokerageConstants.chartTitleHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        L10n.tr(
                          'first_buyer',
                          args: ['${widget.institutionCount}'],
                        ),
                        style: context.pAppStyle.labelReg14textSecondary,
                      ),
                      Text(
                        MoneyUtils().compactMoney(state.topBuyers.toDouble()),
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Grid.xs + Grid.s,
                ),
                StackedBarChart(
                  height: BrokerageConstants.chartHeight,
                  charDataList: _generateChartModel(mainBrokerageList),
                ),
                const SizedBox(
                  height: Grid.l,
                ),
                SizedBox(
                  height: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        L10n.tr('institution_percentage'),
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                      Text(
                        L10n.tr('net_adet'),
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Grid.xs + Grid.s,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - Grid.m * 2,
                  child: ListView.separated(
                      itemCount: mainBrokerageList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const PDivider(),
                      itemBuilder: (context, index) {
                        bool isExpanded = widget.subExpandedIndex == index;
                        AllBrokerageModel? allBrokerageModel = state.data?.all
                            .firstWhereOrNull((element) => element.agent == mainBrokerageList[index].agent);
                        return PExpandablePanel(
                          initialExpanded: isExpanded,
                          isExpandedChanged: (p0) {
                            isExpanded = p0;
                            widget.onTapSubTile(index);
                            setState(() {});
                          },
                          titleBuilder: (_) => BrokerageExpansionHeader(
                            agent: _appInfoState.memberCodeShortNames[mainBrokerageList[index].agent] ??
                                mainBrokerageList[index].agent,
                            ratio: MoneyUtils().ratioFormat(mainBrokerageList[index].netPercent),
                            quantity: MoneyUtils().compactMoney(mainBrokerageList[index].netQuantity.toDouble()),
                            isExpanded: isExpanded,
                            color: index == mainBrokerageList.length - 1
                                ? context.pColorScheme.assetColors.last
                                : context.pColorScheme.assetColors[index],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionSubTile(
                                title: L10n.tr('net_maliyet'),
                                value: MoneyUtils().compactMoney(mainBrokerageList[index].cost),
                              ),
                              ExpansionSubTile(
                                title: L10n.tr('alis_adet'),
                                value: MoneyUtils().compactMoney(mainBrokerageList[index].quantity.toDouble()),
                              ),
                              ExpansionSubTile(
                                title: L10n.tr('satis_adet'),
                                value: MoneyUtils().compactMoney(widget.isBuyer
                                    ? (allBrokerageModel?.ask.quantity.toDouble() ?? 0)
                                    : (allBrokerageModel?.bid.quantity.toDouble() ?? 0)),
                              ),
                              ExpansionSubTile(
                                title: L10n.tr('takas_rt'),
                                value: MoneyUtils().compactMoney(mainBrokerageList[index].swapRt),
                              ),
                              const SizedBox(
                                height: Grid.s + Grid.xs,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),

          );
        });
  }

  List<StackedBarModel> _generateChartModel(List<MainBrokerageModel> data) {
    List<StackedBarModel> chartData = [];
    for (var i = 0; i < data.length; i++) {
      chartData.add(
        StackedBarModel(
          percent: data[i].netPercent,
          color: i == data.length - 1 ? context.pColorScheme.assetColors.last : context.pColorScheme.assetColors[i],
        ),
      );
    }

    return chartData;
  }
}
