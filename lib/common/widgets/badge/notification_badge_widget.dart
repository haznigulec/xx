import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class NotificationBadgeWidget extends StatelessWidget {
  final int count;

  const NotificationBadgeWidget({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    String displayCount = count > 999 ? '999+' : count.toString();
    return Container(
      height: Grid.l,
      width: Grid.l,
      decoration: BoxDecoration(
        color: context.pColorScheme.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        displayCount,
        style: context.pAppStyle.interMediumBase.copyWith(
          fontSize: Grid.s,
          color: context.pColorScheme.lightHigh,
        ),
      ),
    );
  }
}
