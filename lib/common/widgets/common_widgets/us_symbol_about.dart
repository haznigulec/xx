import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/symbol_about_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

import 'package:piapiri_v2/core/model/ticker_overview.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsSymbolAbout extends StatelessWidget {
  final TickerOverview tickerOverview;
  const UsSymbolAbout({
    super.key,
    required this.tickerOverview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SymbolAboutTile(
              leading: L10n.tr('sirket_adi'),
              trailing: tickerOverview.name ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('ticker_code'),
              trailing: tickerOverview.ticker,
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('market_cap'),
              trailing:
                  '${CurrencyEnum.dollar.symbol}${MoneyUtils().compactMoney(double.parse((tickerOverview.marketCap ?? 0).toString()))}',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('share_class_shares_outstanding'),
              trailing:
                  '${CurrencyEnum.dollar.symbol}${MoneyUtils().compactMoney(double.parse((tickerOverview.shareClassSharesOutstanding ?? 0).toString()))}',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('merkez_adres'),
              trailing:
                  StringUtils().capitalizeEachWord(
                  '${tickerOverview.address?.address1}, ${tickerOverview.address?.city}, ${tickerOverview.address?.state} ${tickerOverview.address?.postalCode}'),
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('web_adres'),
              trailing: tickerOverview.homepageUrl ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('phone_number'),
              trailing: tickerOverview.phoneNumber ?? '',
              ignoreHeight: true,
            ),
            const PDivider(),
            SymbolAboutTile(
              leading: L10n.tr('total_employees'),
              trailing: MoneyUtils().readableMoney(
                tickerOverview.totalEmployees ?? 0,
                pattern: '#,##0',
              ),
              ignoreHeight: true,
            ),
            const PDivider(),
            const SizedBox(
              height: Grid.m,
            ),
            Text(
              L10n.tr('sic_description'),
              textAlign: TextAlign.start,
              style: context.pAppStyle.labelReg14textSecondary.copyWith(height: 1),
            ),
            const SizedBox(
              height: Grid.s + Grid.xs,
            ),
            Text(
              StringUtils().capitalizeEachWord(tickerOverview.sicDescription ?? ''),
              textAlign: TextAlign.start,
              style: context.pAppStyle.labelMed16textPrimary,
            ),
            const SizedBox(
              height: Grid.m,
            ),
          ],
        ),
      ),
    );
  }
}
