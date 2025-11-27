import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

class AdvicePrice extends StatelessWidget {
  final bool isVertical;
  final String title;
  final double price;
  final bool isForeign;
  final TextAlign textAlign;
  const AdvicePrice({
    this.isVertical = false,
    required this.title,
    required this.price,
    required this.isForeign,
    this.textAlign = TextAlign.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: context.pAppStyle.labelMed12textSecondary,
                textAlign: textAlign,
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              Text(
                '${isForeign ? CurrencyEnum.dollar.symbol : CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(price)}',
                style: context.pAppStyle.labelMed12textPrimary,
                textAlign: textAlign,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              Flexible(
                child: Text(
                  '${isForeign ? '\$' : '₺'}${MoneyUtils().readableMoney(price)}',
                  style: context.pAppStyle.labelMed12textPrimary,
                ),
              ),
            ],
          );
  }
}
