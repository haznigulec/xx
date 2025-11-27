import 'package:country_flags/country_flags.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/economic_calender/model/calendar_item_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EconomicCalendarTile extends StatelessWidget {
  final CalendarItemModel item;
  final int lastIndex;
  final int index;
  const EconomicCalendarTile({
    super.key,
    required this.item,
    required this.lastIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: Card(
            margin: EdgeInsets.zero,
            color: context.pColorScheme.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.countryCode == 'EU') ...[
                  const SymbolIcon(
                    symbolName: 'ME_EUR',
                    size: 28,
                    symbolType: SymbolTypes.parity,
                  ),
                ] else ...[
                  CountryFlag.fromCountryCode(
                    width: 28,
                    height: 28,
                    item.countryCode == 'UK' ? 'gb' : item.countryCode ?? '',
                    shape: const Circle(),
                  ),
                ],
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.indicatorName ?? '',
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                        ),
                        const SizedBox(
                          width: Grid.l,
                        ),
                        ..._preparePriority(
                          item.priority ?? '1',
                          context,
                        ),
                        const SizedBox(
                          width: Grid.s,
                        ),
                        Text(
                          item.countryCode ?? '',
                          style: context.pAppStyle.labelMed12textPrimary,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: Grid.xs,
                    ),
                    Text(
                      ' ${DateTimeUtils.dateFormat(DateTime.parse(item.date))} ${item.time}${item.period.isNotEmpty ? ', ${item.period}' : ''}',
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _info(
                          'onceki',
                          item.previous.replaceAll('.', ','),
                          context,
                        ),
                        _info(
                          'tahmin',
                          item.concensus.replaceAll('.', ','),
                          context,
                        ),
                        _info(
                          'gercek',
                          item.actual.replaceAll('.', ','),
                          context,
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
        if (lastIndex != index) const PDivider()
      ],
    );
  }

  Widget _priorityIndicator(Color color) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _preparePriority(String priority, BuildContext context) {
    int priorityCount = int.parse(priority);
    // 1 - Low
    // 2 - Mid
    // 3 - High
    int unpriorCount = 3 - priorityCount;
    List<Widget> priorityIndicator = [];
    for (var i = 0; i < priorityCount; i++) {
      priorityIndicator.add(_priorityIndicator(context.pColorScheme.success));
    }
    for (var i = 0; i < unpriorCount; i++) {
      priorityIndicator.add(_priorityIndicator(context.pColorScheme.iconPrimary));
    }
    return priorityIndicator;
  }

  Widget _info(
    String title,
    String data,
    BuildContext context,
  ) {
    return RichText(
      text: TextSpan(
        text: L10n.tr(title),
        style: context.pAppStyle.labelMed12textSecondary,
        children: [
          TextSpan(
            text: data.isNotEmpty ? ' $data' : ' -',
            style: context.pAppStyle.labelMed12textPrimary,
          ),
        ],
      ),
    );
  }
}
