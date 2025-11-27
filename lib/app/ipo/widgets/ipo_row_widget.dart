import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class IpoRowWidget extends StatelessWidget {
  final String title;
  final String value;
  const IpoRowWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).unselectedWidgetColor,
                      fontSize: 14,
                    ),
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
        const SizedBox(
          height: Grid.s,
        ),
        const PDivider(),
        const SizedBox(
          height: Grid.s,
        ),
      ],
    );
  }
}
