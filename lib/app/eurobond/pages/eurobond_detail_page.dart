import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/buy_sell_buttons.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class EuroBondDetailPage extends StatelessWidget {
  final Bonds selectedEuroBond;
  final String transactionStartTime;
  final String transactionEndTime;

  const EuroBondDetailPage({
    super.key,
    required this.selectedEuroBond,
    required this.transactionStartTime,
    required this.transactionEndTime,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = {
      L10n.tr('purchasing_clean_price'):
          '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(selectedEuroBond.creditCleanPrice ?? 0, pattern: '#,##0.000')}',
      L10n.tr('sale_clean_price'):
          '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(selectedEuroBond.debitCleanPrice ?? 0, pattern: '#,##0.000')}',
      L10n.tr('purchase_price'):
          '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(selectedEuroBond.creditPrice ?? 0, pattern: '#,##0.000')}',
      L10n.tr('sale_price'):
          '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(selectedEuroBond.debitPrice ?? 0, pattern: '#,##0.000')}',
      L10n.tr('purchase_return'): MoneyUtils().ratioFormat(selectedEuroBond.creditRate ?? 0, pattern: '#,##0.00'),
      L10n.tr('sales_return'): MoneyUtils().ratioFormat(selectedEuroBond.debitRate ?? 0, pattern: '#,##0.00'),
      L10n.tr('alinabilir_adet'):
          MoneyUtils().readableMoney(selectedEuroBond.creditTransactionLimit ?? 0, pattern: '#,##0'),
      L10n.tr('satilabilir_adet'):
          MoneyUtils().readableMoney(selectedEuroBond.debitTransactionLimit ?? 0, pattern: '#,##0'),
      L10n.tr('purchase_valor'): DateTime.parse(selectedEuroBond.valueDate.toString()).formatDayMonthYearDot(),
      L10n.tr('sales_valor'): (DateTime.parse(selectedEuroBond.valueDate.toString())).formatDayMonthYearDot(),
      L10n.tr('maturity'): DateTime.parse(selectedEuroBond.maturityDate.toString()).formatDayMonthYearDot(),
      L10n.tr('currency_type'): selectedEuroBond.currencyName ?? '',
      L10n.tr('transaction_start_time'):
          DateTimeUtils.strTimeFromDate(date: DateTime.parse(transactionStartTime.toString())),
      L10n.tr('last_transaction_time'):
          DateTimeUtils.strTimeFromDate(date: DateTime.parse(transactionEndTime.toString())),
      L10n.tr('coupon_payment_frequency'): MoneyUtils().readableMoney(selectedEuroBond.couponFrequency ?? 0),
      L10n.tr('coupon_rate'): MoneyUtils().ratioFormat(selectedEuroBond.couponRate ?? 0),
      L10n.tr('next_coupon_payment_date'):
          DateTimeUtils.dateFormat(DateTime.parse(selectedEuroBond.nextCouponDate.toString())),
    };
    return Scaffold(
        appBar: PInnerAppBar(
          title: selectedEuroBond.name ?? '',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.s,
                ),
                child: Row(
                  spacing: Grid.s,
                  children: [
                    SvgPicture.asset(
                      ImagesPath.yurt_disi,
                      width: 28,
                      height: 28,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedEuroBond.name ?? '',
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        Text(
                          selectedEuroBond.currencyName ?? '',
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.s,
              ),
              const PDivider(),
              const SizedBox(
                height: Grid.s,
              ),
              ..._generateInfos(args),
            ],
          ),
        ),
        bottomNavigationBar: BuySellButtons(
          onTapBuy: () {
            router.push(
              EuroBondBuySellRoute(
                action: OrderActionTypeEnum.buy,
                selectedEuroBond: selectedEuroBond,
              ),
            );
          },
          onTapSell: () {
            router.push(
              EuroBondBuySellRoute(
                action: OrderActionTypeEnum.sell,
                selectedEuroBond: selectedEuroBond,
              ),
            );
          },
        ));
  }

  List<Widget> _generateInfos(Map<String, dynamic> args) {
    List<Widget> headerInfos = [];

    for (var i = 0; i < args.length; i += 2) {
      headerInfos.add(
        SizedBox(
          height: 52,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: args.keys.elementAt(i),
                  value: args.values.elementAt(i),
                ),
              ),
              if (i + 1 < args.length)
                Expanded(
                  child: SymbolBriefInfo(
                    label: args.keys.elementAt(i + 1),
                    value: args.values.elementAt(i + 1),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }
}
