import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class OrderDetailPriceTile extends StatelessWidget {
  final String title;
  final String content;
  final Widget? textWidget;
  final Function(double)? selectedPrice;

  const OrderDetailPriceTile({
    super.key,
    required this.title,
    required this.content,
    this.textWidget,
    this.selectedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: context.pAppStyle.labelMed12textSecondary,
        ),
        GestureDetector(
          onTap: content == 'null' || selectedPrice == null
              ? null
              : () => selectedPrice!(
                    MoneyUtils().fromReadableMoney(content),
                  ),
          child: textWidget ??
              Text(
                content == 'null' ? '-' : '₺$content',
                style: context.pAppStyle.labelMed14textPrimary,
              ),
        ),
      ],
    );
  }
}
