import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/account_statement/model/account_transaction_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AccountSummaryTile extends StatelessWidget {
  final AccountSummaryModel accountSummary;
  final bool showDivider;
  const AccountSummaryTile({
    super.key,
    required this.accountSummary,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    String currencySymbol = '';

    if (accountSummary.instrument == 'TRY') {
      currencySymbol = CurrencyEnum.turkishLira.symbol;
    } else if (accountSummary.transactionDetail == 'Müşteriye Portföyden Döviz Satın alma' &&
            accountSummary.instrument == 'USD' ||
        accountSummary.transactionDetail == 'Döviz-Müşteriler Arası Nakit Virman' &&
            accountSummary.instrument == 'USD') {
      currencySymbol = CurrencyEnum.dollar.symbol;
    }

    return InkWell(
      onTap: () {
        PBottomSheet.show(
          context,
          title: L10n.tr('transaction_detail'),
          child: Column(
            children: [
              ..._dialogRowWidget(
                context,
                L10n.tr('aciklama'),
                accountSummary.description,
              ),
              ..._dialogRowWidget(
                context,
                L10n.tr('borc'),
                '$currencySymbol${MoneyUtils().readableMoney(
                  accountSummary.debitAmount,
                )}',
              ),
              ..._dialogRowWidget(
                context,
                L10n.tr('alacak'),
                '$currencySymbol${MoneyUtils().readableMoney(
                  accountSummary.creditAmount,
                )}',
              ),
              ..._dialogRowWidget(
                context,
                L10n.tr('bakiye'),
                '$currencySymbol${MoneyUtils().readableMoney(
                  accountSummary.balanceAmount,
                )}',
                showDivider: false,
              ),
            ],
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.s,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Grid.xxs,
                    children: [
                      Text(
                        accountSummary.transactionDetail,
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                      Text(
                        accountSummary.instrument,
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg12textSecondary,
                      ),
                      Text(
                        DateTime.parse(accountSummary.valueDateString).toLocal().formatDayMonthYearDot(),
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg12textSecondary,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    spacing: Grid.s,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$currencySymbol${MoneyUtils().readableMoney(accountSummary.balanceAmount)}',
                              textAlign: TextAlign.end,
                              style: context.pAppStyle.labelMed12textPrimary,
                            ),
                            const SizedBox(
                              height: Grid.xxs,
                            ),
                            Text(
                              accountSummary.transactionType,
                              textAlign: TextAlign.end,
                              style: context.pAppStyle.labelReg12textPrimary,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        ImagesPath.chevron_down,
                        width: 15,
                        height: 15,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          showDivider
              ? const PDivider(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.s,
                  ),
                )
              : const SizedBox(
                  height: Grid.s,
                ),
        ],
      ),
    );
  }

  List<Widget> _dialogRowWidget(
    BuildContext context,
    String title,
    String value, {
    bool showDivider = true,
  }) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.pAppStyle.labelReg14textSecondary,
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
        ],
      ),
      showDivider
          ? const PDivider(
              padding: EdgeInsets.symmetric(
                vertical: Grid.s + Grid.xs,
              ),
            )
          : const SizedBox(
              height: Grid.s + Grid.xs,
            ),
    ];
  }
}
