import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/charts/stacked_bar_chart.dart';
import 'package:piapiri_v2/common/widgets/charts/model/stacked_bar_model.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_state.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/advices/widgets/advice_history_card.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AdviceHistoryWidget extends StatefulWidget {
  final String mainGroup;
  final bool? canShowAllText;
  const AdviceHistoryWidget({
    super.key,
    required this.mainGroup,
    this.canShowAllText = false,
  });

  @override
  State<AdviceHistoryWidget> createState() => _AdviceHistoryWidgetState();
}

class _AdviceHistoryWidgetState extends State<AdviceHistoryWidget> {
  final AdvicesBloc _advicesBloc = getIt<AdvicesBloc>();
  bool _showAll = false;
  List<DropdownModel<int>> _yearFilterList = [];
  late DropdownModel _selectedYear;
  final List<Color> _chartColors = [
    const Color(0xFFeb5828),
    const Color(0xFF4682B4),
  ];

  @override
  initState() {
    _yearFilterList = buildYearFilterList();
    _selectedYear = _yearFilterList.first;
    _advicesBloc.add(
      GetAdviceHistoryEvent(
        mainGroup: widget.mainGroup,
        year: _selectedYear.value,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AdvicesBloc, AdvicesState>(
      bloc: getIt<AdvicesBloc>(),
      builder: (context, state) {
        return Shimmerize(
          enabled: state.advicesState == PageState.loading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PCustomOutlinedButtonWithIcon(
                text: _selectedYear.name,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                iconSource: ImagesPath.chevron_down,
                foregroundColorApllyBorder: false,
                foregroundColor: context.pColorScheme.primary,
                backgroundColor: context.pColorScheme.secondary,
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('sumaryDateRange'),
                    titlePadding: const EdgeInsets.only(
                      top: Grid.m,
                    ),
                    child: ListView.separated(
                      itemCount: _yearFilterList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return BottomsheetSelectTile(
                          title: _yearFilterList[index].name,
                          isSelected: _selectedYear == _yearFilterList[index],
                          value: _yearFilterList[index],
                          onTap: (_, value) {
                            setState(() {
                              _selectedYear = value;
                            });
                            _advicesBloc.add(
                              GetAdviceHistoryEvent(
                                mainGroup: widget.mainGroup,
                                year: _selectedYear.value,
                              ),
                            );

                            router.maybePop();
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const PDivider(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: Grid.m,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    L10n.tr('number_of_closed_trade_suggestions'),
                    style: context.pAppStyle.labelReg14textSecondary,
                  ),
                  Text(
                    '${state.adviceHistoryModel.closedAdviceCount ?? ''}',
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                ],
              ),
              const SizedBox(height: Grid.s + Grid.xs),
              StackedBarChart(
                charDataList: _generateChartModel(
                  context,
                  [
                    ((state.adviceHistoryModel.closedWithProfit ?? 0)).toDouble(),
                    ((state.adviceHistoryModel.closedWithLoss ?? 0)).toDouble(),
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.l,
              ),
              ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: [
                  ((state.adviceHistoryModel.closedWithProfit ?? 0)).toDouble(),
                  ((state.adviceHistoryModel.closedWithLoss ?? 0)).toDouble(),
                ].length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.m,
                  ),
                  child: PDivider(),
                ),
                itemBuilder: (context, index) {
                  double closedWithProfit =
                      (state.adviceHistoryModel.closedWithProfit ?? 0).toDouble(); // Kar ile Kapatan
                  double closedWithLoss =
                      (state.adviceHistoryModel.closedWithLoss ?? 0).toDouble(); // Zarar ile Kapatan

                  double total = closedWithProfit + closedWithLoss;

                  return Row(
                    children: [
                      Container(
                        height: 30,
                        width: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: index ==
                                  [
                                        ((state.adviceHistoryModel.closedWithProfit ?? 0)).toDouble(),
                                        ((state.adviceHistoryModel.closedWithLoss ?? 0)).toDouble(),
                                      ].length -
                                      1
                              ? _chartColors.last
                              : _chartColors[index],
                        ),
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            L10n.tr(
                              index == 0 ? L10n.tr('closed_with_profit') : L10n.tr('closed_with_loss'),
                            ),
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          Text(
                            index == 0
                                ? '%${MoneyUtils().readableMoney((closedWithProfit / total) * 100)}'
                                : '%${MoneyUtils().readableMoney((closedWithLoss / total) * 100)}',
                            style: context.pAppStyle.labelReg14textSecondary,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        index == 0
                            ? '${state.adviceHistoryModel.closedWithProfit ?? '0'} ${L10n.tr('advice')}'
                            : '${state.adviceHistoryModel.closedWithLoss ?? '0'} ${L10n.tr('advice')}',
                      )
                    ],
                  );
                },
              ),
              const SizedBox(
                height: Grid.m,
              ),
              const PDivider(),
              const SizedBox(
                height: Grid.s,
              ),
              if (state.adviceHistoryModel.closedAdvices != null && state.adviceHistoryModel.closedAdvices!.isNotEmpty)
                ListView.separated(
                  itemCount: _showAll || widget.canShowAllText == false
                      ? state.adviceHistoryModel.closedAdvices!.length
                      : (state.adviceHistoryModel.closedAdvices!.length > 2
                          ? 2
                          : state.adviceHistoryModel.closedAdvices!
                              .length), // Eğer canShowAllText true ise ve item sayısı 2 den büyükse sadece 2 tane listeleyip, Daha Fazla Göster butonunu gösterdiğimiz kontrol.
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Grid.s,
                    ),
                    child: PDivider(),
                  ),
                  itemBuilder: (context, index) {
                    return AdviceHistoryCard(
                      closedAdvices: state.adviceHistoryModel.closedAdvices![index],
                      symbol: MarketListModel(
                        symbolCode: state.adviceHistoryModel.closedAdvices![index].symbolName,
                        updateDate: '',
                      ),
                      isForeign: widget.mainGroup == MarketTypeEnum.marketUs.value,
                    );
                  },
                ),
              const SizedBox(
                height: Grid.m,
              ),
              if (!_showAll &&
                  state.adviceHistoryModel.closedAdvices != null &&
                  state.adviceHistoryModel.closedAdvices!.length > 2) // Eğer tümü gösterilmiyorsa butonu ekle
                PCustomPrimaryTextButton(
                  margin: const EdgeInsets.symmetric(),
                  text: L10n.tr('show_more_list'),
                  onPressed: () => setState(() {
                    _showAll = true;
                  }),
                ),
              const SizedBox(
                height: Grid.m,
              ),
            ],
          ),
        );
      },
    );
  }

  List<StackedBarModel> _generateChartModel(BuildContext context, List<double> data) {
    List<StackedBarModel> chartData = [];

    for (var i = 0; i < data.length; i++) {
      if (data[i].abs() != 0) {
        chartData.add(
          StackedBarModel(
            percent: data[i].abs(),
            color: i == data.length - 1 ? _chartColors.last : _chartColors[i],
          ),
        );
      }
    }

    return chartData;
  }

  List<DropdownModel<int>> buildYearFilterList() {
    final int currentYear = DateTime.now().year;
    final int startYear = currentYear;
    final int endYear = (currentYear - 4 >= 2024) ? currentYear - 4 : 2024;

    List<DropdownModel<int>> yearList = [];

    for (int y = startYear; y >= endYear; y--) {
      yearList.add(
        DropdownModel(
          name: y.toString(),
          value: y,
        ),
      );
    }

    // En sona Tüm Zamanlar
    yearList.add(
      DropdownModel(
        name: L10n.tr('all_times'),
        value: 0,
      ),
    );

    return yearList;
  }
}
