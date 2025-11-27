import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/chart_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolChartOptions extends StatelessWidget {
  final bool hasCurrencySwitch;
  final bool showChartCurrency;
  final bool hasGraphType;
  final CurrencyEnum selectedCurrencyEnum;
  final ChartType? selectedType;
  final ChartFilter chartFilter;
  final List<ChartFilter> chartFilterList;
  final Function(int value) onFilterChanged;
  final Function(CurrencyEnum value) onCurrencyChanged;
  final Function(ChartType value)? onTypeChanged;

  const SymbolChartOptions({
    super.key,
    this.hasCurrencySwitch = true,
    this.showChartCurrency = true,
    this.hasGraphType = true,
    required this.selectedCurrencyEnum,
    this.selectedType,
    required this.chartFilter,
    required this.chartFilterList,
    required this.onFilterChanged,
    required this.onCurrencyChanged,
    this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          child: SlidingSegment(
            initialSelectedSegment: chartFilterList.indexOf(chartFilter),
            slidingSegmentWidth: MediaQuery.sizeOf(context).width - (Grid.m * 2) - 80,
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
            segmentList: chartFilterList
                .map(
                  (e) => PSlidingSegmentModel(
                    segmentTitle: L10n.tr(e.localizationKey),
                    segmentColor: context.pColorScheme.backgroundColor,
                  ),
                )
                .toList(),
            onValueChanged: (int value) => onFilterChanged(value),
          ),
        ),
        const SizedBox(
          width: Grid.s,
        ),
        if (showChartCurrency)
          InkWell(
            onTap: !hasCurrencySwitch
                ? null
                : () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('chartCurrency'),
                      titlePadding: const EdgeInsets.only(
                        top: Grid.m,
                      ),
                      child: ListView.separated(
                        itemCount: 2,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const PDivider(),
                        itemBuilder: (context, index) {
                          CurrencyEnum currency = index == 0 ? CurrencyEnum.turkishLira : CurrencyEnum.dollar;
                          return BottomsheetSelectTile(
                            value: currency,
                            title: L10n.tr(currency.shortName),
                            isSelected: selectedCurrencyEnum == currency,
                            onTap: (String title, value) => onCurrencyChanged(value),
                          );
                        },
                      ),
                    );
                  },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: context.pColorScheme.card,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                selectedCurrencyEnum.symbol,
                style: context.pAppStyle.labelReg16textPrimary,
              ),
            ),
          ),
        if (hasGraphType && selectedType != null) ...[
          const SizedBox(
            width: Grid.s,
          ),
          InkWell(
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: context.pColorScheme.card,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                selectedType!.imagePath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            onTap: () {
              PBottomSheet.show(
                context,
                title: L10n.tr('chart_type'),
                titlePadding: const EdgeInsets.only(
                  top: Grid.m,
                ),
                child: ListView.separated(
                  itemCount: ChartType.values.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const PDivider(),
                  itemBuilder: (context, index) {
                    ChartType chartType = ChartType.values[index];
                    return BottomsheetSelectTile(
                      value: chartType,
                      title: L10n.tr(chartType.localizationKey),
                      isSelected: selectedType == chartType,
                      prefix: SvgPicture.asset(
                        chartType.imagePath,
                        width: 17,
                        height: 17,
                        colorFilter: ColorFilter.mode(
                          selectedType == chartType ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      onTap: (String title, value) => onTypeChanged?.call(value),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
