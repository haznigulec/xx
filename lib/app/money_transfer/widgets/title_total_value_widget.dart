import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';

class TitleTotalValueWidget extends StatelessWidget {
  const TitleTotalValueWidget({
    super.key,
    required this.title,
    required this.currency,
    required this.totalValue,
    this.titleStyle,
    this.valueStyle,
  });

  final String title;
  final String currency;
  final double totalValue;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: titleStyle ?? context.pAppStyle.labelReg14textPrimary,
          ),
          TextSpan(
            text: '$currency${MoneyUtils().readableMoney(totalValue)}',
            style: valueStyle ?? context.pAppStyle.labelMed18textPrimary,
          ),
        ],
      ),
    );
  }
}
