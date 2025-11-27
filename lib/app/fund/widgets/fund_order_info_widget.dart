import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/charts/risk_bar.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';

import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundOrderInfoWidget extends StatelessWidget {
  final FundDetailModel fund;
  final double? fundPrice;

  const FundOrderInfoWidget({
    super.key,
    required this.fund,
    this.fundPrice,
  });

  @override
  Widget build(BuildContext context) {
    double price;
    if (fundPrice != null && fundPrice != 0) {
      price = fundPrice!;
    } else if (fund.price != null && fund.price != 0) {
      price = fund.price!;
    } else {
      price = 0;
    }
    double performance = (fund.performance1D ?? 0) * 100;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SymbolIcon(
              symbolName: fund.institutionCode,
              symbolType: SymbolTypes.fund,
              size: 30,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fund.subType,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                Text(
                  '${fund.code} • ${fund.founder.toCapitalizeCaseTr}',
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () => SymbolSearchUtils.goSymbolDetail(
                filterList: SymbolSearchFilterEnum.values
                    .where(
                      (element) => ![
                        SymbolSearchFilterEnum.crypto,
                        SymbolSearchFilterEnum.parity,
                        SymbolSearchFilterEnum.preciousMetals,
                        SymbolSearchFilterEnum.endeks,
                        SymbolSearchFilterEnum.etf,
                      ].contains(element),
                    )
                    .toList(),
              ),
              child: SvgPicture.asset(
                ImagesPath.search,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Grid.s),
          child: PDivider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  L10n.tr('fiyat'),
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                Text(
                  '₺${MoneyUtils().readableMoney(
                    price,
                    pattern: '#,##0.000000',
                  )}',
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  L10n.tr('risk_level'),
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                fund.riskLevel != null && fund.riskLevel != 0
                    ? RiskBar(riskLevel: fund.riskLevel!)
                    : Text(
                        '-',
                        style: context.pAppStyle.labelMed14textSecondary,
                      ),
              ],
            ),
            Column(
              children: [
                Text(
                  '%${L10n.tr('fark')}',
                  style: context.pAppStyle.labelMed14textSecondary,
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                DiffPercentage(
                  percentage: performance,
                  fontSize: Grid.m - Grid.xxs,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
