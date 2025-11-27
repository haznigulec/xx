import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/widgets.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class RealizedTransactionRow extends StatelessWidget {
  final String qty;
  final String price;
  final String buyer;
  final String seller;
  final Color textColor;
  const RealizedTransactionRow({
    super.key,
    required this.qty,
    required this.price,
    required this.buyer,
    required this.seller,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = (MediaQuery.of(context).size.width - Grid.m * 3) / 4;

    return Column(
      children: [
        const SizedBox(
          height: Grid.s,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                qty,
                style: context.pAppStyle.interRegularBase.copyWith(
                  color: textColor,
                  fontSize: Grid.m - Grid.xxs,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              alignment: Alignment.center,
              child: Text(
                price,
                textAlign: TextAlign.left,
                style: context.pAppStyle.interRegularBase.copyWith(
                  color: textColor,
                  fontSize: Grid.m - Grid.xxs,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buyer,
                  maxLines: 1,
                  style: context.pAppStyle.interRegularBase.copyWith(
                    color: textColor,
                    fontSize: Grid.m - Grid.xxs,
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  seller,
                  style: context.pAppStyle.interRegularBase.copyWith(
                    color: textColor,
                    fontSize: Grid.m - Grid.xxs,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
