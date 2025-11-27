import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

class BottomsheetCashWidget extends StatelessWidget {
  final List<Map<String, dynamic>> titles;
  final bool isDefaultParity;
  final double totalUsdOverall;
  final bool isVisible;
  const BottomsheetCashWidget({
    super.key,
    required this.titles,
    required this.isDefaultParity,
    required this.totalUsdOverall,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: titles.length,
      itemBuilder: (context, index) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[index]['title'].toString(),
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                    if (titles[index]['description'] != null)
                      const SizedBox(
                        height: Grid.xxs / 2,
                      ),
                    Text(
                      titles[index]['description'].toString(),
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
                Text(
                    isDefaultParity
                        ? isVisible
                            ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(titles[index]['amount'])}'
                            : '${CurrencyEnum.turkishLira.symbol}**'
                        : isVisible
                            ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(titles[index]['amount'] / totalUsdOverall)}'
                            : '${CurrencyEnum.dollar.symbol}**',
                    style: context.pAppStyle.labelMed14textPrimary),
              ],
            ),
          ),
          if (index != titles.length - 1) const PDivider(),
        ],
      ),
    );
  }
}
