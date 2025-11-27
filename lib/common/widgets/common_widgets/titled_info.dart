import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class TitledInfo extends StatelessWidget {
  final String title;
  final String info;
  final bool isPercentage;
  final bool showArrow;
  final bool isNegative;

  const TitledInfo({
    super.key,
    required this.title,
    required this.info,
    this.isPercentage = false,
    this.showArrow = false,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        isPercentage
            ? preparePercentage(context, info)
            : Text(
                '${showArrow ? isNegative ? '\u25BE' : '\u25B4' : ''} $info',
                style: TextStyle(
                  color: showArrow
                      ? isNegative
                          ? context.pColorScheme.critical
                          : context.pColorScheme.success
                      : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }

  Widget preparePercentage(BuildContext context, String value) {
    bool isNegative = double.parse(value).isNegative;

    return Text(
      isNegative
          ? '\u25BE %${MoneyUtils().readableMoney(
              double.parse(value) == -100 ? 0.0 : double.parse(value).abs(),
            )}'
          : '\u25B4 %${MoneyUtils().readableMoney(double.parse(value))}',
      style: TextStyle(
        color: isNegative ? context.pColorScheme.critical : context.pColorScheme.success,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
