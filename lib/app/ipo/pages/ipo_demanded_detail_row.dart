import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_detail_symbol_name_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoDemandedDetailRow extends StatelessWidget {
  final IpoDemandModel? demandedIpo;
  const IpoDemandedDetailRow({
    super.key,
    required this.demandedIpo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(children: [
        _rowWidget(
          context,
          L10n.tr('durum'),
          L10n.tr('PENDINGNEW'),
          valueColor: context.pColorScheme.primary,
        ),
        _rowWidget(
          context,
          L10n.tr('symbol'),
          demandedIpo?.name ?? '',
          valueWidget: IpoDetailSymbolNameWidget(
            symbolName: demandedIpo?.name ?? '',
            onTap: () {
              MarketListModel selectedItem = MarketListModel(
                symbolCode: demandedIpo?.name ?? '',
                updateDate: '',
              );

              router.push(
                SymbolDetailRoute(
                  symbol: selectedItem,
                ),
              );
            },
          ),
        ),
        _rowWidget(
          context,
          L10n.tr('islem_turu'),
          L10n.tr('participation_ipo'),
          valueColor: context.pColorScheme.primary,
        ),
        _rowWidget(
          context,
          L10n.tr('ipo_price'),
          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(demandedIpo?.offerPrice ?? 0)}',
        ),
        _rowWidget(
          context,
          L10n.tr('adet'),
          '${demandedIpo?.unitsDemanded?.toInt() ?? ''}',
        ),
        _rowWidget(
          context,
          L10n.tr('tutar'),
          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(demandedIpo?.amountDemanded ?? 0)}',
        ),
        _rowWidget(
          context,
          L10n.tr('payment_type'),
          _detailValue(demandedIpo?.detail ?? ''),
        ),
        _rowWidget(
          context,
          L10n.tr('hesap'),
          demandedIpo?.accountExtId ?? '',
        ),
        _rowWidget(
          context,
          L10n.tr('order_date'),
          DateTime.parse(demandedIpo?.demandDate ?? DateTime.now().toString()).formatDayMonthYearTimeWithComma(),
        ),
        _rowWidget(
          context,
          L10n.tr('ipo_order_no'),
          '${demandedIpo?.ipoDemandExtId ?? ''}',
        ),
        _rowWidget(
          context,
          L10n.tr('ipo_minimum_lot'),
          '${demandedIpo?.minimumDemand?.toInt() ?? ''}',
        ),
      ]),
    );
  }

  String _detailValue(key) {
    switch (key) {
      case 'Cash':
      case 'Nakit':
        return L10n.tr('ipo_cash');
      case 'Döviz Blokajı':
        return L10n.tr('ipo_foreign_exchange_blockage');
      case 'Fon Blokajı':
      case 'Fund Blockage':
        return L10n.tr('ipo_fund_blockage');
      case 'Hisse Blokajı':
      case 'Equity Blockage':
        return L10n.tr('ipo_equity_blockage');
      default:
        return L10n.tr('ipo_cash');
    }
  }

  Widget _rowWidget(
    BuildContext context,
    String title,
    String value, {
    Color? valueColor,
    Widget? valueWidget,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: context.pAppStyle.labelReg14textSecondary,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: valueWidget ??
                  Text(
                    value,
                    textAlign: TextAlign.right,
                    style: context.pAppStyle.interMediumBase.copyWith(
                      color: valueColor ?? context.pColorScheme.textPrimary,
                      fontSize: Grid.m - Grid.xxs,
                    ),
                  ),
            ),
          ],
        ),
        const PDivider(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
        )
      ],
    );
  }
}
