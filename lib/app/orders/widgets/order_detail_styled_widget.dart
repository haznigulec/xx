import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class OrderDetailStyledWidget extends StatelessWidget {
  final String text;
  final TransactionModel selectedOrder;
  const OrderDetailStyledWidget({
    super.key,
    required this.text,
    required this.selectedOrder,
  });

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: L10n.tr(
        text,
        namedArgs: {
          'symbol': '<bold>${(selectedOrder.symbol ?? selectedOrder.asset ?? '').toUpperCase()}</bold>',
          'transactionType':
              '<transaction_type>${selectedOrder.sideType == 1 ? L10n.tr('alim').toUpperCase() : L10n.tr('satim').toUpperCase()}</transaction_type>',
          'unit': '${(selectedOrder.orderUnit ?? 0).toInt()}',
          'amout': '₺${MoneyUtils().readableMoney(selectedOrder.orderPrice ?? 0)}',
        },
      ),
      textAlign: TextAlign.center,
      style: context.pAppStyle.labelReg14textPrimary,
      tags: {
        'bold': StyledTextTag(
          style: context.pAppStyle.labelMed16textPrimary.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        'transaction_type': StyledTextTag(
            style: context.pAppStyle.interRegularBase.copyWith(
          fontSize: Grid.m,
          color: selectedOrder.sideType == 1 ? context.pColorScheme.success : context.pColorScheme.critical,
        )),
      },
    );
  }
}
