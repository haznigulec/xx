import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_capra_model.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TransactionHistoryAbroadCard extends StatelessWidget {
  final TransactionHistoryCapraModel transactionHistory;
  final bool hasDivider;
  const TransactionHistoryAbroadCard({
    super.key,
    required this.transactionHistory,
    required this.hasDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.m,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _headerLeftWidget(
                context,
                transactionHistory,
              ),
            ),
            Text(
              L10n.tr(
                'transaction_history_capra_${transactionHistory.status ?? ''}',
              ),
              textAlign: TextAlign.right,
              style: context.pAppStyle.labelMed12textSecondary,
            ),
          ],
        ),
        const SizedBox(
          height: Grid.xxs,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                L10n.tr(
                  transactionHistory.activityType == 'JNLC' ? 'cash' : '',
                ),
                style: context.pAppStyle.labelReg12textSecondary,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            _middleRightWidget(context),
          ],
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              L10n.tr('american_stock_exchange_account'),
              style: context.pAppStyle.labelReg12textSecondary,
              textAlign: TextAlign.start,
            ),
            Text(
              transactionHistory.date ?? '',
              textAlign: TextAlign.right,
              style: context.pAppStyle.labelReg12textSecondary,
            ),
          ],
        ),
        const SizedBox(
          height: Grid.m,
        ),
        if (hasDivider) const PDivider(),
      ],
    );
  }

  Widget _headerLeftWidget(BuildContext context, TransactionHistoryCapraModel transactionHistory) {
    switch (transactionHistory.activityType) {
      case 'JNLC':
        return Text(
          L10n.tr(double.parse(transactionHistory.netAmount ?? '0') > 0 ? 'deposit_balance' : 'withdraw_balance'),
          style: context.pAppStyle.labelReg14textPrimary,
        );
      case 'FEE':
        return Text(
          L10n.tr(
            transactionHistory.type ?? '',
          ),
          style: context.pAppStyle.labelReg14textPrimary,
        );
      case 'FILL':
        return RichText(
          text: TextSpan(
            style: context.pAppStyle.labelReg14textPrimary,
            children: [
              TextSpan(
                text: transactionHistory.symbol ?? '',
              ),
              const TextSpan(
                text: ' • ',
              ),
              TextSpan(
                text: transactionHistory.side == 'buy' ? L10n.tr('alis').toUpperCase() : L10n.tr('satis').toUpperCase(),
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                  color:
                      transactionHistory.side == 'buy' ? context.pColorScheme.success : context.pColorScheme.critical,
                ),
              ),
            ],
          ),
        );

      case 'DIV':
      case 'DIVCGL':
      case 'DIVNRA':
      case 'DIVROC':
      case 'DIVTXEX':
        return RichText(
          text: TextSpan(
            style: context.pAppStyle.labelReg14textPrimary,
            children: [
              TextSpan(
                text: transactionHistory.symbol ?? '',
              ),
              const TextSpan(
                text: ' • ',
              ),
              TextSpan(
                text: L10n.tr(
                  'transaction_history.${transactionHistory.activityType!.toLowerCase()}',
                ),
                style: context.pAppStyle.labelReg14textPrimary.copyWith(
                  color: context.pColorScheme.success,
                ),
              ),
            ],
          ),
        );

      case 'SPLIT':
        return RichText(
          text: TextSpan(
            style: context.pAppStyle.labelReg14textPrimary,
            children: [
              TextSpan(
                text: transactionHistory.symbol ?? '',
              ),
              const TextSpan(
                text: ' • ',
              ),
              TextSpan(
                text: L10n.tr(
                  'transaction_history.${transactionHistory.activityType!.toLowerCase()}',
                ),
                style: context.pAppStyle.labelReg14textPrimary.copyWith(
                  color: double.parse(transactionHistory.qty ?? '0') > 0
                      ? context.pColorScheme.success
                      : context.pColorScheme.critical,
                ),
              ),
            ],
          ),
        );

      default:
        return RichText(
          text: TextSpan(
            style: context.pAppStyle.labelReg14textPrimary,
            children: [
              if (transactionHistory.symbol?.isNotEmpty == true) ...[
                TextSpan(
                  text: transactionHistory.symbol ?? '',
                ),
              ],
              if (transactionHistory.symbol?.isNotEmpty == true &&
                  transactionHistory.activityType?.isNotEmpty == true) ...[
                const TextSpan(
                  text: ' • ',
                ),
              ],
              if (transactionHistory.activityType?.isNotEmpty == true) ...[
                TextSpan(
                  text: L10n.tr(
                    'transaction_history.${transactionHistory.activityType!.toLowerCase()}',
                  ),
                  style: context.pAppStyle.labelReg14textPrimary.copyWith(
                    color: double.parse(transactionHistory.qty ?? transactionHistory.netAmount ?? '0') > 0
                        ? context.pColorScheme.success
                        : context.pColorScheme.critical,
                  ),
                ),
              ],
            ],
          ),
        );
    }
  }

  Widget _middleRightWidget(BuildContext context) {
    switch (transactionHistory.activityType) {
      case 'DIV':
      case 'DIVCGL':
      case 'DIVNRA':
      case 'DIVROC':
      case 'DIVTXEX':
      case 'JNLC':
      case 'FEE':
        return Text(
          '\$${MoneyUtils().readableMoney(double.parse(transactionHistory.netAmount ?? '0'))}',
          textAlign: TextAlign.right,
          style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.s + Grid.xs,
              color: double.parse(transactionHistory.netAmount ?? '0') > 0
                  ? context.pColorScheme.success
                  : context.pColorScheme.critical),
        );

      case 'SPLIT':
        return RichText(
          text: TextSpan(
            style: context.pAppStyle.labelReg14textPrimary,
            children: [
              TextSpan(
                text: '${transactionHistory.groupedQty ?? transactionHistory.qty ?? ''} ${L10n.tr('adet')}',
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.s + Grid.xs,
                  color: double.parse(transactionHistory.qty ?? '0') > 0
                      ? context.pColorScheme.success
                      : context.pColorScheme.critical,
                ),
              ),
              TextSpan(
                text: ' • ',
                style: context.pAppStyle.labelReg14textPrimary.copyWith(
                  color: double.parse(transactionHistory.qty ?? '0') > 0
                      ? context.pColorScheme.success
                      : context.pColorScheme.critical,
                ),
              ),
              TextSpan(
                text: '\$${transactionHistory.groupedPrice ?? MoneyUtils().readableMoney(
                      (double.parse(transactionHistory.qty ?? '1')) * (double.parse(transactionHistory.price ?? '0')),
                      pattern: MoneyUtils().getPatternByUnitDecimal(
                        (double.parse(transactionHistory.qty ?? '1')) * (double.parse(transactionHistory.price ?? '0')),
                      ),
                    )}',
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.s + Grid.xs,
                  color: double.parse(transactionHistory.qty ?? '0') > 0
                      ? context.pColorScheme.success
                      : context.pColorScheme.critical,
                ),
              ),
            ],
          ),
        );

      case 'FILL':
        return RichText(
          text: TextSpan(
            style: context.pAppStyle.labelReg14textPrimary,
            children: [
              TextSpan(
                text: '${transactionHistory.groupedQty ?? transactionHistory.qty ?? ''} ${L10n.tr('adet')}',
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.s + Grid.xs,
                  color:
                      transactionHistory.side == 'buy' ? context.pColorScheme.success : context.pColorScheme.critical,
                ),
              ),
              TextSpan(
                text: ' • ',
                style: context.pAppStyle.labelReg14textPrimary.copyWith(
                  color:
                      transactionHistory.side == 'buy' ? context.pColorScheme.success : context.pColorScheme.critical,
                ),
              ),
              TextSpan(
                text: '\$${transactionHistory.groupedPrice ?? MoneyUtils().readableMoney(
                      (double.parse(transactionHistory.qty ?? '1')) * (double.parse(transactionHistory.price ?? '0')),
                      pattern: MoneyUtils().getPatternByUnitDecimal(
                        (double.parse(transactionHistory.qty ?? '1')) * (double.parse(transactionHistory.price ?? '0')),
                      ),
                    )}',
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.s + Grid.xs,
                  color:
                      transactionHistory.side == 'buy' ? context.pColorScheme.success : context.pColorScheme.critical,
                ),
              ),
            ],
          ),
        );

      default:
        {
          return transactionHistory.qty?.isNotEmpty == true || transactionHistory.netAmount?.isNotEmpty == true
              ? RichText(
                  text: TextSpan(
                    style: context.pAppStyle.labelReg14textPrimary,
                    children: [
                      if (transactionHistory.qty?.isNotEmpty == true) ...[
                        TextSpan(
                          text: '${transactionHistory.groupedQty ?? transactionHistory.qty ?? ''} ${L10n.tr('adet')}',
                          style: context.pAppStyle.interMediumBase.copyWith(
                            fontSize: Grid.s + Grid.xs,
                            color: double.parse(transactionHistory.groupedQty ?? transactionHistory.qty ?? '0') > 0
                                ? context.pColorScheme.success
                                : context.pColorScheme.critical,
                          ),
                        ),
                      ],
                      if (transactionHistory.qty?.isNotEmpty == true &&
                          transactionHistory.netAmount?.isNotEmpty == true) ...[
                        TextSpan(
                          text: ' • ',
                          style: context.pAppStyle.labelReg14textPrimary.copyWith(
                            color: transactionHistory.side == 'buy'
                                ? context.pColorScheme.success
                                : context.pColorScheme.critical,
                          ),
                        ),
                      ],
                      if (transactionHistory.netAmount?.isNotEmpty == true) ...[
                        TextSpan(
                          text: '\$${MoneyUtils().readableMoney(double.parse(transactionHistory.netAmount ?? '0'))}',
                          style: context.pAppStyle.interMediumBase.copyWith(
                            fontSize: Grid.s + Grid.xs,
                            color: double.parse(transactionHistory.netAmount ?? '0') > 0
                                ? context.pColorScheme.success
                                : context.pColorScheme.critical,
                          ),
                        ),
                      ]
                    ],
                  ),
                )
              : const SizedBox.shrink();
        }
    }
  }
}
