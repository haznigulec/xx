import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class OrderDetailListTile extends StatelessWidget {
  final String title;
  final String text;
  const OrderDetailListTile({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 14,
                color: Theme.of(context).unselectedWidgetColor,
              ),
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Expanded(
          child: Text(
            text == 'null' ? '-' : text,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 14,
                  color: Theme.of(context).dividerColor,
                ),
          ),
        ),
      ],
    );
  }
}
