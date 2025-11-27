import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class IncomeDataSubRow extends StatelessWidget {
  final String title;
  final double value;
  const IncomeDataSubRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                title,
                style: context.pAppStyle.labelReg12textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '₺${MoneyUtils().compactMoney(value)}'.trim(),
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const SizedBox(
              width: Grid.m,
            ),
          ],
        ),
      ],
    );
  }
}
