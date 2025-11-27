import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class UnReadCountWidget extends StatelessWidget {
  final int unReadCount;
  const UnReadCountWidget({
    super.key,
    required this.unReadCount,
  });

  @override
  Widget build(BuildContext context) {
    if (unReadCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).focusColor,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(5),
      child: Center(
        child: FittedBox(
          child: Text(
            '$unReadCount',
            textAlign: TextAlign.center,
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.s + Grid.xs,
              color: context.pColorScheme.card.shade50,
            ),
          ),
        ),
      ),
    );
  }
}
