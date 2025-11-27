import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class BalanceDataSingleRow extends StatelessWidget {
  final String title;
  final double value;
  const BalanceDataSingleRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            title,
            style: context.pAppStyle.labelReg14textPrimary,
          ),
        ),
        const Spacer(),
        Text(
          '₺${MoneyUtils().compactMoney(value)}'.trim(),
          style: context.pAppStyle.labelMed14textPrimary,
        ),
        const SizedBox(
          width: Grid.m,
        ),
      ],
    );
  }
}
